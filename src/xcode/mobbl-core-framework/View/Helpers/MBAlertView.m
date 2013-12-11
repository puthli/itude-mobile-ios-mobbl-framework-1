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

#import "MBAlertView.h"
#import "MBField.h"

@interface MBAlertView () {
    NSMutableDictionary *_fields;
}
@property (nonatomic, retain) NSMutableDictionary *fields;
@end

@implementation MBAlertView

@synthesize fields = _fields;


- (void)dealloc
{
    [_fields release];
    [super dealloc];
}

- (void)setField:(MBField *)field forButtonWithKey:(NSString *)key {
    [self.fields setObject:field forKey:key];
}

- (MBField *)fieldForButtonAtIndex:(NSInteger) index {
    NSString *title = [self buttonTitleAtIndex:index];
    return [self.fields objectForKey:title];
}


- (NSMutableDictionary *)fields {
    if (!_fields) {
        _fields = [NSMutableDictionary new];
    }
    return _fields;
}

@end
