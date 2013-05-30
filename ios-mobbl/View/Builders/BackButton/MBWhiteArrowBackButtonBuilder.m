//
//  MBWhiteArrowBackButtonBuilder.m
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/30/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBWhiteArrowBackButtonBuilder.h"

@implementation MBWhiteArrowBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton new] autorelease];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"backButtonArrowInverted.png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

@end
