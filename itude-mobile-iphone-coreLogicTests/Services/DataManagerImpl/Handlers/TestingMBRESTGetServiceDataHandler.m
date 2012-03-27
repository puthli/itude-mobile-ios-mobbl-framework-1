//
//  TestingMBRESTGetServiceDataHandler.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "TestingMBRESTGetServiceDataHandler.h"

@implementation TestingMBRESTGetServiceDataHandler

@synthesize nextResult = _nextResult;

- (void)dealloc
{
    [_nextResult release];
    [super dealloc];
}

- (NSURLConnection *)createConnectionAndStartLoadingWithRequest:(NSURLRequest *)request delegate:(MBRequestDelegate *)delegate
{
    NSLog(@"Create connection for %@", request);
    
    // Mark delegate as finished immediately
    delegate.finished = YES;
    
    return  nil;
}

- (MBDocument *)createDocumentWithName:(NSString *)documentName forData:(NSData *)data
{
    NSLog(@"Create document %@ with %@", documentName, data);
    return self.nextResult;
}

@end
