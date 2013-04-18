//
//  MBMobbl1DocumentParser.m
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//
//  Deserializes an XML document with an element containing JSON

#import "MBMacros.h"
#import "MBMobbl1DocumentParser.h"
#import "MBJsonDocumentParser.h"
#import "JSON.h"
#import "NSString+SBJSON.h"


@implementation MBMobbl1DocumentParser

+(MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition {
    MBMobbl1DocumentParser *documentParser = [[MBMobbl1DocumentParser alloc]init];
    MBDocument *result = [documentParser parse: data usingDefinition: definition];
    [documentParser release];
    return result;
}

- (MBDocument*) parse:(NSData *)data usingDefinition: (MBDocumentDefinition*) definition {
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
	
	_stack = [[NSMutableArray alloc] init];
	_definition = definition;
	_characters = nil;
	
	[xmlParser parse];
	MBDocument *document = [[_stack lastObject] retain];
	
	[_stack release];
	[_characters release];
	[xmlParser release];
	return [document autorelease];
}

-(void)  parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
	 attributes:(NSDictionary *)attributeDict {
	
	[_characters release];
	_characters = [NSMutableString new];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[_characters appendString:string];
}

-(void) parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"ServerResponse"]) {
		// skip this wrapper element
		// TODO: implement text messages from server (text elements of this element)
	}
	else if([elementName isEqualToString:@"JsonObject"]){
		// Deserialize JSON object
		MBDocument *document = [MBJsonDocumentParser documentWithString:_characters andDefinition:_definition];
		[_stack addObject:document];
	}
	else{
		WLog(@"WARNING: Unexpected element during parsing of Mobbl document");
	}
	[_characters release];
	_characters = nil;
}

@end
