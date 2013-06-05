//
//  MBOrderedMutableDictionary.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 6/5/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBOrderedMutableDictionary.h"

@interface MBOrderedMutableDictionary () {
    NSMutableDictionary *_dictionary;
    NSMutableArray *_array;
}
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSMutableArray *array;
@end

#pragma mark -
@implementation MBOrderedMutableDictionary

@synthesize dictionary = _dictionary;
@synthesize array = _array;

- (void)dealloc
{
    [_dictionary release];
    [_array release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dictionary = [NSMutableDictionary dictionary];
        self.array = [NSMutableArray array];
    }
    return self;
}

-(id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    self = [super initWithObjects:objects forKeys:keys];
    if (self != nil)
    {
        self.dictionary = [[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
        self.array = [[NSMutableArray alloc] initWithArray:objects];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
    self = [super initWithCapacity:numItems];
    if (self != nil)
    {
        self.dictionary = [[[NSMutableDictionary alloc] initWithCapacity:numItems] autorelease];
        self.array = [[[NSMutableArray alloc] initWithCapacity:numItems] autorelease];
    }
    return self;
}



#pragma mark -
#pragma mark Overridden NSMutableDictionary methods

- (NSUInteger)count {
    return [self.dictionary count];
}

- (id)objectForKey:(id)aKey {
    return [self.dictionary objectForKey:aKey];
}


- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (![self.dictionary objectForKey:aKey]) {
        [self.array addObject:aKey];
    }
    [self.dictionary setObject:anObject forKey:aKey];

}

- (void)removeObjectForKey:(id)aKey
{
    [self.dictionary removeObjectForKey:aKey];
    [self.array removeObject:aKey];
}


-(void)removeAllObjects {
    [self.dictionary removeAllObjects];
    [self.array removeAllObjects];
}


- (NSEnumerator *)keyEnumerator
{
    return [self.array objectEnumerator];
}

-(NSArray *)allValues {
    // Sort all the values
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in self.array) {
        [result addObject:[self.dictionary objectForKey:key]];
    }
    return result;
}

#pragma mark -
#pragma mark Header methods implementation

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
	if ([self.dictionary objectForKey:aKey])
	{
		[self.dictionary removeObjectForKey:aKey];
	}
	[self.array insertObject:aKey atIndex:anIndex];
	[self.dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex
{
	return [self.array objectAtIndex:anIndex];
}

- (id)objectAtIndex:(NSInteger)anIndex {
    NSString *key = [self keyAtIndex:anIndex];
    return [self.dictionary objectForKey:key];
}

@end
