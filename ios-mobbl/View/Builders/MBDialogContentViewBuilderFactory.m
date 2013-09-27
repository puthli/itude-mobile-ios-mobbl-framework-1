//
//  MBDialogContentBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDialogContentViewBuilderFactory.h"
#import "MBDialogController.h"
#import "MBMacros.h"

// Builders
#import "MBSingleDialogContentBuilder.h"
#import "MBSplitDialogContentBuilder.h"
#import "MBModalDialogDecorator.h"

@interface MBDialogContentViewBuilderFactory ()
@property(readonly,nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBDialogContentViewBuilderFactory {
    NSMutableDictionary *_registry;
}

@synthesize registry = _registry;


- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        [self registerDialogContentBuilder:[[MBSingleDialogContentBuilder new] autorelease] forType:C_DIALOG_CONTENT_TYPE_SINGLE];
        [self registerDialogContentBuilder:[[MBSplitDialogContentBuilder new] autorelease] forType:C_DIALOG_CONTENT_TYPE_SPLIT];
    }

    return self;
}

- (void)dealloc
{
    [_registry release];
    [super dealloc];
}


- (void)registerDialogContentBuilder:(id<MBDialogContentBuilder>)dialogContentBuilder forType:(NSString *)type {
    [self.registry setObject:dialogContentBuilder forKey:type];
}


- (id<MBDialogContentBuilder>)builderForType:(NSString *)type {
    id dialogContentBuilder = [self.registry valueForKey:type];
    if (dialogContentBuilder) return dialogContentBuilder;
    
    DLog(@"No dialog content builder found for type %@",type);

    return nil;
}


-(UIViewController*) buildDialogContentViewControllerForDialog:(MBDialogController*) dialog {
    id<MBDialogContentBuilder> builder = [self builderForType:dialog.contentType];
    
    if (builder) {
        return [builder buildDialogContentViewControllerForDialog:dialog];
    }
    else {
        [NSException raise:@"DialogContentBuilderNotFound" format:@"No dialog content builder found for contentType %@ ", dialog.contentType];
        return nil;
    }
    
}




@end
