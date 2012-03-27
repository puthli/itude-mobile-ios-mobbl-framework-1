//
//  MBRESTGetServiceDataHandler.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBRESTGetServiceDataHandler.h"

#import "MBApplicationFactory.h"
#import "MBCacheManager.h"
#import "MBMacros.h"
#import "MBLocalizationService.h"
#import "MBDocumentFactory.h"
#import "MBMetadataService.h"
#import "Reachability.h"

@implementation MBRESTGetServiceDataHandler

+ (MBDocumentDefinition *)argumentsDocumentDefinition
{
    MBDocumentDefinition *requestDocumentDefinition = [[[MBDocumentDefinition alloc] init] autorelease];
    MBElementDefinition *requestDefinition = [[MBElementDefinition alloc] init];
    requestDefinition.name = @"Request";
    [requestDocumentDefinition addElement:requestDefinition];
    
    MBElementDefinition *parameterDefinition = [[MBElementDefinition alloc] init];
    parameterDefinition.name = @"Parameter";
    parameterDefinition.minOccurs = 0;
    [requestDefinition addElement:parameterDefinition];
    
    MBAttributeDefinition *keyAttribute = [[MBAttributeDefinition alloc] init];
    keyAttribute.name = @"key";
    [parameterDefinition addAttribute:keyAttribute];
    MBAttributeDefinition *valueAttribute = [[MBAttributeDefinition alloc] init];
    valueAttribute.name = @"value";
    [parameterDefinition addAttribute:valueAttribute];
    
    [requestDefinition release];
    [parameterDefinition release];
    [keyAttribute release];
    [valueAttribute release];
    
    return requestDocumentDefinition;
}

+ (MBDocument *)argumentsDocumentForDictionary:(NSDictionary *)arguments
{
    MBDocumentDefinition *docDefinition = [[self class] argumentsDocumentDefinition];
    MBDocument *requestDocument = [[[MBDocument alloc] initWithDocumentDefinition:docDefinition] autorelease];
    [requestDocument createElementWithName:@"Request"];
    for (NSString *key in arguments) {
        MBElement *request = [requestDocument valueForPath:@"Request[0]"];
        MBElement *parameter = [request createElementWithName:@"Parameter"];
        [parameter setValue:key forAttribute:@"key"];
        [parameter setValue:[arguments valueForKey:key] forAttribute:@"value"];
    }
    return requestDocument;
}

- (MBDocument *)loadDocument:(NSString *)documentName
{
    return [self loadDocument:documentName withArguments:nil];
}

