//
//  MBXmlDocumentParser.h
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBDocumentParserProtocol.h"

@interface MBXmlDocumentParser : NSObject <MBDocumentParserProtocol, NSXMLParserDelegate>{
	NSMutableArray *_stack;
	NSMutableArray *_pathStack;
	MBDocumentDefinition *_definition;
	NSMutableString *_characters;
	NSString *_rootElementName;
	MBElementContainer *_rootElement;
    BOOL _copyRootAttributes;
}

+ (MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition;
+ (void) parseFragment:(NSData *)data intoDocument:(MBDocument*) document rootPath:(NSString*) rootPath copyRootAttributes:(BOOL) copyRootAttributes;
- (MBDocument*) parse:(NSData *)data usingDefinition: (MBDocumentDefinition*) definition;
- (NSString*) currentPath;




@end
