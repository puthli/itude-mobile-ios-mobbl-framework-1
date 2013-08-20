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

- (CGRect) sizeForButton:(MBField*) field withMaxBounds:(CGRect) bounds  {
    CGRect frame = CGRectMake(0, 0, 100, 29);
    frame.origin.y = (bounds.size.height/2)-(frame.size.height/2);
    frame.origin.x = bounds.size.width-frame.size.width-10; // 10 px margin
    return frame;
}

-(UIView*)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    
	UIButton *button = [[self styleHandler] createStyledButton:field];
	if (button == nil) button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = [self sizeForButton:field withMaxBounds:bounds];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	NSString *text = field.label;
	
	[button setTitle:text forState:UIControlStateNormal];
	[button addTarget:field action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
	[[self styleHandler] styleButton:button component:field];
	return button;

}

@end
