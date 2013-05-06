//
//  MBDialogController.m
//  Core
//
//  Created by Frank van Eenbergen on 10/18/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogController.h"
#import "MBMetadataService.h"
#import "MBActivityIndicator.h"
#import "MBDevice.h"
#import "MBDialogContentTypes.h"

@interface MBDialogController (){
	
	NSString *_name;
	NSString *_iconName;
	NSString *_title;
    NSString *_contentType;
    NSMutableArray *_pageStacks;
    UIViewController *_viewController;
	NSInteger _activityIndicatorCount;
}

@end

@implementation MBDialogController

@synthesize name = _name;
@synthesize iconName = _iconName;
@synthesize title = _title;
@synthesize contentType = _contentType;
@synthesize pageStackControllers = _pageStacks;



- (void) dealloc
{
	[_name release];
	[_iconName release];
	[_title release];
    [_contentType release];
    [_pageStacks release];
    [_viewController release];
	[super dealloc];
}

-(id) initWithDefinition:(MBDialogDefinition*)definition {
	if(self = [super init]) {
		self.name = definition.name;
		self.iconName = definition.iconName;
		self.title = definition.title;
        self.contentType = definition.contentType;
        
		_activityIndicatorCount = 0;
		
        // Load all the pageStacks
        self.pageStackControllers = [NSMutableArray array];
        for (MBPageStackDefinition *stackDef in definition.pageStacks) {
            MBPageStackController *stackController = [[MBPageStackController alloc] initWithDefinition:stackDef withDialogController:self];
            [self.pageStackControllers addObject:stackController];
            [stackController release];
        }
        
        // Create at least one pageStack for backwards compatibility
        if (definition.pageStacks.count == 0) {
            MBPageStackDefinition *stackDefinition = [[MBPageStackDefinition alloc] init];
            stackDefinition.name = self.name;
            stackDefinition.title = self.title;
            MBPageStackController *stackController = [[MBPageStackController alloc] initWithDefinition:stackDefinition withDialogController:self];
            [self.pageStackControllers addObject:stackController];
            [stackController release];
            [stackDefinition release];
        }
        
        // If the user did not set a contentType we set a default one so the DialogContentBuilderFactory knows which ContentBuilder to choose
        if (self.contentType.length == 0 && definition.pageStacks.count == 1) {
            self.contentType = C_DIALOG_CONTENT_TYPE_SINGLE;
        }
        else if (self.contentType.length == 0 && definition.pageStacks.count > 1) {
            self.contentType = C_DIALOG_CONTENT_TYPE_SPLIT;
        }
        
	}
	return self;	
}

- (MBPageStackController *)pageStackControllerWithName:(NSString *)name {
    for (MBPageStackController *pageStackController in self.pageStackControllers) {
        if ([pageStackController.name isEqualToString:name]) {
            return pageStackController;
        }
    }
    return nil;
}

// loadView
- (void) loadView {
    if (!self.rootViewController) {
        self.rootViewController = [[[UIViewController alloc] init] autorelease];
        self.rootViewController.view.backgroundColor = [UIColor greenColor];
        
        // TODO: These should not be on top of each other!
        for (MBPageStackController *pageStackController in self.pageStackControllers) {
            [self.rootViewController.view addSubview:pageStackController.navigationController.view];
        }
    }
}

#pragma mark -
#pragma mark ActivityIndicator managment

- (void)showActivityIndicator {
	
	if(_activityIndicatorCount == 0) {
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		
		// Somehow, the bounds of the applicationFrame on iPad, are not correct. 
		// The y starts at 20, while the frame for the application is 0. The code below corrects this.
		if ([MBDevice isPad]) {
			NSInteger correctiohHeight = bounds.origin.y;
			bounds.origin.y -= correctiohHeight;
			bounds.size.height+= correctiohHeight;
		}
		
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
		[self.rootViewController.view addSubview:blocker];
	}
	_activityIndicatorCount ++;
}

- (void)hideActivityIndicator {
	if(_activityIndicatorCount > 0) {
		_activityIndicatorCount--;
		
		if(_activityIndicatorCount == 0) {
			UIView *top = [self.rootViewController.view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}
}



@end
