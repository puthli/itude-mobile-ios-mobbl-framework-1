//
//  ViewUtilities.m
//  Core
//
//  Created by Wido on 14-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "ViewUtilities.h"


@implementation UIView (ViewAdditions)

-(id) firstChildOfType:(Class) clazz {
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:clazz]) return view;
	}
	return nil;
}

-(id) firstDescendantOfType:(Class) clazz {
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:clazz]) return view;
		UIView *sub = [view firstDescendantOfType: clazz];
		if(sub != nil) return sub;
	}
	return nil;
}

@end
