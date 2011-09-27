//
//  MBFieldViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMacros.h"
#import "MBFieldViewBuilder.h"
#import "MBField.h"
#import "MBStyleHandler.h"
#import "LocaleUtilities.h"
#import "MBLocalizationService.h"
#import "StringUtilities.h"

@implementation MBFieldViewBuilder

-(CGRect) textRectMultiLine:(NSString*) text atX:(CGFloat) x atY:(CGFloat) y {
	CGSize constSize = { [UIScreen mainScreen].applicationFrame.size.width, 20000.0f };
	CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constSize lineBreakMode:UILineBreakModeWordWrap];
	return CGRectMake(x, y, [UIScreen mainScreen].applicationFrame.size.width, textSize.height+textSize.height/3 );
}	

-(CGRect) textRect:(NSString*) text atX:(CGFloat) x atY:(CGFloat) y {
	CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:17]];
	return CGRectMake(x, y, textSize.width, textSize.height);
}	


-(UIView*) buildTextField:(MBField*) field withMaxBounds:(CGRect) bounds {
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
	
	[fieldContainer addSubview:textField];
	
	// Whatever; this needs some clever stuff (and this is not it ;-):
	fieldContainer.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 30.0);
	
	return [fieldContainer autorelease];
}

-(UIView*) buildLabel:(MBField*) field withMaxBounds:(CGRect) bounds {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 25.0)];
	if(field.path != nil) label.text = [field value];
	else label.text = field.label;
	label.backgroundColor = [UIColor clearColor];
    
	return [label autorelease];
}

-(UIView*) buildButton:(MBField*) field withMaxBounds:(CGRect) bounds {
	
	UIButton *button = [[self styleHandler] createStyledButton:field];
	if (button == nil) button = [UIButton buttonWithType:UIButtonTypeRoundedRect];	
	//UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(0.0, 0.0, 100.0, 29.0);
	
	NSString *text = field.label;
	
	[button setTitle:text forState:UIControlStateNormal];
	[button addTarget:field action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
	[[self styleHandler] styleButton:button component:field];
	return button;
}

-(UIView*) buildFieldView:(MBField*) field withMaxBounds:(CGRect) bounds {
	UIView *view = nil;  
	
	if(     [C_FIELD_INPUT    isEqualToString: field.type]) view = [self buildTextField: field withMaxBounds: bounds];
	else if([C_FIELD_USERNAME isEqualToString: field.type]) view = [self buildTextField: field withMaxBounds: bounds];
	else if([C_FIELD_PASSWORD isEqualToString: field.type]) view = [self buildTextField: field withMaxBounds: bounds];
	else if([C_FIELD_BUTTON   isEqualToString: field.type]) view = [self buildButton: field withMaxBounds: bounds];
	else if([C_FIELD_LABEL    isEqualToString: field.type]) view = [self buildLabel: field withMaxBounds: bounds];
	else if([C_FIELD_SUBLABEL isEqualToString: field.type]) view = [self buildLabel: field withMaxBounds: bounds];
	else {
		WLog(@"Failed to build unsupported view type %@", field.type);
    }
	
	field.responder = view;
	
	return view;
}


@end
