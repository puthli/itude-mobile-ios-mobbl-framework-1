//
//  MBDatePickerPopoverController.m
//  itude-mobile-ios-binck-befrank
//
//  Created by Frank van Eenbergen on 3/7/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDatePickerPopoverController.h"

@implementation MBDatePickerPopoverController

@synthesize popover = _popover;

- (void) viewDidLoad {
	[super viewDidLoad];
	
	// Change the height of the popover
	CGSize size = self.contentSizeForViewInPopover;
    
    CGFloat height = 0;
    for (UIView *subview in self.view.subviews) {
        
        if ([subview isKindOfClass:[UIDatePicker class]]) {
            height += subview.frame.size.height;
        }
        else if ([subview isKindOfClass:[UIToolbar class]]){
            height += subview.frame.size.height;
        }
        
    }
    
    if (size.height > height && height>0) {
		size.height = height;
		self.contentSizeForViewInPopover = size;
	}
    
}

- (void)done:(id)sender {
    [super done:sender];
    if (_popover != nil) [_popover dismissPopoverAnimated:YES];
    
}

-(void)cancel:(id)sender {
    [super cancel:sender];
    if (_popover != nil) [_popover dismissPopoverAnimated:YES];
}

@end
