//
//  MBRESTServiceDataHandler.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBWebserviceDataHandler.h"
#import "MBURLConnectionDataHandler.h"

@interface MBRESTServiceDataHandler : MBURLConnectionDataHandler {

	NSString *_documentFactoryType;
}

@property (nonatomic, retain) NSString *documentFactoryType;

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args;
- (void) storeDocument:(MBDocument *)document;

- (NSMutableURLRequest *) setupHTTPRequest:(NSMutableURLRequest *)request;

@end
