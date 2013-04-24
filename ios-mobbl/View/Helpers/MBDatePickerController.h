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
    IBOutlet UIBarButtonItem *_cancelButton;
    IBOutlet UIBarButtonItem *_doneButton;
	MBField * _field;
    
    UIDatePickerMode _datePickerMode;
    NSDate *_minimumDate;
    NSDate *_maximumDate;
}

@property (nonatomic, retain) UIDatePicker * datePickerView;
@property (nonatomic, retain) MBField * field;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *maximumDate;

- (void)presentWithSuperview:(UIView *)superview;
- (void)removeFromSuperviewWithAnimation;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
