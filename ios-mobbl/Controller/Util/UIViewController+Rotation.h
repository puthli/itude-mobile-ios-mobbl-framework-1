//
//  UIViewController+Rotation.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/19/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Rotation)

#pragma mark - iOS 6 and up
-(BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;

#pragma mark - iOS 5 and lower
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
