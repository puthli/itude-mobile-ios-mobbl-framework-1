//
//  MBPanelViewBuilder.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTypes.h"

@class MBPanel;

@protocol MBPanelViewBuilder <NSObject>
-(UIView*) buildPanelView:(MBPanel*) panel withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState;
@end
