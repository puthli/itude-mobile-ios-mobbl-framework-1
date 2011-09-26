//
//  MBConfigurationParser.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBConfigurationParserProtocol.h"
#import "StringUtilities.h"

@interface MBConfigurationParser : NSObject <MBConfigurationParserProtocol, NSXMLParserDelegate> {
	NSMutableArray *_stack;
	NSMutableString *_characters;
	NSString *_documentName;
}

@property (nonatomic, retain) NSString* documentName;

- (id) parseData:(NSData*)data ofDocument:(NSString*) documentName;
- (void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string;

- (BOOL) processElement:(NSString*)elementName attributes:(NSDictionary*)attributeDict;
- (void) didProcessElement:(NSString*)elementName;

- (BOOL) isConcreteElement:(NSString*)element;
- (BOOL) isIgnoredElement:(NSString*)element;

- (BOOL) checkAttributesForElement:(NSString*) elementName withAttributes:(NSDictionary*) attributes withValids:(NSArray*) valids;
- (void) notifyProcessed:(id) object usingSelector:(SEL) selector;

@end
