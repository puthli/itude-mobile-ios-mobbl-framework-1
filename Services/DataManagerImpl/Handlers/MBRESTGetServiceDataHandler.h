//
//  MBRESTGetServiceDataHandler.h
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBURLConnectionDataHandler.h"

// DataHandler implementation that uses HTTP GET requests for read operations and HTTP POST for create operations.
@interface MBRESTGetServiceDataHandler : MBURLConnectionDataHandler

// Create an MBDocument containing the elements of the dictionary. The resulting MBDocument can be used in loadDocument:withArguments.
+ (MBDocument *)argumentsDocumentForDictionary:(NSDictionary *)arguments;

// Isolated methods that can be overridden in Testing subclass, making it possible to unit test without actual connection or XML configuration
- (NSURLConnection *)createConnectionAndStartLoadingWithRequest:(NSURLRequest *)request delegate:(MBRequestDelegate *)delegate;
- (MBDocument *)createDocumentWithName:(NSString *)documentName forData:(NSData *)data;

- (NSString *)getRequestUrlForDocument:(NSString *)documentName WithArguments:(MBDocument *)arguments;


- (NSMutableURLRequest *) setupHTTPRequest:(NSMutableURLRequest *)request;

@end
