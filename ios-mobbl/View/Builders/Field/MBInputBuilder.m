//
//  MBTextBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBInputBuilder.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
#import "LocaleUtilities.h"
#import "StringUtilities.h"

@implementation MBInputBuilder

-(UILabel *)buildLabelForField:(MBField *)field withMaxBounds:(CGRect)bounds {
    
    CGRect labelBounds = [[self styleHandler] sizeForLabel:field withMaxBounds:bounds];
    UILabel *label = [[[UILabel alloc] initWithFrame:labelBounds] autorelease];
    [self configureLabel:label forField:field];
    return label;
}

-(UITextField *)buildTextFieldForField:(MBField *)field withMaxBounds:(CGRect)bounds {
    
    CGRect fieldBounds = [[self styleHandler] sizeForTextField:field withMaxBounds:bounds];
	UITextField *textField = [[[UITextField alloc]initWithFrame: fieldBounds] autorelease];
    
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    textField.placeholder = field.hint;
    [self configureTextField:textField forField:field];
    return textField;
}

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    
    // Add both the label and the editfield to a single view; we can only return 1 view: fieldContainer
	UIView *fieldContainer = [[UIView new] autorelease];
    fieldContainer.frame = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    fieldContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Create the label
    UILabel *label = [self buildLabelForField:field withMaxBounds:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    [fieldContainer addSubview:label];
    
    // Create the textField
	UITextField *textField = [self buildTextFieldForField:field withMaxBounds:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    [fieldContainer addSubview:textField];

	return fieldContainer;

}

-(void)configureLabel:(UILabel *)label forField:(MBField *)field {
    label.text = field.label;

    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; //UILineBreakModeWordWrap;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    label.autoresizingMask =   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self styleHandler] styleLabel:label component:field];
}


-(void)configureTextField:(UITextField *)textField forField:(MBField *)field {

	if ([C_FIELD_PASSWORD isEqualToString:field.type]) {
		textField.secureTextEntry = YES;
	}else if ([C_FIELD_USERNAME isEqualToString:field.type]) {
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
    
	textField.text = [field value];
	textField.delegate = field;
	textField.enabled = TRUE;
	//modified by Xiaochen: added UIControlEventEditingChanged
	//since in QuestionnairePageController of iPsy, we do not listen to the value change events of textfields
	//instead, we save the value when UIKeyboardWillHideNotification occurs. But this happens before UIControlEventEditingDidEnd where the text in textFields is saved
	//so we need the save the value once the editing changed, which happens before keyboard will hide
	[textField addTarget:field action:@selector(textFieldDoneEditing:) forControlEvents: UIControlEventEditingChanged | UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
	
	// There is no nice numericKeyboard with a dot/comma for doubles and floats.
	// A possible solution is to create one, but this can easly break when Apple decides to update the keyboard.
	// So for now we show the numbers and punctuation-keyboard as default. A way to check the characters is set in MBField
	if ([field.dataType isEqualToString:@"int"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([field.dataType isEqualToString:@"email"]) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    else if ([field.dataType isEqualToString:@"zipcode"]) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
	else if([field.dataType isEqualToString:@"double"] ||
			[field.dataType isEqualToString:@"float"]) {
		
		textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		
		// Depending on the localeCode-settings in the applicationProperties, we want to display a comma or a dot as decimal seperator for floats and doubles
		if ([[[MBLocalizationService sharedInstance] localeCode] isEqualToString:LOCALECODEDUTCH]) {
			// TODO: Make sure that the number we get, is english formatting!
			NSString *textFieldText = [textField.text formatNumberWithOriginalNumberOfDecimals];
			textField.text = textFieldText;
			
		}
	}
	
	[[self styleHandler] styleTextfield: textField component:field];
}

@end
