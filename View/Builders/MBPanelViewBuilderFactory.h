//
//  MBPanelViewBuilderFactory.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTypes.h"

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
