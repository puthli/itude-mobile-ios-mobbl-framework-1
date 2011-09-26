//
//  MBDocumentParserProtocol.h
//  Core
//
//  Created by Robin Puthli on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@class MBDocumentDefinition;
@class MBDocument;

@protocol MBDocumentParserProtocol

+ (MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition;


@end
