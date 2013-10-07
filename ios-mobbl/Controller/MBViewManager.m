//
//  MBViewManager.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewManager.h"

#import "MBDialogDefinition.h"
#import "MBDialogController.h"
#import "MBPageStackDefinition.h"
#import "MBPageStackController.h"

#import "MBOutcomeDefinition.h"
#import "MBOutcome.h"

#import "MBPage.h"
#import "MBAlert.h"

#import "MBConfigurationDefinition.h"
#import "MBMetadataService.h"
#import "MBResourceService.h"

#import "MBActivityIndicator.h"
#import "MBSpinner.h"

#import "MBLocalizationService.h"
#import "MBBasicViewController.h"
#import "MBTransitionStyle.h"

#import "MBFontCustomizer.h"

#import "MBMacros.h"

// Used to get a stylehandler to style navigationBar
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface MBViewManager() {
	UIWindow *_window;
	UITabBarController *_tabController;
    
	MBDialogManager *_dialogManager;
    
	UIAlertView *_currentAlert; // TODO: I don't see why we need the currentAlert??
	UINavigationController *_modalController; // TODO: Get rid of this modalController thingy
    
    NSMutableDictionary *_activityIndicatorCounts;
	int _activityIndicatorCount;
}

@property (nonatomic, retain) NSMutableDictionary *activityIndicatorCounts;

- (void) clearWindow;
- (void) resetView;
- (void) showAlertView:(MBPage*) page;

@end

@implementation MBViewManager

@synthesize window = _window;
@synthesize tabController = _tabController;
@synthesize dialogManager = _dialogManager;
@synthesize currentAlert = _currentAlert;
@synthesize activityIndicatorCounts = _activityIndicatorCounts;

- (id) init {
	self = [super init];
	if (self != nil) {
        _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen]bounds]];
        self.activityIndicatorCounts = [NSMutableDictionary new];
		self.dialogManager = [[[MBDialogManager alloc] initWithDelegate:self] autorelease];
	}
	return self;
}

- (void) dealloc {
	[_window release];
	[_tabController release];
	[_dialogManager release];
	[_currentAlert release];
	[_modalController release];
    [_activityIndicatorCounts release];
	[super dealloc];
}

-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode {
    [self showPage:page displayMode:displayMode transitionStyle:nil];
}

