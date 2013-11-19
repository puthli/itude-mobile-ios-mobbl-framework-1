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

#import <Foundation/Foundation.h>

@interface UIView (TreeWalker)

/**
* @return all subviews of the given class. The top level UIView is NOT included. Returns an empty array if no
* UIViews are found.
*/
- (NSArray *)subviewsOfClass:(Class)clazz;

/**
 * @return the first superview of the given class. Returns nil if no
 * superview of the given class is found.
 */
- (UIView *)firstSuperviewOfClass:(Class)clazz;

@end