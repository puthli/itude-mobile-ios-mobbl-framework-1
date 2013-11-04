//
//  MBPageStackController.h
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPageStackDefinition.h"
#import "MBPage.h"
#import "MBNotificationTypes.h"

@class MBDialogController;

@interface MBPageStackController : NSObject <UINavigationControllerDelegate> 

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) MBDialogController *dialogController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, assign) CGRect bounds;

- (id) initWithDefinition:(MBPageStackDefinition *)definition withDialogController:(MBDialogController *)parent;
- (id) initWithDefinition:(MBPageStackDefinition *)definition page:(MBPage*) page bounds:(CGRect) bounds;

- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style;
- (void) popPageWithTransitionStyle:(NSString *)transitionStyle animated:(BOOL) animated;


- (UIView*) view;
- (CGRect) screenBoundsForDisplayMode:(NSString*) displayMode;

- (void) showActivityIndicator;
- (void) hideActivityIndicator;

- (void) willActivate;
- (void) didActivate;

- (NSString *)dialogName;

- (void) resetView;

@end
