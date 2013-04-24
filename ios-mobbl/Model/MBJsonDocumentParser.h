//
//  MB1DocumentFactory.h
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//
//	Parses Mobbl1 ServerResponse Documents

#import "MBDocumentParserProtocol.h"
@class MBElement;
@class MBDefinition;
@class MBElementContainer;
@class MBElementDefinition;

@interface MBJsonDocumentParser : NSObject <MBDocumentParserProtocol>{

}

+ (MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition;
+ (MBDocument*) documentWithString:(NSString *)string andDefinition: (MBDocumentDefinition*) definition;

-(MBDocument *) parseJsonString:(NSString *)jsonString usingDefinition:(MBDocumentDefinition *)definition;
-(void) parseJsonValue:(id) jsonValue usingDefinition:(MBDefinition *)definition withElement:(MBElementContainer *) element;

@end
