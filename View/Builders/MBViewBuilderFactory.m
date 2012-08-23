//
//  MBViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBRowViewBuilder.h"
#import "MBViewBuilderFactory.h"
#import "MBPanelViewBuilder.h"
#import "MBPageViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBDefaultRowViewBuilder.h"
#import "MBFieldViewBuilder.h"
#import "MBStyleHandler.h"
#import "MBRowViewBuilderFactory.h"

static MBViewBuilderFactory *_instance = nil;

@implementation MBViewBuilderFactory

@synthesize panelViewBuilder = _panelViewBuilder;
@synthesize pageViewBuilder = _pageViewBuilder;
@synthesize forEachViewBuilder = _forEachViewBuilder;
@synthesize fieldViewBuilder = _fieldViewBuilder;
@synthesize styleHandler = _styleHandler;
@synthesize rowViewBuilderFactory = _rowViewBuilderFactory;

- (id) init
{
	self = [super init];
	if (self != nil) {
		_panelViewBuilder = [[MBPanelViewBuilder alloc] init];
		_pageViewBuilder = [[MBPageViewBuilder alloc] init];
		_forEachViewBuilder = [[MBForEachViewBuilder alloc] init];
		_fieldViewBuilder = [[MBFieldViewBuilder alloc] init];
		_styleHandler = [[MBStyleHandler alloc] init];
        _rowViewBuilderFactory = [[MBRowViewBuilderFactory alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[_panelViewBuilder release];
	[_pageViewBuilder release];
	[_forEachViewBuilder release];
	[_fieldViewBuilder release];
    [_rowViewBuilderFactory release];
	[super dealloc];
}

+(MBViewBuilderFactory *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBViewBuilderFactory *) factory {
	@synchronized(self) {
		if(_instance != nil && _instance != factory) {
			[_instance release];
		}
		_instance = factory;
		[_instance retain];
	}
}

- (id <MBRowViewBuilder>)rowViewBuilder
{
    return self.rowViewBuilderFactory.defaultBuilder;
}


@end
