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

#import "MBDocumentDiff.h"
#import "MBDocument.h"
#import "StringUtilities.h"

@interface MBDocument()
- (void) addAllPathsTo:(NSMutableSet*) set currentPath:(NSString*) currentPath;
@end

@interface MBDocumentDiff()

- (void) diffA:(MBDocument*) a andB:(MBDocument*) b;

@end

@implementation MBDocumentDiff


- (id) initWithDocumentA:(MBDocument*) a andDocumentB:(MBDocument*) b
{
	self = [super init];
	if (self != nil) {
		_modified = [NSMutableSet new];
		_aValues = [NSMutableDictionary new];
		_bValues = [NSMutableDictionary new];
		[self diffA: a andB: b];
	}
	return self;
}

- (void) dealloc
{
	[_modified release];
	[_aValues release];
	[_bValues release];
	[super dealloc];
}

- (NSString*) normalize:(NSString*) path {

	if(![path hasPrefix:@"/"]) path = [NSString stringWithFormat:@"/%@", path];
	return [path normalizedPath];
}

- (void) diffA:(MBDocument*) a andB:(MBDocument*) b {
	NSMutableSet *set = [NSMutableSet new];
	[a addAllPathsTo:set currentPath:@""];
	[b addAllPathsTo:set currentPath:@""];
	
	for(NSString *changedPath in set) {
		NSString *path = [self normalize: changedPath];
		NSString *valueA = [a valueForPath:path];	
		NSString *valueB = [b valueForPath:path];
		
		if((valueA != nil && valueB == nil) || (valueA == nil && valueB != nil)) {
			[_modified addObject: path];
		}
		else if (valueA != nil && valueB != nil && ![valueA isEqualToString:valueB]) { 
			[_modified addObject: path];
			[_aValues setValue:valueA forKey:path];
			[_bValues setValue:valueB forKey:path];
		}
	}
	[set release];
}

- (NSSet*) paths {
	return _modified;	
}

- (BOOL) isChanged:(NSString*) path {
	return [_modified containsObject:[self normalize: path]];
}

- (BOOL) isChanged {
	return [_modified count] != 0;
}

-(NSString*) valueOfAForPath:(NSString*) path {
	return [_aValues valueForKey:[self normalize: path]];
}

-(NSString*) valueOfBForPath:(NSString*) path {
	return [_bValues valueForKey:[self normalize: path]];
}

- (NSString *) description {
	return [_modified description];	
}

@end
