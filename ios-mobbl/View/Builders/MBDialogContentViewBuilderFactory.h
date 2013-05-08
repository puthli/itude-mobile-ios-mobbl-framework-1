//
//  MBDialogContentBuilder.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDialogContentTypes.h"

@protocol MBDialogContentBuilder;
@class MBDialogController;

@interface MBDialogContentViewBuilderFactory : NSObject

/// @name Registering MBDialogContentBuilder instances
- (void)registerDialogContentBuilder:(id<MBDialogContentBuilder>)dialogContentBuilder forType:(NSString *)type;

/// @name Getting a MBDialogContentBuilder instance
- (id<MBDialogContentBuilder>)builderForType:(NSString *)type;

/// @name Creating Dialog content
-(UIViewController*) buildDialogContentViewControllerForDialog:(MBDialogController*) dialog;

@end
