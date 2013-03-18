//
//  MBButtonBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBButtonBuilder.h"
#import "MBStyleHandler.h"

@implementation MBButtonBuilder

-(UIView*)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    
	UIButton *button = [[self styleHandler] createStyledButton:field];
	if (button == nil) button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	//UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(0.0, 0.0, 100.0, 44.0);
    
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	NSString *text = field.label;
	
	[button setTitle:text forState:UIControlStateNormal];
	[button addTarget:field action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
	[[self styleHandler] styleButton:button component:field];
	return button;

}

@end
