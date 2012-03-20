//
//  MBDocumentDefinitionTest.m
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 20-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBDocumentDefinitionTest.h"
#import "MBDocumentDefinition.h"

@implementation MBDocumentDefinitionTest

- (void)testCreation
{
    MBDocumentDefinition *definition = [[MBDocumentDefinition alloc] init];
    STAssertNotNil(definition, @"Creation failed");
}

@end
