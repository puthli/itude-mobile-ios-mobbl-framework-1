//
//  MBDocumentDefinitionTest.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 20-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBDocumentDefinitionTest.h"
#import "MBDocumentDefinition.h"

@implementation MBDocumentDefinitionTest {
    MBDocumentDefinition *definition;
}

- (void)setUp
{
    definition = [[MBDocumentDefinition alloc] init];
    STAssertNotNil(definition, @"Creation failed");
}

- (void)testXmlWithEmptyDefinition
{
    NSString *xml = [definition asXmlWithLevel:0];
    STAssertEqualObjects(@"<Document name='(null)' dataManager='(null)' autoCreate='FALSE'>\n</Document>\n", xml, nil);
}

- (void)testElementWithPathWithEmptyDefinition
{
    STAssertTrueNoThrow([definition elementWithPath:@"test"] == nil, @"elementWithPath for unknown element must return nil and not throw an exception");
}

- (void)testChildWithNameForNonExistingChild
{
    STAssertNil([definition childWithName:@"notExisting"], @"ChildWithName for unknown name must return nil");
}

- (void)testChildWithNameForExistingChild
{
    // Add child element to definition
    MBElementDefinition *elementDefinition = [[MBElementDefinition alloc] init];
    elementDefinition.name = @"elementName";
    [definition addElement:elementDefinition];
    
    NSLog(@"%@", [definition asXmlWithLevel:0]);
    
    STAssertEqualObjects(elementDefinition, [definition childWithName:@"elementName"], @"ChildWithName for existing element must return the element");
}

@end
