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

#import "MBPanelViewBuilderFactory.h"
#import "MBPageViewBuilder.h"
#import "MBAlertViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBRowViewBuilder.h"
#import "MBFieldViewBuilderFactory.h"
#import "MBRowViewBuilderFactory.h"
#import "MBDialogContentViewBuilderFactory.h"
#import "MBDialogDecoratorFactory.h"
#import "MBBackButtonBuilderFactory.h"
#import "MBStyleHandler.h"

@interface MBViewBuilderFactory : NSObject {

	MBPageViewBuilder *_pageViewBuilder;
    MBAlertViewBuilder *_alertViewBuilder;
	MBForEachViewBuilder *_forEachViewBuilder;
	MBStyleHandler *_styleHandler;
}

@property (nonatomic, retain, readonly) MBPanelViewBuilderFactory *panelViewBuilderFactory;
@property (nonatomic, retain) MBPageViewBuilder *pageViewBuilder;
@property (nonatomic, retain) MBAlertViewBuilder *alertViewBuilder;
@property (nonatomic, retain) MBForEachViewBuilder *forEachViewBuilder;
@property (nonatomic, retain) MBStyleHandler *styleHandler;
@property (nonatomic, retain, readonly) MBFieldViewBuilderFactory *fieldViewBuilderFactory;
@property (nonatomic, retain, readonly) MBRowViewBuilderFactory *rowViewBuilderFactory;
@property (nonatomic, retain) MBDialogContentViewBuilderFactory *dialogContentViewBuilderFactory;
@property (nonatomic, retain, readonly) MBDialogDecoratorFactory *dialogDecoratorFactory;
@property (nonatomic, retain, readonly) MBBackButtonBuilderFactory *backButtonBuilderFactory;

/**
* Return the default MBRowViewBuilder.
*
* Use MBRowViewBuilderFactory:builderForStyle to get a custom MBRowViewBuilder for a given row style.
*/
- (id<MBRowViewBuilder>)rowViewBuilder;

+(MBViewBuilderFactory *) sharedInstance;
+(void) setSharedInstance:(MBViewBuilderFactory *) factory;



@end
