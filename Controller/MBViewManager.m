//
//  MBViewManager.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMacros.h"
#import "MBViewManager.h"
#import "MBDialogDefinition.h"
#import "MBDialogGroupDefinition.h"
#import "MBDialogController.h"
#import "MBDialogGroupController.h"
#import "MBOutcomeDefinition.h"
#import "MBOutcome.h"
#import "MBMetadataService.h"
#import "MBPage.h"
#import "MBResourceService.h"
#import "MBActivityIndicator.h"
#import "MBConfigurationDefinition.h"
#import "MBNavigationController.h"
#import "MBSpinner.h"
#import "MBLocalizationService.h"

// Used to get a stylehandler to style navigationBar
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface MBViewManager()
-(MBDialogController*) dialogWithName:(NSString*) name;
- (void) clearWindow;
- (void) updateDisplay;
- (void) resetView;
- (void) showAlertView:(MBPage*) page;
- (void) addPageToDialog:(MBPage *) page displayMode:(NSString*) displayMode selectDialog:(BOOL) shouldSelectDialog;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;
@end

@implementation MBViewManager

@synthesize tabController = _tabController;
@synthesize activeDialogName = _activeDialogName;
@synthesize activeDialogGroupName = _activeDialogGroupName;
@synthesize currentAlert = _currentAlert;
@synthesize singlePageMode = _singlePageMode;

- (id) init {
	self = [super init];
	if (self != nil) {
		_activityIndicatorCounts = [NSMutableDictionary new];
        _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen]bounds]];
		_sortedNewDialogNames = [NSMutableArray new];
		self.singlePageMode = FALSE;
        [self resetView];
	}
	return self;
}

- (void) dealloc {
	[_dialogControllers release];
	[_dialogGroupControllers release];
	[_window release];
	[_tabController release];
	[_sortedNewDialogNames release];
	[_activityIndicatorCounts release];
	[_activeDialogName release];
	[_activeDialogGroupName release];
	[_currentAlert release];
	[_modalController release];
	[super dealloc];
}

-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode {
    [self showPage:page displayMode:displayMode transitioningStyle:nil selectDialog:TRUE];
}

- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitioningStyle:(NSString *) transitioningStyle {
    [self showPage:page displayMode:displayMode transitioningStyle:transitioningStyle selectDialog:TRUE];
}

-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode selectDialog:(BOOL) shouldSelectDialog {
    [self showPage:page displayMode:displayMode transitioningStyle:nil selectDialog:shouldSelectDialog];
}


