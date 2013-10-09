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

#import "MBLabelBuilder.h"
#import "MBField.h"
#import "MBStyleHandler.h"

@implementation MBLabelBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
 	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 25.0)];

    [self configureView:label forField:field];
	return [label autorelease];
}

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    UIView *view = cell.textLabel;
    [self configureView: view forField: field];
    return view;
}

-(void)configureView:(UIView *)view forField:(MBField *)field {
    UILabel *label = (UILabel*)view;
    label.text = [field formattedValue];
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; //UILineBreakModeWordWrap;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;

    label.autoresizingMask =   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.styleHandler applyStyle:field forView: label viewState:0];
}

@end
