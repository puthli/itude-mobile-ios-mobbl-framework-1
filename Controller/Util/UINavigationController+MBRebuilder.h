//
//  UINavigationController+MBRebuilder.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/12/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MBRebuilder)<UINavigationBarDelegate>
-(void) rebuild;
-(void)setRootViewController:(UIViewController *)rootViewController;
@end
