//
//  MBOrderedMutableDictionary.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 6/5/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBOrderedMutableDictionary : NSMutableDictionary

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;
- (id)keyAtIndex:(NSUInteger)anIndex;
- (id)objectAtIndex:(NSInteger)anIndex;

@end
