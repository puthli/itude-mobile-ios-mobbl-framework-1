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

- (void)testLoadDocumentWithParameters
{
    // Set up documentdefinition for URL parameters
    MBDocumentDefinition *requestDocumentDefinition = [[[MBDocumentDefinition alloc] init] autorelease];
    MBElementDefinition *requestDefinition = [[[MBElementDefinition alloc] init] autorelease];
    requestDefinition.name = @"Request";
    [requestDocumentDefinition addElement:requestDefinition];
    
    MBElementDefinition *parameterDefinition = [[[MBElementDefinition alloc] init] autorelease];
    parameterDefinition.name = @"Parameter";
    parameterDefinition.minOccurs = 0;
    [requestDefinition addElement:parameterDefinition];
    
    MBAttributeDefinition *keyAttribute = [[[MBAttributeDefinition alloc] init] autorelease];
    keyAttribute.name = @"key";
    [parameterDefinition addAttribute:keyAttribute];
    MBAttributeDefinition *valueAttribute = [[[MBAttributeDefinition alloc] init] autorelease];
    valueAttribute.name = @"value";
    [parameterDefinition addAttribute:valueAttribute];
    
    // Create document containing parameters
    MBDocument *requestDocument = [[[MBDocument alloc] initWithDocumentDefinition:requestDocumentDefinition] autorelease];
    MBElement *request = [[[MBElement alloc] initWithDefinition:requestDefinition] autorelease];
    [requestDocument addElement:request];
    MBElement *parameter1 = [[[MBElement alloc] initWithDefinition:parameterDefinition] autorelease];
    [parameter1 setValue:@"argument1" forKey:@"key"];
    [parameter1 setValue:@"value1" forKey:@"value"];
    [request addElement:parameter1];
    MBElement *parameter2 = [[[MBElement alloc] initWithDefinition:parameterDefinition] autorelease];
    [parameter2 setValue:@"argument2" forKey:@"key"];
    [parameter2 setValue:@"41" forKey:@"value"];
    [request addElement:parameter2];

    MBDocument *mockResult = [[[MBDocument alloc] init] autorelease];
    self.dataHandler.nextResult = mockResult;
    
    [self.dataHandler loadDocument:TEST_DOCUMENT withArguments:requestDocument];
    
    NSString *expectedUri = [TEST_URI stringByAppendingString:@"?argument1=value1&argument2=41"];
    STAssertEqualObjects(self.dataHandler.lastRequest.URL, [NSURL URLWithString:expectedUri], nil);
}

@end
