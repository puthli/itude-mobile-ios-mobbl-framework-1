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
