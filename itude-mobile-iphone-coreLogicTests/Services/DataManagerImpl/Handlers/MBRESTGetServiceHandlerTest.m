//
//  MBRESTGetServiceHandlerTest.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "TestingMBRESTGetServiceDataHandler.h"
#import "MBRESTGetServiceHandlerTest.h"
#import "MBDocument.h"
#import "MBMetadataService.h"

@interface MBRESTGetServiceHandlerTest()
@property (nonatomic, retain) TestingMBRESTGetServiceDataHandler *dataHandler;
@end

@implementation MBRESTGetServiceHandlerTest

@synthesize dataHandler = _dataHandler;


#define TEST_DOCUMENT @"TestDocument"
#define TEST_URI @"http://www.itude.com"
- (void)setUp
{   
    // Setup datahandler
    MBWebservicesConfiguration *configuration = [[MBWebservicesConfiguration alloc] init];
    MBEndPointDefinition *endpoint = [[MBEndPointDefinition alloc] init];
    endpoint.documentOut = TEST_DOCUMENT;
    endpoint.endPointUri = TEST_URI;
    [configuration addEndPoint:endpoint];
    self.dataHandler = [[[TestingMBRESTGetServiceDataHandler alloc] initWithConfiguration:configuration] autorelease];
    [configuration release];
    [endpoint release];
    
    STAssertNotNil(self.dataHandler, nil);
}

- (void)testLoadDocumentWithoutParameters
{
    MBDocument *mockResult = [[[MBDocument alloc] init] autorelease];
    self.dataHandler.nextResult = mockResult;
    
    MBDocument *result = [self.dataHandler loadDocument:TEST_DOCUMENT];
    
    STAssertEqualObjects(result, mockResult, nil);
    
    // Check URL request that was issued
    STAssertEqualObjects(self.dataHandler.lastRequest.HTTPMethod, @"GET", @"LoadDocument should use HTTP GET");
    STAssertEqualObjects(self.dataHandler.lastRequest.URL, [NSURL URLWithString:TEST_URI], nil);
    STAssertTrue(self.dataHandler.lastRequest.cachePolicy == NSURLRequestUseProtocolCachePolicy, @"Should use default HTTP caching");
}

@end
