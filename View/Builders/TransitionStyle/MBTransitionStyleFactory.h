//
//  MBTransitionStyleFactory.h
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 26-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTransitionStyles.h"

@protocol MBTransitionStyle;

@interface MBTransitionStyleFactory : NSObject

/// @name Registering MBTransitionStyle instances
- (void)registerTransistion:(id<MBTransitionStyle>)transition forTransitionStyle:(NSString *)transitionStyle;

/// @name Getting a MBRowViewBuilder instance
@property (nonatomic, retain) id<MBTransitionStyle> defaultTransition;
- (id<MBTransitionStyle>)transitionForStyle:(NSString*)transitionStyle;

- (void) applyTransitionStyle:(NSString *)transitionStyle forViewController:(UIViewController *)viewController modal:(BOOL)modal;

@end
