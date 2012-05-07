//
//  MBElementContainerTest.m
//  itude-mobile-iphone-core
//
//  Created by Frank Eenbergen, van on 5/7/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBElementContainerTest.h"
#import "MBElementContainer.h"
#import "MBDocument.h"

@implementation MBElementContainerTest {
    MBDocumentDefinition *documentDefinition;
    MBElementContainer *elementContainer;
}


- (void)setUp
{
    //parser = [[MBXmlDocumentParser alloc] init];
    //STAssertNotNil(parser, @"Initialization must succeed");
    
    /*
     Set up document definition for:
     
     <root>
         <parent parentAttribute="value">
             <child>
                 value
             </child>
         </parent>
         <parent2>
             <child>
                 value
             </child>
         </parent>
     </root>
     */   
    documentDefinition = [[MBDocumentDefinition alloc] init];
    documentDefinition.name = @"root";
    
    // <parent>
    MBElementDefinition *parentElementDefinition = [[MBElementDefinition alloc] init];
    parentElementDefinition.name = @"parent";
    MBAttributeDefinition *parentAttribute = [[MBAttributeDefinition alloc] init];
    parentAttribute.name = @"parentAttribute";
    [parentElementDefinition addAttribute:parentAttribute];
    [documentDefinition addElement:parentElementDefinition];
    
    // <child>
    MBElementDefinition *childElementDefinition = [[MBElementDefinition alloc] init];
    childElementDefinition.name = @"child";
    MBAttributeDefinition *childContent = [[MBAttributeDefinition alloc] init];
    childContent.name = @"text()";
    [childElementDefinition addAttribute:childContent];
    [parentElementDefinition addElement:childElementDefinition];
    
    // <parent2>
    MBElementDefinition *parentTwoElementDefinition = [[MBElementDefinition alloc] init];
    parentTwoElementDefinition.name = @"parent2";
    [documentDefinition addElement:parentTwoElementDefinition];
    
    // <child>
    MBElementDefinition *childTwoElementDefinition = [[MBElementDefinition alloc] init];
    childTwoElementDefinition.name = @"child";
    MBAttributeDefinition *childTwoContent = [[MBAttributeDefinition alloc] init];
    childTwoContent.name = @"text()";
    [childTwoElementDefinition addAttribute:childTwoContent];
    [parentTwoElementDefinition addElement:childTwoElementDefinition];
    
    
    
    [childContent release];
    [childElementDefinition release];
    [parentAttribute release];
    [parentElementDefinition release];
    [childTwoContent release];
    [childTwoElementDefinition release];
    [parentTwoElementDefinition release];
    
    elementContainer = [[MBDocument alloc] initWithDocumentDefinition:documentDefinition];
    STAssertNotNil(elementContainer, @"Initialization must succeed");
}

- (void)tearDown
{
    [documentDefinition release];
    [elementContainer release];
}


- (void)testCreateElementWithNameAtIndex {
    // Add a first time with no elements added
    //STAssertNoThrow([elementContainer createElementWithName:@"parent" atIndex:0], @"Creation of element at index 0 failed");
    
    // Add a first time with no elements added
    MBElement *element = [elementContainer createElementWithName:@"parent" atIndex:0];
    STAssertNotNil(element, @"Element creation failed");
    
    // Add a second element time at the top. This works, but somehow when printing the description the element is added a a second time.
    STAssertNoThrow([elementContainer createElementWithName:@"parent2" atIndex:0], @"Creation of element at index 0 failed");
    
    //STAssertTrue([[elementContainer description] isEqualToString:@"<root><parent></parent><parent2></parent2></root>"], @"Element 'parent2' not added where it is supposed to be added");

    NSLog(@"elementContainer=%@",elementContainer);
}

- (void)testcreateElementWithNameAtIndexTwoWhileOnlyOneExists {
    //*** -[__NSArrayM insertObject:atIndex:]: index 2 beyond bounds for empty array    
    STAssertThrows([elementContainer createElementWithName:@"parent" atIndex:2], @"No exception throwed while index (2) was expected to be out of bounds");    
    //NSLog(@"elementContainer=%@",elementContainer);
}

@end
