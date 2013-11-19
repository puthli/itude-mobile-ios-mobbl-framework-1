/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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