-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) transitionStyle  {
    
    DLog(@"ViewManager: showPage name=%@ pageStack=%@ mode=%@ type=%i", page.pageName, page.pageStackName, displayMode, page.pageType);

	if(page.pageType == MBPageTypesErrorPage || [@"POPUP" isEqualToString:displayMode]) {
		[self showAlertView: page];
	}
//	else if(_modalController == nil &&
//			([@"MODAL" isEqualToString:displayMode] || 
//			 [@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode] || 
//			 [@"MODALFORMSHEET" isEqualToString:displayMode] ||
//			 [@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode] || 
//			 [@"MODALPAGESHEET" isEqualToString:displayMode] ||
//			 [@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode] ||
//			 [@"MODALFULLSCREEN" isEqualToString:displayMode] ||
//			 [@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode] || 
//			 [@"MODALCURRENTCONTEXT" isEqualToString:displayMode] ||
//			 [@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode])) {
//                
//                BOOL addCloseButton = NO;
//                UIModalPresentationStyle modalPresentationStyle = UIModalPresentationFormSheet;
//                if ([@"MODALFORMSHEET" isEqualToString:displayMode])			[_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
//                else if ([@"MODALPAGESHEET" isEqualToString:displayMode])		[_modalController setModalPresentationStyle:UIModalPresentationPageSheet];
//                else if ([@"MODALFULLSCREEN" isEqualToString:displayMode])		[_modalController setModalPresentationStyle:UIModalPresentationFullScreen];
//                else if ([@"MODALCURRENTCONTEXT" isEqualToString:displayMode])	[_modalController setModalPresentationStyle:UIModalPresentationCurrentContext];
//                else if ([@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode]) addCloseButton = YES;
//                else if ([@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
//                    addCloseButton = YES;
//                    modalPresentationStyle = UIModalPresentationFormSheet;
//                }
//                else if ([@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
//                    addCloseButton = YES;
//                    modalPresentationStyle = UIModalPresentationPageSheet;
//                }
//                else if ([@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode]) {
//                    addCloseButton = YES;
//                    modalPresentationStyle = UIModalPresentationFullScreen;
//                }
//                else if ([@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode]) {
//                    addCloseButton = YES;
//                    modalPresentationStyle = UIModalPresentationCurrentContext;
//                }
//                
//                // TODO: support nested modal pageStacks
//                _modalController = [[UINavigationController alloc] initWithRootViewController:[page viewController]];
//                _modalController.modalPresentationStyle = modalPresentationStyle;
//                [[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:_modalController.navigationBar];
//                
//                if (addCloseButton) {
//                    NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
//                    UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(endModalPageStack)] autorelease];
//                    [_modalController.topViewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
//                }
//                                                
//                // If tabController is nil, there is only one viewController
//                if (_tabController) {
//                    [[[MBApplicationFactory sharedInstance] transitionStyleFactory] applyTransitionStyle:transitionStyle withMovement:MBTransitionMovementPush forViewController:_tabController];
//                    page.transitionStyle = transitionStyle;
//                    [self presentViewController:_modalController fromViewController:_tabController animated:YES];
//                }
//                else {
//                    MBPageStackController *pageStackController = [self.dialogManager pageStackControllerWithName:[self.dialogManager activePageStackName]];
//                    [[[MBApplicationFactory sharedInstance] transitionStyleFactory] applyTransitionStyle:transitionStyle withMovement:MBTransitionMovementPush forViewController:_modalController];
//                    page.transitionStyle = transitionStyle;
//                    [self presentViewController:_modalController fromViewController:pageStackController.navigationController animated:YES];
//                }
//                // tell other view controllers that they have been dimmed (and auto-refresh controllers may need to stop refreshing)
//                NSDictionary * dict = [NSDictionary dictionaryWithObject:_modalController forKey:@"modalViewController"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MODAL_VIEW_CONTROLLER_PRESENTED object:self userInfo:dict];
//            }
//	else if(_modalController != nil) {
//		UIViewController *currentViewController = [page viewController];
//        
//        // Apply transition. Pushing on the navigation stack
//        id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
//        [transition applyTransitionStyleToViewController:_modalController forMovement:MBTransitionMovementPush];
//        page.transitionStyle = transitionStyle;
//		[_modalController pushViewController:currentViewController animated:[transition animated]];
//		
//		// See if the first viewController has a barButtonItem that can close the controller. If so, add it to the new controller
//		UIViewController *rootViewController = [_modalController.viewControllers objectAtIndex:0];		
//		UIBarButtonItem *rootViewCtrlRightBarButtonItem = rootViewController.navigationItem.rightBarButtonItem;
//        UIBarButtonItem *currentViewCtrlBarButtonItem = currentViewController.navigationItem.rightBarButtonItem;
//		NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
//		if ([rootViewCtrlRightBarButtonItem.title isEqualToString:closeButtonTitle] && (!currentViewCtrlBarButtonItem
//            || [currentViewCtrlBarButtonItem isKindOfClass:[MBFontCustomizer class]])) {
//            UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(endModalPageStack)] autorelease];
//            [currentViewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
//		}
//		
//		// Workaround for view delegate method calls in modal views Controller (BINCKAPPS-426 and MOBBL-150)
//		[currentViewController performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:0];
//		[currentViewController performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:0]; 
//	}
    else {
        
        
        // Is the dialogController currently Visble?
        MBDialogController *dialogController = [self.dialogManager dialogForPageStackName:page.pageStackName];
        
        
        

        // The page can get a pageStackName from an outcome but if this is not the case we set the activePageStackName
        if (page.pageStackName.length == 0) {
            page.pageStackName = self.dialogManager.activePageStackName;
        }
        
        
        // Show (or Hide) it if needed
        // TODO: Comparing the activeDialogName does not work for initialOutcomes, because the MBFireInitialOutcomes activates the first pageStack by default
        if (![[self.dialogManager activeDialogName] isEqualToString:dialogController.name]) {
            [[[MBViewBuilderFactory sharedInstance] dialogDecoratorFactory] presentDialog:dialogController withTransitionStyle:transitionStyle];
        }
        
        
        
        // Do we need to make the dialog visible? (modal or tab or nothing)
        if (![page.pageStackName isEqualToString:self.dialogManager.activePageStackName]) {
            [self.dialogManager activatePageStackWithName:page.pageStackName];
        }
        
        // Show page on pageStack
        MBPageStackController *pageStackController = [dialogController pageStackControllerWithName:page.pageStackName];
        [pageStackController showPage:page displayMode:displayMode transitionStyle:transitionStyle];
        
	}
    
}	

