/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
