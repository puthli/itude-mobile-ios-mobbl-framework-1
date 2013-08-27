//
//  MBWebserviceDataService.m
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBWebserviceDataHandler.h"
#import "MBMetadataService.h"
#import "DataUtilites.h"

@implementation MBWebserviceDataHandler

- (id) init {
	self = [super init];
	if (self != nil) {
        MBWebservicesConfigurationParser *parser = [[MBWebservicesConfigurationParser alloc] init];
		NSString *documentName = [[MBMetadataService sharedInstance] endpointsName];
		NSData *data = [NSData dataWithEncodedContentsOfMainBundle: documentName];
		_webServiceConfiguration = [[parser parseData:data ofDocument: documentName] retain];
        [parser release];
	}
	return self;
}

- (id) initWithConfiguration:(MBWebservicesConfiguration *)configuration
{
    self = [super init];
    if (self) {
        _webServiceConfiguration = [configuration retain];
    }
    return  self;
}

- (MBEndPointDefinition *) getEndPointForDocument:(NSString*)name {
	return [_webServiceConfiguration getEndPointForDocumentName:name];	
}

- (MBDocument *) loadDocument:(NSString *)documentName {
	MBDocument *result = [self loadDocument:documentName withArguments:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkActivity" object: nil];
	return result;
}

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkActivity" object: nil];
	return nil;
}

- (void) storeDocument:(MBDocument *)document {
}

- (void) dealloc {
	[_webServiceConfiguration release];
	[super dealloc];	
}


@end
