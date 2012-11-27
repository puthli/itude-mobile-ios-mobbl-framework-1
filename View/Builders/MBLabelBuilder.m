//
//  MBLabelBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBLabelBuilder.h"
#import "MBField.h"

@implementation MBLabelBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
 	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 25.0)];
	if(field.path != nil) label.text = [field value];
	else label.text = field.label;
	label.backgroundColor = [UIColor clearColor];
    
	return [label autorelease];
}

@end