// After delegate didloaddialogs
- (void)createTabbarForDialogControllers:(NSArray *)dialogControllers {
    
    
    MBDialogController *firstDialogController = nil;
    // Should create tabbar
    if([dialogControllers count] > 1 && [self shouldCreateTabBarForDialogsControllers:dialogControllers])
	{
        // Build the tabbar
        self.tabController = [[UITabBarController alloc] init];
        self.tabController.delegate = self;
        [self setContentViewController:self.tabController];
        
        // Build the tabs
        int idx = 0;
        NSMutableArray *tabs = [NSMutableArray new];
        for (MBDialogController *dialogController in dialogControllers) {
            if ([dialogController showAsTab]) {
                // Create a tabbarProperties
                UIViewController *viewController = dialogController.rootViewController;
                UIImage *tabImage = [[MBResourceService sharedInstance] imageByID: dialogController.iconName];
                NSString *tabTitle = MBLocalizedString(dialogController.title);
                UITabBarItem *tabBarItem = [[[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:idx] autorelease];
                viewController.tabBarItem = tabBarItem;
                
                [tabs addObject:viewController];
                
                if (idx == 0) {
                    firstDialogController = dialogController;
                }
                
                idx ++;
            }
        }
        
        // Set the tabs to the tabbar
        [self.tabController setViewControllers: tabs animated: YES];
        [[self.tabController moreNavigationController] setHidesBottomBarWhenPushed:FALSE];
        self.tabController.moreNavigationController.delegate = self;
        self.tabController.customizableViewControllers = nil;
        [tabs release];
        
        [[[MBViewBuilderFactory sharedInstance] styleHandler] styleTabBarController:self.tabController];
    }
    
    // Single page mode
    else if([dialogControllers count] > 0) {
        
        // Search for the only dialogController with attribute 'showAs="TAB"'.
        MBDialogController *dialogController = nil;
        for (MBDialogController *currentDialogContoller in dialogControllers) {
            if ([currentDialogContoller showAsTab]) {
                dialogController = currentDialogContoller;
                break;
            }
        }
        
        // Take the first dialogController if no dialogController with attribute 'showAs="TAB"' is found.
        if (!dialogController) {
            dialogController = [dialogControllers objectAtIndex:0];
        }
        
        [self setContentViewController:dialogController.rootViewController];
        firstDialogController = dialogController;
    }
    
    
    // Ensure we select a pageStack
    if (firstDialogController) {
        MBPageStackController *pageStackController = [firstDialogController.pageStackControllers objectAtIndex:0];
        [self.dialogManager activatePageStackWithName:pageStackController.name];
    }
    
    // Make sure we activate ourselve when we have something to show (initially)
    if (!self.window.isKeyWindow) {
        [self makeKeyAndVisible];
    }
}


- (void) endModalPageStack {
	if(_modalController != nil) {
		// Hide any activity indicator for the modal stuff:
		while(_activityIndicatorCount >0) [self hideActivityIndicator];
		
        // If tabController is nil, there is only one viewController
        if (self.tabController) {
            [self dismisViewController:self.tabController animated:TRUE];
        }
        else {
            MBPageStackController *pageStackController = [self.dialogManager pageStackControllerWithName:[self.dialogManager activePageStackName]];
            // TODO: TransitionStyle!!!
            [self dismisViewController:pageStackController.navigationController animated:YES];
        }
        
		[[NSNotificationCenter defaultCenter] postNotificationName:MODAL_VIEW_CONTROLLER_DISMISSED object:self];
		[_modalController release];
		_modalController = nil;
	}
}


#pragma mark -
#pragma mark MBAlert and UIAlertView management

-(void) showAlertView:(MBPage*) page {
	
	if(self.currentAlert == nil) {
//			[self.currentAlert dismissWithClickedButtonIndex:0 animated: FALSE];
		
		NSString *title;
		NSString *message;
        MBDocument *document = page.document;
		
        if([document.name isEqualToString:DOC_SYSTEM_EXCEPTION] &&
           [[document valueForPath:PATH_SYSTEM_EXCEPTION_TYPE] isEqualToString:DOC_SYSTEM_EXCEPTION_TYPE_SERVER]) {
			title = [document valueForPath:PATH_SYSTEM_EXCEPTION_NAME];
			message = [document valueForPath:PATH_SYSTEM_EXCEPTION_DESCRIPTION];
		}
		
        else if([document.name isEqualToString:DOC_SYSTEM_EXCEPTION]) {
			title = MBLocalizedString(@"Application error");
			message = MBLocalizedString(@"Unknown error");
		}
		else {
			title = page.title;
			message = MBLocalizedString([document valueForPath:@"/message[0]/@text"]);
			if(message == nil) message = MBLocalizedString([document valueForPath:@"/message[0]/@text()"]);
		}
		
		_currentAlert = [[UIAlertView alloc]
                         initWithTitle: title
                         message: message
                         delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
		
        // Show a alert on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentAlert show];
        });
	}
}

