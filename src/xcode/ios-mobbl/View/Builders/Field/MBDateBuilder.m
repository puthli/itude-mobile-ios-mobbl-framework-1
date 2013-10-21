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

#import "MBDateBuilder.h"
#import "MBStyleHandler.h"

@implementation MBDateBuilder

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    cell.textLabel.text = field.label;
    cell.detailTextLabel.text = [field formattedValue];
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";

    
    [self.styleHandler styleLabel:cell.textLabel component:field];
    
    return cell.textLabel;

}

@end
