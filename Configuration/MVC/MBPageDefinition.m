//
//  MBPageDefinition.m
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBPageDefinition.h"

@implementation MBPageDefinition

@synthesize rootPath = _rootPath;
@synthesize pageType = _pageType;

- (void) dealloc
{
	[_documentName release];
	[_rootPath release];
	[super dealloc];
}

- (NSString*) documentName
{
	return _documentName;
}

- (void) setDocumentName:(NSString *) name {
	if(name != _documentName) [_documentName release];
	
	NSRange rng = [name rangeOfString: @"/"];
	if(rng.length > 0)
	{ 
		_documentName = [name substringToIndex:rng.location];
		[_documentName retain];
		NSString *rp = [name substringFromIndex:rng.location];
		if(![rp hasSuffix:@"/"]) rp = [NSString stringWithFormat:@"%@/", rp];
		self.rootPath = rp;
	} 
	else { 
	   _documentName = name;
		self.rootPath = @"";
		[_documentName retain];
	}
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Page name='%@' document='%@'%@>\n", level, "",  _name, _documentName, [self attributeAsXml:@"title" withValue:_title]];
	for (MBPanelDefinition* child in _children)
		[result appendString: [child asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</Page>\n", level, ""];
		 
	return result;
}

-(void) validateDefinition {
	if(_name == nil) @throw [NSException exceptionWithName: @"InvalidPageDefinition" reason: [NSString stringWithFormat: @"no name set for page %@", [self asXmlWithLevel:0]] userInfo:nil];
	if(_documentName == nil) @throw [NSException exceptionWithName: @"InvalidPageDefinition" reason: [NSString stringWithFormat: @"no document set for page %@", _name] userInfo:nil];
}

@end
