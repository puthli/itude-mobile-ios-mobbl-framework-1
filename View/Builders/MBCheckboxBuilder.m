//
//  MBCheckboxBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/5/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBCheckboxBuilder.h"
#import "MBField.h"

@implementation MBCheckboxBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
    [self configureView:switchView forField:field];
    return switchView;

}

-(void)configureView:(UIView *)view forField:(MBField *)field {
    UISwitch *switchView = (UISwitch*)view;
    
    // Always check the untranslated value
    if ([@"true" isEqualToString:[field untranslatedValue] ]) {
        switchView.on = YES;
    }
    [switchView addTarget:field action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    
    // reformat the frame
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    switchView.isAccessibilityElement = YES;
    switchView.accessibilityLabel = [NSString stringWithFormat:@"switch_%@", field.label];
}

@end
