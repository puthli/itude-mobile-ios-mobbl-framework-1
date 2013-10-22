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

#import "MBTransitionStyleFactory.h"
#import "MBTransitionStyle.h"

// Transition Styles
#import "MBDefaultTransitionStyle.h"
#import "MBFadeTransitionStyle.h"
#import "MBFlipTransitionStyle.h"
#import "MBCurlTransitionStyle.h"
#import "MBNoTransitionStyle.h"

@interface MBTransitionStyleFactory ()
@property(readonly,nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBTransitionStyleFactory {
    NSMutableDictionary *_registry;
    id<MBTransitionStyle> _defaultTransition;
}

@synthesize registry = _registry;
@synthesize defaultTransition = _defaultTransition;


- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        _defaultTransition = [[MBDefaultTransitionStyle new] retain];
    }
    
    // Register other generic builders
    [self registerTransition:[[MBFadeTransitionStyle new] autorelease] forTransitionStyle:C_TRANSITIONSTYLE_FADE];
    [self registerTransition:[[MBFlipTransitionStyle new] autorelease] forTransitionStyle:C_TRANSITIONSTYLE_FLIP];
    [self registerTransition:[[MBCurlTransitionStyle new] autorelease] forTransitionStyle:C_TRANSITIONSTYLE_CURL];
    [self registerTransition:[[MBNoTransitionStyle new] autorelease] forTransitionStyle:C_TRANSITIONSTYLE_NONE];
    
    return self;
}

- (void)dealloc
{
    [_registry release];
    [_defaultTransition release];
    [super dealloc];
}

- (void)registerTransition:(id<MBTransitionStyle>)transition forTransitionStyle:(NSString *)transitionStyle {
    [self.registry setObject:transition forKey:transitionStyle];
}


- (id<MBTransitionStyle>)transitionForStyle:(NSString*)transitionStyle {
    id style = [self.registry valueForKey:transitionStyle];
    if (style) return style;
    
    return self.defaultTransition;
}

- (void)applyTransitionStyle:(NSString *)transitionStyle withMovement:(MBTransitionMovement)transitionMovement forViewController:(UIViewController *)viewController {
    id<MBTransitionStyle> style = [self transitionForStyle:transitionStyle];
    
    if (style) {
        [style applyTransitionStyleToViewController:viewController forMovement:transitionMovement];
    }
    else {
        [NSException raise:@"MBTransitionStyleNotFound" format:@"No transition found for style %@", transitionStyle];
    }
}


@end
