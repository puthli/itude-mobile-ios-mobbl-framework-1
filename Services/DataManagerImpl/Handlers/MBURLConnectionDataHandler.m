//
//  MBURLConnectionDataHandler.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

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
