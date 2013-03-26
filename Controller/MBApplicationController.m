//
//  MBApplicationController.m
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBApplicationController.h"
#import "MBAlertController.h"
#import "MBDocument.h"
#import "MBAction.h"
#import "MBPage.h"
#import "MBDialogController.h"
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

//#define SELECTOR_HANDLING performSelector
#define SELECTOR_HANDLING performSelectorInBackground

static MBApplicationController *_instance = nil;

@interface MBApplicationController() {
    MBAlertController *_alertController;
}
@property (nonatomic, retain) MBAlertController *alertController;
- (void) doHandleOutcome:(MBOutcome *)outcome;
- (void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome;
- (void) fireInitialOutcomes;
- (MBOutcome*) outcomeWhichCausedModal;
- (void) setOutcomeWhichCausedModal:(MBOutcome*) outcome;
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
    [_alertController release];
	[_applicationFactory release];
	[_outcomeWhichCausedModal release];
    [_viewManager release];
	[super dealloc];
}

+(MBApplicationController *) currentInstance {
	return _instance;
}

-(void) startApplication:(MBApplicationFactory *)applicationFactory {
	DLog(@"MBApplicationController:startApplication");
	
    self.alertController = [MBAlertController new];
    
	_applicationFactory = applicationFactory;
	[_applicationFactory retain];
	
	_viewManager = [[MBViewManager alloc] init];

	_viewManager.singlePageMode = [[[MBMetadataService sharedInstance] dialogs] count] <= 1;
	
	// Added for optimization: Make sure the stringUtilitiesHelper is created. The createInstance methods instantiate variables that only need to be gathered once in the application lifecycle 
	[StringUtilitiesHelper createInstance]; // Added for optimization
	
    [self fireInitialOutcomes];
	[_viewManager makeKeyAndVisible];
}

-(void) resetController {
	[UIView beginAnimations:@"resetController" context:nil];
	[_viewManager resetView];
	[self fireInitialOutcomes];
    [UIView commitAnimations];
}

-(void) resetControllerPreservingCurrentDialog {
	[_viewManager resetViewPreservingCurrentDialog];
}


-(void) fireInitialOutcomes {
	MBOutcome *initialOutcome = [[MBOutcome alloc]init];
    initialOutcome.originName = @"Controller";
    initialOutcome.outcomeName = @"init";
    initialOutcome.dialogName = [self activeDialogName];
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
    
    NSMutableArray *dialogs = [NSMutableArray array];
    NSString *selectPageInDialog = @"yes";
	
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
			outcomeToProcess.dialogName = outcome.dialogName;
			if (outcome.displayMode != nil) outcomeToProcess.displayMode = outcome.displayMode;
			outcomeToProcess.noBackgroundProcessing = outcome.noBackgroundProcessing || outcomeDef.noBackgroundProcessing;

			if([outcomeToProcess isPreConditionValid]) {
			
				// Update a possible switch of dialog/display mode set by the outcome definition
				if(outcomeDef.dialog != nil) outcomeToProcess.dialogName = outcomeDef.dialog;
				if(outcomeDef.displayMode != nil) outcomeToProcess.displayMode = outcomeDef.displayMode;
				if(outcomeToProcess.originDialogName == nil) outcomeToProcess.originDialogName = outcomeToProcess.dialogName;
				
				if(outcomeToProcess.dialogName != nil) [dialogs addObject: outcomeToProcess.dialogName];
				
				if([@"MODAL" isEqualToString: outcomeToProcess.displayMode] || 
				   [@"MODALFORMSHEET" isEqualToString: outcomeToProcess.displayMode] || 
				   [@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:outcomeToProcess.displayMode] ||
				   [@"MODALPAGESHEET" isEqualToString:	outcomeToProcess.displayMode] ||		
				   [@"MODALFULLSCREEN" isEqualToString:	outcomeToProcess.displayMode] ||		
				   [@"MODALCURRENTCONTEXT" isEqualToString:	outcomeToProcess.displayMode])	{
					self.outcomeWhichCausedModal = outcomeToProcess;   
				}
				else if([@"ENDMODAL" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager endModalDialog];   
				}
				else if([@"ENDMODAL_CONTINUE" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager endModalDialog];
					[self performSelector:@selector(handleOutcome:) withObject:self.outcomeWhichCausedModal afterDelay:0];
					self.outcomeWhichCausedModal = nil;
				}
				else if([@"POP" isEqualToString: outcomeToProcess.displayMode]) {
					// TODO: This causes a bug when the user desides to pop the rootViewController
					[_viewManager popPage: outcomeToProcess.dialogName];   
				}
				else if([@"POPALL" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager endDialog: outcomeToProcess.dialogName keepPosition:TRUE];   
				}
				else if([@"CLEAR" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager resetView];   
				}
				else if([@"END" isEqualToString: outcomeToProcess.displayMode]) {
					[_viewManager endDialog: outcomeToProcess.dialogName keepPosition: FALSE];   
					[dialogs removeObject:outcomeToProcess.dialogName];
				}
				else {
					[_viewManager notifyDialogUsage: outcomeToProcess.dialogName];	
				}
				
                // Action
				MBActionDefinition *actionDef = [metadataService definitionForActionName:outcomeDef.action throwIfInvalid: FALSE];
				if(actionDef != nil) { 
					[_viewManager showActivityIndicatorForDialog:outcomeToProcess.dialogName];
					if(outcomeToProcess.noBackgroundProcessing) [self performSelector:@selector(performActionInBackground:) withObject:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], actionDef, nil]];
					else [self SELECTOR_HANDLING:@selector(performActionInBackground:) withObject:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], actionDef, nil]];
				}
				
                // Page
				MBPageDefinition *pageDef = [metadataService definitionForPageName:outcomeDef.action throwIfInvalid: FALSE];
				if(pageDef != nil) {
					[_viewManager showActivityIndicatorForDialog:outcomeToProcess.dialogName];
					if(outcomeToProcess.noBackgroundProcessing) [self performSelector:@selector(preparePageInBackground:) withObject:[NSArray arrayWithObjects: [[[MBOutcome alloc] initWithOutcome:outcomeToProcess] autorelease], pageDef.name, selectPageInDialog, nil]];
					else [self SELECTOR_HANDLING:@selector(preparePageInBackground:) withObject:[NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess]autorelease], pageDef.name, selectPageInDialog, nil]];

					selectPageInDialog = @"no";
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
}

