/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBApplicationController.h"
#import "MBAlertController.h"
#import "MBDocument.h"
#import "MBAction.h"
#import "MBPage.h"
#import "MBPageStackController.h"
#import "MBMetadataService.h"
#import "MBDataManagerService.h"
#import "MBTableViewController.h"
#import "MBOutcome.h"
#import "MBDialogController.h"
#import "MBViewManager.h"
#import "MBScriptService.h"
#import "UncaughtExceptionHandler.h"
#import "GTMStackTrace.h"
#import "MBMacros.h"
#import "MBLocalizationService.h"
#import "StringUtilitiesHelper.h"
#import "MBDevice.h"
#import "MBViewBuilderFactory.h"
#import "MBOutcomeListenerProtocol.h"

static MBApplicationController *_instance = nil;

@interface MBApplicationController() {
    MBAlertController *_alertController;
}

@property (nonatomic, retain) NSMutableArray *outcomeListeners;
@property (nonatomic, retain) MBAlertController *alertController;
@property (nonatomic, assign, readonly) dispatch_queue_t queue;
- (void) doHandleOutcome:(MBOutcome *)outcome;
- (void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome;
- (void) fireInitialOutcomes;
@end

@implementation MBApplicationController

@synthesize alertController = _alertController;
@synthesize applicationActive = _applicationActive;
@synthesize viewManager = _viewManager;
@synthesize applicationFactory = _applicationFactory;

- (id) init
{
	self = [super init];
	if (self != nil) {
        _instance = self;
		_outcomeListeners = [[NSMutableArray array] retain];
		_queue = dispatch_queue_create("OutcomeQueue", NULL);
		// Added for optimization: Make sure the MBDevice is created at startup. The createInstance method instantiate variables that only need to be gathered once in the application lifecycle
		[MBDevice createInstance];
	}
	return self;
}

- (MBViewManager *)viewManager {
    if (!_viewManager) {
        _viewManager = [[MBViewManager alloc] init];
    }
    return _viewManager;
}

-(void) dealloc {
	[_outcomeListeners release];
    [_alertController release];
	[_applicationFactory release];
    [_viewManager release];
	[super dealloc];
}

+(MBApplicationController *) currentInstance {
	return _instance;
}

-(void) startApplication:(MBApplicationFactory *)applicationFactory {
	DLog(@"MBApplicationController:startApplication");
	
    self.alertController = [[MBAlertController new] autorelease];
    self.applicationFactory = applicationFactory;
    
	
	// Added for optimization: Make sure the stringUtilitiesHelper is created. The createInstance methods instantiate variables that only need to be gathered once in the application lifecycle
	[StringUtilitiesHelper createInstance]; // Added for optimization
    
    [self fireInitialOutcomes];
}

-(void) resetController {
	[UIView beginAnimations:@"resetController" context:nil];
	[_viewManager resetView];
	[self fireInitialOutcomes];
    [UIView commitAnimations];
}

-(void) resetControllerPreservingCurrentPageStack {
	[_viewManager resetViewPreservingCurrentPageStack];
}


-(void) fireInitialOutcomes {
	MBOutcome *initialOutcome = [[MBOutcome alloc]init];
    initialOutcome.originName = @"Controller";
    initialOutcome.outcomeName = @"init";
    initialOutcome.pageStackName = [self activePageStackName];
	initialOutcome.noBackgroundProcessing = TRUE;
    
	_suppressPageSelection = TRUE;
    [self handleOutcome:initialOutcome];
	_suppressPageSelection = FALSE;
    
    [initialOutcome release];
}

-(void) handleOutcome:(MBOutcome *)outcome {
    @try {
		[self doHandleOutcome: outcome];
    }
    @catch (NSException *e) {
        [self handleException: e outcome: outcome];
    }
}

- (void) doHandleOutcome:(MBOutcome *)outcome {
	DLog(@"MBApplicationController:handleOutcome: %@", outcome);

	// notify all outcome listeners
	for(id<MBOutcomeListenerProtocol> lsnr in self.outcomeListeners) {
		if ([lsnr respondsToSelector:@selector(outcomeProduced:)])
			[lsnr outcomeProduced:outcome];
	}

	// Make sure that the (external) document cache of the document itself is cleared since this
	// might interfere with the preconditions that are evaluated later on. Also: if the document is transferred
	// the next page / action will also have fresh copies
	[outcome.document clearAllCaches];
	
	MBMetadataService *metadataService = [MBMetadataService sharedInstance];
    
	NSArray *outcomeDefinitions = [metadataService outcomeDefinitionsForOrigin:outcome.originName outcomeName:outcome.outcomeName throwIfInvalid:FALSE];
    if([outcomeDefinitions count] == 0) {
        NSString *msg = [NSString stringWithFormat:@"No outcome defined for origin=%@ outcome=%@", outcome.originName, outcome.outcomeName];
        @throw [NSException exceptionWithName:@"NoOutcomesDefined" reason:msg userInfo:nil];
    }
    
    BOOL shouldPersist = FALSE;
    for(MBOutcomeDefinition *outcomeDef in outcomeDefinitions) {
        shouldPersist |= outcomeDef.persist;
    }
    
    if(shouldPersist) {
		if([outcome document] == nil) {
			WLog(@"WARNING: origin=%@ and name=%@ has persistDocument=TRUE but there is no document (probably the outcome originates from an action; which cannot have a document)", outcome.originName, outcome.outcomeName);
		}
		else [[MBDataManagerService sharedInstance] storeDocument: outcome.document];
	}
    
    NSMutableArray *pageStacks = [NSMutableArray array];
	
	// We need to make sure that the order of the dialog tabs conforms to the order of the outcomes
	// This is not necessarily the case because preparing of page A might take longer in the background than page B
	// Because of this, page B migh be places on a tab prior to page A which is undesired. We handle this by
	// notifying the view handler of the dialogs used by the outcome in sequental order. The viewmanager will then
	// use this information to sort the tabs
	
    for(MBOutcomeDefinition *outcomeDef in outcomeDefinitions) {
        
		if([@"RESET_CONTROLLER" isEqualToString:outcomeDef.action]) {
			[self resetController];
		}
		else {
            
			// Create a working copy of the outcome; we manipulate the outcome below and we want the passed outcome to be left unchanged (good practise)
			MBOutcome *outcomeToProcess = [[[MBOutcome alloc] initWithOutcomeDefinition: outcomeDef] autorelease];
			
			outcomeToProcess.path = outcome.path;
			outcomeToProcess.document = outcome.document;
            if (outcomeToProcess.pageStackName.length == 0) outcomeToProcess.pageStackName = outcome.pageStackName;
            if (outcomeToProcess.pageStackName.length == 0) outcomeToProcess.pageStackName = outcome.originPageStackName;
			if (outcome.displayMode != nil) outcomeToProcess.displayMode = outcome.displayMode;
			outcomeToProcess.noBackgroundProcessing = outcome.noBackgroundProcessing || outcomeDef.noBackgroundProcessing;
            
			if([outcomeToProcess isPreConditionValid]) {
                
				// Update a possible switch of pageStack/display mode set by the outcome definition
				if(outcomeDef.pageStackName != nil) outcomeToProcess.pageStackName = outcomeDef.pageStackName;
                if(outcomeToProcess.displayMode.length == 0) outcomeToProcess.displayMode = outcomeDef.displayMode;
				if(outcomeToProcess.originPageStackName == nil) outcomeToProcess.originPageStackName = outcomeToProcess.pageStackName;
				
				if(outcomeToProcess.pageStackName != nil) [pageStacks addObject: outcomeToProcess.pageStackName];
				
                if([@"ENDMODAL" isEqualToString: outcomeToProcess.displayMode]) {
                    MBDialogController *dialog = [self.viewManager.dialogManager dialogForPageStackName:outcomeToProcess.pageStackName];
                    [[[MBViewBuilderFactory sharedInstance] dialogDecoratorFactory] dismissDialog:dialog withTransitionStyle:outcomeToProcess.transitionStyle];
				}
                
				else if([@"POP" isEqualToString: outcomeToProcess.displayMode]) {
					// TODO: This causes a bug when the user desides to pop the rootViewController
					[_viewManager.dialogManager popPageOnPageStackWithName: outcomeToProcess.pageStackName];
				}
				else if([@"POPALL" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager.dialogManager endPageStackWithName: outcomeToProcess.pageStackName keepPosition:TRUE];
				}
				else if([@"CLEAR" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager resetView];
				}
				else if([@"END" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager.dialogManager endPageStackWithName: outcomeToProcess.pageStackName keepPosition: FALSE];
					[pageStacks removeObject:outcomeToProcess.pageStackName];
				}
				
				
                // Action
				MBActionDefinition *actionDef = [metadataService definitionForActionName:outcomeDef.action throwIfInvalid: FALSE];
				if(actionDef != nil) {
                    if(outcomeToProcess.noBackgroundProcessing) {
                        [self performActionInBackground:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], actionDef, nil]];
					}
                    else {
                        [_viewManager showActivityIndicatorWithMessage:outcomeToProcess.processingMessage];
						dispatch_async(self.queue, ^{
	                        [self performActionInBackground:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], actionDef,  nil]];
						});
                    }
				}
				
                // Page
				MBPageDefinition *pageDef = [metadataService definitionForPageName:outcomeDef.action throwIfInvalid: FALSE];
				if(pageDef != nil) {
					[_viewManager showActivityIndicatorWithMessage:outcomeToProcess.processingMessage];
					if(outcomeToProcess.noBackgroundProcessing) [self preparePageInBackground:[NSArray arrayWithObjects: [[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], pageDef.name, nil]];
					else dispatch_async(self.queue, ^{
						[self preparePageInBackground:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess]autorelease], pageDef.name, nil]];
					});
				}
                
                // Alert
                MBAlertDefinition *alertDef = [metadataService definitionForAlertName:outcomeDef.action throwIfInvalid:FALSE];
                if (alertDef != nil) {
                    [self.alertController handleAlert:alertDef forOutcome:outcomeToProcess];
                }
                
				if(actionDef == nil && pageDef == nil && alertDef == nil && ![outcomeDef.action isEqualToString:@"none"]) {
					NSString *msg = [NSString stringWithFormat:@"Invalid outcome; no action or page with name %@ defined. See outcome origin=%@ action=%@. Check \n%@", outcomeDef.action, outcomeDef.origin, outcomeDef.name, [outcomeDef asXmlWithLevel:5]];
					@throw [NSException exceptionWithName:@"InvalidOutcome" reason:msg userInfo:nil];
				}
			}
		}
	}

	dispatch_async(self.queue, ^{
		dispatch_async(dispatch_get_main_queue(), ^{
		// notify all outcome listeners
		for(id<MBOutcomeListenerProtocol> lsnr in self.outcomeListeners) {
			if ([lsnr respondsToSelector:@selector(outcomeHandled:)])
				[lsnr outcomeHandled:outcome];
		}});
	});
}



