//
//  MBEndPointDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBEndPointDefinition.h"


@implementation MBEndPointDefinition

@synthesize documentIn = _documentIn;
@synthesize documentOut = _documentOut;
@synthesize endPointUri = _endPointUri;
@synthesize cacheable = _cacheable;
@synthesize ttl = _ttl;
@synthesize timeout = _timeout;

- (id) init
{
    self = [super init];
    if (self != nil) {
        _resultListeners = [NSMutableArray new];
    }
    return self;
}

- (void) dealloc
{
	[_endPointUri release];
	[_documentOut release];
	[_documentIn release];
    [_resultListeners release];
	[super dealloc];
}

- (void) addResultListener:(MBResultListenerDefinition*) lsnr {
    [_resultListeners addObject: lsnr];
}

- (NSMutableArray*) resultListeners {
    return _resultListeners;
}

@end
