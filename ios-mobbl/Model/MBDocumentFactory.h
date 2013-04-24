//
//  MBDocumentFactory.h
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"
#import "MBDocumentDefinition.h"

#define PARSER_XML @"XML"
#define PARSER_JSON @"JSON"
#define PARSER_MOBBL1 @"MOBBL1" // mixed xml with json inside


@interface MBDocumentFactory : NSObject {
}

+ (MBDocumentFactory *) sharedInstance;

- (MBDocument*) documentWithData:(NSData *)data withType:(NSString*)type andDefinition: (MBDocumentDefinition*) definition;
	

@end
