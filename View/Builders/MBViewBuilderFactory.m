//
//  MBViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilderFactory.h"
#import "MBPanelViewBuilder.h"
#import "MBPageViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBDefaultRowViewBuilder.h"
#import "MBFieldViewBuilder.h"
#import "MBStyleHandler.h"

static MBViewBuilderFactory *_instance = nil;

@implementation MBViewBuilderFactory

@synthesize panelViewBuilder = _panelViewBuilder;
@synthesize pageViewBuilder = _pageViewBuilder;
@synthesize forEachViewBuilder = _forEachViewBuilder;
@synthesize rowViewBuilder = _rowViewBuilder;
@synthesize fieldViewBuilder = _fieldViewBuilder;
@synthesize styleHandler = _styleHandler;

- (id) init
{
	self = [super init];
	if (self != nil) {
		_panelViewBuilder = [[MBPanelViewBuilder alloc] init];
		_pageViewBuilder = [[MBPageViewBuilder alloc] init];
		_forEachViewBuilder = [[MBForEachViewBuilder alloc] init];
		_rowViewBuilder = [[MBDefaultRowViewBuilder alloc] init];
		_fieldViewBuilder = [[MBFieldViewBuilder alloc] init];
		_styleHandler = [[MBStyleHandler alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[_panelViewBuilder release];
	[_pageViewBuilder release];
	[_forEachViewBuilder release];
	[_rowViewBuilder release];
	[_fieldViewBuilder release];
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


@end
