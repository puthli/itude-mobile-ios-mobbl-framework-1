//
//  MBPickerPopoverController.m
//  Core
//
//  Created by Frank van Eenbergen on 12/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPickerPopoverController.h"
#import "MBViewBuilderFactory.h"
#import "MBStyleHandler.h"
#import "MBOrientationManager.h"

#define ROWHEIGHT 44

@implementation MBPickerPopoverController

@synthesize field = _field;
@synthesize popover = _popover; 

#pragma mark -
#pragma mark Initializers

- (id) init {

	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.tableView.delegate = self;
	}
	return self;
}

- (id) initWithField:(MBField *)field {
	
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		_field = field;
		self.tableView.delegate = self;
	}
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	// Change the height of the popover, if we need to show less rows than that fit on the screen
	CGSize size = self.contentSizeForViewInPopover;
	NSInteger height = ROWHEIGHT*[_field.domain.domainValidators count];
	
	if (size.height > height && height>0) {
		size.height = height;
		self.contentSizeForViewInPopover = size;
		self.tableView.scrollEnabled = NO;
	}
}

- (void) viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	
}

- (void) viewDidAppear:(BOOL)animated {
	
	// set the current value of the picker if any
	NSString * currentValue = [_field value];
	
	if (currentValue.length > 0) {
		
		// figure out the index from the value
		MBDomainDefinition * domain = _field.domain;
		
		// look for a matching value attribute
		NSInteger index = 0;
		for (MBDomainValidatorDefinition * e in domain.domainValidators) {
			
			NSString * elementValue = e.value;
			if ([elementValue isEqualToString:currentValue]) {
				// TODO: Fix this. The value seems to match, but the row is not selected.
				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
				[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
				break;
			}
			index++;
		}
	}
	
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark UITableView delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MBDomainDefinition * domain = _field.domain;
	[_field setValue:[(MBDomainValidatorDefinition*)[domain.domainValidators objectAtIndex:indexPath.row] value]];
	if (_popover != nil) [_popover dismissPopoverAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	MBDomainDefinition *domain = _field.domain;
	return [domain.domainValidators count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return ROWHEIGHT;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseId = @"pickerPopoverTableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
	if (cell==nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseId] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	MBDomainDefinition *domain = _field.domain;
	cell.textLabel.text = [[domain.domainValidators objectAtIndex:indexPath.row] title];
	//cell.textLabel.font = [UIFont systemFontOfSize:16]; // Make the font a bit smaller, because the default is ugly
	
	[[[MBViewBuilderFactory sharedInstance] styleHandler] styleLabel:cell.textLabel component:_field];
	
	// Add a checkmark to the currently selected field
	NSString * currentValue = [_field value];
	if (currentValue.length > 0) {
		MBDomainValidatorDefinition *def = [_field.domain.domainValidators objectAtIndex:indexPath.row];
		if ([def.value isEqualToString:currentValue])	cell.accessoryType = UITableViewCellAccessoryCheckmark;
		else											cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [[MBOrientationManager sharedInstance] supportInterfaceOrientation:toInterfaceOrientation];
}

-(BOOL)shouldAutorotate {
    return [[MBOrientationManager sharedInstance] shouldAutorotate];
}

@end
