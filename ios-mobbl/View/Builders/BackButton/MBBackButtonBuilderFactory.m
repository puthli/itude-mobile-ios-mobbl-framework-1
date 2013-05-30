//
//  MBBackButtonBuilderFactory.m
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/30/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBBackButtonBuilderFactory.h"

@interface MBBackButtonBuilderFactory ()

@end;

@implementation MBBackButtonBuilderFactory {
    id<MBBackButtonBuilder> _defaultBuilder;
}

@synthesize defaultBuilder = _defaultBuilder;

- (void)dealloc
{
    [_defaultBuilder release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // TODO: Maybe set a default builder
        //_defaultBuilder = [MBDefaultBackButtonBuilder new];
    }
    return self;
}

- (UIBarButtonItem *)buildBackButton {
    return [self.defaultBuilder buildBackButton];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    return [self.defaultBuilder buildBackButtonWithTitle:title];
}


@end