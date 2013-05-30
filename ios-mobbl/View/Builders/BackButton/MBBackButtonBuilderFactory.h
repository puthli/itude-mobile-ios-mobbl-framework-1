//
//  MBBackButtonBuilderFactory.h
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/30/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBBackButtonBuilder.h"

// Builders
#import "MBDefaultBackButtonBuilder.h"
#import "MBArrowIconBackButtonBuilder.h"
#import "MBWhiteArrowBackButtonBuilder.h"


@interface MBBackButtonBuilderFactory : NSObject

@property (nonatomic, retain) id<MBBackButtonBuilder> defaultBuilder;

/// @name Building Back Buttons
- (UIBarButtonItem *)buildBackButton;
- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title;

@end
