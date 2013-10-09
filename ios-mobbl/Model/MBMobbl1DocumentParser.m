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
