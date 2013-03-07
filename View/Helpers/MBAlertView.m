//
//  MBAlertView.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertView.h"
#import "MBField.h"

@interface MBAlertView () {
    NSMutableDictionary *_fields;
}
@property (nonatomic, retain) NSMutableDictionary *fields;
@end

@implementation MBAlertView

@synthesize fields = _fields;


- (void)dealloc
{
    [_fields release];
    [super dealloc];
}

- (void)setField:(MBField *)field forButtonWithKey:(NSString *)key {
    [self.fields setObject:field forKey:key];
}

- (MBField *)fieldForButtonAtIndex:(NSInteger) index {
    NSString *title = [self buttonTitleAtIndex:index];
    return [self.fields objectForKey:title];
}


- (NSMutableDictionary *)fields {
    if (!_fields) {
        _fields = [NSMutableDictionary new];
    }
    return _fields;
}

@end
