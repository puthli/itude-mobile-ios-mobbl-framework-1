//
//  MBDocumentFactory.m
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocumentFactory.h"
#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBXmlDocumentParser.h"
#import "MBJsonDocumentParser.h"
#import "MBMobbl1DocumentParser.h"

static MBDocumentFactory *_instance = nil;

@implementation MBDocumentFactory

+ (MBDocumentFactory *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (MBDocument*) documentWithData:(NSData *)data withType:(NSString*)type andDefinition: (MBDocumentDefinition*) definition {

	if ([PARSER_XML isEqualToString:type]) {
		return [MBXmlDocumentParser documentWithData:data andDefinition:definition];
	}
	else
	if ([PARSER_MOBBL1 isEqualToString:type]) {
		return [MBMobbl1DocumentParser documentWithData:data andDefinition:definition];
	}
	else @throw [NSException exceptionWithName:@"UnknownDataType" reason:type userInfo:nil];
}

@end