-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitioningStyle:(NSString *) transitioningStyle selectDialog:(BOOL) shouldSelectDialog {
    
    
    DLog(@"ViewManager: showPage name=%@ dialog=%@ mode=%@ type=%i", page.pageName, page.dialogName, displayMode, page.pageType);
    
	if(page.pageType == MBPageTypesErrorPage || [@"POPUP" isEqualToString:displayMode]) {
		[self showAlertView: page];
	}
	else if(_modalController == nil && 
			([@"MODAL" isEqualToString:displayMode] || 
			 [@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode] || 
			 [@"MODALFORMSHEET" isEqualToString:displayMode] ||
			 [@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode] || 
			 [@"MODALPAGESHEET" isEqualToString:displayMode] ||
			 [@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode] ||
			 [@"MODALFULLSCREEN" isEqualToString:displayMode] ||
			 [@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode] || 
			 [@"MODALCURRENTCONTEXT" isEqualToString:displayMode] ||
			 [@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode])) {
                // TODO: support nested modal dialogs
                _modalController = [[MBNavigationController alloc] initWithRootViewController:[page viewController]];
                [[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:_modalController.navigationBar];
                
                BOOL addCloseButton = NO;
                if ([@"MODALFORMSHEET" isEqualToString:displayMode])			[_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
                else if ([@"MODALPAGESHEET" isEqualToString:displayMode])		[_modalController setModalPresentationStyle:UIModalPresentationPageSheet];
                else if ([@"MODALFULLSCREEN" isEqualToString:displayMode])		[_modalController setModalPresentationStyle:UIModalPresentationFullScreen];
                else if ([@"MODALCURRENTCONTEXT" isEqualToString:displayMode])	[_modalController setModalPresentationStyle:UIModalPresentationCurrentContext];
                else if ([@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode]) addCloseButton = YES;
                else if ([@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
                    addCloseButton = YES;
                    [_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
                }
                else if ([@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
                    addCloseButton = YES;
                    [_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
                }
                else if ([@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode]) {
                    addCloseButton = YES;
                    //[_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
                    [_modalController setModalPresentationStyle:UIModalPresentationFullScreen];
                }
                else if ([@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode]) {
                    addCloseButton = YES;
                    [_modalController setModalPresentationStyle:UIModalPresentationFormSheet];
                }
                
                if (addCloseButton) {
                    NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
                    UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(endModalDialog)] autorelease];
                    [_modalController.topViewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
                }
                
                // Apply transitioning style (UIModalTransitionStyleCoverVertical = default)
                if ([@"FLIP" isEqualToString:transitioningStyle]) {
                    _modalController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                }
                else if ([@"CURL" isEqualToString:transitioningStyle]) {
                    _modalController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                }
                else if ([@"CROSSDISSOLVE" isEqualToString:transitioningStyle]) {
                    _modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                }
                                
                // If tabController is nil, there is only one viewController
                if (_tabController) {
                    [_tabController presentModalViewController:_modalController animated:TRUE];
                }
                else if (_singlePageMode){
                    MBDialogController *dc = [[_dialogControllers allValues] objectAtIndex:0];
                    [dc.rootController presentModalViewController:_modalController animated:TRUE];
                }
                // tell other view controllers that they have been dimmed (and auto-refresh controllers may need to stop refreshing)
                NSDictionary * dict = [NSDictionary dictionaryWithObject:_modalController forKey:@"modalViewController"];
                [[NSNotificationCenter defaultCenter] postNotificationName:MODAL_VIEW_CONTROLLER_PRESENTED object:self userInfo:dict];
            }
	else if(_modalController != nil) {
		UIViewController *currentViewController = [page viewController];
		[_modalController pushViewController:currentViewController animated:TRUE];
		
		// See if the first viewController has a barButtonItem that can close the controller. If so, add it to the new controller
		UIViewController *rootViewController = [_modalController.viewControllers objectAtIndex:0];		
		UIBarButtonItem *rightBarButtonItem = rootViewController.navigationItem.rightBarButtonItem;
		NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
		if (rightBarButtonItem != nil && [rightBarButtonItem.title isEqualToString:closeButtonTitle] && 
			currentViewController.navigationItem.rightBarButtonItem == nil) {
            UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(endModalDialog)] autorelease];
            [currentViewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
		}
		
		// Workaround for view delegate method calls in modal views Controller (BINCKAPPS-426 and MOBBL-150)
		[currentViewController performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:0];
		[currentViewController performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:0]; 
	}
    else {
		[self addPageToDialog:page displayMode:displayMode selectDialog:shouldSelectDialog];
	}
}	

-(void) addPageToDialog:(MBPage *) page displayMode:(NSString*) displayMode selectDialog:(BOOL) shouldSelectDialog {
    MBDialogController *dialog = [self dialogWithName: page.dialogName];
    if(dialog == nil || dialog.temporary) {
		MBDialogDefinition *dialogDefinition = [[MBMetadataService sharedInstance] definitionForDialogName:page.dialogName];
		dialog = [[MBDialogController alloc] initWithDefinition: dialogDefinition page: page bounds: [self bounds]];
		dialog.iconName = dialogDefinition.icon;
		dialog.dialogGroupName = dialogDefinition.groupName;
		dialog.position = dialogDefinition.position;
		
		[_dialogControllers setValue: dialog forKey: page.dialogName];
		[dialog release];
		[self updateDisplay];
	}
	else [dialog showPage: page displayMode: displayMode];
	
	if(shouldSelectDialog ) [self activateDialogWithName:page.dialogName];
}

-(void) showAlertView:(MBPage*) page {
	
	
	if(self.currentAlert == nil) {
		//			[self.currentAlert dismissWithClickedButtonIndex:0 animated: FALSE];
		
		NSString *title;
		NSString *message;
		if([page.document.name isEqualToString:DOC_SYSTEM_EXCEPTION]) {
			title = [page.document valueForPath:PATH_SYSTEM_EXCEPTION_NAME];
			message = [page.document valueForPath:PATH_SYSTEM_EXCEPTION_DESCRIPTION];
		}
		else {
			title = page.title;
			message = MBLocalizedString([page.document valueForPath:@"/message[0]/@text"]);
			if(message == nil) message = MBLocalizedString([page.document valueForPath:@"/message[0]/@text()"]);
		}
		
		self.currentAlert = [[UIAlertView alloc]
							 initWithTitle: title
							 message: message
							 delegate:self
							 cancelButtonTitle:@"OK"
							 otherButtonTitles:nil];
		
		[self.currentAlert show];
		[self.currentAlert autorelease];
	}
}	

- (void) makeKeyAndVisible {
	[_tabController.moreNavigationController popToRootViewControllerAnimated:NO];
	[_window makeKeyAndVisible];
	
	// ensure first dialogGroup is selected.
	if (_dialogGroupControllersOrdered.count >0) {
		_activeDialogGroupName = (NSString*)[_dialogGroupControllersOrdered objectAtIndex:0];
	}
}

- (void) endModalDialog {
	if(_modalController != nil) {
		// Hide any activity indicator for the modal stuff:
		while(_activityIndicatorCount >0) [self hideActivityIndicator];
		[_tabController dismissModalViewControllerAnimated:TRUE];
		[[NSNotificationCenter defaultCenter] postNotificationName:MODAL_VIEW_CONTROLLER_DISMISSED object:self];
		[_modalController release];	
		_modalController = nil;
	}
}

- (void) popPage:(NSString*) dialogName {
    MBDialogController *result = [_dialogControllers objectForKey: dialogName];
	[result popPageAnimated:FALSE];	
}

-(void) endDialog:(NSString*) dialogName keepPosition:(BOOL) keepPosition {
    MBDialogController *result = [_dialogControllers objectForKey: dialogName];
    if(result != nil) {
        [_dialogControllersOrdered removeObject:result];
        [_dialogControllers removeObjectForKey: dialogName];
        [self updateDisplay];
    }
	if(!keepPosition) [_sortedNewDialogNames removeObject:dialogName];
}

-(void) activateDialogWithName:(NSString*) dialogName {
	
	self.activeDialogName = dialogName;
    MBDialogController *dialog = [self dialogWithName:dialogName];
	
	// Property is nil if the current ActiveDialog is not nested inside a DialogGroup.
	self.activeDialogGroupName = dialog.dialogGroupName;
	
	
	// Only set the selected tab if realy necessary; because it messes up the more navigation controller
	int idx = _tabController.selectedIndex;
	int shouldBe = [_tabController.viewControllers indexOfObject:dialog.rootController];
	
	// Apparently we need to select the tab. Only now we cannot do this for tabs that are on the more tab
	// because it destroys the navigation controller for some reason
	// TODO: Make selecting a dialog work; even if it is nested within the more tab
    
	if(idx != shouldBe && shouldBe < FIRST_MORE_TAB_INDEX) {
		UIViewController *ctrl = [_tabController selectedViewController];
		[ctrl viewWillDisappear:FALSE];
		[_tabController setSelectedViewController: dialog.rootController];
		[ctrl viewDidDisappear:FALSE];
	}
}

- (void) resetView {
    
    [_tabController release];
    [_dialogControllers release];
    [_dialogControllersOrdered release];
	[_dialogGroupControllers release];
	[_dialogGroupControllersOrdered release];
	[_modalController release];
    
    _tabController = nil;
	_modalController = nil;
    _dialogControllers = [NSMutableDictionary new];
    _dialogControllersOrdered = [NSMutableArray new];
	_dialogGroupControllers = [NSMutableDictionary new];
	_dialogGroupControllersOrdered = [NSMutableArray new];
    [self clearWindow];
}

- (void) resetViewPreservingCurrentDialog {
	for (UIViewController *controller in [_tabController viewControllers]){
		if ([controller isKindOfClass:[MBNavigationController class]]) {
			[(MBNavigationController *) controller popToRootViewControllerAnimated:YES];
		}
	}
	
}

-(MBDialogController*) dialogWithName:(NSString*) name {
    
	MBDialogController *result = [_dialogControllers objectForKey: name];
	return result;
}

-(MBDialogGroupController*) dialogGroupWithName:(NSString*) name {
	
	MBDialogGroupController *result = [_dialogGroupControllers objectForKey: name];
	return result;
}

- (void) sortTabs {
	NSMutableArray *orderedTabNames = [NSMutableArray new];
	
	// First add the names of the dialogs that are NOT new; the order is already OK
	for(MBDialogController *dc in _dialogControllersOrdered) {
		if([_sortedNewDialogNames indexOfObject:dc.name] == NSNotFound) [orderedTabNames addObject:dc.name];
	}
	// Now add the names of new dialogs that are not yet in the resulting array:
	for(NSString *name in _sortedNewDialogNames) {
		if([orderedTabNames indexOfObject:name] == NSNotFound) [orderedTabNames addObject:name];
	}
	// Now rebuild the _dialogControllersOrdered array; using the order of the orderedTabNames
	
	[_dialogControllersOrdered removeAllObjects];
	for(NSString *name in orderedTabNames) {
		MBDialogController *dlgCtrl = [_dialogControllers valueForKey:name];
		// dlgCtrl might be nil! This is because the application controller may have started processing
		// and already has notified us; but the processing (in the background) has not yet completed.
		// Inthis case; the name of the dialog is already known but it is not yet created
		if(dlgCtrl != nil) [_dialogControllersOrdered addObject: dlgCtrl];
	}
	[orderedTabNames release];
}	

// Remove every view that is not the activityIndicatorView
-(void) clearWindow {
    for(UIView *view in [_window subviews]) {
		if(![view isKindOfClass:[MBActivityIndicator class]]) [view removeFromSuperview];
	}
}

-(void) setContentView:(UIView*) view {
	[self clearWindow];
	[_window insertSubview:view atIndex:0];
}

-(void) updateDisplay {
    if(_singlePageMode && [_dialogControllers count] == 1) {
		[self setContentView: [[[_dialogControllers allValues] objectAtIndex:0] view]];
    } 
    else if([_dialogControllers count] > 1 || !_singlePageMode) 
	{
		if(_tabController == nil) {
			
			///////////////// CREATE THE TAB CONTROLLER
			///////////////////////////////////////////
			
			_tabController = [[UITabBarController alloc] init];
			_tabController.delegate = self;
			
			// Apply style to the tabbarController
			[[[MBViewBuilderFactory sharedInstance] styleHandler] styleTabBarController:_tabController];
			
			[self clearWindow];
			[_window insertSubview:_tabController.view atIndex:0];
		}		
		[self sortTabs];
		
        NSMutableArray *tabs = [NSMutableArray new];
        int idx = 0;
        for(MBDialogController *dc in _dialogControllersOrdered) {
			
			UIImage *tabImage = nil;
			NSString *tabTitle = nil;
			UITabBarItem *tabBarItem = nil;
			
			// If dialogs are nested in DialogGroups, create a MBDialogGroup
			NSString *dialogGroupName = dc.dialogGroupName;
			if (dialogGroupName) {
				
				MBDialogGroupController *dialogGroupController = nil;
				if (![_dialogGroupControllersOrdered containsObject:dialogGroupName]) {
					MBDialogGroupDefinition *dialogGroupDefinition = [[MBMetadataService sharedInstance] definitionForDialogGroupName:dialogGroupName];		
					dialogGroupController = [[[MBDialogGroupController alloc] initWithDefinition:dialogGroupDefinition] autorelease];
					[_dialogGroupControllersOrdered addObject:dialogGroupName];
					[_dialogGroupControllers setValue:dialogGroupController forKey:dialogGroupName];
				} else {
					dialogGroupController = [_dialogGroupControllers valueForKey:dialogGroupName];
				}
				
				if ([dc.position isEqualToString:@"LEFT"])			[dialogGroupController setLeftDialogController:dc];
				else if ([dc.position isEqualToString:@"RIGHT"])	[dialogGroupController setRightDialogController:dc];
				
				if (![tabs containsObject:dialogGroupController.splitViewController]) {
					// Set some tabbarProperties
					tabImage = [[MBResourceService sharedInstance] imageByID: dialogGroupController.iconName];
					tabTitle = MBLocalizedString(dialogGroupController.title);
					tabBarItem = [[[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:idx] autorelease];
					
					dialogGroupController.splitViewController.hidesBottomBarWhenPushed = TRUE;
					dialogGroupController.splitViewController.tabBarItem = tabBarItem;
					[dialogGroupController.splitViewController setHidesBottomBarWhenPushed:FALSE];
					
					[tabs addObject:dialogGroupController.splitViewController];
					
					idx++;
				}
			}
            
			// For regular DialogControllers
			else {
				
				// Set some tabbarProperties
				tabImage = [[MBResourceService sharedInstance] imageByID: dc.iconName];
				tabTitle = MBLocalizedString(dc.title);
				tabBarItem = [[[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:idx] autorelease];
				
				[tabs addObject:dc.rootController];
				
				dc.rootController.hidesBottomBarWhenPushed = TRUE;
				dc.rootController.tabBarItem = tabBarItem;
				[dc.rootController setHidesBottomBarWhenPushed: FALSE];
                
				// TODO: FIX THIS FOR THE IPAD. This is only valid for the iPhone (with current implementation)!!!
				if(idx++ >= FIRST_MORE_TAB_INDEX) {
					// The following is required to make sure TableViewControllers act nice
					// Not sure why this works for ALL controllers since it looks like the
					// moreNavigationController can only have 1 delegate and this is within a loop
					// It is confirmed that it works though.
					// TODO: understand why this works!
					_tabController.moreNavigationController.delegate = dc;
					
					// Apply style to the navigationBar behind "More" button
					[[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:_tabController.moreNavigationController.navigationBar];
				}
			}
        }
		
		// For each dialog in the DialogGroups, we need to trigger the loading of the views and stuff. 
		// The MBSplitViewController will take care of that by triggering the loadDialogs method.
		for (MBDialogGroupController *dialogGroupController in [_dialogGroupControllers allValues]) {
			[dialogGroupController loadDialogs];
		}
		
        [_tabController setViewControllers: tabs animated: YES];
		[[_tabController moreNavigationController] setHidesBottomBarWhenPushed:FALSE];
        [tabs release];
    }
}

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //	if ([[tabBarController viewControllers] objectAtIndex:[tabBarController selectedIndex]] == viewController)
    //		return NO;
	return YES;
}

- (CGRect) screenBoundsForDialog:(NSString*) dialogName displayMode:(NSString*) displayMode {
	return [[self dialogWithName:dialogName] screenBoundsForDisplayMode: displayMode];	
}

- (void)showActivityIndicatorForDialog:(NSString*) dialogName {
	if(_modalController != nil) [self showActivityIndicator];
	else {
		MBDialogController *dialog = [self dialogWithName:dialogName];
		// If the dialog is nested inside a dialogGroup, the spinner should be displayed over the entire group
		if (dialog.dialogGroupName) {
			MBDialogGroupController *dialogGroupController = [self dialogGroupWithName:dialog.dialogGroupName];
			[dialogGroupController showActivityIndicator];
		}
		else {
			[dialog showActivityIndicator];
		}
	}
}

- (void)hideActivityIndicatorForDialog:(NSString*) dialogName {
	if(_modalController != nil) [self hideActivityIndicator];
	else {
		MBDialogController *dialog = [self dialogWithName:dialogName];
		// If the dialog is nested inside a dialogGroup, the spinner should be hidden from the group
		if (dialog.dialogGroupName) {
			MBDialogGroupController *dialogGroupController = [self dialogGroupWithName:dialog.dialogGroupName];
			[dialogGroupController hideActivityIndicator];
		}
		else {
			[dialog hideActivityIndicator];
		}
	}
}

- (void)showActivityIndicator {
	if(_activityIndicatorCount == 0) {
		// determine the maximum bounds of the screen
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
        
		/*
         CGRect activityInset = CGRectInset(bounds, (bounds.size.width - 24) / 2, (bounds.size.height - 24) / 2);
         UIActivityIndicatorView *aiv = [[[UIActivityIndicatorView alloc] initWithFrame:activityInset] autorelease];
         [aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
         [aiv startAnimating];
         
         [blocker addSubview:aiv];
		 */
		[_window addSubview:blocker];
	}
	_activityIndicatorCount ++;
    
	//[[MBSpinner sharedInstance] showActivityIndicator:_window];
}

- (void)hideActivityIndicator {
	if(_activityIndicatorCount > 0) {
		_activityIndicatorCount--;
		
		if(_activityIndicatorCount == 0) {
			UIView *top = [_window.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}
    
	//[[MBSpinner sharedInstance] hideActivityIndicator:_window];
}

-(CGRect) bounds {
    return [_window bounds];
}

- (void) notifyDialogUsage:(NSString*) dialogName {
	if(dialogName != nil) {
		if(![_sortedNewDialogNames containsObject:dialogName])
			[_sortedNewDialogNames addObject:dialogName];
        
		// Create a temporary dialog controller
		MBDialogController *dialog = [self dialogWithName: dialogName];
		if(dialog == nil) {
			MBDialogDefinition *dialogDefinition = [[MBMetadataService sharedInstance] definitionForDialogName: dialogName];
			dialog = [[MBDialogController alloc] initWithDefinition: dialogDefinition temporary: TRUE];
			dialog.iconName = dialogDefinition.icon;
			dialog.dialogMode = dialogDefinition.mode;
			dialog.dialogGroupName = dialogDefinition.groupName;
			dialog.position = dialogDefinition.position;
			
			[_dialogControllers setValue: dialog forKey: dialogName];
			[dialog release];
			[self updateDisplay];
		}
	}
}

// Method is called when the tabBar will be edited by the user (when the user presses the edid-button on the more-page). 
// It is used to update the style of the "Edit" navigationBar behind the Edit-button
- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {	
	// Get the navigationBar from the edit-view behind the more-tab and apply style to it. 
    UINavigationBar *navBar = [[[tabBarController.view.subviews objectAtIndex:1] subviews] objectAtIndex:0];
	[[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:navBar];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	self.currentAlert = nil;
}

- (MBViewState) currentViewState {
	// Currently fullscreen is not implemented
	if(_modalController != nil) return MBViewStateModal;
	if(_tabController != nil) return MBViewStateTabbed;
	return MBViewStatePlain;
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	
	// Set the actievDialogName
	for (MBDialogController *dialogController in [_dialogControllers allValues]) {
		if (dialogController.rootController == viewController) {
			_activeDialogName = dialogController.name;
			break;
		}
	}
	
	// Set the activeDialogGroupName
	for (MBDialogGroupController * groupController in [_dialogGroupControllers allValues]){
		if (groupController.splitViewController == viewController){
			if ([_activeDialogGroupName isEqualToString:groupController.name]) {
				id masterNavController = groupController.splitViewController.masterViewController;
				if ([masterNavController respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
					[((UINavigationController *) masterNavController ) popToRootViewControllerAnimated:YES];
				}
				id detailNavController = groupController.splitViewController.detailViewController;
				if ([detailNavController respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
					[((UINavigationController *) detailNavController ) popToRootViewControllerAnimated:YES];
				}
			}
			else{
				_activeDialogGroupName = groupController.name;
			}
		}
	}
}

@end
