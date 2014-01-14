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

#import "MBApplicationFactory.h"

@class MBPage;
@class MBApplicationFactory;
@class MBOutcome;
@class MBViewManager;
@class MBAlertController;
@class MBOutcomeManager;
@protocol MBOutcomeListenerProtocol;


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
    BOOL _applicationActive;
}

@property (nonatomic, assign) BOOL applicationActive;
@property (nonatomic, assign) MBViewManager *viewManager;
@property (readonly, nonatomic) MBApplicationFactory *applicationFactory;
@property (readonly, nonatomic, retain) MBAlertController *alertController;
@property (readonly, nonatomic, retain) MBOutcomeManager *outcomeManager;

/** determines which MBPage or MBAction to execute based on the outcome.
 @param outcome an MBOutcome defined in the application configuration (config.xmlx)
 */
-(void) handleOutcome:(MBOutcome *)outcome;
-(void) startApplication:(MBApplicationFactory *)_applicationFactory;
-(void) handleExceptionAfterDelay:(NSArray *)args;
-(void) handleException:(NSException*) exception outcome:(MBOutcome*) outcome;
+(MBApplicationController *) currentInstance;
-(NSString*) activePageStackName;
-(NSString *) activeDialogName;
-(void) activatePageStackWithName:(NSString*) name;
-(void) showActivityIndicatorWithMessage:(NSString*) message;
-(void) showActivityIndicator;
-(void) hideActivityIndicator;
-(void) resetControllerPreservingCurrentPageStack;
-(void) resetController;

@end
