//
//  MBAlertViewBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertViewBuilder.h"
#import "MBAlert.h"
#import "MBField.h"
#import "MBFieldTypes.h"
#import "MBMacros.h"

@implementation MBAlertViewBuilder

/*
 <Field type="BUTTON" label="OK" outcome="OUTCOME-ok" style="POSITIVE" />
 <Field type="BUTTON" label="Cancel" style="NEGATIVE" />
 <Field type="BUTTON" label="Help" outcome="OUTCOME-help" style="OTHER" />
 */

/**
 * In iOS we only define the cancel button and other buttons. In Android this is different. They have three different types of buttons. 
 * We define all three to keep the frameworks consitant but use only the NEGATIVE (cancel button)
 */
#define C_FIELD_BUTTON_STYLE_NEGATIVE @"NEGATIVE" // iOS: Cancel Button
#define C_FIELD_BUTTON_STYLE_POSITIVE @"POSITIVE" // iOS: Other Button
#define C_FIELD_BUTTON_STYLE_OTHER    @"OTHER"    // iOS: Other Button

-(UIAlertView *)buildAlertView:(MBAlert *)alert {
    
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[alert title] message:nil delegate:nil cancelButtonTitle:@"Test" otherButtonTitles: nil] autorelease];
    
    NSInteger cancelButtonIndex = 0;
    NSArray *children = [alert children];
    for (MBField *field in children) {
        
        // The message
        if ([C_FIELD_TEXT isEqualToString:field.type]) {
            if(field.path != nil) {
                alertView.message = [field formattedValue];
            }
            else {
                alertView.message = field.label;
            }
        }
        
        // Buttons
        else if ([C_FIELD_BUTTON isEqualToString:field.type]) {
            // Cancel Button
            if ([C_FIELD_BUTTON_STYLE_NEGATIVE isEqualToString:field.style]) {
                if (alertView.cancelButtonIndex == -1) {
                    [alertView setCancelButtonIndex:cancelButtonIndex];
                }
                else {
                    WLog(@"WARNING! There are two NEGATIVE (cancel) buttons defined for alert with name %@. Check config definition! Button with index %i is set as the cancel button.",alert.title ,alertView.cancelButtonIndex);
                }
                
            }
            
            // Other buttons
            [alertView addButtonWithTitle:field.label];

            cancelButtonIndex ++;
        }
    }

    return alertView;
}





@end
