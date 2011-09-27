//
//  MBDocumentDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDocumentDefinition.h"
#import "MBElementDefinition.h"
#import "MBDefinition.h"
#import "MBDocument.h"
#import "StringUtilities.h"
#import "MBMetadataService.h" 

@implementation MBDocumentDefinition

@synthesize dataManager = _dataManager;
@synthesize autoCreate = _autoCreate;

- (id) init {
	if (self = [super init]) {
		_elements = [NSMutableDictionary new];
		_elementsSorted = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc {
	[_dataManager release];
	[_elements release];
	[_elementsSorted release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%*s<Document name='%@' dataManager='%@' autoCreate='%@'>\n", level, "", _name, _dataManager, _autoCreate?@"TRUE":@"FALSE"];	
	for (MBElementDefinition* elem in _elementsSorted)
		[result appendString:[elem asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</Document>\n", level, ""];
    
	return result;
}

- (void) addElement:(MBElementDefinition*)element {
	[_elementsSorted addObject:element];
	[_elements setValue:element forKey:element.name];
}

- (BOOL) isValidChild: (NSString*) elementName {
	return [_elements objectForKey:elementName] != nil;	
}

- (NSMutableArray*) children {
	return _elementsSorted;	
}

- (MBElementDefinition*) childWithName:(NSString*) elementName {
    if(![self isValidChild:elementName]) {
        @throw [NSException exceptionWithName:@"InvalidElementName" reason:elementName userInfo:nil];
    }
	return [_elements objectForKey:elementName];	
}

- (MBElementDefinition*) elementWithPathComponents:(NSMutableArray*) pathComponents {
	if([pathComponents count] > 0) {
		MBElementDefinition *root = [self childWithName:[pathComponents objectAtIndex:0]];
		[pathComponents removeObjectAtIndex:0];
		return [root elementWithPathComponents: pathComponents];
    }
	@throw [NSException exceptionWithName:@"EmptyPath" reason:@"No path specified" userInfo:nil];
}

- (MBElementDefinition*) elementWithPath:(NSString*) path {
	NSMutableArray *pathComponents = [path splitPath];
	
	// If there is a ':' in the name of the first component; we might need a different document than 'self'
	if([pathComponents count]>0) {
		NSRange range = [[pathComponents objectAtIndex:0] rangeOfString:@":"];
		if(range.length>0) {
			NSString *documentName = [[pathComponents objectAtIndex:0] substringToIndex: range.location];
			NSString *rootElementName = [[pathComponents objectAtIndex:0] substringFromIndex: range.location+1];
            if(![documentName isEqualToString:[self name]]) {
				// Different document! Dispatch the valueForPath
				MBDocumentDefinition *docDef = [[MBMetadataService sharedInstance] definitionForDocumentName: documentName];
				if([rootElementName length]>0)[pathComponents replaceObjectAtIndex:0 withObject:rootElementName];
				else [pathComponents removeObjectAtIndex:0];
				
				return [docDef elementWithPathComponents: pathComponents];
			}
			else [pathComponents replaceObjectAtIndex:0 withObject:rootElementName];
		}
	}
	
	return [self elementWithPathComponents:pathComponents];
}

- (MBAttributeDefinition*) attributeWithPath:(NSString*) path {
	NSRange range = [path rangeOfString:@"@"];
	if(range.length == 0) @throw [NSException exceptionWithName:@"InvalidPath" reason:path userInfo:nil];
	NSString *elementPath = [path substringToIndex:range.location];
	NSString *attrName = [path substringFromIndex:range.location+1];
	
	MBElementDefinition *elemDef = [self elementWithPath: elementPath];
	return [elemDef attributeWithName:attrName];
}


- (NSMutableString*) childElementNames {
	NSMutableString *result = [NSMutableString new];
	[result autorelease];
	for(MBElementDefinition *ed in _elementsSorted) { 
		if([result length]>0) [result appendString:@", "];
		[result appendString:ed.name];
	}
	if([result isEqualToString:@""]) [result appendString:@"[none]"];
	return result;
}

- (MBDocument*) createDocument {
    
	MBDocument *doc = [[[MBDocument alloc] initWithDocumentDefinition:self] autorelease];
	for(MBElementDefinition *elemDef in _elementsSorted) {
		for(int i=0; i< [elemDef minOccurs]; i++) [doc addElement:[elemDef createElement]];
	}
    
	return doc;
}

-(NSString*) evaluateExpression:(NSString*) variableName {
	@throw [NSException exceptionWithName: @"UnknownVariable" reason:[NSString stringWithFormat:@"Unknown variable: %@", variableName] userInfo:nil];
}
@end
