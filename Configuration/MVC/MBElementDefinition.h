//
//  MBElementDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBAttributeDefinition.h"
#import "MBDefinition.h"
@class MBElement;

@interface MBElementDefinition : MBDefinition {
	NSMutableDictionary *_attributes;
	NSMutableArray *_attributesSorted;
	NSMutableDictionary *_children;
	NSMutableArray *_childrenSorted;

	NSInteger _minOccurs, _maxOccurs;
}

- (void) addElement:(MBElementDefinition*)element;
- (void) addAttribute:(MBAttributeDefinition*)attribute;
- (MBAttributeDefinition*) attributeWithName:(NSString*)name;
- (NSMutableArray*) attributes;
- (NSMutableString*) attributeNames;
- (NSMutableString*) childElementNames;
- (NSMutableArray*) children;
- (BOOL) isValidChild: (NSString*) name;
- (BOOL) isValidAttribute: (NSString*) name;
- (MBElementDefinition*) elementWithPathComponents:(NSMutableArray*) pathComponents;
- (MBElement*) createElement;
- (MBElementDefinition*) childWithName:(NSString*)name;

@property (nonatomic, assign) NSInteger minOccurs;
@property (nonatomic, assign) NSInteger maxOccurs;

@end
