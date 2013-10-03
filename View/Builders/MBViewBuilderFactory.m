/*
 * (C) Copyright Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBViewBuilderFactory.h"
#import "MBPanelViewBuilder.h"
#import "MBPageViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBRowViewBuilder.h"
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
		_rowViewBuilder = [[MBRowViewBuilder alloc] init];
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
