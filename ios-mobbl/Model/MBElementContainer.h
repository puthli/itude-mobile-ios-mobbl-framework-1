/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
