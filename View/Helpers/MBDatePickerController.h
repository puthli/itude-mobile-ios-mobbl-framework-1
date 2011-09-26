//
//  MBDatePickerController.h
//  Core
//
//  Created by Frank van Eenbergen on 8/4/11.
//  Copyright 2011 Itude Mobile. All rights reserved.
//

#import "MBField.h"



@interface MBDatePickerController : UIViewController {
	IBOutlet UIDatePicker * _datePickerView;
	IBOutlet UIToolbar * _toolbar;
	MBField * _field;
    UIDatePickerMode _datePickerMode;
}

@property (nonatomic, retain) UIDatePicker * datePickerView;
@property (nonatomic, retain) MBField * field;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

- (void)presentWithSuperview:(UIView *)superview;
- (void)removeFromSuperviewWithAnimation;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
