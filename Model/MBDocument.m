//
//  MBDocument.m
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBDataManagerService.h"

@interface MBElementContainer()
- (void) copyChildrenInto:(MBElementContainer*) other;
@end

@implementation MBDocument

@synthesize sharedContext = _sharedContext;
@synthesize argumentsUsed = _argumentsUsed;

- (id) initWithDocumentDefinition: (MBDocumentDefinition*) definition {
	if (self = [super init]) {
		_definition = definition;
		_sharedContext = [NSMutableDictionary new];
		[_definition retain];
		_pathCache = [NSMutableDictionary new];
	}
	return self;	
}

- (void) dealloc
{
	[_definition release];
	[_sharedContext release];
	[_argumentsUsed release];
	[_pathCache release];
	[super dealloc];
}

- (id) copy {
	MBDocument *newDoc = [[MBDocument alloc] initWithDocumentDefinition:_definition];
	[self copyChildrenInto: newDoc];
	newDoc->_argumentsUsed = [_argumentsUsed copy];
	return newDoc;
}

- (void) assignToDocument:(MBDocument*) target {
	if(![target->_definition.name isEqualToString:_definition.name]) {
		NSString *msg = [NSString stringWithFormat:@"Cannot assign document since document types differ: %@ != %@", target->_definition.name, _definition.name];
		@throw [NSException exceptionWithName:@"CannotAssign" reason:msg userInfo:nil];

	}
	[target->_elements removeAllObjects];
	[target->_pathCache removeAllObjects];
	[self copyChildrenInto: target];
}

- (NSString*) uniqueId {
	NSMutableString *uid = [NSMutableString stringWithCapacity:200];
	
	// Specification: the uniqueId of a document starts with <docname>:
	// This is required for the cache manager to determine the document type
	[uid appendFormat:@"%@:", _definition.name];
	[uid appendString:[super uniqueId]];
	return uid;
}

- (void) clearAllCaches {
	[self.sharedContext removeAllObjects];	
	[self clearPathCache];
}
	 
// Be careful with reload since it might change the number of elements; making any existing path (indexes) invalid
// It is safer to use loadFreshCopyForDelegate:resultSelector:errorSelector: and process the result in the callbacks
- (void) reload {

	MBDocument *fresh;
	
	if(_argumentsUsed == nil) fresh = [[MBDataManagerService sharedInstance] loadDocument:_definition.name];
	else fresh = [[MBDataManagerService sharedInstance] loadDocument:_definition.name withArguments: _argumentsUsed];
	[_elements release];
	_elements = [[fresh elements] retain];
	[_pathCache removeAllObjects];
}

-(void) loadFreshCopyForDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL)errorSelector {
	[[MBDataManagerService sharedInstance] loadDocument:_definition.name withArguments:_argumentsUsed forDelegate:delegate resultSelector:resultSelector errorSelector:errorSelector];
}

- (NSString *) asXmlWithLevel:(int)level
{
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<%@", level, "", _definition.name];
	if([[self elements] count] == 0)
		[result appendString:@"/>\n"];
	else {
		[result appendString:@">\n"];
		for(MBElementDefinition *elemDef in [_definition children]) {
			NSArray *lst = [[self elements] objectForKey:elemDef.name];
			for(MBElement *elem in lst)
    			[result appendString: [elem asXmlWithLevel: level+2]];
		}
		[result appendFormat:@"%*s</%@>\n", level, "", _definition.name];
	}
	
	return result;
}

- (void) clearPathCache {
	[_pathCache removeAllObjects];
}

- (id) valueForPath:(NSString*)path {
	NSArray *comps = [path componentsSeparatedByString:@"@"];
	if([comps count] != 2) return [self valueForPath:path translatedPathComponents:nil];
	
	MBElement *element = [_pathCache valueForKey:[comps objectAtIndex:0]];
	
	if(element == nil) {
		element = [super valueForPath:[comps objectAtIndex:0]];
		[_pathCache setValue:element forKey:[comps objectAtIndex:0]];
	} 	
	return [element valueForAttribute:[comps objectAtIndex:1]];
}

- (NSString *) description {
	return [self asXmlWithLevel: 0];
}

- (id) definition {
	return _definition;
}

- (NSString*) documentName {
	return _definition.name;
}

-(MBDocument*) document {
	return self;
}


@end
