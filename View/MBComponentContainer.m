//
//  MBComponentContainer.m
//  Core
//
//  Created by Wido on 6/5/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponentContainer.h"


@implementation MBComponentContainer
@synthesize children = _children;


-(id) initWithDefinition:(id)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent {

    if(self = [super initWithDefinition: definition document:document parent:parent]) {
        _children = [NSMutableArray new];
    }
    return self;
}

- (void) dealloc
{
	[_children release];
	[super dealloc];
}

-(void) addChild: (MBComponent*) child {
    if(child != nil && !child.markedForDestruction) {
        [_children addObject:child];
        [child setParent:self];
    }
}

- (void) translatePath {
	for(MBComponent *child in _children) {
		[child translatePath];	
	}
}

-(BOOL) resignFirstResponder {
	BOOL result = FALSE;
	for(MBComponent *child in [self children]) result |= [child resignFirstResponder];
	return result;
}

- (NSMutableArray*) childrenOfKind:(Class) clazz {
    NSMutableArray *result = [NSMutableArray array];
    for(MBComponent *child in _children) {
        if([child isKindOfClass: clazz]) [result addObject: child];
    }
    return result;
}

- (NSMutableArray*) descendantsOfKind:(Class) clazz {
    
    NSMutableArray *result = [NSMutableArray array];
    for(MBComponent *child in _children) {
        if([child isKindOfClass: clazz]) [result addObject: child];
        
        [result addObjectsFromArray: [child descendantsOfKind: clazz]];
    }
    return result;
}
         
- (NSString *) childrenAsXmlWithLevel:(int)level {
	NSMutableString *result = [[NSMutableString new] autorelease];
    
	for (MBComponent* child in _children)
		[result appendString:[child asXmlWithLevel:level]];
	
	return result;
}


@end
