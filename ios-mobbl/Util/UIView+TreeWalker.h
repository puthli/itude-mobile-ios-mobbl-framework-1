//
//  UIView(TreeWalker) 
//
//  Created by Pieter Kuijpers on 14-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (TreeWalker)

/**
* @return all subviews of the given class. The top level UIView is NOT included. Returns an empty array if no
* UIViews are found.
*/
- (NSArray *)subviewsOfClass:(Class)clazz;

@end