//////// PAGE HANDLING

- (void)preparePageInBackground:(NSArray*)args {
	
    MBOutcome *causingOutcome = [args objectAtIndex:0];
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @try {
        
        NSString *pageName = [args objectAtIndex:1];
        
        // construct the page
        MBPageDefinition *pageDefinition = [[MBMetadataService sharedInstance] definitionForPageName:pageName];
		
		// Load the document from the store
		MBDocument *document = nil;
		
		if(causingOutcome.transferDocument) {
			if(causingOutcome.document == nil)  {
				NSString *msg = [NSString stringWithFormat:@"No document provided (nil) in outcome '%@' by action/page '%@' but transferDocument='TRUE' in outcome definition",causingOutcome.outcomeName , causingOutcome.originName];
				@throw [NSException exceptionWithName:@"InvalidOutcome" reason:msg userInfo:nil];
			}
			NSString *actualType =  [[causingOutcome.document definition] name];
			if(![actualType isEqualToString: [pageDefinition documentName]]) {
				NSString *msg = [NSString stringWithFormat:@"Document provided via outcome by action/page=%@ (transferDocument='TRUE') is of type %@ but must be of type %@",
								 causingOutcome.originName, actualType, [pageDefinition documentName]];
				@throw [NSException exceptionWithName:@"InvalidOutcome" reason:msg userInfo:nil];
			}
			document = causingOutcome.document;
		}
		else {
			document = [[MBDataManagerService sharedInstance] loadDocument:[pageDefinition documentName]];
            
			if(document == nil) {
				document = [[MBDataManagerService sharedInstance] loadDocument:[pageDefinition documentName]];
				NSString *msg = [NSString stringWithFormat:@"Document with name %@ not found (check filesystem/webservice)", [pageDefinition documentName]];
				@throw [NSException exceptionWithName:@"NoDocument" reason:msg userInfo:nil];
			}
		}
        
		if(causingOutcome.noBackgroundProcessing) [self showResultingPage:[NSArray arrayWithObjects:causingOutcome, pageDefinition, document, nil]];
		else
			dispatch_async(dispatch_get_main_queue(), ^{
				[self showResultingPage:[NSArray arrayWithObjects:causingOutcome, pageDefinition, document, nil]];
			});

        
    }
    @catch (NSException *e) {
        [self handleException: e outcome: causingOutcome];
    }
    @finally {
        [pool release];
    }
}

