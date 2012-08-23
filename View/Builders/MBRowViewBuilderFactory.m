//
//  MBRowViewBuilderFactory 
//
//  Created by Pieter Kuijpers on 21-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBDefaultRowViewBuilder.h"
#import "MBRowViewBuilderFactory.h"

@interface MBRowViewBuilderFactory()
@property (nonatomic, retain) NSMutableDictionary *registeredBuilders;
@end

@implementation MBRowViewBuilderFactory

@synthesize registeredBuilders = _registeredBuilders;
@synthesize defaultBuilder = _defaultBuilder;

- (id)init
{
    self = [super init];
    if (self) {
        _registeredBuilders = [[NSMutableDictionary dictionary] retain];
        _defaultBuilder = [[MBDefaultRowViewBuilder alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_registeredBuilders release];
    [_defaultBuilder release];
    [super dealloc];
}

- (void)registerRowViewBuilder:(id <MBRowViewBuilder>)rowViewBuilder forRowStyle:(NSString *)style
{
    [self.registeredBuilders setObject:rowViewBuilder forKey:style];
}

- (id <MBRowViewBuilder>)builderForStyle:(NSString *)style
{
    id<MBRowViewBuilder> builder = [self.registeredBuilders objectForKey:style];
    return builder ? builder : self.defaultBuilder;
}


@end