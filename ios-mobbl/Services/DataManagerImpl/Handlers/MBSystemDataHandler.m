//
//  MBSystemDataHandler.m
//  Core
//
//  Created by Wido on 25-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBSystemDataHandler.h"
#import "MBMetadataService.h"
#import "MBDocumentFactory.h"
#import "MBConfigurationDefinition.h"
#import "MBXmlDocumentParser.h"
#import "DataUtilites.h"

@interface MBSystemDataHandler()
- (void) initDocuments;
@end


@implementation MBSystemDataHandler

- (id) init {
	if (self = [super init]) {
		_dictionary = [[NSMutableDictionary alloc] init];
		
		[self initDocuments];
	}
	return self;
}

- (void) dealloc {
	[_dictionary release];
	[super dealloc];
}

- (void) setSystemProperty:(NSString*) name value:(NSString*) value document:(MBDocument*) doc {
	MBElement *prop = [doc createElementWithName:@"/System[0]/Property"];
	
	[prop setValue:name forAttribute:@"name"];
	[prop setValue:value forAttribute:@"value"];
}

- (void) initDocuments {
	MBDocumentDefinition *docDef = [[MBMetadataService sharedInstance]definitionForDocumentName: DOC_SYSTEM_PROPERTIES];
	MBDocument *doc = [docDef createDocument];	
	
	[self setSystemProperty:@"platform" value:@"iPhone" document:doc];
	
	NSData *data = [NSData dataWithEncodedContentsOfMainBundle:@"applicationproperties"];
	
	[MBXmlDocumentParser parseFragment:data intoDocument:doc rootPath:@"/Application[0]" copyRootAttributes: FALSE];
	[_dictionary setValue:doc forKey:DOC_SYSTEM_PROPERTIES];
}

- (MBDocument *) loadDocument:(NSString *)documentName {
	MBDocument *doc = [_dictionary objectForKey:documentName];
	if(doc == nil)
	{
		// Not yet in the store; handle default construction of the document using a file as template
		NSData *data = [NSData dataWithEncodedContentsOfMainBundle:documentName];
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
