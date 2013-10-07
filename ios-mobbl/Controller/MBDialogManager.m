//
//  MBDialogManager.m
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/25/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDialogManager.h"
#import "MBDialogController.h"
#import "MBMetadataService.h"
#import "MBPage.h"
#import "MBBasicViewController.h"

@interface MBDialogManager () {
    MBOrderedMutableDictionary *_dialogControllers;
    MBOrderedMutableDictionary *_pageStackControllers;

	NSString *_activePageStackName;
	NSString *_activeDialogName;
}

@property (nonatomic, retain) MBOrderedMutableDictionary *pageStackControllers;
@end

@implementation MBDialogManager

@synthesize dialogControllers = _dialogControllers;
@synthesize pageStackControllers = _pageStackControllers;

- (void)dealloc
{
    [_dialogControllers release];
    [_pageStackControllers release];

    [_activePageStackName release];
    [_activeDialogName release];
    [super dealloc];
}

- (id)initWithDelegate:(id<MBDialogManagerDelegate>)delegate {
    self = [super init];
	if (self != nil) {
        self.delegate = delegate;
        
        self.dialogControllers = [[MBOrderedMutableDictionary new] autorelease];
        self.pageStackControllers = [[MBOrderedMutableDictionary new] autorelease];
        
        [self createAllDialogControllers];
    }
    return self;
}


- (void)createAllDialogControllers {
    NSArray *dialogDefinitions = [[MBMetadataService sharedInstance] dialogDefinitions];
    for (MBDialogDefinition *dialogDefinition in dialogDefinitions) {
        MBDialogController *dialogController = [[MBApplicationFactory sharedInstance] createDialogController:dialogDefinition];
        [self.dialogControllers setObject:dialogController forKey:dialogController.name];
        for (MBPageStackController *stack in dialogController.pageStackControllers) {
            [self.pageStackControllers setObject:stack forKey:stack.name];
        }
    }
    
    [self.delegate didLoadDialogControllers:[self.dialogControllers allValues]];
}


-(MBDialogController*) dialogWithName:(NSString*) name {
	return [self.dialogControllers objectForKey: name];
}

- (MBDialogController *)dialogForPageStackName:(NSString *)name {
    
    MBPageStackController *pageStackController = [self pageStackControllerWithName:name];
    return [self dialogWithName:[pageStackController dialogName]];
}

-(MBPageStackController*) pageStackControllerWithName:(NSString*) name {
	return [_pageStackControllers objectForKey: name];
}


#pragma mark -
#pragma mark Managing PageStacks

- (void) popPageOnPageStackWithName:(NSString*) pageStackName {
    MBPageStackController *pageStackController = [self pageStackControllerWithName:pageStackName];
    
    // Determine transitionStyle
    MBBasicViewController *viewController = [pageStackController.navigationController.viewControllers lastObject];
    id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:viewController.page.transitionStyle];
    [pageStackController popPageWithTransitionStyle:viewController.page.transitionStyle animated:[style animated]];
}

// TODO: keepPosition should remember the old position of the pageStack somehow (probably came from dialog/dialoggroup refactoring)
-(void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition {
    MBPageStackController *result = [self pageStackControllerWithName:pageStackName];
    if(result != nil) {
        [self.pageStackControllers removeObjectForKey: pageStackName];
        [self.delegate didEndPageStackWithName:pageStackName];
    }
}

-(void) activatePageStackWithName:(NSString*) pageStackName {
    
    if (![pageStackName isEqualToString:self.activePageStackName]) {
        // Set the activePageStackName
        [_activePageStackName release];
        _activePageStackName = [pageStackName retain];
        
        // Notify the delegate
        MBPageStackController *pageStackController = [self pageStackControllerWithName:pageStackName];
        MBDialogController *dialogController = [self dialogForPageStackName:pageStackName];
        [self.delegate didActivatePageStack:pageStackController inDialog:dialogController];
    }
    
}

-(void)activateDialogWithName:(NSString *)dialogName {
    MBDialogController *dialogController = [self dialogWithName:dialogName];
    MBPageStackController *pageStackController = [dialogController.pageStackControllers objectAtIndex:0];
    [self activatePageStackWithName:pageStackController.name];
}

#pragma mark -
#pragma mark Getters and Setters

- (NSString *)activeDialogName {
    MBDialogController *dialogController = [self dialogForPageStackName:self.activePageStackName];
    return dialogController.name;
}

@end