- (void)showAlert:(MBAlert *)alert {
    // Show a alert on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert.alertView show];
    });
}

#pragma mark -
#pragma mark Presenting and Dismissing ViewControllers

- (void) resetView {
    [_tabController release];
	[_modalController release];
    
    _tabController = nil;
	_modalController = nil;
    
    [self clearWindow];
}


- (void) resetViewPreservingCurrentPageStack {
    // TODO: This will probably fail because Dialogs (ViewControllers) have nested PageStacks (NavigationControllers)
	for (UIViewController *controller in [_tabController viewControllers]){
		if ([controller isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *) controller popToRootViewControllerAnimated:YES];
		}
	}
}


// Remove every view that is not the activityIndicatorView
-(void) clearWindow {
    for(UIView *view in [self.window subviews]) {
		if(![view isKindOfClass:[MBActivityIndicator class]]) [view removeFromSuperview];
	}
}

- (void)setContentViewController:(UIViewController *)viewController {
    [self clearWindow];
    [self.window setRootViewController:viewController];
}

- (void)presentViewController:(UIViewController *)controller fromViewController:(UIViewController *)fromViewController animated:(BOOL)animated {

//- (void)presentViewController:(UIViewController *)controller fromViewController:(UIViewController *)fromViewController withTransitionStyle:(NSString *)transitionStyle {
//    
//    id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
//    [transition applyTransitionStyleToViewController:_modalController forMovement:MBTransitionMovementPush];
//    BOOL animated = [transition animated];
    
    // iOS 6.0 and up
    if ([fromViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [fromViewController presentViewController:controller animated:animated completion:nil];
    }
    // iOS 5.x and lower
    else {
        // Suppress the deprecation warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [fromViewController presentModalViewController:controller animated:animated];
#pragma clang diagnostic pop
    }
    
}

- (void) dismisViewController:(UIViewController *)controller animated:(BOOL)animated {
    // iOS 6.0 and up
    if ([controller respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [controller dismissViewControllerAnimated:animated completion:nil];
    }
    // iOS 5.x and lower
    else {
        
        // Suppress the deprecation warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [controller dismissModalViewControllerAnimated:animated];
#pragma clang diagnostic pop
    }
}


#pragma mark -
#pragma mark Activity Indicator management

- (void)showActivityIndicator {
    [self showActivityIndicatorWithMessage:nil];
}

- (void)showActivityIndicatorWithMessage:(NSString *)message {
	if(_activityIndicatorCount == 0) {
		// determine the maximum bounds of the screen
        UIViewController *topMostVisibleViewController = [self topMostVisibleViewController];
        CGRect bounds = topMostVisibleViewController.view.bounds;
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
        if (message) {
            [blocker showWithMessage:message];
        }
        
        [topMostVisibleViewController.view addSubview:blocker];
	}else{
        
        for (UIView *subview in [[[self.dialogManager pageStackControllerWithName:self.dialogManager.activePageStackName] view] subviews]) {
            if ([subview isKindOfClass:[MBActivityIndicator class]]) {
                MBActivityIndicator *indicatorView = (MBActivityIndicator *)subview;
                [indicatorView setMessage:message];
                break;
            }
        }
    }
	_activityIndicatorCount ++;
}

- (void)hideActivityIndicator {
	if(_activityIndicatorCount > 0) {
		_activityIndicatorCount--;
		
		if(_activityIndicatorCount == 0) {
            UIViewController *topMostVisibleViewController = [self topMostVisibleViewController];
            for (UIView *subview in [[topMostVisibleViewController view] subviews]) {
                if ([subview isKindOfClass:[MBActivityIndicator class]]) {
                    [subview removeFromSuperview];
                }
            }
		}
	}
}


#pragma mark -
#pragma mark Util

-(CGRect) bounds {
    return [self.window bounds];
}


- (MBViewState) currentViewState {
	// Currently fullscreen is not implemented
	if(_modalController != nil) return MBViewStateModal;
	if(_tabController != nil) return MBViewStateTabbed;
	return MBViewStatePlain;
}

- (UIViewController *)topMostVisibleViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    // On iOS 5 and later: search for the topViewController
    if ([topController respondsToSelector:@selector(presentedViewController)]) {
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        return topController;
    }
    
    // Fallback scenario for iOS 4.3 and earlier
    else if (self.window.rootViewController.modalViewController) {
        return self.window.rootViewController.modalViewController;
    }
    
    // If all else fails, return the rootViewcontroller of the Window
    return self.window.rootViewController;
    
}

/**
 * Returns TRUE if two or more DialogControllers have defined 'showAs="TAB"'
 */
- (BOOL)shouldCreateTabBarForDialogsControllers:(NSArray *)dialogControllers {
    NSInteger numberOfShowAsTabs = 0;
    for (MBDialogController *dialogController in dialogControllers) {
        if ([dialogController showAsTab]) {
            numberOfShowAsTabs ++;
            if (numberOfShowAsTabs > 1) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	self.currentAlert = nil;
}


#pragma mark -
#pragma mark UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[MBBasicViewController class]])
    {
        MBBasicViewController* controller = (MBBasicViewController*) viewController;
        [controller.pageStackController didActivate];
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[MBBasicViewController class]])
    {
        MBBasicViewController* controller = (MBBasicViewController*) viewController;
        [controller.pageStackController willActivate];
        
    }
}


#pragma mark -
#pragma mark UITabBarControllerDelegate

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return YES;
}

