//
//  MBAlert.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlert.h"
#import "MBApplicationFactory.h"
#import "MBComponentFactory.h"
#import "MBViewbuilderFactory.h"
#import "MBFieldTypes.h"


@implementation MBAlert

@synthesize alertName = _alertName;
@synthesize rootPath = _rootPath;
@synthesize title = _title;
@synthesize document = _document;
@synthesize alertView = _alertView;

- (void)dealloc
{
    [_alertName release];
    [_rootPath release];
    [_title release];
    [_document release];
    [_alertView release];
    [super dealloc];
}

-(id) initWithDefinition:(MBAlertDefinition*) definition
                document:(MBDocument*) document
                rootPath:(NSString*) rootPath
                delegate:(id<UIAlertViewDelegate>)alertViewDelegate {


    if (self = [super initWithDefinition:definition document:document parent:nil])
    {
        self.rootPath = rootPath;
        self.document = document;
        self.title = definition.title;
        self.alertName = definition.name;

        // Ok; now we can build the children:
        for(MBDefinition *def in definition.children) {
			if([def isPreConditionValid:document currentPath:[[self parent] absoluteDataPath]]) {
                [self addChild: [MBComponentFactory componentFromDefinition: def document: document parent: self]];
            } 
		}
        
        self.alertView = [[[MBViewBuilderFactory sharedInstance] alertViewBuilder] buildAlertView:self forDelegate:alertViewDelegate];

    }
	return self;
}


- (NSString *)outcomeNameForButtonAtIndex:(NSInteger)index {
    return [self.alertView outcomeNameForButtonAtIndex:index];
}


@end
