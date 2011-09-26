//
//  MBSession.m
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBSession.h"
#import "MBDocument.h"
#import "MBDataManagerService.h"

static MBSession *_instance = nil;

@implementation MBSession

+(MBSession *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBSession *) session {
	@synchronized(self) {
		if(_instance != nil && _instance != session) {
			[_instance release];
		}
		_instance = session;
		[_instance retain];
	}
}

//
// Override the following methods in an instance specific for your app; and register it app startup with setSharedInstance
//
-(MBDocument*) document {
    return nil;
}

-(void) logOff {
}

- (BOOL)loggedOn {
	return NO;
}

@end