// Method is called when the tabBar will be edited by the user (when the user presses the edid-button on the more-page).
// It is used to update the style of the "Edit" navigationBar behind the Edit-button
- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
	// Get the navigationBar from the edit-view behind the more-tab and apply style to it.
    UINavigationBar *navBar = [[[tabBarController.view.subviews objectAtIndex:1] subviews] objectAtIndex:0];
	[[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:navBar];
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    // Set active dialog/pageStack name
    for (MBDialogController *dialogController in [self.dialogManager.dialogControllers allValues]) {
        if (viewController == dialogController.rootViewController) {
            if ([viewController isKindOfClass:[MBBasicViewController class]]) {
                MBBasicViewController *basicViewController = (MBBasicViewController*)viewController;
                [self.dialogManager activatePageStackWithName:basicViewController.pageStackController.name];
            }
            else {
                [self.dialogManager activateDialogWithName:dialogController.name];
            }
            break;
        }
    }
}


#pragma mark -
#pragma mark UIWindow delegate methods

- (void) makeKeyAndVisible {
	[self.tabController.moreNavigationController popToRootViewControllerAnimated:NO];
	[self.window makeKeyAndVisible];
}


#pragma mark -
#pragma mark MBDialogManagerDelegate

- (void)didLoadDialogControllers:(NSArray *)dialogControllers {
    [self createTabbarForDialogControllers:dialogControllers];
}

- (void)didEndPageStackWithName:(NSString*) pageStackName {
    // TODO: Remove???
}

- (void)didActivatePageStack:(MBPageStackController *)pageStackController inDialog:(MBDialogController *)dialogController {
    
    // If we have more than one viewController visible
    if (self.tabController) {
        // Only set the selected tab if realy necessary; because it messes up the more navigation controller
        NSInteger idx = _tabController.selectedIndex;
        NSInteger shouldBe = [_tabController.viewControllers indexOfObject: dialogController.rootViewController];
        
        if(idx != shouldBe && shouldBe!=NSNotFound) {
            [self.tabController setSelectedIndex:shouldBe];
        }
    }

}


@end
