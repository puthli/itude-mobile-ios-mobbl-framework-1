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

@interface MBElement : MBElementContainer {

	@private
	NSMutableDictionary *_values;   // Dictionary of strings
	MBElementDefinition *_definition;
}

- (id) initWithDefinition:(id) definition;
- (void) setValue:(id)value forAttribute:(NSString *)attributeName;
- (void) setValue:(id)value forAttribute:(NSString *)attributeName throwIfInvalid:(BOOL) throwIfInvalid;
- (NSString*) valueForAttribute:(NSString*)attributeName;
- (NSString *) asXmlWithLevel:(int)level;
- (MBElementDefinition*) definition;
- (BOOL) isValidAttribute:(NSString*) attributeName;
- (NSString *) bodyText;
- (void) setBodyText:(NSString*) text;
- (void) assignToElement:(MBElement*) target;
- (void) assignByName:(MBElementContainer*) other;
- (NSString *) name;
- (NSInteger) physicalIndexWithCurrentPath: (NSString *)path;


@end
