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
    
    NSMutableDictionary *_pageStackControllers;
	NSMutableArray *_pageStackControllersOrdered;
	NSMutableArray *_sortedNewPageStackNames;
	NSString *_activePageStackName;
	NSString *_activeDialogName;
}

@end

@implementation MBDialogManager

- (void)dealloc
{
    [_dialogControllers release];
    [_pageStackControllers release];
    [_pageStackControllersOrdered release];
    [_activePageStackName release];
    [_activeDialogName release];
    [super dealloc];
}

- (id) init {
	self = [super init];
	if (self != nil) {
        self.dialogControllers = [[MBOrderedMutableDictionary new] autorelease];
        _sortedNewPageStackNames = [NSMutableArray new];
	}
	return self;
}

- (MBDialogController *)createDialogController:(MBDialogDefinition *)definition {
    MBDialogController *dialogController = [self dialogWithName:definition.name];
    
    if (dialogController == nil) {
        dialogController = [[MBApplicationFactory sharedInstance] createDialogController:definition];
        [self.dialogControllers setValue:dialogController forKey:dialogController.name];
        for (MBPageStackController *stack in dialogController.pageStackControllers) {
            [_pageStackControllers setObject:stack forKey:stack.name];
            [_pageStackControllersOrdered addObject:stack.name];
        }
    }
    return dialogController;
}


- (NSArray *)visibleDialogControllers {
    NSMutableArray *visibleDialogControllers = [NSMutableArray array];
    for (MBDialogController *dialogController in [self.dialogControllers allValues]) {
        MBDialogDefinition *dialogDefinition = [[MBMetadataService sharedInstance] definitionForDialogName:dialogController.name];
        if ([dialogController showAsTab] && [dialogDefinition isPreConditionValid]) {
            [visibleDialogControllers addObject:dialogController];
        }
        
    }
    return visibleDialogControllers;
}

-(MBDialogController*) dialogWithName:(NSString*) name {
	return [self.dialogControllers objectForKey: name];
}

-(MBPageStackController*) pageStackControllerWithName:(NSString*) name {
	return [_pageStackControllers objectForKey: name];
}


#pragma mark -
#pragma mark Managing PageStacks

-(void) addPageToPageStack:(MBPage *) page displayMode:(NSString*) displayMode transitionStyle:transitionStyle selectPageStack:(BOOL) shouldSelectPageStack {
    
    
    MBDialogDefinition *dialogDef = [[MBMetadataService sharedInstance] dialogDefinitionForPageStackName:page.pageStackName];
    MBDialogController *dialogController = [self dialogWithName:dialogDef.name];
    
    if (dialogController == nil) {
        dialogController = [self createDialogController:dialogDef];
        [self.delegate didCreateDialogController:dialogController];
    }
    
    MBPageStackController *pageStackController = [dialogController pageStackControllerWithName:page.pageStackName];
    [pageStackController showPage:page displayMode:displayMode transitionStyle:transitionStyle];
    
	
	if(shouldSelectPageStack ) {
        [self activatePageStackWithName:page.pageStackName];
    }
}

- (void) popPageOnPageStackWithName:(NSString*) pageStackName {
    MBPageStackController *pageStackController = [self pageStackControllerWithName:pageStackName];
    
    // Determine transitionStyle
    MBBasicViewController *viewController = [pageStackController.navigationController.viewControllers lastObject];
    id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:viewController.page.transitionStyle];
    [pageStackController popPageWithTransitionStyle:viewController.page.transitionStyle animated:[style animated]];
}


-(void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition {
    MBPageStackController *result = [self pageStackControllerWithName:pageStackName];
    if(result != nil) {
        [_pageStackControllersOrdered removeObject:result];
        [_pageStackControllers removeObjectForKey: pageStackName];
        [self.delegate didEndPageStackWithName:pageStackName];
    }
	if(!keepPosition) [_sortedNewPageStackNames removeObject:pageStackName];
}

- (void) notifyPageStackUsage:(NSString*) pageStackName {
	if(pageStackName != nil) {
		if(![_sortedNewPageStackNames containsObject:pageStackName]) {
			[_sortedNewPageStackNames addObject:pageStackName];
        }
	}
}

-(void) activatePageStackWithName:(NSString*) pageStackName {
    self.activePageStackName = pageStackName;
    
    MBPageStackController *pageStackController = [self pageStackControllerWithName:pageStackName];
    MBDialogController *dialogController = [self dialogWithName:[pageStackController dialogName]];
    
	self.activeDialogName = [dialogController name];
    [self.delegate didActivatePageStack:pageStackController inDialog:dialogController];
}

#pragma mark -
#pragma mark Resetting Dialogs and PageStacks

- (void)resetDialogs {
    self.dialogControllers = [[MBOrderedMutableDictionary new] autorelease];
}

- (void)resetPageStacks {
    // TODO: Use the getters and setter here (make properties
    [_pageStackControllers release];
    [_pageStackControllersOrdered release];
    
    _pageStackControllers = [NSMutableDictionary new];
    _pageStackControllersOrdered = [NSMutableArray new];
}

@end
