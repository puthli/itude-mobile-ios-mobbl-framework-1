//
//  MBMobbl1DocumentParser.h
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBXmlDocumentParser.h"

@interface MBMobbl1DocumentParser : NSObject <MBDocumentParserProtocol, NSXMLParserDelegate> {
	NSMutableArray *_stack;
	MBDocumentDefinition *_definition;
	NSMutableString *_characters;
	
}

- (MBDocument*) parse:(NSData *)data usingDefinition: (MBDocumentDefinition*) definition;

@end
