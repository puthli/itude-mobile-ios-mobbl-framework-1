//
//  UIView+HierarchyLogging.h
//  Core
//
//  Created by Ricardo de Wilde on 9/27/11.
//  Copyright (c) 2011 Itude Mobile BV. All rights reserved.
//

#ifndef Binck_UIView_HierarchyLogging_h
#define Binck_UIView_HierarchyLogging_h

@interface UIView (ViewHierarchyLogging)
- (void)logViewHierarchy;
- (void)logViewHierarchy:(int)index;
@end

// UIView+HierarchyLogging.m
@implementation UIView (ViewHierarchyLogging)
- (void)logViewHierarchy
{
    NSLog(@"LEVEL:0---%@", self);
    for (UIView *subview in self.subviews)
    {
        [subview logViewHierarchy:0];
    }
}

- (void)logViewHierarchy:(int)index
{
    NSString *level = [NSString stringWithFormat:@"%d---", index];
    for (int i=0; i<index; i++) level = [level stringByAppendingString:@"---"];
    NSLog(@"LEVEL:%@%@", level, self);
    for (UIView *subview in self.subviews)
    {
        [subview logViewHierarchy:index+1];
    }
}
@end

#endif
