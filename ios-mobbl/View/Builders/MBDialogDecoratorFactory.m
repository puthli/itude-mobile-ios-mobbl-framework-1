//
//  MBDialogDecorationBuilderFactory.m
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDialogDecoratorFactory.h"
#import "MBDialogController.h"
#import "MBMacros.h"

// Decorators
#import "MBDefaultDialogDecorator.h"
#import "MBModalDialogDecorator.h"

@interface MBDialogDecoratorFactory ()
@property(readonly,nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBDialogDecoratorFactory {
    NSMutableDictionary *_registry;
    id<MBDialogDecorator> _defaultDecorator;
}

@synthesize registry = _registry;
@synthesize defaultDecorator = _defaultDecorator;


- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        _defaultDecorator = [MBDefaultDialogDecorator new];
        [self registerDialogDecorationBuilder:[[MBModalDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODAL];
    }
    
    return self;
}

- (void)dealloc
{
    [_registry release];
    [super dealloc];
}

- (void)registerDialogDecorationBuilder:(id<MBDialogDecorator>)dialogDecorationBuilder forType:(NSString *)type {
    [self.registry setObject:dialogDecorationBuilder forKey:type];
}


- (id<MBDialogDecorator>)builderForType:(NSString *)type {
    
    if (type.length > 0) {
        id dialogDecorator = [self.registry valueForKey:type];
        if (dialogDecorator) return dialogDecorator;
        DLog(@"No dialog decorator found for type %@",type);
    }
    
    return self.defaultDecorator;

    
    return nil;
}


-(void)decorateDialog:(MBDialogController *)dialog {
    id<MBDialogDecorator> builder = [self builderForType:dialog.decorator];
    
    if (builder) {
        // TODO: DisplayMode is @"MODAL" for testing. Should be different????
        [builder decorateViewController:dialog.rootViewController displayMode:dialog.decorator];
    }
    else {
        [NSException raise:@"DialogDecoratorNotFound" format:@"No dialog decorator found for contentType %@ ", dialog.decorator];
    }
    
}

@end
