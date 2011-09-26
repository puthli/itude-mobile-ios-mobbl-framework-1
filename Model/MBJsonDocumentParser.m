//
//  MB1DocumentFactory.m
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMacros.h"
#import "MBJsonDocumentParser.h"
#import "JSON.h"
#import "MBDocument.h"
#import "MBElement.h"
#import "MBElementDefinition.h"
#import "MBElementContainer.h"
#import "MBAttributeDefinition.h"


@implementation MBJsonDocumentParser

+(MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition {
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    MBDocument *result = [MBJsonDocumentParser documentWithString: string andDefinition:definition];
	[string release];
	return result;
}

+(MBDocument *) documentWithString:(NSString *)string andDefinition:(MBDocumentDefinition *)definition{
	MBJsonDocumentParser *parser = [MBJsonDocumentParser new];
	MBDocument *result = [parser parseJsonString:string usingDefinition:definition];
	[parser release];
	return result;
}

-(MBDocument *) parseJsonString:(NSString *)jsonString usingDefinition:(MBDocumentDefinition *)definition{
	
	NSDictionary *jsonDoc = [jsonString JSONValue];
	MBDocument *document = [[[MBDocument alloc] initWithDocumentDefinition:definition]autorelease];
	// ignore the first Element, use its child as the root
	NSDictionary *jsonRoot = [[jsonDoc allValues] objectAtIndex:0];
	//
	// kick off recursive constrution, starting with root element
	[self parseJsonValue:jsonRoot usingDefinition:definition withElement:document];
	return document;
}


-(void) parseJsonValue:(id) jsonValue usingDefinition:(MBDefinition *) definition withElement:(MBElementContainer *) element{
	// check if jsonValue contains an element with the name in the definition
	
	// DLog(@"parseJsonValue element name=%@", [element name]);
	
	
	if ([jsonValue isKindOfClass:[NSDictionary class]]) {
		for (MBElementDefinition *childDefinition in [definition performSelector:@selector(children)]){
			id jsonChild = [(NSDictionary *) jsonValue valueForKey:childDefinition.name];
			if ([jsonChild isKindOfClass:[NSString class]]) {
				MBElement *childElement = [childDefinition createElement];
				[childElement setBodyText:jsonChild];
				[element addElement:childElement];
			}
			if ([jsonChild isKindOfClass:[NSNumber class]]) {
				MBElement *childElement = [childDefinition createElement];
				[childElement setBodyText:[jsonChild stringValue]];
				[element addElement:childElement];
			}
			if ([jsonChild isKindOfClass:[NSDictionary class]]) {
				MBElement *childElement = [childDefinition createElement];
				[element addElement:childElement];
				[self parseJsonValue:jsonChild usingDefinition:childDefinition withElement:childElement];
			}
			if ([jsonChild isKindOfClass:[NSArray class]]) {
				for (id jsonRow in jsonChild){
					MBElement *childElement = [childDefinition createElement];
					[element addElement:childElement];
					[self parseJsonValue:jsonRow usingDefinition:childDefinition withElement:childElement];
				}
			}
		}
	}
	
	// get attributes
	if ([definition isKindOfClass:[MBElementDefinition class]] && [element isKindOfClass:[MBElement class]]) {
		for (MBAttributeDefinition *attributeDefinition in [((MBElementDefinition *)definition) attributes]){
			id jsonChild = [(NSDictionary *) jsonValue valueForKey:attributeDefinition.name];
			if ([jsonChild isKindOfClass:[NSString class]]) {
				[((MBElement *) element) setValue: ((NSString*) jsonChild) forAttribute:attributeDefinition.name];
			}
			if ([jsonChild isKindOfClass:[NSNumber class]]) {
				[((MBElement *) element) setValue:[jsonChild stringValue] forAttribute:attributeDefinition.name];
			}
			
		}
	}
	
	
}


// discarded attempt to use JSON structure to construct Document
-(MBElement *) parseJsonValue:(id) jsonValue forKey:(NSString *) key usingDefinition:(MBElementDefinition *)definition withElement:(MBElement *) element{
	
	DLog(@"MBJsonDocumentParser.parseJsonValue: processing element %@ for json class %@", [element name],[[jsonValue class] description]);

	// add child elements
	
	// add attributes
	
	/*
	// handle array
	loop through array
	 - pass each object to method
	// handle dictionary
	//   -single element
	//   -repetition (array)
	// handle primitive
	
	*/
	if([jsonValue isKindOfClass:[NSArray class]]){
		// iterate over the collection
		for (id jsonRow in jsonValue) {
			[self parseJsonValue:jsonRow 
						  forKey:key 
				 usingDefinition:definition 
					  withElement:element];
		}
		
	}	
	else if ([jsonValue isKindOfClass:[NSDictionary class]]) {
		// This can be an object or an array of objects 
		for (NSString *childKey in [jsonValue allKeys]) {
			id childValue = [jsonValue valueForKey:childKey];
			MBElementDefinition *childDefinition = [definition childWithName:childKey];
			if ([childValue isKindOfClass:[NSArray class]]) {
				// repetition
				[self parseJsonValue:childValue forKey:childKey usingDefinition:childDefinition withElement:element];
			}
			else{
				// create element
				MBElement *child = [definition createElement];
				[element addElement:child];
				[self parseJsonValue:childValue forKey:childKey usingDefinition:childDefinition withElement:child];
			}
		}
	}

	else if([jsonValue isKindOfClass:[NSDecimalNumber class]]){
		//DLog(@"MBJsonDocumentParser.parseJsonValue: creating number for field %@", key);
		// Numbers
		
		// TODO: check that the key is an attribute or a child element
		// JSON serializes body text and attributes into the same construct! 
		
		if ([[element name] isEqualToString:key]) {
			[element setBodyText:[jsonValue stringValue]];
		}
		else{
			[element setValue:[jsonValue stringValue] forAttribute:key];
		}
	}
	else{
		//DLog(@"MBJsonDocumentParser.parseJsonValue: creating string for field %@", key);
		// Strings
		if ([[element name] isEqualToString:key]) {
			[element setBodyText:jsonValue];
		}
		else{
			[element setValue:jsonValue forKey:key];
		}
	}
	
	
	
	// process attributes
	// process text
	
	return nil;
}


 
 
 // processJsonArray: (NSArray*) array withDefinition:(MBElementDefinition *)definition
 
 // processJsonNumber
 
 // processJsonString
 
 
 
 
 
 @end