//////// PAGE HANDLING

- (void)preparePageInBackground:(NSArray*)args {
	
    MBOutcome *causingOutcome = [args objectAtIndex:0];
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @try {
	
        NSString *pageName = [args objectAtIndex:1];
        NSString *selectPageInDialog = [args objectAtIndex:2];
        
        // construct the page
        MBPageDefinition *pageDefinition = [[MBMetadataService sharedInstance] definitionForPageName:pageName];
		
		// Load the document from the store
		MBDocument *document = nil;
		
		if(causingOutcome.transferDocument) {
			if(causingOutcome.document == nil)  {
				NSString *msg = [NSString stringWithFormat:@"No document provided (nil) in outcome by action/page=%@ but transferDocument='TRUE' in outcome definition", causingOutcome.originName];
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
				  
		if(causingOutcome.noBackgroundProcessing) [self performSelector:@selector(showResultingPage:) 
															 withObject:[NSArray arrayWithObjects:causingOutcome, pageDefinition, document, selectPageInDialog, nil]];
		else [self performSelectorOnMainThread:@selector(showResultingPage:) 
									withObject:[NSArray arrayWithObjects:causingOutcome, pageDefinition, document, selectPageInDialog, nil]
								 waitUntilDone:YES];
        
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
        [_viewManager hideActivityIndicatorForDialog:causingOutcome.dialogName];
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
        NSString *selectPageInDialog = [args objectAtIndex:3];
        
        CGRect bounds = [[UIScreen mainScreen] applicationFrame];
        
        MBPage *page = [_applicationFactory createPage:pageDefinition 
											  document: document 
											  rootPath: causingOutcome.path  
											 viewState: viewState 
										 withMaxBounds: bounds];
        page.controller = self;
        page.dialogName = causingOutcome.dialogName;
		// Fallback on the lastly selected dialog if there is no dialog set in the outcome:
	    if(page.dialogName == nil) {
			page.dialogName = [self activeDialogName];
		}
        BOOL doSelect = [@"yes" isEqualToString:selectPageInDialog] && !_suppressPageSelection;
        [_viewManager showPage: page displayMode: displayMode transitionStyle: transitionStyle selectDialog:doSelect];
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
			[_viewManager hideActivityIndicatorForDialog:causingOutcome.dialogName];
            DLog(@"No outcome produced by action %@ (outcome == nil); no further procesing.", actionDef.name);
        }
        else {
			if(causingOutcome.noBackgroundProcessing) [self performSelector:@selector(handleActionResult:) withObject:[NSArray arrayWithObjects:causingOutcome, actionDef, actionOutcome, nil]];
            else [self performSelectorOnMainThread:@selector(handleActionResult:) withObject:[NSArray arrayWithObjects:causingOutcome, actionDef, actionOutcome, nil] waitUntilDone:YES];
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
		[_viewManager hideActivityIndicatorForDialog:causingOutcome.dialogName];
        
        MBActionDefinition *actionDef = [args objectAtIndex:1];
        MBOutcome *actionOutcome = [args objectAtIndex:2];
        
        if(actionOutcome.dialogName == nil) actionOutcome.dialogName = causingOutcome.dialogName;
        actionOutcome.originName = actionDef.name;

        [self handleOutcome:actionOutcome];
    }
    @catch (NSException *e) {
        [self handleException: e outcome: causingOutcome];
    }
}

//////// END OF ACTION HANDLING

- (MBOutcome*) outcomeWhichCausedModal {
	
	MBOutcome * result = nil;
	@synchronized(self) {
		result = _outcomeWhichCausedModal;
	}
	return result;
}

- (void) setOutcomeWhichCausedModal:(MBOutcome*) outcome {
	@synchronized(self) {
		if(_outcomeWhichCausedModal != outcome) {
			[_outcomeWhichCausedModal release];
			_outcomeWhichCausedModal = outcome;
			[_outcomeWhichCausedModal retain];
		}
	}
}

- (NSString*) activeDialogName {
	NSString *result = nil;
	if(_viewManager != nil) {
	  	result = _viewManager.activeDialogName;
	}
	return result;
}

// Returns nil if the current ActiveDialog is not nested inside a DialogGroup.
- (NSString *) activeDialogGroupName {
	NSString *result = nil;
	if (_viewManager != nil) {
		
		result = _viewManager.activeDialogGroupName;
	}
	return result;
}

-(void) activateDialogWithName:(NSString*) name {
	[_viewManager activateDialogWithName: name];
}

-(void) showActivityIndicatorForDialog:(NSString*) dialogName {
	[_viewManager showActivityIndicatorForDialog:dialogName];
}

-(void) hideActivityIndicatorForDialog:(NSString*) dialogName {
	[_viewManager hideActivityIndicatorForDialog:dialogName];
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
	[_viewManager hideActivityIndicatorForDialog:outcome.dialogName];

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
		genericExceptionHandler.dialogName = outcome.dialogName;
		genericExceptionHandler.path = outcome.path;
		
		[self doHandleOutcome: genericExceptionHandler];
	}
}


@end
