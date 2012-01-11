//
//  MBDataServiceBase.m
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBMacros.h"
#import "MBDataHandlerBase.h"
#import "MBMetadataService.h"

@implementation MBDataHandlerBase

- (MBDocument *) loadDocument:(NSString *)documentName {
	WLog(@"No loadDocument implementation for %@", documentName);
	return nil;
}

- (MBDocument *) loadFreshDocument:(NSString *)documentName {
	WLog(@"No loadFreshDocument implementation for %@", documentName);
	return nil;
}

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args {
	WLog(@"No loadDocument:withArguments implementation for %@", documentName);
	return nil;	
}

- (MBDocument *) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument*) args {
	WLog(@"No loadFreshDocument:withArguments implementation for %@", documentName);
	return nil;	
}

- (void) storeDocument:(MBDocument *)document {
	WLog(@"No storeDocument implementation for %@", [[document definition]name]);	
}

@end
