//
//  MBResource.m
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBResourceDefinition.h"


@implementation MBResourceDefinition

@synthesize resourceId = _resourceId;
@synthesize url = _url;
@synthesize cacheable = _cacheable;
@synthesize ttl = _ttl;


- (void) dealloc
{
	[_resourceId release];
	[_url release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Resource id='%@' url='%@'%@ ttl='%i'/>\n", level, "",  _resourceId, _url, _cacheable?@"TRUE":@"FALSE", _ttl];
	return result;
}

-(void) validateDefinition {
	if(_resourceId == nil)  @throw [NSException exceptionWithName: @"InvalidResourceDefinition" reason: [NSString stringWithFormat: @"no id set for resource %@", [self asXmlWithLevel:0]] userInfo:nil];
	if(_url == nil) @throw [NSException exceptionWithName: @"InvalidResourceDefinition" reason: [NSString stringWithFormat: @"no url set for resource %@", [self asXmlWithLevel:0]] userInfo:nil];
}

@end
