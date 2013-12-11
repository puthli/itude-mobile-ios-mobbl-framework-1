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

#import "MBDocumentDefinition.h"
#import "MBResultListenerDefinition.h"

@interface MBEndPointDefinition : MBDefinition {
	NSString *_documentIn;
	NSString *_documentOut;
	NSString *_endPointUri;
    NSMutableArray *_resultListeners;
	BOOL _cacheable;
	int _timeout;
	int _ttl;
}

@property (nonatomic, retain) NSString *documentIn;
@property (nonatomic, retain) NSString *documentOut;
@property (nonatomic, retain) NSString *endPointUri;
@property (nonatomic, assign) BOOL cacheable;
@property (nonatomic, assign) int timeout;
@property (nonatomic, assign) int ttl;

- (void) addResultListener:(MBResultListenerDefinition*) lsnr;
- (NSMutableArray*) resultListeners;

@end
