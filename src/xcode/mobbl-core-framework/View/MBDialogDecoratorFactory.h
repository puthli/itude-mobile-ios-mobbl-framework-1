//
//  MBDialogDecorationBuilderFactory.h
//  itude-mobile-ios-core
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDialogDecoratorTypes.h"


@protocol MBDialogDecorator;
@class MBDialogController;

@interface MBDialogDecoratorFactory : NSObject

/// @name Registering MBDialogDecorationBuilder instances
- (void)registerDialogDecorationBuilder:(id<MBDialogDecorator>)dialogDecorationBuilder forType:(NSString *)type;

/// @name Getting a MBDialogDecorationBuilder instance
@property (nonatomic, retain) id<MBDialogDecorator> defaultDecorator;
- (id<MBDialogDecorator>)builderForType:(NSString *)type;

/// @name Decorating Dialogs
-(void) decorateDialog:(MBDialogController*) dialog;

/// @name Presenting and hiding (modal) Dialogs
-(void)presentDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle;
-(void)dismissDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle;

@end
