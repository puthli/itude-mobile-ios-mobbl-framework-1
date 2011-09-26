//
//  MBElementDefinition.m
//  Core
//
//  Created by Wido on 5/20/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBElementDefinition.h"
#import "MBElement.h"

@implementation MBElementDefinition

@synthesize minOccurs = _minOccurs;
@synthesize maxOccurs = _maxOccurs;

- (id) init {
	if (self = [super init]) {
		_attributes = [NSMutableDictionary new];
		_attributesSorted = [NSMutableArray new];
		_children = [NSMutableDictionary new];
		_childrenSorted = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc {
	[_attributes release];
	[_attributesSorted release];
	[_children release];
	[_childrenSorted release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Element name='%@' minOccurs='%i' maxOccurs='%i'>\n", level, "",  _name, _minOccurs, _maxOccurs];
	for (MBAttributeDefinition* attr in _attributesSorted)
		[result appendString:[attr asXmlWithLevel:level+2]];
	for (MBElementDefinition* elem in _childrenSorted)
		[result appendString:[elem asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</Element>\n", level, ""];
	return result;
}

- (void) addAttribute:(MBAttributeDefinition*)attribute {
	[_attributes setValue:attribute forKey:attribute.name];
	[_attributesSorted addObject:attribute];
}

- (MBAttributeDefinition*) attributeWithName:(NSString*)name {
	return [_attributes objectForKey:name];	
}

- (NSMutableArray*) attributes {
	return _attributesSorted;
}

- (NSMutableArray*) children {
	return _childrenSorted;	
}

- (MBElementDefinition*) childWithName:(NSString*)name {
	return [_children objectForKey:name];	
}

- (void) addElement:(MBElementDefinition*)element {
	[_childrenSorted addObject:element];
	[_children setValue:element forKey:element.name];
}

- (BOOL) isValidChild: (NSString*) name {
	return [_children objectForKey:name] != nil;	
}

- (BOOL) isValidAttribute: (NSString*) name {
	return [_attributes objectForKey:name] != nil;	
}

- (MBElementDefinition*) elementWithPathComponents:(NSMutableArray*) pathComponents {
	if([pathComponents count] > 0) {
		MBElementDefinition *root = [self childWithName:[pathComponents objectAtIndex:0]];
		[pathComponents removeObjectAtIndex:0];
		return [root elementWithPathComponents: pathComponents];
	}
	else return self;
}

- (NSMutableString*) attributeNames {
	NSMutableString *result = [NSMutableString new];
	[result autorelease];
	for(MBAttributeDefinition *ad in _attributesSorted) { 
		if([result length]>0) [result appendString:@", "];
		[result appendString:ad.name];
	}
	return result;
}

- (NSMutableString*) childElementNames {
	NSMutableString *result = [NSMutableString new];
	[result autorelease];
	for(MBElementDefinition *ed in _childrenSorted) { 
		if([result length]>0) [result appendString:@", "];
		[result appendString:ed.name];
	}
	if([result isEqualToString:@""]) [result appendString:@"[none]"];
	return result;
}

- (MBElement*) createElement {
	MBElement *element = [[MBElement alloc] initWithDefinition:self];
	
	for(MBAttributeDefinition *attrDef in [_attributes allValues]) {
		if(attrDef.defaultValue != nil) {
			[element setValue:attrDef.defaultValue forAttribute:attrDef.name];
		}
	}

	for(MBElementDefinition *elemDef in _childrenSorted) {
		for(int i=0; i< [elemDef minOccurs]; i++) [element addElement:[elemDef createElement]];
	}
	
	return [element autorelease];
}

@end
