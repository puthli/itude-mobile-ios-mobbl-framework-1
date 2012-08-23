//
//  MBAlertView.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertView.h"

@interface MBAlertView () {
    NSMutableDictionary *_outcomeNames;
}
@property (nonatomic, retain) NSMutableDictionary *outcomeNames;
@end

@implementation MBAlertView

@synthesize outcomeNames = _outcomeNames;

- (void)dealloc
{
    [_outcomeNames release];
    [super dealloc];
}


- (void)setOutcomeName:(NSString *)outcomeName forButtonWithKey:(NSString *)key {
    [self.outcomeNames setObject:outcomeName forKey:key];
}

- (NSString *)outcomeNameForButtonAtIndex:(NSInteger) index {
    NSString *title = [self buttonTitleAtIndex:index];
    return [self.outcomeNames objectForKey:title];
}


- (NSMutableDictionary *)outcomeNames {
    if (!_outcomeNames) {
        _outcomeNames = [NSMutableDictionary new];
    }
    return _outcomeNames;
}

@end
