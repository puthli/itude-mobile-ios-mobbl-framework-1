//
//  MBDialog.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/26/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDialog.h"
#import "MBDialogDefinition.h"

@interface MBDialog () {
    NSString *_name;
    NSString *_title;
    NSString *_iconName;
    NSString *_dialogMode;
    NSString *_contentType;
    NSString *_decorator;
    NSString *_stackStrategy;
    
    NSMutableArray *_pageStacks;

}

@end

@implementation MBDialog

@synthesize name = _name;
@synthesize title = _title;
@synthesize dialogMode = _dialogMode;
@synthesize iconName = _iconName;
@synthesize contentType = _contentType;
@synthesize decorator = _decorator;
@synthesize stackStrategy = _stackStrategy;
@synthesize pageStacks = _pageStacks;

- (void)dealloc
{
    [_name release];
    [_title release];
    [_dialogMode release];
    [_iconName release];
    [_contentType release];
    [_stackStrategy release];
    [_pageStacks release];
    [super dealloc];
}

-(id)initWithDefinition:(MBDialogDefinition *)definition {
    self = [super initWithDefinition:definition document:nil parent:nil];
    
    if (self) {
        self.name = definition.name;
        self.iconName = definition.iconName;
        self.dialogMode = definition.mode;
        self.title = definition.title;
        
        // TODO: Complete implementation
        
    }
    return self;
}


@end
