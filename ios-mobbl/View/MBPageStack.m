//
//  MBPageStack.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/25/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBPageStack.h"
#import "MBDefinition.h"

@interface MBPageStack (){
    NSString *_name;
}

@end

@implementation MBPageStack

@synthesize name = _name;

- (void)dealloc
{
    [_name release];
    [super dealloc];
}

- (id)initWithDefinition:(id)definition document:(MBDocument *)document parent:(MBComponentContainer *)parent {
    self = [super initWithDefinition:definition document:document parent:parent];
    if (self) {
        
        if ([definition isKindOfClass:[MBDefinition class]]) {
            self.name = [(MBDefinition *)definition name];
        }
        
    }
    return self;
}


@end
