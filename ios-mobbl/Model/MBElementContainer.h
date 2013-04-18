//
//  MBElementContainer.h
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

@class MBElement;
@class MBDocument;

/**
* A node in a tree of MBElement instances.
*
* Configuration and application state in MOBBL is represented in trees of MBELement instances,
* resembling an XML tree.
*
* Each ElementContainer has an associated MBElementDefinition. The structure of the Element tree
* must conform to the ElementDefinition.
*/
@interface MBElementContainer : NSObject {
	NSMutableDictionary *_elements; // Dictionary of lists of elements
	MBElementContainer *_parent;
}

/// @name Creating and Initializing an Element Tree
- (id) init;

/// @name Getting ElementContainer Properties
@property (nonatomic, assign) MBElementContainer *parent;
/** MBElementDefinition for this ElementContainer */
- (id) definition;
- (NSString*) name;
- (MBDocument*) document;
- (NSString*) documentName;
- (NSString*) uniqueId;

/// @name Adding Elements to the Tree
- (MBElement*) createElementWithName: (NSString*) name;
- (MBElement*) createElementWithName: (NSString*) name atIndex:(NSInteger)index;
- (void) addElement: (MBElement*) element;
- (void) addElement: (MBElement*) element atIndex:(NSInteger)index;

/// @name Removing Elements from the Tree
- (void) deleteElementWithName: (NSString*) name atIndex:(int) index;
- (void) deleteAllChildElements;

/// @name Getting Elements from the Tree
- (NSMutableDictionary*) elements;
- (NSMutableArray*) elementsWithName: (NSString*) name;

/// @name Getting a Value from the Tree
- (id) valueForPath:(NSString *)path;
- (id) valueForPath:(NSString*)path translatedPathComponents:(NSMutableArray*) translatedPathComponents;
- (id) valueForPathComponents:(NSMutableArray*)pathComponents withPath: (NSString*) originalPath nillIfMissing:(BOOL) nillIfMissing translatedPathComponents:(NSMutableArray*)translatedPathComponents;

/// @name Setting a Value in the Tree
- (void) setValue:(NSString*)value forPath:(NSString *)path;

/// @name Evaluating Expressions
- (NSString*) evaluateExpression:(NSString*) expression;
- (NSString*) evaluateExpression:(NSString*) expression currentPath:(NSString*) currentPath;

/// @name Reordering Elements
- (void) sortElements:(NSString*) elementName onAttributes:(NSString*) attributeNames;

/// @name Working with the Shared Context
- (NSMutableDictionary*) sharedContext;
- (void) setSharedContext:(NSMutableDictionary*) sharedContext;
- (MBDocument*) getDocumentFromSharedContext:(NSString*) documentName;
- (void) registerDocumentWithSharedContext:(MBDocument*) document;

@end
