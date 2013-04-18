//
//  MBBundleDefinition.m
//  Core
//
//  Created by Wido on 8-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBBundleDefinition.h"


@implementation MBBundleDefinition

@synthesize languageCode = _languageCode;
@synthesize url = _url;


- (void) dealloc
{
	[_url release];
	[_languageCode release];
	[super dealloc];
}

-(void) validateDefinition {
	if(_languageCode == nil)  @throw [NSException exceptionWithName: @"InvalidBundleDefinition" reason: [NSString stringWithFormat: @"no languageCode set for bundle %@", [self asXmlWithLevel:0]] userInfo:nil];
	if(_url == nil) @throw [NSException exceptionWithName: @"InvalidBundleDefinition" reason: [NSString stringWithFormat: @"no url set for bundle %@", [self asXmlWithLevel:0]] userInfo:nil];
}

@end
