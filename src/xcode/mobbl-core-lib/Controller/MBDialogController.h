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

#import "MBPageStackController.h"
#import "MBDialogDefinition.h"
#import "MBSplitViewController.h"
#import "MBPageStackController.h"

@interface MBDialogController : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *showAs;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *decorator;
@property (nonatomic, assign) BOOL closable;
@property (nonatomic, retain) NSMutableArray *pageStackControllers;
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL visible;

- (id) initWithDefinition:(MBDialogDefinition*)definition;

- (MBPageStackController *)pageStackControllerWithName:(NSString *)name;

- (void) resetView;

- (void) showActivityIndicator;
- (void) hideActivityIndicator;

- (BOOL) showAsTab;

@end
