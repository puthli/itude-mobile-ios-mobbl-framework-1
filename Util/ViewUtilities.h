//
//  ViewUtilities.h
//  Core
//
//  Created by Wido on 14-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface UIView (ViewAdditions)

/**
 * Searches for the first child (subview) of the given clazz that is a direct subview of UIView (self).
 * @param clazz = The Class-type that should be searched for
 * @return The first subView that is a child of the given Class-type OR nil
 * @note Returns nil if the view has no subviews or no child of the given Class-type is found.
 */
-(id) firstChildOfType:(Class) clazz;


/**
 * Searches for the first descendant of the given Class-type. The search is performed down the entire tree of children.
 * @param clazz = The Class-type that should be searched for
 * @return The first subView that is a descendant of the given Class-type OR nil
 * @note Returns nil if the view has no subviews or no child of the given Class-type is found.
 */
-(id) firstDescendantOfType:(Class) clazz;

@end
