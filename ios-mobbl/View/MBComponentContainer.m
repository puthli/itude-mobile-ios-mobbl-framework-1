/*
 * (C) Copyright ItudeMobile.
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
