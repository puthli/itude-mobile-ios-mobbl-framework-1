//
//  MBPicker.h
//  Core
//
//  Created by Daniel Salber on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBField.h"


@interface MBPickerController : UIViewController {

	IBOutlet UIPickerView * _pickerView;
	IBOutlet UIToolbar * _toolbar;
	MBField * _field;
}

@property (nonatomic, retain) UIPickerView * pickerView;
@property (nonatomic, retain) MBField * field;

- (void)presentWithSuperview:(UIView *)superview;
- (void)removeFromSuperviewWithAnimation;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
