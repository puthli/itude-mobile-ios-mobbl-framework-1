//
//  UINavigationController+Rotation
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/28/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Rotation)

#pragma mark - iOS 6 and up
-(BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;

#pragma mark - iOS 5 and lower
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
