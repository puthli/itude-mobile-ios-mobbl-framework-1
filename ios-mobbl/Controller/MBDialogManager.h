//
//  MBDialogManager.h
//  itude-mobile-ios-core
//
//  Created by Frank van Eenbergen on 9/25/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBOrderedMutableDictionary.h"

@class MBDialogController;
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
@property (nonatomic, retain, readonly) NSString *activePageStackName;
@property (nonatomic, retain, readonly) NSString *activeDialogName;

- (id)initWithDelegate:(id<MBDialogManagerDelegate>) delegate;

/**
 * @name Gettings Dialogs and PageStacks
 */
- (MBDialogController *)dialogWithName:(NSString*) name;
- (MBDialogController *)dialogForPageStackName:(NSString *)name;
- (MBPageStackController *)pageStackControllerWithName:(NSString*) name;


/**
 * @name Managing PageStacks
 */
- (void) popPageOnPageStackWithName:(NSString*) pageStackName;
- (void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition;
- (void) activatePageStackWithName:(NSString*) pageStackName;
- (void) activateDialogWithName:(NSString*) dialogName;

@end
