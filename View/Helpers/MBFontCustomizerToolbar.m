//
//  MBFontCustomizerToolbar.m
//  Core
//
//  Created by Frank van Eenbergen on 4/7/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import "MBFontCustomizerToolbar.h"


@implementation MBFontCustomizerToolbar

@synthesize increaseFontSizeButton = _increaseFontSizeButton;
@synthesize decreaseFontSizeButton = _decreaseFontSizeButton;
@synthesize buttonsDelegate = _buttonsDelegate;
@synthesize sender = _sender;

- (void)setup {
    [self setBackgroundColor:[UIColor clearColor]];
    
    int width = 110; //English button width should be 93. Dutch should be 
	CGRect frame = CGRectMake(0, 0, width, 44.01);
    self.frame = frame;
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
	
	// Add a flexible space to the left of the toolbar so all items are aligned to the right
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
    
    UIImage *increaseIcon = [UIImage imageNamed:@"FontUp_Icon.png"];
    UIImage *decreaseIcon = [UIImage imageNamed:@"FontDown_Icon.png"];
    
    _decreaseFontSizeButton = [[UIBarButtonItem alloc] initWithImage:decreaseIcon style:UIBarButtonItemStyleBordered target:self action:@selector(handleDecreaseButtonPressed:)];
    
    _increaseFontSizeButton = [[UIBarButtonItem alloc] initWithImage:increaseIcon style:UIBarButtonItemStyleBordered target:self action:@selector(handleIncreaseButtonPressed:)];
    
    
    
    [toolbarItems addObject:flexibleSpace];
    [toolbarItems addObject:_decreaseFontSizeButton];
    [toolbarItems addObject:_increaseFontSizeButton];
    
    [flexibleSpace release];
    
    [self setItems:toolbarItems animated:NO];
    [toolbarItems release];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void) addBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    [items addObject:barButtonItem];
    
    CGRect frame = self.frame;
    frame.size.width += 70; // 70 px will always be enough for the button to add
    self.frame = frame;
    
    [self setItems:items animated:animated];
}


// To create transparent background, we must override the drawRect and do noting in it.
- (void) drawRect:(CGRect)rect {}

#pragma -
#pragma Button handling methods

- (void)handleIncreaseButtonPressed:(id)sender{
    if ([_buttonsDelegate respondsToSelector:@selector(fontsizeIncreased:)]) {
        [_buttonsDelegate performSelector:@selector(fontsizeIncreased:) withObject:_sender];
    }
    else if ([_buttonsDelegate respondsToSelector:@selector(fontChanged:)]) {
        [_buttonsDelegate performSelector:@selector(fontChanged:) withObject:_sender];
    }
}

- (void)handleDecreaseButtonPressed:(id)sender{
    if ([_buttonsDelegate respondsToSelector:@selector(fontsizeDecreased:)]) {
        [_buttonsDelegate performSelector:@selector(fontsizeDecreased:) withObject:_sender];
    }
    
    else if ([_buttonsDelegate respondsToSelector:@selector(fontChanged:)]) {
        [_buttonsDelegate performSelector:@selector(fontChanged:) withObject:_sender];
    }
}

@end
