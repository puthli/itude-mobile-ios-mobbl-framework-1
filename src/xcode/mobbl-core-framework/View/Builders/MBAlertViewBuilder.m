/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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

#import "MBAlertViewBuilder.h"
#import "MBAlertView.h"
#import "MBAlert.h"
#import "MBField.h"
#import "MBFieldTypes.h"
#import "MBMacros.h"
#import "MBLocalizationService.h"

@implementation MBAlertViewBuilder

/**
 * In iOS we only define the cancel button and other buttons. In Android this is different. They have three different types of buttons. 
 * We define all three to keep the frameworks consitant but use only the NEGATIVE (cancel button)
 */
#define C_FIELD_BUTTON_STYLE_NEGATIVE @"NEGATIVE" // iOS: Cancel Button
#define C_FIELD_BUTTON_STYLE_POSITIVE @"POSITIVE" // iOS: Other Button
#define C_FIELD_BUTTON_STYLE_OTHER    @"OTHER"    // iOS: Other Button

-(MBAlertView *)buildAlertView:(MBAlert *)alert forDelegate:(id<UIAlertViewDelegate>) alertViewDelegate {
    

    NSString *message = nil;
    NSString *cancelButtonTitle = nil;
    NSInteger cancelButtonIndex = 0;
    NSMutableArray *otherButtonTitles = [NSMutableArray new];
    NSMutableArray *buttonFields = [NSMutableArray new];
    
    NSInteger counter = 0;
    NSArray *children = [alert children];
    for (MBField *field in children) {
        
        // The message
        if ([C_FIELD_TEXT isEqualToString:field.type]) {
            if(field.path != nil) {
                message = [field formattedValue];
            }
            else {
                message = field.label;
            }
        }
        
        // Buttons
        else if ([C_FIELD_BUTTON isEqualToString:field.type]) {
            // Cancel Button
            if ([C_FIELD_BUTTON_STYLE_NEGATIVE isEqualToString:field.style]) {
                if (cancelButtonTitle.length == 0) {
                    cancelButtonTitle = field.label;
                    cancelButtonIndex = counter;
                }
                else {
                    WLog(@"WARNING! There are two NEGATIVE (cancel) buttons defined for alert with name %@. Check config definition! Button with title '%@' is set as the cancel button.",alert.title ,cancelButtonTitle);
                    [otherButtonTitles addObject:field.label];
                }
            }
            
            // Other buttons
            else {
                [otherButtonTitles addObject:field.label];
            }
            
            [buttonFields addObject:field];
            
            counter ++;
        }
    }
    
    // Now build the actual AlertView
    NSString *title = MBLocalizedString(alert.title);
    MBAlertView *alertView = [[[MBAlertView alloc] initWithTitle:title message:message delegate:alertViewDelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] autorelease];
    for (NSString *title in otherButtonTitles) {
        [alertView addButtonWithTitle:title];
    }
    
    alertView.cancelButtonIndex = cancelButtonIndex;
    
    // Set the outcomes
    for (MBField *field in buttonFields) {
        [alertView setField:field forButtonWithKey:field.label];
    }

    
    [otherButtonTitles release];
    [buttonFields release];
    
    return alertView;
}


@end
