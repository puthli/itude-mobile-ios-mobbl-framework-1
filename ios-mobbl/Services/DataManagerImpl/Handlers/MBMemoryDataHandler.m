//
//  MBMemoryDataService.m
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBMemoryDataHandler.h"
#import "MBMetadataService.h"
#import "MBDocumentFactory.h"

@implementation MBMemoryDataHandler

- (id) init {
	if (self = [super init]) {
		_dictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_dictionary release];
	[super dealloc];
}

- (MBDocument *) loadDocument:(NSString *)documentName {
	MBDocument *doc = [_dictionary objectForKey:documentName];
	if(doc == nil)
	{
		// Not yet in the store; handle default construction of the document using a file as template
		NSString *fileName = [NSString stringWithFormat:@"%@.xmlx", documentName];
		NSString *absFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: fileName];
		NSData *data = [NSData dataWithContentsOfFile: absFile];
		MBDocumentDefinition *docDef = [[MBMetadataService sharedInstance] definitionForDocumentName: documentName];
		return [[MBDocumentFactory sharedInstance] documentWithData: data withType:PARSER_XML andDefinition:docDef];
	}
	return doc;
}

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args {
    // Memory does not know what to do with arguments; so just ignore them
    return [self loadDocument: documentName];
}

- (void) storeDocument:(MBDocument *)document {
	[_dictionary setValue:document forKey:[document name]];	
}

@end
