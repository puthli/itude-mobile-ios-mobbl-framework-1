//
//  MBWebserviceConfiguration.m
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBWebservicesConfiguration.h"

@implementation MBWebservicesConfiguration

- (id) init
{
	self = [super init];
	if (self != nil) {
		_endPoints = [NSMutableDictionary new];
        _resultListeners = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc
{
	[_endPoints release];
    [_resultListeners release];
	[super dealloc];
}

- (void) linkGlobalListeners {
    for(MBEndPointDefinition *def in [_endPoints allValues]) {
        [[def resultListeners] addObjectsFromArray: _resultListeners];
    }
}

- (void) addEndPoint:(MBEndPointDefinition *)definition {
	[_endPoints setValue:definition forKey:definition.documentOut];
}

- (MBEndPointDefinition *)getEndPointForDocumentName:(NSString *)documentName {
	return (MBEndPointDefinition*)[_endPoints valueForKey:documentName];
}

- (void) addResultListener:(MBResultListenerDefinition*) lsnr {
    [_resultListeners addObject: lsnr];
}

- (NSMutableArray*) resultListeners {
    return _resultListeners;
}

@end
