//
//  MBCheckboxBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/5/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBCheckboxBuilder.h"
#import "MBField.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
#import "MBDevice.h"

@implementation MBCheckboxBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {

    // Add both the label and the editfield to a single view; we can only return 1 view: fieldContainer
	UIView *fieldContainer = [[UIView new] autorelease];
    fieldContainer.frame = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    fieldContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Create the label
    UILabel *label = [self buildLabelForField:field withMaxBounds:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    [fieldContainer addSubview:label];
    
    // Create the switch
    UISwitch *switchView = [self buildSwitchForField:field withMaxBounds:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    [fieldContainer addSubview:switchView];
    
	return fieldContainer;
}

-(UILabel *)buildLabelForField:(MBField *)field withMaxBounds:(CGRect)bounds {
    
    CGRect labelBounds = [[self styleHandler] sizeForLabel:field withMaxBounds:bounds];
    UILabel *label = [[[UILabel alloc] initWithFrame:labelBounds] autorelease];
    [self configureLabel:label forField:field];
    return label;
}

-(void)configureLabel:(UILabel *)label forField:(MBField *)field {
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    label.text = field.label;
    [[self styleHandler] styleLabel:label component:field];
}

- (UISwitch *)buildSwitchForField:(MBField *)field withMaxBounds:(CGRect)bounds {
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
    
    switchView.frame = [self frameForSwitch:switchView withMaxBounds:bounds];

    [self configureSwitch:switchView forField:field];
    return switchView;
}

-(void)configureSwitch:(UISwitch *)switchView forField:(MBField *)field {

    // Always check the untranslated value
    if ([@"true" isEqualToString:[field untranslatedValue] ]) {
        switchView.on = YES;
    }
    [switchView addTarget:field action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    switchView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    switchView.isAccessibilityElement = YES;
    switchView.accessibilityLabel = [NSString stringWithFormat:@"switch_%@", field.label];
    [[self styleHandler] styleSwitch:switchView component:field];
}

// Apple Developer documentation states: The size components of the switch frame (rectangle) are ignored.
- (CGRect)frameForSwitch:(UISwitch *)switchView withMaxBounds:(CGRect)bounds {
    CGFloat rightMargin = ([MBDevice iOSVersion] < 7.0f) ? 10 : 20; // The default rightMargin is different on older iOS versions
    CGRect frame = switchView.frame;
    frame.origin.y = (bounds.size.height/2)-(frame.size.height/2);
    frame.origin.x = bounds.size.width-frame.size.width-rightMargin; // 10 px margin
    return frame;
}


@end
