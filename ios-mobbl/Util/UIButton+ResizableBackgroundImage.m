//
//  UIButton+ResizableBackgroundImage.m
//  Binck
//
//  Created by Frank van Eenbergen on 8/23/13.
//  Copyright (c) 2013 Itude Mobile BV. All rights reserved.
//

#import "UIButton+ResizableBackgroundImage.h"

@implementation UIButton (ResizableBackgroundImage)

- (void)setResizableBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, image.size.width/2 - 2, image.size.height, image.size.width/2 + 2);
    image = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:image forState:state];
}

@end
