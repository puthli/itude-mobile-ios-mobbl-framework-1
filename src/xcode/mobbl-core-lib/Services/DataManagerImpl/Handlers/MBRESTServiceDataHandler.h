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

#import "MBWebserviceDataHandler.h"
#import "MBURLConnectionDataHandler.h"

/** retrieves and sends MBDocument instances to and from a webservice using HTTP POST. */
@interface MBRESTServiceDataHandler : MBURLConnectionDataHandler {

	NSString *_documentFactoryType;
}

@property (nonatomic, retain) NSString *documentFactoryType;

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args;
- (void) storeDocument:(MBDocument *)document;

- (NSMutableURLRequest *) setupHTTPRequest:(NSMutableURLRequest *)request;

@end