- (void)showResultingPage:(NSArray*)args {
	
    MBOutcome *causingOutcome = [args objectAtIndex:0];
    @try {
        [_viewManager hideActivityIndicator];
        NSString *displayMode = causingOutcome.displayMode;
        NSString *transitionStyle = causingOutcome.transitionStyle;
		MBViewState viewState = [_viewManager currentViewState];
		
		if([displayMode isEqualToString:@"MODAL"] ||
		   [displayMode isEqualToString:@"MODALFORMSHEET"] ||
		   [displayMode isEqualToString:@"MODALFORMSHEETWITHCLOSEBUTTON"] ||
		   [displayMode isEqualToString:@"MODALPAGESHEET" ] ||
		   [displayMode isEqualToString:@"MODALFULLSCREEN"] ||
		   [displayMode isEqualToString:@"MODALCURRENTCONTEXT"] ){
			viewState = MBViewStateModal;
		}
		
        MBPageDefinition *pageDefinition = [args objectAtIndex:1];
        MBDocument *document = [args objectAtIndex:2];
        CGRect bounds = self.viewManager.bounds;
        
        MBPage *page = [_applicationFactory createPage:pageDefinition
											  document: document
											  rootPath: causingOutcome.path
											 viewState: viewState
										 withMaxBounds: bounds];
        page.applicationController = self;
        page.pageStackName = causingOutcome.pageStackName;
        
        [_viewManager showPage: page displayMode: displayMode transitionStyle: transitionStyle];
    }
    @catch (NSException *e) {
        [self handleException: e outcome: causingOutcome];
    }
}

