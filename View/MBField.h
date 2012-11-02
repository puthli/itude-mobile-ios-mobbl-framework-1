//
//  MBField.h
//  Core
//
//  Created by Wido on 21-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponent.h"
@class MBFieldDefinition;
@class MBDomainDefinition;

/** smallest user interface element definition in MOBBL framework. Typically an input field, label or button */
@interface MBField  : MBComponent <UITextFieldDelegate>{
	
	@private
	UIView *_responder;
	MBAttributeDefinition *_attributeDefinition;
	BOOL _domainDetermined;
	MBDomainDefinition *_domainDefinition;
	NSString *_translatedPath;
	NSString *_label;
	NSString *_type;
	NSString *_dataType;
	NSString *_formatMask;
	NSString *_alignment;
	NSString *_valueIfNil;
	BOOL _hidden;
	BOOL _required;
	int _width;
	int _height;
	NSString *_custom1;
	NSString *_custom2;
	NSString *_custom3;
}

@property (nonatomic, retain) UIView *responder;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *dataType;
@property (nonatomic, retain) NSString *formatMask;
@property (nonatomic, retain) NSString *alignment;
@property (nonatomic, retain) NSString *valueIfNil;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, retain) NSString *custom1;
@property (nonatomic, retain) NSString *custom2;
@property (nonatomic, retain) NSString *custom3;

-(NSString*) value;
-(NSString*) untranslatedValue; // Added by Frank: In some cases we want to use the untranslated value of the field (e.g. for comparing to the value of the domainValidator. JIRA IQ-70)
-(void) setValue: (NSString*) value;
-(NSString*) path;
-(NSString*) label;
-(NSString*) type;
-(NSString*) dataType;
-(NSString*) text;
-(NSString*) outcomeName;
-(BOOL) required;
-(MBDomainDefinition*) domain;
-(MBAttributeDefinition*) attributeDefinition;
-(int) width;
-(int) height;
-(NSString *) formattedValue;

// for UISwitch
-(void) switchToggled:(id)sender;
	

@end
