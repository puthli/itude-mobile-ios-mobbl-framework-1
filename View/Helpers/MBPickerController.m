//
//  MBPicker.m
//  Core
//
//  Created by Daniel Salber on 6/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPickerController.h"
#import "MBDomainDefinition.h"
#import "MBDomainValidatorDefinition.h"
#import "MBViewBuilderFactory.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
//#import "BinckStyleHandler.h"

@implementation MBPickerController

@synthesize pickerView = _pickerView;
@synthesize field = _field;


#pragma mark -
#pragma mark Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[[MBViewBuilderFactory sharedInstance].styleHandler applyStyle:_toolbar field:_field viewState: MBViewStatePlain];
	}
	return self;
}

- (void)viewDidLoad
{
    //removed Binck related styler, TODO: update pickerController for Binck!
    //	BinckStyleHandler * styler = (BinckStyleHandler *)[MBViewBuilderFactory sharedInstance].styleHandler;
    MBStyleHandler *styler = [MBViewBuilderFactory sharedInstance].styleHandler;
	[styler styleToolbar:_toolbar];
	
    _cancelButton.title = MBLocalizedString(_cancelButton.title);
    _doneButton.title = MBLocalizedString(_doneButton.title);
    
    //	// set the current value of the picker if any
    //	NSString * currentValue = [_field value];
    
    // Select the row of the untranslated Value. The title of the UIPickerView is translated. The value is not. JIRA: IQ-71
	NSString *currentValue = [_field untranslatedValue];
	
	if (currentValue.length > 0) {
		
		// figure out the index from the value
		MBDomainDefinition * domain = _field.domain;
		
		// look for a matching value attribute
		NSInteger index = NSNotFound;
		
		NSInteger ct = 0;
		for (MBDomainValidatorDefinition * e in domain.domainValidators) {
            
			NSString * elementValue = e.value;
			if ([elementValue isEqualToString:currentValue]) {
				index = ct;
				break;
			}
			ct++;
		}
		
		if (index >= 0) {
			
			[_pickerView selectRow:index inComponent:0 animated:NO];
			
		}
		
	}
	
	[super viewDidLoad];
}


#pragma mark -
#pragma mark IB actions

- (IBAction)cancel:(id)sender
{
	[self removeFromSuperviewWithAnimation];
}

- (IBAction)done:(id)sender
{
	NSUInteger row = [_pickerView selectedRowInComponent:0];
	
	[self removeFromSuperviewWithAnimation];
	
	MBDomainDefinition * domain = _field.domain;
    NSString *value = [[domain.domainValidators objectAtIndex:row] value];
    
	[_field setValue:value];
}

#pragma mark -
#pragma mark Picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	MBDomainDefinition * domain = _field.domain;
	return [domain.domainValidators count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	MBDomainDefinition * domain = _field.domain;
    
    //return [[domain.domainValidators objectAtIndex:row] title]; // Commented by Frank. 
	return MBLocalizedString([[domain.domainValidators objectAtIndex:row] title]); // Added by Frank. The titles should be translated
}


#pragma mark -
#pragma mark Animation

// add our view to superview, and slide it in from the bottom
- (void)presentWithSuperview:(UIView *)superview {
	
    // set initial location at bottom of superview
    CGRect r = self.view.frame;
    r.origin = CGPointMake(0.0, superview.bounds.size.height);
    self.view.frame = r;
	
	[superview addSubview:self.view];
	
    // animate to new location
    [UIView beginAnimations:@"presentWithSuperview" context:nil];
    r.origin = CGPointZero;
    self.view.frame = r;
    [UIView commitAnimations];
    
}

// called when removeFromSuperviewWithAnimation's animation completes
- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
    }
}

// slide this view to bottom of superview, then remove from superview
- (void)removeFromSuperviewWithAnimation {
	
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
	
    // set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
    // Move this view to bottom of superview
    CGRect r = self.view.frame;
    r.origin = CGPointMake(0.0, self.view.superview.bounds.size.height);
    self.view.frame = r;
	
    [UIView commitAnimations];    
}


@end
