/*
 * (C) Copyright ItudeMobile.
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

#import "MBDialogDecoratorFactory.h"
#import "MBDialogController.h"
#import "MBMacros.h"

// Decorators
#import "MBDefaultDialogDecorator.h"
#import "MBModalDialogDecorator.h"
#import "MBModalCurrentContextDialogDecorator.h"
#import "MBModalFormSheetDialogDecorator.h"
#import "MBModalFullScreenDialogDecorator.h"
#import "MBModalPageSheetDialogDecorator.h"


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
        [self registerDialogDecorationBuilder:[[MBModalDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODAL_CLOSABLE];
        [self registerDialogDecorationBuilder:[[MBModalCurrentContextDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALCURRENTCONTEXT];
        [self registerDialogDecorationBuilder:[[MBModalCurrentContextDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALCURRENTCONTEXT_CLOSABLE];
        [self registerDialogDecorationBuilder:[[MBModalFormSheetDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALFORMSHEET];
        [self registerDialogDecorationBuilder:[[MBModalFormSheetDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALFORMSHEET_CLOSABLE];
        [self registerDialogDecorationBuilder:[[MBModalFullScreenDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALFULLSCREEN];
        [self registerDialogDecorationBuilder:[[MBModalFullScreenDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALFULLSCREEN_CLOSABLE];
        [self registerDialogDecorationBuilder:[[MBModalPageSheetDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALPAGESHEET];
        [self registerDialogDecorationBuilder:[[MBModalPageSheetDialogDecorator new] autorelease] forType:C_DIALOG_DECORATOR_TYPE_MODALPAGESHEET_CLOSABLE];
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
        [builder decorateDialog:dialog];
    }
    else {
        [NSException raise:@"DialogDecoratorNotFound" format:@"No dialog decorator found for contentType %@ ", dialog.decorator];
    }
    
}

-(void)presentDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle {
    id<MBDialogDecorator> builder = [self builderForType:dialog.decorator];
    
    if (builder) {
        [builder presentViewController:dialog.rootViewController withTransitionStyle:transitionStyle];
    }
    else {
        [self throwDialogDecoratorNotFoundExceptionForDialog:dialog];
    }
}

-(void)dismissDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle {
    id<MBDialogDecorator> builder = [self builderForType:dialog.decorator];
    
    if (builder) {
        [builder dismissViewController:dialog.rootViewController withTransitionStyle:transitionStyle];
    }
    else {
        [self throwDialogDecoratorNotFoundExceptionForDialog:dialog];
    }
}


#pragma mark -
#pragma mark Util

- (void)throwDialogDecoratorNotFoundExceptionForDialog:(MBDialogController *)dialog {
    [NSException raise:@"DialogDecoratorNotFound" format:@"No dialog decorator found for contentType %@ ", dialog.decorator];
}

@end
