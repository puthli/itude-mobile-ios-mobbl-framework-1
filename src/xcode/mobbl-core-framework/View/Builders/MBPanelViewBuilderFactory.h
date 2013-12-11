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

#import <Foundation/Foundation.h>
#import "MBTypes.h"
#import "MBPanelTypes.h"

@protocol MBPanelViewBuilder;
@class MBPanel;

@interface MBPanelViewBuilderFactory : NSObject

/// @name Registering MBRowViewBuilder instances
- (void)registerPanelViewBuilder:(id<MBPanelViewBuilder>)panelViewBuilder forPanelType:(NSString*)type forPanelStyle:(NSString *)style;
- (void)registerPanelViewBuilder:(id<MBPanelViewBuilder>)panelViewBuilder forPanelType:(NSString*)type;

/// @name Getting a MBRowViewBuilder instance
@property (nonatomic, retain) id<MBPanelViewBuilder> defaultBuilder;
- (id<MBPanelViewBuilder>)builderForType:(NSString *)type withStyle:(NSString*)style;

-(UIView*) buildPanelView:(MBPanel*) panel forParent:(UIView*) parent  withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState;

@end
