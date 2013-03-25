//
//  MBDropDownBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/6/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBDropDownBuilder.h"
#import "MBField.h"
#import "MBStyleHandler.h"
#import "MBMacros.h"

@implementation MBDropDownBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    DLog(@"WARNING! MBDropDownBuilder does not implement 'buildFieldView: withMaxBounds:'.");
    return nil;
}

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    cell.textLabel.text = field.label;
    if (field.path != nil) {
        MBDomainDefinition *domain = field.domain;
        for (MBDomainValidatorDefinition *domainValidator in domain.domainValidators) {
            // JIRA: IQ-70. Changed by Frank: The rowValue is NEVER translated. The fieldValue can be
            // translated if fetched in a regular way so in that case they will never match
            if ([domainValidator.value isEqualToString:[field untranslatedValue]]) {
                cell.detailTextLabel.text =
                [domainValidator.title length] ? domainValidator.title : domainValidator.value;
            }
        }
    }
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";

    [self.styleHandler styleLabel:cell.textLabel component:field];
    
    return cell.textLabel;
}

@end
