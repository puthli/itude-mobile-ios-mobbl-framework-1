//
//  MBTableViewCellConfiguratorDropDownList 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTableViewCellConfiguratorDropDownList.h"


@implementation MBTableViewCellConfiguratorDropDownList

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
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
    [self addAccessoryDisclosureIndicatorToCell:cell];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}


@end