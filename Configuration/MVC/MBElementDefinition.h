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

/**
* Definition of the valid structure of MBElement instances. An ElementDefinition is a node in a tree
* of MBElementDefinitions, corresponding to the tree of MBElementContainer instances that it defines.
*
* Typically, all ElementDefinitions are read at startup from the configuration files, like
* `documents.xmlx` for MBDocument trees. When constructing MBElementContainer structures, the
* framework checks that the structures conform to the Definition.
*/
@interface MBElementDefinition : MBDefinition {
	NSMutableDictionary *_attributes;
	NSMutableArray *_attributesSorted;
	NSMutableDictionary *_children;
	NSMutableArray *_childrenSorted;

	NSInteger _minOccurs, _maxOccurs;
}

/// @name Constructing the ElementDefinition Tree
- (void) addElement:(MBElementDefinition*)element;
- (void) addAttribute:(MBAttributeDefinition*)attribute;
- (MBElement*) createElement;

- (MBAttributeDefinition*) attributeWithName:(NSString*)name;
- (NSMutableArray*) attributes;
- (NSMutableString*) attributeNames;
- (NSMutableString*) childElementNames;
- (NSMutableArray*) children;
- (BOOL) isValidChild: (NSString*) name;
- (BOOL) isValidAttribute: (NSString*) name;
- (MBElementDefinition*) elementWithPathComponents:(NSMutableArray*) pathComponents;
- (MBElementDefinition*) childWithName:(NSString*)name;

@property (nonatomic, assign) NSInteger minOccurs;
@property (nonatomic, assign) NSInteger maxOccurs;

@end
