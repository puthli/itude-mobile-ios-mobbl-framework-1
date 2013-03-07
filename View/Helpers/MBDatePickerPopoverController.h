//
//  MBDatePickerPopoverController.h
//  itude-mobile-ios-binck-befrank
//
//  Created by Frank van Eenbergen on 3/7/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBField.h"
#import "MBDatePickerController.h"

@interface MBDatePickerPopoverController : MBDatePickerController {
	UIPopoverController *_popover;
}

@property (nonatomic, retain) UIPopoverController *popover;

@end