//////// END OF PAGE HANDLING

//////// ACTION HANDLING

- (void) performActionInBackground:(NSArray *)args {
    
    MBOutcome *causingOutcome = [args objectAtIndex:0];
    
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @try {
        
        MBActionDefinition *actionDef = [args objectAtIndex:1];
        id<MBAction> action = [_applicationFactory createAction: actionDef.className];
        MBOutcome *actionOutcome = [action execute: causingOutcome.document withPath:causingOutcome.path];
        
        if(actionOutcome == nil) {
			[_viewManager hideActivityIndicator];
            DLog(@"No outcome produced by action %@ (outcome == nil); no further procesing.", actionDef.name);
        }
        else {
			if(causingOutcome.noBackgroundProcessing) [self handleActionResult:[NSArray arrayWithObjects:causingOutcome, actionDef, actionOutcome, nil]];
            else {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self handleActionResult:[NSArray arrayWithObjects:causingOutcome, actionDef, actionOutcome, nil]];
				});
			}
        }
    }
    @catch (NSException *e) {
        [self handleException: e outcome: causingOutcome];
    }
    @finally {
        [pool release];
    }
}

- (void) handleActionResult:(NSArray *)args {
    MBOutcome *causingOutcome = [args objectAtIndex:0];
    
    @try {
		[_viewManager hideActivityIndicator];
        
        MBActionDefinition *actionDef = [args objectAtIndex:1];
        MBOutcome *actionOutcome = [args objectAtIndex:2];
        
        if(actionOutcome.pageStackName == nil) actionOutcome.pageStackName = causingOutcome.pageStackName;
        actionOutcome.originName = actionDef.name;
        
        [self handleOutcome:actionOutcome];
    }
    @catch (NSException *e) {
        [self handleException: e outcome: causingOutcome];
    }
}

//////// END OF ACTION HANDLING

- (NSString*) activePageStackName {
	NSString *result = nil;
	if(_viewManager != nil) {
	  	result = _viewManager.dialogManager.activePageStackName;
	}
	return result;
}

// Returns nil if the current ActiveDialog is not nested inside a DialogGroup.
- (NSString *) activeDialogName {
	NSString *result = nil;
	if (_viewManager != nil) {
		
		result = _viewManager.dialogManager.activeDialogName;
	}
	return result;
}

-(void) activatePageStackWithName:(NSString*) name {
	[_viewManager.dialogManager activatePageStackWithName: name];
}

-(void) showActivityIndicator {
	[_viewManager showActivityIndicator];
}

-(void) showActivityIndicatorWithMessage:(NSString*) message {
	[_viewManager showActivityIndicatorWithMessage:message];
}

-(void) hideActivityIndicator {
	[_viewManager hideActivityIndicator];
}

- (NSArray *)getStack:(NSException*) exception
{
	NSMutableArray *result = [NSMutableArray array];
	NSScanner *scanner = [NSScanner scannerWithString: GTMStackTraceFromException(exception)];
	NSString *line;
	
	while([scanner scanUpToString:@"\n" intoString:&line] || ![scanner isAtEnd]) [result addObject: line];
	return result;
}

