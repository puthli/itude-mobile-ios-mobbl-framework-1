//
//  MBDialogController.h
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogDefinition.h"
#import "MBPage.h"
#import "MBNotificationTypes.h"

#define FIRST_MORE_TAB_INDEX 4

@interface MBDialogController : NSObject <UINavigationControllerDelegate> {

	NSString *_name;
	NSString *_iconName;
	NSString *_title;
	NSString *_dialogMode;
	NSString *_dialogGroupName;
	NSString *_position;
	BOOL _usesNavbar;
	CGRect _bounds;
    UINavigationController *_rootController;
    UINavigationController *_navigationController;
	int _activityIndicatorCount;
	BOOL _temporary;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *dialogMode;
@property (nonatomic, retain) NSString *dialogGroupName;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) UINavigationController *rootController;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) BOOL temporary;

- (id) initWithDefinition:(MBDialogDefinition*)definition temporary:(BOOL) isTemporary;
- (id) initWithDefinition:(MBDialogDefinition*)definition page:(MBPage*) page bounds:(CGRect) bounds;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style;
-(void) popPageAnimated:(BOOL) animated;
- (UIView*) view;
- (CGRect) screenBoundsForDisplayMode:(NSString*) displayMode;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;
- (void) willActivate;
- (void) didActivate;

@end
