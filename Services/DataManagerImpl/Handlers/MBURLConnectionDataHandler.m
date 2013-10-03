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
#import "MBDataManagerService.h"
#import "MBMacros.h"
#import "MBConstants.h"

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

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    if ([self allowSelfSignedSslCertificates]) {
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([self allowSelfSignedSslCertificates]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

/**
 * @return YES if self signed certificates are allowed and debug is disabled
 * @discussion This methoud will return FALSE if; 
 * - debug is disabled,
 * - the environment document can not be found.
 */
- (BOOL) allowSelfSignedSslCertificates {

    BOOL allowSelfSignedSslCerfificates = NO;
    
    @try {
#ifdef DEBUG
        MBDocument *environmentDocument = [[MBDataManagerService sharedInstance] loadDocument:C_APPLICATION_ENVIRONMENT];
        allowSelfSignedSslCerfificates = [[environmentDocument valueForPath:@"Secure[0]/@allowAll"] boolValue];
#endif
    }
    @catch (NSException *exception) {
        DLog(@"No Environment properties set");
    }
    @finally {
        return allowSelfSignedSslCerfificates;
    }

}

@end


@implementation MBURLConnectionDataHandler

@end
