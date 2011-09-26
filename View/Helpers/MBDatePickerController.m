//
//  MBDatePickerController.m
//  Core
//
//  Created by Frank van Eenbergen on 8/4/11.
//  Copyright 2011 Itude Mobile. All rights reserved.
//

#import "MBDatePickerController.h"
#import "MBDomainDefinition.h"
#import "MBDomainValidatorDefinition.h"
#import "MBViewBuilderFactory.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"

@implementation MBDatePickerController

@synthesize datePickerView = _datePickerView;
@synthesize field = _field;
@synthesize datePickerMode = _datePickerMode;

// XML date format
#define XMLDATEFORMAT @"yyyy-MM-dd'T'HH:mm:ss"


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
    
    MBStyleHandler *styler = [MBViewBuilderFactory sharedInstance].styleHandler;
	[styler styleToolbar:_toolbar];
	
    self.datePickerView.datePickerMode = self.datePickerMode;
    
    // Default date to set is today
    NSDate *dateToSet = [NSDate date];
    
    // Check if the field already has a value to set
	NSString *currentValue = [_field untranslatedValue];
    if (currentValue) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
        
        // XML date format
        [dateFormatter setDateFormat:XMLDATEFORMAT];
        dateToSet = [dateFormatter dateFromString:currentValue];    
    }
    
    [_datePickerView setDate:dateToSet];
    
    // Apply style to the navigationbar
    [[[MBViewBuilderFactory sharedInstance] styleHandler] styleDatePicker:_datePickerView component:_field];
    
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
    
    NSDate *date = _datePickerView.date;
	
    [self removeFromSuperviewWithAnimation];
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    // TODO: Get Locale from settings
    //NSLocale *locale = [[NSLocale alloc] init];
    //[[MBLocalizationService sharedInstance] localeCode];
    //[dateFormatter setLocale:locale];
    
    // XML date format
    [dateFormatter setDateFormat:XMLDATEFORMAT];
    
    NSString *fieldValue = [dateFormatter stringFromDate:date];
	[_field setValue: fieldValue];
}

#pragma mark -
#pragma mark Picker delegate


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
