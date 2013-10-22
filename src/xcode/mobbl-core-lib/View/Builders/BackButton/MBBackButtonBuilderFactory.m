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

#import "MBBackButtonBuilderFactory.h"

@interface MBBackButtonBuilderFactory ()

@end;

@implementation MBBackButtonBuilderFactory {
    id<MBBackButtonBuilder> _defaultBuilder;
}

@synthesize defaultBuilder = _defaultBuilder;

- (void)dealloc
{
    [_defaultBuilder release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // TODO: Maybe set a default builder
        //_defaultBuilder = [MBDefaultBackButtonBuilder new];
    }
    return self;
}

- (UIBarButtonItem *)buildBackButton {
    return [self.defaultBuilder buildBackButton];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    return [self.defaultBuilder buildBackButtonWithTitle:title];
}


@end