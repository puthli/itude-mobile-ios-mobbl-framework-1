//
//  MBDialogDefinition.m
//  Core
//
//  Created by Frank van Eenbergen on 13-10-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogDefinition.h"
#import "MBPageStackDefinition.h"

@interface MBDialogDefinition () {
	NSString *_title;
	NSString *_mode;
	NSString *_icon;
    NSString *_showAs;
    NSString *_contentType;
    NSString *_decorator;
    NSString *_stackStrategy;
    NSMutableArray *_pageStacks;
}

@end

@implementation MBDialogDefinition

@synthesize title = _title;
@synthesize mode = _mode;
@synthesize iconName = _icon;
@synthesize showAs = _showAs;
@synthesize contentType = _contentType;
@synthesize decorator = _decorator;
@synthesize stackStrategy = _stackStrategy;
@synthesize pageStacks = _pageStacks;


- (id) init {
	if (self = [super init]) {
        self.pageStacks = [[NSMutableArray new] autorelease];
	}
	return self;
}


- (void) dealloc {
	[_title release];
	[_mode release];
	[_icon release];
    [_showAs release];
    [_contentType release];
    [_decorator release];
    [_stackStrategy release];
	[_pageStacks release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Dialog %@%@%@%@%@%@%@%@/>\n", level, "", 
							   [self attributeAsXml:@"name" withValue:self.name],
                               [self attributeAsXml:@"mode" withValue:self.mode],
							   [self attributeAsXml:@"title" withValue:self.title],
							   [self attributeAsXml:@"icon" withValue:self.iconName],
                               [self attributeAsXml:@"showAs" withValue:self.showAs],
                               [self attributeAsXml:@"contentType" withValue:self.contentType],
                               [self attributeAsXml:@"decorator" withValue:self.decorator],
                               [self attributeAsXml:@"stackStrategy" withValue:self.stackStrategy]];
	
	for (MBPageStackDefinition *definition in self.pageStacks) {
		[result appendString:[definition asXmlWithLevel:level+2]];
	}

	[result appendFormat:@"%*s</Dialog>\n", level, ""];
	return result;
}

- (void) validateDefinition {
	if(_name == nil) @throw [NSException exceptionWithName: @"InvalidDialogDefinition" reason: [NSString stringWithFormat: @"no name set for dialog"] userInfo:nil];
}


- (void) addPageStack:(MBPageStackDefinition *) child {
    [self.pageStacks addObject:child];
}


@end
