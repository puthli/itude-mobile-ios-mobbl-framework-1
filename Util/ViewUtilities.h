//
//  ViewUtilities.h
//  Core
//
//  Created by Wido on 14-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface UIView (ViewAdditions)

-(id) firstChildOfType:(Class) clazz;
-(id) firstDescendantOfType:(Class) clazz;

@end
