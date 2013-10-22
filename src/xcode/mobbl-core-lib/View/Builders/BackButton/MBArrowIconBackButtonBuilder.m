/*
 * (C) Copyright ItudeMobile.
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

#import "MBArrowIconBackButtonBuilder.h"

@implementation MBArrowIconBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIImage *iconImage = [UIImage imageNamed:@"backButtonIconArrowWhite.png"];
    return [[[UIBarButtonItem alloc] initWithImage:iconImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)] autorelease];
}

@end
