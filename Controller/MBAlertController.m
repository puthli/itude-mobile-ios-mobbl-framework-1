//
//  MBAlertController.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertController.h"
#import "MBAlertDefinition.h"
#import "MBAlert.h"
#import "MBApplicationController.h"
#import "MBOutcome.h"
#import "MBMetadataService.h"
#import "MBDataManagerService.h"
#import "MBMacros.h"


@interface MBAlertController () <UIAlertViewDelegate> {
    MBAlert *_currentAlert;
}
@property (nonatomic, retain) MBAlert *currentAlert;
- (void)prepareAlertInBackground:(NSArray *)args;
- (void)showResultingAlert:(NSArray *)args;
@end


@implementation MBAlertController

@synthesize currentAlert = _currentAlert;

- (void)dealloc
{
    [_currentAlert release];
    [super dealloc];
}

- (void)handleAlert:(MBAlertDefinition *)alertDef forOutcome:(MBOutcome *)outcomeToProcess {
    NSArray *args = [NSArray arrayWithObjects:[[[MBOutcome alloc] initWithOutcome:outcomeToProcess]autorelease], alertDef.name, nil];
    [self performSelector:@selector(prepareAlertInBackground:) withObject:args];
}


- (void)prepareAlertInBackground:(NSArray *)args {
    
    MBOutcome *causingOutcome = [args objectAtIndex:0];
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @try {
        
        
        NSString *alertName = [args objectAtIndex:1];
        
        // construct the alert
        MBAlertDefinition *alertDefinition = [[MBMetadataService sharedInstance] definitionForAlertName:alertName];
        
		// Load the document from the store
		MBDocument *document = nil;
		if(causingOutcome.transferDocument) {
			if(causingOutcome.document == nil)  {
				NSString *msg = [NSString stringWithFormat:@"No document provided (nil) in outcome by action/alert=%@ but transferDocument='TRUE' in outcome definition", causingOutcome.originName];
				@throw [NSException exceptionWithName:@"InvalidOutcome" reason:msg userInfo:nil];
			}
			NSString *actualType =  [[causingOutcome.document definition] name];
			if(![actualType isEqualToString: [alertDefinition documentName]]) {
				NSString *msg = [NSString stringWithFormat:@"Document provided via outcome by action/alert=%@ (transferDocument='TRUE') is of type %@ but must be of type %@",
								 causingOutcome.originName, actualType, [alertDefinition documentName]];
				@throw [NSException exceptionWithName:@"InvalidOutcome" reason:msg userInfo:nil];
			}
			document = causingOutcome.document;
		}
		else {
			document = [[MBDataManagerService sharedInstance] loadDocument:[alertDefinition documentName]];
            
			if(document == nil) {
				document = [[MBDataManagerService sharedInstance] loadDocument:[alertDefinition documentName]];
				NSString *msg = [NSString stringWithFormat:@"Document with name %@ not found (check filesystem/webservice)", [alertDefinition documentName]];
				@throw [NSException exceptionWithName:@"NoDocument" reason:msg userInfo:nil];
			}
		}
        
        // Show the alert
		if(causingOutcome.noBackgroundProcessing) [self performSelector:@selector(showResultingAlert:)
															 withObject:[NSArray arrayWithObjects:causingOutcome, alertDefinition, document, nil]];
		else [self performSelectorOnMainThread:@selector(showResultingAlert:)
									withObject:[NSArray arrayWithObjects:causingOutcome, alertDefinition, document, nil]
								 waitUntilDone:YES];
        
    }
    @catch (NSException *e) {
        [[MBApplicationController currentInstance] handleException:e outcome:causingOutcome];
    }
    @finally {
        [pool release];
    }
    
}

- (void)showResultingAlert:(NSArray *)args {
    MBOutcome *causingOutcome = [args objectAtIndex:0];
    MBViewManager *viewManager = [[MBApplicationController currentInstance] viewManager];
    @try {
        [viewManager hideActivityIndicatorForDialog:causingOutcome.dialogName];
        
        MBAlertDefinition *alertDefinition = [args objectAtIndex:1];
        MBDocument *document = [args objectAtIndex:2];
        
        self.currentAlert = [[[MBApplicationController currentInstance] applicationFactory] createAlert:alertDefinition document:document rootPath:causingOutcome.path delegate:self];
        [viewManager showAlert:self.currentAlert];
    }
    @catch (NSException *e) {
        [[MBApplicationController currentInstance] handleException:e outcome:causingOutcome];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    MBOutcome *outcome = [self.currentAlert outcomeForButtonAtIndex:buttonIndex];
    if (outcome) {
        [[MBApplicationController currentInstance] handleOutcome:outcome];
    }    
    else if (buttonIndex != alertView.cancelButtonIndex) {
        WLog(@"WARNING! Button at index %i has no outcome defined",buttonIndex);
    }
        
}

@end
