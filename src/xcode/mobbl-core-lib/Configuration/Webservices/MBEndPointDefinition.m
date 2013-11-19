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

#import "MBEndPointDefinition.h"


@implementation MBEndPointDefinition

@synthesize documentIn = _documentIn;
@synthesize documentOut = _documentOut;
@synthesize endPointUri = _endPointUri;
@synthesize cacheable = _cacheable;
@synthesize ttl = _ttl;
@synthesize timeout = _timeout;

- (id) init
{
    self = [super init];
    if (self != nil) {
        _resultListeners = [NSMutableArray new];
    }
    return self;
}

- (void) dealloc
{
	[_endPointUri release];
	[_documentOut release];
	[_documentIn release];
    [_resultListeners release];
	[super dealloc];
}

- (void) addResultListener:(MBResultListenerDefinition*) lsnr {
    [_resultListeners addObject: lsnr];
}

- (NSMutableArray*) resultListeners {
    return _resultListeners;
}

@end
