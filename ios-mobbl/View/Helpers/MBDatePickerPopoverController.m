//
//  MBDatePickerPopoverController.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 08/11/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDatePickerPopoverController.h"

#define C_PICKER_HEIGHT 216
#define C_BAR_HEIGHT 44

@implementation MBDatePickerPopoverController

@synthesize popover = _popover;

- (void)dealloc
{
    [_popover release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forcePopoverSize];
}

- (void)removeFromSuperviewWithAnimation {
    if (self.popover){
        [self.popover dismissPopoverAnimated:YES];
    }
}

#pragma mark -
#pragma mark Util

- (void) sizeToFit {
    CGFloat height = C_PICKER_HEIGHT + C_BAR_HEIGHT;
    
    CGRect frame = self.view.frame;
    frame.size.height = height;
    self.view.frame = frame;
    
    self.contentSizeForViewInPopover = CGSizeMake(320, height);
}

// Make sure that the popover resizes
- (void) forcePopoverSize {
    CGSize currentSetSizeForPopover = self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
    self.contentSizeForViewInPopover = fakeMomentarySize;
    self.contentSizeForViewInPopover = currentSetSizeForPopover;
}

@end
