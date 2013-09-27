//
//  MBViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBRowViewBuilder.h"
#import "MBViewBuilderFactory.h"
#import "MBPanelViewBuilderFactory.h"
#import "MBPageViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBFieldViewBuilder.h"
#import "MBStyleHandler.h"
#import "MBRowViewBuilderFactory.h"

static MBViewBuilderFactory *_instance = nil;

@implementation MBViewBuilderFactory

@synthesize pageViewBuilder = _pageViewBuilder;
@synthesize alertViewBuilder = _alertViewBuilder;
@synthesize forEachViewBuilder = _forEachViewBuilder;
@synthesize fieldViewBuilderFactory = _fieldViewBuilderFactory;
@synthesize styleHandler = _styleHandler;
@synthesize rowViewBuilderFactory = _rowViewBuilderFactory;
@synthesize panelViewBuilderFactory = _panelViewBuilderFactory;
@synthesize dialogContentViewBuilderFactory = _dialogContentViewBuilderFactory;
@synthesize dialogDecoratorFactory = _dialogDecoratorFactory;
@synthesize backButtonBuilderFactory = _backButtonBuilderFactory;

- (id) init
{
	self = [super init];
	if (self != nil) {
		_panelViewBuilderFactory = [[MBPanelViewBuilderFactory alloc] init];
		_pageViewBuilder = [[MBPageViewBuilder alloc] init];
        _alertViewBuilder = [[MBAlertViewBuilder alloc] init];
		_forEachViewBuilder = [[MBForEachViewBuilder alloc] init];
		_fieldViewBuilderFactory = [[MBFieldViewBuilderFactory alloc] init];
		_styleHandler = [[MBStyleHandler alloc] init];
        _rowViewBuilderFactory = [[MBRowViewBuilderFactory alloc] init];
        _dialogContentViewBuilderFactory = [MBDialogContentViewBuilderFactory new];
        _dialogDecoratorFactory = [MBDialogDecoratorFactory new];
        _backButtonBuilderFactory = [MBBackButtonBuilderFactory new];
	}
	return self;
}


- (void) dealloc
{
	[_panelViewBuilderFactory release];
	[_pageViewBuilder release];
    [_alertViewBuilder release];
	[_forEachViewBuilder release];
	[_fieldViewBuilderFactory release];
    [_rowViewBuilderFactory release];
    [_dialogContentViewBuilderFactory release];
    [_dialogDecoratorFactory release];
    [_backButtonBuilderFactory release];
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
