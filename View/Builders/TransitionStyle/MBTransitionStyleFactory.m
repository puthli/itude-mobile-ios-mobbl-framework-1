//
//  MBTransitionStyleFactory.m
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 26-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBTransitionStyleFactory.h"
#import "MBTransitionStyle.h"

// Transition Styles
#import "MBDefaultTransitionStyle.h"
#import "MBFadeTransitionStyle.h"

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
    [self registerTransistion:[[MBFadeTransitionStyle new] autorelease] forTransitionStyle:C_TRANSITIONSTYLE_FADE];

    
    return self;
}

- (void)dealloc
{
    [_registry release];
    [_defaultTransition release];
    [super dealloc];
}

- (void)registerTransistion:(id<MBTransitionStyle>)transition forTransitionStyle:(NSString *)transitionStyle {
    [self.registry setObject:transition forKey:transitionStyle];
}


- (id<MBTransitionStyle>)transitionForStyle:(NSString*)transitionStyle {
    id style = [self.registry valueForKey:transitionStyle];
    if (style) return style;
    
    return self.defaultTransition;
}

- (void) applyTransitionStyle:(NSString *)transitionStyle forViewController:(UIViewController *)viewController modal:(BOOL)modal {
    id<MBTransitionStyle> style = [self transitionForStyle:transitionStyle];
    
    if (style) {
        [style applyTransitionStyleToViewController:viewController modal:modal];
    }
    else {
        [NSException raise:@"MBTransitionStyleNotFound" format:@"No transition found for style %@", transitionStyle];
    }
}


@end
