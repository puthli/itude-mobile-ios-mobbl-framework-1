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

#import "MBWhiteArrowBackButtonBuilder.h"

@implementation MBWhiteArrowBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton new] autorelease];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"backButtonArrowInverted.png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

@end
