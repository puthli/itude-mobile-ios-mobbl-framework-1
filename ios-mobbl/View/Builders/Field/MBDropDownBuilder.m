/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
