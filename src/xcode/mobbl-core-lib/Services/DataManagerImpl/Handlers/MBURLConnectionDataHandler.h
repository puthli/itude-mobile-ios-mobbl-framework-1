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
#import "MBWebserviceDataHandler.h"

// Delegate used for callbacks in asynchronous http request. //
@interface MBRequestDelegate : NSObject // <NSURLConnectionDelegate> from iOS 5 on
{
	
	BOOL _finished;
	NSMutableData *_data;
	NSURLConnection *_connection;
	NSError *_err;
	NSURLResponse *_response;
	
}

@property BOOL finished;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSError *err;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSMutableData *data;

@end

// Abstract superclass for DataHandler that use a NSURLConnection to access data.
@interface MBURLConnectionDataHandler : MBWebserviceDataHandler

@end