- (NSURLConnection *)createConnectionAndStartLoadingWithRequest:(NSURLRequest *)request delegate:(MBRequestDelegate *)delegate
{
    return [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

- (MBDocument *)createDocumentWithName:(NSString *)documentName forData:(NSData *)data
{
    return [[MBDocumentFactory sharedInstance] documentWithData:data withType:PARSER_XML andDefinition:[[MBMetadataService sharedInstance] definitionForDocumentName:documentName]];
}

- (MBDocument *)loadDocument:(NSString *)documentName withArguments:(MBDocument *)args
{
    MBEndPointDefinition *endPoint = [self getEndPointForDocument:documentName];
	DLog(@"MBRESTGetServiceDataHandler:loadDocument %@ from %@", documentName, endPoint.endPointUri);
	
	if (endPoint != nil)
	{
		
		// Look for any cached result. If there; return it
		BOOL cacheable = FALSE;
        
		cacheable = [endPoint cacheable];
		if(cacheable) {
			MBDocument *result = [MBCacheManager documentForKey:[args uniqueId]];
			if(result != nil) return result;
		}
		
		NSString *urlString = endPoint.endPointUri;
		BOOL firstParam = YES;
		for (MBElement *element in [args valueForPath:@"/Request[0]/Parameter"]) {
			NSString *key  = [element valueForAttribute:@"key"];
			NSString *value = [element valueForAttribute:@"value"];
			if ([key isEqualToString:@"query"]) {
				if ([value length]>0) {
					urlString = [urlString stringByAppendingString:value];
				}
			}
			else{
				NSString *value = [element valueForAttribute:@"value"];
				if (firstParam) {
					urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@=%@", key, value]];
					firstParam = NO;
				}
				else {
					urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
				}
                
			}
		}
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:endPoint.timeout];
		[request setHTTPMethod:@"GET"];
		
		// Content-Type must be set because otherwise the MidletCommandProcessor servlet cannot read the XML
		// this is related to a bug in Tomcat 6
		// MIME type application/x-www-form-encoded is the default
		// RM0412 TODO: check handling of special characters
		[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
		//NSString *body = [[args valueForPath:@"/*[0]"] asXmlWithLevel:0];
		
		//if(body != nil) [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
		// DLog(@"Request is: %@", body);
		MBRequestDelegate *delegate = [MBRequestDelegate new];
		NSString *dataString = nil;
		MBDocument *responseDoc = nil;
		@try {
			delegate.err = nil;
			delegate.response = nil;
			delegate.finished = NO;
			delegate.data = [[NSMutableData new] retain];
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			
            if (delegate.connection = [self createConnectionAndStartLoadingWithRequest:request delegate:delegate]){
                while (!delegate.finished) {
                    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
                        // Big problem, throw Exception
                        [delegate.connection cancel];
                        @throw [NSException exceptionWithName:MBLocalizedString(@"Network error") reason:MBLocalizedString(@"No internet connection") userInfo:nil];
                    }
                    if([[Reachability reachabilityWithHostName:[[NSURL URLWithString:urlString ] host]] currentReachabilityStatus ] == NotReachable){
                        // Big problem, throw Exception
                        [delegate.connection cancel];
                        @throw [NSException exceptionWithName:MBLocalizedString(@"Network error") reason:MBLocalizedString(@"Server unreachable") userInfo:nil];
                    }
                    // Wait for async http request to finish, but make sure delegate methods are called, since this is executed in an NSOperation
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
            }
            dataString = [[NSString alloc] initWithData:delegate.data encoding:NSUTF8StringEncoding];

			BOOL serverErrorHandled = NO;
			
			for(MBResultListenerDefinition *lsnr in [endPoint resultListeners]) {
				if([lsnr matches:dataString]) {
					id<MBResultListener> rl = [[MBApplicationFactory sharedInstance] createResultListener:lsnr.name];
					[rl handleResult:dataString requestDocument:args definition: lsnr];
					serverErrorHandled = YES;
				}
			}
			if (delegate.err != nil) {
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
				WLog(@"An error (%@) occured while accessing endpoint '%@'", delegate.err, urlString);
				@throw [NSException exceptionWithName:MBLocalizedString(@"Network error") reason:[delegate.err localizedDescription] userInfo:[delegate.err userInfo]];
			}
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
            responseDoc = [self createDocumentWithName:documentName forData:delegate.data];
            
			// if the response document is empty and unhandled by endpoint listeners let the user know there is a problem
			if (!serverErrorHandled && responseDoc == nil) {
				NSString *msg = MBLocalizedString(@"The server returned an error. Please try again later");
				if(delegate.err != nil) {
					msg = [NSString stringWithFormat:@"%@ %@: %@", msg, delegate.err.domain, delegate.err.code];
				}
				@throw [NSException exceptionWithName:@"Server Error" reason: msg userInfo:nil];
			}
			
			
			if(cacheable) {
				[MBCacheManager setDocument:responseDoc forKey:[args uniqueId] timeToLive:endPoint.ttl];
			}
		}
		@catch (NSException * e) {
			//DLog(@"%@",body);
			DLog(@"%@",dataString);
			@throw e;
		}
		@finally {
			[delegate release];
		}
		
		//
		// animate if proper data was returned
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkActivity" object: nil];
		return responseDoc;
	}
	else {
		WLog(@"No endpoint defined for document name '%@'", documentName);
		return nil;
	}	
}

@end
