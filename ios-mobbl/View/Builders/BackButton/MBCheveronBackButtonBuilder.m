//
//  MBCheveronBackButtonBuilder.m
//  Binck
//
//  Created by Frank van Eenbergen on 9/3/13.
//  Copyright (c) 2013 Itude Mobile BV. All rights reserved.
//

#import "MBCheveronBackButtonBuilder.h"

@implementation MBCheveronBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIImage *iconImage = [UIImage imageNamed:@"backButtonCheveron.png"];
    return [[[UIBarButtonItem alloc] initWithImage:iconImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)] autorelease];
}


@end
