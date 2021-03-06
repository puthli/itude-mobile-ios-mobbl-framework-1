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

#import "UIButton+ResizableBackgroundImage.h"

@implementation UIButton (ResizableBackgroundImage)

- (void)setResizableBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, image.size.width/2 - 2, image.size.height, image.size.width/2 + 2);
    image = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:image forState:state];
}

@end
