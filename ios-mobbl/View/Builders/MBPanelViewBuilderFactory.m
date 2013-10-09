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

#import "MBPanelViewBuilderFactory.h"
#import "MBPanel.h"
#import "MBPlainPanelBuilder.h"
#import "MBBasicPanelBuilder.h"
#import "MBViewBuilderFactory.h"
#import "MBListBuilder.h"
#import "MBMatrixBuilder.h"
#import "MBSectionPanelViewBuilder.h"

@interface MBPanelViewBuilderFactory ()
@property(readonly,nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBPanelViewBuilderFactory {
    NSMutableDictionary *_registry;
    id<MBPanelViewBuilder> _defaultBuilder;
}

@synthesize registry = _registry;
@synthesize defaultBuilder = _defaultBuilder;


- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        _defaultBuilder = [[[MBBasicPanelBuilder alloc] init] retain];
    }
    
    
    
    [self registerPanelViewBuilder:[[[MBPlainPanelBuilder alloc]init] autorelease] forPanelType:C_PANEL_PLAIN];
    [self registerPanelViewBuilder:[[[MBListBuilder alloc]init] autorelease] forPanelType:C_PANEL_LIST];
    [self registerPanelViewBuilder:[[[MBMatrixBuilder alloc]init] autorelease] forPanelType:C_PANEL_MATRIX];
    [self registerPanelViewBuilder:[[[MBSectionPanelViewBuilder alloc] init] autorelease] forPanelType:C_PANEL_SECTION];

    return self;
}

- (void)dealloc
{
    [_registry release];
    [_defaultBuilder release];
    [super dealloc];
}


- (void)registerPanelViewBuilder:(id<MBPanelViewBuilder>)panelViewBuilder forPanelType:(NSString*)type  {
    [self registerPanelViewBuilder:panelViewBuilder forPanelType:type forPanelStyle:nil];
}

- (void)registerPanelViewBuilder:(id<MBPanelViewBuilder>)panelViewBuilder forPanelType:(NSString*)type forPanelStyle:(NSString *)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) {
        
        styleDict = [[NSMutableDictionary dictionary] retain];
        [self.registry setValue:styleDict forKey:type];
        [styleDict release];
    }
    
    [styleDict setObject:panelViewBuilder forKey:style ? style : [NSNull null]];
}


- (id<MBPanelViewBuilder>)builderForType:(NSString *)type withStyle:(NSString*)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) return self.defaultBuilder;
    
    id<MBPanelViewBuilder> builder = [styleDict valueForKey:style];
    if (!builder) builder = [styleDict objectForKey:[NSNull null]];
    if (!builder) builder = self.defaultBuilder;
    
    return builder;
    
}


-(UIView*) buildPanelView:(MBPanel*) panel forParent:(UIView*) parent withMaxBounds:(CGRect) bounds viewState:(MBViewState)viewState {
    id<MBPanelViewBuilder> builder = [self builderForType:panel.type withStyle:panel.style];
    
    if (builder) {
        UIView *view= [builder buildPanelView:panel forParent:(UIView*) parent withMaxBounds:bounds viewState:viewState];
        [[[MBViewBuilderFactory sharedInstance] styleHandler] applyStyle:panel forView:view viewState: viewState];
        return view;
    }
    else {
        [NSException raise:@"BuilderNotFound" format:@"No builder found for type %@ and style %@", panel.type, panel.style];
        return nil;
    }
}

@end
