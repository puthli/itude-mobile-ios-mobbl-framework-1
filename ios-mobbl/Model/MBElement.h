//
//  MBElement.h
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBElementDefinition.h"
#import "MBElementContainer.h"

#define TEXT_ATTRIBUTE @"text()"

/**
* A node in an Element tree.
*/
@interface MBElement : MBElementContainer {

	@private
	NSMutableDictionary *_values;   // Dictionary of strings
	MBElementDefinition *_definition;
}

/// @name Creating and Initializing an Element
- (id) initWithDefinition:(id) definition;

/// @name Getting Element Properties
- (NSString *) name;
- (MBElementDefinition*) definition;
/** Gets the physical index of an element with a given path */
- (NSInteger) physicalIndexWithCurrentPath: (NSString *)path;

/// @name Working with Attribute Values
- (NSString*) valueForAttribute:(NSString*)attributeName;
- (void) setValue:(id)value forAttribute:(NSString *)attributeName;
- (void) setValue:(id)value forAttribute:(NSString *)attributeName throwIfInvalid:(BOOL) throwIfInvalid;

/// @name Working with the 'text()' attribute
- (NSString *) bodyText;
- (void) setBodyText:(NSString*) text;

/// @name Checking Existence of Attributes
- (BOOL) isValidAttribute:(NSString*) attributeName;

/// @name Exporting to XML
- (NSString *) asXmlWithLevel:(int)level;

/// @name Copying Element State
- (void) assignToElement:(MBElement*) target;
- (void) assignByName:(MBElementContainer*) other;

@end
