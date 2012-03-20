//
//  MBXmlDocumentParserTest.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 20-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBXmlDocumentParser.h"
#import "MBXmlDocumentParserTest.h"

@implementation MBXmlDocumentParserTest {
    MBDocumentDefinition *documentDefinition;
    MBXmlDocumentParser *parser;
}

- (void)setUp
{
    parser = [[MBXmlDocumentParser alloc] init];
    STAssertNotNil(parser, @"Initialization must succeed");

    /*
         Set up document definition for:

         <root>
          <parent parentAttribute="value">
              <child>
                  value
              </child>
          </parent>
         </root>
     */   
    documentDefinition = [[MBDocumentDefinition alloc] init];
    documentDefinition.name = @"root";
    MBElementDefinition *parentElementDefinition = [[MBElementDefinition alloc] init];
    parentElementDefinition.name = @"parent";
    MBAttributeDefinition *parentAttribute = [[MBAttributeDefinition alloc] init];
    parentAttribute.name = @"parentAttribute";
    [parentElementDefinition addAttribute:parentAttribute];
    [documentDefinition addElement:parentElementDefinition];
    
    MBElementDefinition *childElementDefinition = [[MBElementDefinition alloc] init];
    childElementDefinition.name = @"child";
    MBAttributeDefinition *childContent = [[MBAttributeDefinition alloc] init];
    childContent.name = @"text()";
    [childElementDefinition addAttribute:childContent];
    [parentElementDefinition addElement:childElementDefinition];
    
    [childContent release];
    [childElementDefinition release];
    [parentAttribute release];
    [parentElementDefinition release];
}

- (void)tearDown
{
    [parser release];
    [documentDefinition release];
}

- (void)testParseUsingDefinition
{
    NSData *data = [@"<root><parent parentAttribute=\"attribute\"><child>childContent</child></parent></root>" dataUsingEncoding:NSUTF8StringEncoding];
    
    MBDocument *result = nil;
    STAssertNoThrow(result = [parser parse:data usingDefinition:documentDefinition], nil);
    
    STAssertEqualObjects([result valueForPath:@"/parent[0]@parentAttribute"], @"attribute", nil);
    STAssertEqualObjects([result valueForPath:@"/parent[0]/child[0]@text()"], @"childContent", nil);
}

- (void)testParseDocumentContainingExtraElement
{
    NSData *data = [@"<root><parent parentAttribute=\"attribute\"><child>childContent</child><extra>should be ignored</extra></parent></root>" dataUsingEncoding:NSUTF8StringEncoding];
    
    MBDocument *result = nil;
    STAssertNoThrow(result = [parser parse:data usingDefinition:documentDefinition], nil);
    
    STAssertEqualObjects([result valueForPath:@"/parent[0]@parentAttribute"], @"attribute", nil);
    STAssertEqualObjects([result valueForPath:@"/parent[0]/child[0]@text()"], @"childContent", nil);
    
    STAssertNil([result valueForPath:@"/parent[0]/extra[0]@text()"], @"Extra element not in document definition, should be ignored");
}

@end
