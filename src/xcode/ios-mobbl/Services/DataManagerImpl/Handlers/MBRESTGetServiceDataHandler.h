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

#import <UIKit/UIKit.h>

#import "MBURLConnectionDataHandler.h"

/** DataHandler implementation that uses HTTP GET requests for read operations and HTTP POST for create operations. */
@interface MBRESTGetServiceDataHandler : MBURLConnectionDataHandler

/** Create an MBDocument containing the elements of the dictionary. The resulting MBDocument can be used in loadDocument:withArguments. */
+ (MBDocument *)argumentsDocumentForDictionary:(NSDictionary *)arguments;

// Isolated methods that can be overridden in Testing subclass, making it possible to unit test without actual connection or XML configuration
- (NSURLConnection *)createConnectionAndStartLoadingWithRequest:(NSURLRequest *)request delegate:(MBRequestDelegate *)delegate;
- (MBDocument *)createDocumentWithName:(NSString *)documentName forData:(NSData *)data;

- (NSString *)getRequestUrlForDocument:(NSString *)documentName WithArguments:(MBDocument *)arguments;

- (NSMutableURLRequest *) setupHTTPRequest:(NSMutableURLRequest *)request withArguments:(MBDocument *)arguments;

@end
