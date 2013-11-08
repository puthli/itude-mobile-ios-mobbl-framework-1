//
//  MBCheckboxBuilder.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/5/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBFieldViewBuilder.h"

@interface MBCheckboxBuilder : MBFieldViewBuilder

/// @name UILabel
-(UILabel *)buildLabelForField:(MBField *)field withMaxBounds:(CGRect)bounds;
- (void)configureLabel:(UILabel *)label forField:(MBField *)field;

/// @name UISwitch
- (UISwitch *)buildSwitchForField:(MBField *)field withMaxBounds:(CGRect)bounds;
- (void)configureSwitch:(UISwitch *)switchView forField:(MBField *)field ;

// Apple Developer documentation states: The size components of the switch frame (rectangle) are ignored.
- (CGRect)frameForSwitch:(UISwitch *)switchView withMaxBounds:(CGRect)bounds;

@end
