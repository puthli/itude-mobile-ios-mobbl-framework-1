//
//  MBPickerPopoverController.h
//  Core
//
//  Created by Frank van Eenbergen on 12/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBField.h"

@interface MBPickerPopoverController : UITableViewController<UITableViewDelegate> {
	MBField *_field;
	UIPopoverController *_popover;
}

@property (nonatomic, retain) MBField *field;
@property (nonatomic, retain) UIPopoverController *popover;

- (id) initWithField:(MBField *)field;

@end
