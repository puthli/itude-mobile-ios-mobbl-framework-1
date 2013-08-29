//
//  UIViewController+Layout.m
//  Binck
//
//  Created by Frank van Eenbergen on 8/29/13.
//  Copyright (c) 2013 Itude Mobile BV. All rights reserved.
//

#import "UIViewController+Layout.h"

@implementation UIViewController (Layout)

- (void)setupLayoutForIOS7 {
    // iOS7 (make sure we don't draw underneath the navigation bar)
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

@end
