//
//  MBApplicationController.h
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBApplicationFactory.h"

@class MBPage;
@class MBApplicationFactory;
@class MBOutcome;
@class MBViewManager;

@interface MBApplicationController : NSObject {
	
	@private
	MBApplicationFactory *_applicationFactory;
	MBViewManager *_viewManager;
	BOOL _suppressPageSelection;
	MBOutcome *_outcomeWhichCausedModal;
    BOOL _applicationActive;
}

@property (nonatomic, assign) BOOL applicationActive;
@property (nonatomic, assign) MBViewManager *viewManager;


-(void) startApplication:(MBApplicationFactory *)_applicationFactory;
-(void) handleOutcome:(MBOutcome *)outcome;
-(void) handleExceptionAfterDelay:(NSArray *)args;
-(void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome;
+(MBApplicationController *) currentInstance;
-(NSString*) activeDialogName;
-(NSString *) activeDialogGroupName;
-(void) activateDialogWithName:(NSString*) name;
-(void) showActivityIndicatorForDialog:(NSString*) dialogName;
-(void) hideActivityIndicatorForDialog:(NSString*) dialogName;
-(void) resetControllerPreservingCurrentDialog;

@end
