//
//  MBDialogContentBuilder.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//


@class MBDialogController;

@protocol MBDialogContentBuilder <NSObject>
- (UIView*) buildDialogContent:(MBDialogController*) dialogController;

@end
