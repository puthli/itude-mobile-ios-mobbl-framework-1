/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
