//
//  MBArrowIconBackButtonBuilder.m
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/30/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBArrowIconBackButtonBuilder.h"

@implementation MBArrowIconBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIImage *iconImage = [UIImage imageNamed:@"backButtonIconArrowWhite.png"];
    return [[[UIBarButtonItem alloc] initWithImage:iconImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)] autorelease];
}

@end