-(void) handleExceptionAfterDelay:(NSArray *)args {
	NSException *exception = [args objectAtIndex:0];
	MBOutcome *outcome = [args objectAtIndex:1];
	[self handleException:exception outcome:outcome];
}

- (void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome {
	
	WLog(@"________EXCEPTION RAISED______________________________________________________________");
	WLog(@"%@: %@", exception.name, exception.reason);
	NSArray *trace = [self getStack:exception];
	if(trace != nil) for(id t in trace) WLog(@"%@", t);
	WLog(@"______________________________________________________________________________________");
    
	MBDocument *exceptionDocument = [[MBDataManagerService sharedInstance] loadDocument: DOC_SYSTEM_EXCEPTION];
	[exceptionDocument setValue: MBLocalizedString(exception.name) forPath: PATH_SYSTEM_EXCEPTION_NAME];
	[exceptionDocument setValue: MBLocalizedString(exception.reason) forPath: PATH_SYSTEM_EXCEPTION_DESCRIPTION];
	[exceptionDocument setValue: outcome.originName forPath: PATH_SYSTEM_EXCEPTION_ORIGIN];
	[exceptionDocument setValue: outcome.outcomeName forPath: PATH_SYSTEM_EXCEPTION_OUTCOME];
	[exceptionDocument setValue: [[exception class] description] forPath: PATH_SYSTEM_EXCEPTION_TYPE];
	for(NSString *line in trace) {
		MBElement *stackline = [exceptionDocument createElementWithName:@"/Exception[0]/Stackline"];
		if([line length] > 52) line = [line substringFromIndex:52];
		[stackline setValue:line forPath:@"@line"];
	}
	
	[[MBDataManagerService sharedInstance] storeDocument: exceptionDocument];
    
	MBMetadataService *metadataService = [MBMetadataService sharedInstance];
	
	// We are not sure at this moment if the activity indicator is shown. But to be sure; try to hide it.
	// This might mess up the count of the activity indicators if more than one page is being constructed in the background;
	// however most of the times this will work out; so:
	[_viewManager hideActivityIndicator];
    
	// See if there is an outcome defined for this particular exception
	NSArray *outcomeDefinitions = [metadataService outcomeDefinitionsForOrigin:outcome.originName outcomeName:[exception name] throwIfInvalid:FALSE];
    if([outcomeDefinitions count] != 0) {
		MBOutcome *specificExceptionHandler = [[[MBOutcome alloc] initWithOutcome:outcome] autorelease];
		specificExceptionHandler.outcomeName = [exception name];
		specificExceptionHandler.document = exceptionDocument;
		[self handleOutcome: specificExceptionHandler];
	}
	else {
		// There is no specific exception handler defined. So fall back on the generic one
		NSArray *outcomeDefinitions = [metadataService outcomeDefinitionsForOrigin:outcome.originName outcomeName:@"exception" throwIfInvalid:FALSE];
		if([outcomeDefinitions count] == 0) {
			WLog(@"No outcome with origin=%@ name=exception defined to handle errors; so re-throwing exception", outcome.originName);
			@throw [exception retain];
		}
		if([outcome.outcomeName isEqualToString: @"exception"]) {
			WLog(@"Error in handling an outcome with name=exception (i.e. the error handling in the controller is probably misconfigured) Re-throwing exception");
			@throw [exception retain];
		}
		
		MBOutcome *genericExceptionHandler = [[[MBOutcome alloc] initWithOutcomeName:@"exception" document: exceptionDocument] autorelease];
		genericExceptionHandler.pageStackName = outcome.pageStackName;
		genericExceptionHandler.path = outcome.path;
		
		[self doHandleOutcome: genericExceptionHandler];
	}
}


#pragma mark -
#pragma mark Private Setters and Getters

- (void)setApplicationFactory:(MBApplicationFactory *)applicationFactory {
    if (_applicationFactory != applicationFactory) {
        [_applicationFactory release];
        _applicationFactory = applicationFactory;
        [applicationFactory retain];
    }
}


#pragma mark -
#pragma mark Outcome listeners

- (void) registerOutcomeListener:(id<MBOutcomeListenerProtocol>) listener {
	if(![self.outcomeListeners containsObject:listener]) [self.outcomeListeners addObject:listener];
}

- (void) unregisterOutcomeListener:(id<MBOutcomeListenerProtocol>) listener {
	[self.outcomeListeners removeObject: listener];
}


@end
