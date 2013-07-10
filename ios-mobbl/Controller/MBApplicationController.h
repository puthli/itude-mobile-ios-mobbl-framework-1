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

/** Application Controller. Facade for all navigation control and logic sequencing.
 * The MBApplicationController is responsible for determining which MBPage or MBAction should be constructed when an MBOutcome is triggered.
 * The handleOutcome method is the main usage. The MBOutcomes are defined in the application configuration which is typically the config.xmlx file. Alternatively config.xmlx may reference a file using the <Include ...> directive in which case outcomes.xmlx is an often used convention. 
 * 
 * The UIApplicationDelegate in a project is typically a subclass of the MBApplicationController.
 */
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
@property (readonly, nonatomic) MBApplicationFactory *applicationFactory;

/** determines which MBPage or MBAction to execute based on the outcome.
 @param outcome an MBOutcome defined in the application configuration (config.xmlx)
 */
-(void) handleOutcome:(MBOutcome *)outcome;
-(void) startApplication:(MBApplicationFactory *)_applicationFactory;
-(void) handleExceptionAfterDelay:(NSArray *)args;
-(void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome;
+(MBApplicationController *) currentInstance;
-(NSString*) activeDialogName;
-(NSString *) activeDialogGroupName;
-(void) activateDialogWithName:(NSString*) name;
-(void) showActivityIndicatorWithMessage:(NSString*) dialogName;
-(void) hideActivityIndicatorForDialog:(NSString*) dialogName;
-(void) resetControllerPreservingCurrentDialog;

@end
