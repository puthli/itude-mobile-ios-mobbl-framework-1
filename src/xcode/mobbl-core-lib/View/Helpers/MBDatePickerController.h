/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
