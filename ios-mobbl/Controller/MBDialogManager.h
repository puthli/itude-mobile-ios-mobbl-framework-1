//
//  MBDialogManager.h
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/25/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBOrderedMutableDictionary.h"

@class MBPage;
@class MBDialogDefinition;
@class MBDialogController;
@class MBPageStackDefinition;
@class MBPageStackController;


@protocol MBDialogManagerDelegate <NSObject>
@required
- (void)didLoadDialogControllers:(NSArray *)dialogControllers;
- (void)didEndPageStackWithName:(NSString*) pageStackName;
- (void)didActivatePageStack:(MBPageStackController*) pageStackController inDialog:(MBDialogController *)dialogController;
@end


@interface MBDialogManager : NSObject
@property (nonatomic, assign) id<MBDialogManagerDelegate>delegate;
@property (nonatomic, retain) MBOrderedMutableDictionary *dialogControllers;
@property (nonatomic, retain) NSString *activePageStackName;
@property (nonatomic, retain) NSString *activeDialogName;

- (id)initWithDelegate:(id<MBDialogManagerDelegate>) delegate;

/**
 * @name Gettings Dialogs and PageStacks
 */
- (MBDialogController *)dialogWithName:(NSString*) name;
- (MBPageStackController *)pageStackControllerWithName:(NSString*) name;


/**
 * @name Managing PageStacks
 */
- (void) addPageToPageStack:(MBPage *) page displayMode:(NSString*) displayMode transitionStyle:(NSString *)transitionStyle selectPageStack:(BOOL) shouldSelectPageStack;
- (void) popPageOnPageStackWithName:(NSString*) pageStackName;
- (void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition;
- (void) activatePageStackWithName:(NSString*) pageStackName;

@end
