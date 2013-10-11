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
#import "MBRowViewBuilder.h"
#import "MBNewRowViewBuilder.h"
#import "MBRowViewBuilderFactory.h"
#import "MBViewBuilderFactory.h"
#import "MBPanel.h"

@interface MBRowViewBuilderFactory()
@property (nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBRowViewBuilderFactory {
    NSMutableDictionary *_registry;
    id<MBRowViewBuilder> _defaultBuilder;
}

@synthesize registry = _registry;
@synthesize defaultBuilder = _defaultBuilder;

- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        _defaultBuilder = [[MBNewRowViewBuilder alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_registry release];
    [_defaultBuilder release];
    [super dealloc];
}


-(void)registerRowViewBuilder:(id<MBRowViewBuilder>)rowViewBuilder forRowType:(NSString *)type {
    [self registerRowViewBuilder:rowViewBuilder forRowType:type forRowStyle:nil];
}

-(void)registerRowViewBuilder:(id<MBRowViewBuilder>)rowViewBuilder forRowType:(NSString *)type forRowStyle:(NSString *)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) {
        
        styleDict = [[NSMutableDictionary dictionary] retain];
        [self.registry setValue:styleDict forKey:type];
        [styleDict release];
    }
    
    [styleDict setObject:rowViewBuilder forKey:style ? style : [NSNull null]];
}

- (id<MBRowViewBuilder>)builderForType:(NSString *)type withStyle:(NSString *)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) return self.defaultBuilder;
    
    id<MBRowViewBuilder> builder = [styleDict valueForKey:style];
    if (!builder) builder = [styleDict objectForKey:[NSNull null]];
    if (!builder) builder = self.defaultBuilder;
    
    return builder;
    
}

- (UITableViewCell *)buildTableViewCellFor:(MBPanel *)panel forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState forTableView:(UITableView *)tableView
{
    id<MBRowViewBuilder> builder = [self builderForType:panel.type withStyle:panel.style];
    
    if (builder) {
        UITableViewCell *cell = [builder buildTableViewCellFor:panel forIndexPath:indexPath viewState:viewState forTableView:tableView];
        // TODO: Maybe pass trough stylehandler
        //[[[MBViewBuilderFactory sharedInstance] styleHandler] applyStyle:panel forView:view viewState: viewState];
        return cell;
    }
    else {
        [NSException raise:@"BuilderNotFound" format:@"No builder found for type %@ and style %@", panel.type, panel.style];
        return nil;
    }
}

- (CGFloat)heightForPanel:(MBPanel *)panel atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
    id<MBRowViewBuilder> builder = [self builderForType:panel.type withStyle:panel.style];
    
    if (builder) {
        return [builder heightForPanel:panel atIndexPath:indexPath forTableView:tableView];
    }
    else {
        [NSException raise:@"BuilderNotFound" format:@"No builder found for type %@ and style %@", panel.type, panel.style];
        return 0.0f;
    }

}

@end