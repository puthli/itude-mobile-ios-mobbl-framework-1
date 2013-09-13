//
//  UITextField+ResizableBackgroundImage.m
//  Binck
//
//  Created by Frank van Eenbergen on 9/13/13.
//  Copyright (c) 2013 Itude Mobile BV. All rights reserved.
//

#import "UITextField+ResizableBackgroundImage.h"

@implementation UITextField (ResizableBackgroundImage)

-(void)setResizableBackgroundImage:(UIImage *)image {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, image.size.width/2 - 2, image.size.height, image.size.width/2 + 2);
    image = [image resizableImageWithCapInsets:insets];
    [self setBackground:image];
}

@end
