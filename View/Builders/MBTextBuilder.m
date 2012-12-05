//
//  MBTextBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTextBuilder.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
#import "LocaleUtilities.h"
#import "StringUtilities.h"

@implementation MBTextBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    // Add both the label and the editfield to a single view; we can only return 1 view: fieldContainer
    
	UIView *fieldContainer = [[UIView alloc] init];
    //	CGRect lablabelFieldelBounds = [[self styleHandler] sizeForLabel:field withMaxBounds:bounds];
    
    // Duplicate label will be displayed if added here!
    //	UILabel *label = [[[UILabel alloc] initWithFrame:labelBounds] autorelease];
    //	label.text = field.label;
    //	[fieldContainer addSubview:label];
	
    //	[[self styleHandler] styleLabel:label component:field];
    
	CGRect fieldBounds = [[self styleHandler] sizeForTextField:field withMaxBounds:bounds];
	UITextField *textField = [[[UITextField alloc]initWithFrame: fieldBounds] autorelease];

    [self configureView:textField forField:field];
    
    [fieldContainer addSubview:textField];

	// Whatever; this needs some clever stuff (and this is not it ;-):
	fieldContainer.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 30.0);
	
	return [fieldContainer autorelease];

}

-(void)configureView:(UIView *)view forField:(MBField *)field {
    UITextField *textField = (UITextField*)view;
    
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
