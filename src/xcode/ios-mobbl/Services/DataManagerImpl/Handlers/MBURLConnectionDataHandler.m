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

#import "MBURLConnectionDataHandler.h"

// uncomment to allow self signed SSL certificates
// #define ALLOW_SELFSIGNED_SSL_CERTS 1

@implementation MBRequestDelegate

@synthesize connection = _connection;
@synthesize err = _err;
@synthesize response = _response;
@synthesize data = _data;
@synthesize finished = _finished;

-(void) dealloc{
	self.data = nil;
	self.err = nil;
	self.response = nil;
	self.connection = nil;
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	_finished = YES;
	self.err = error;
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.data appendData:data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.data setLength:0];
	self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	_finished = YES;
}

- (void) cancel{
    [self.connection cancel];
    _finished = YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
	// never cache the response of the urlConnection here.
	return nil;
}

#ifdef ALLOW_SELFSIGNED_SSL_CERTS

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#endif

@end


@implementation MBURLConnectionDataHandler

@end
