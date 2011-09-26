//
//  MBFieldDefinition.h
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"
#import "MBConditionalDefinition.h"

@class MBDomainDefinition;

@interface MBFieldDefinition : MBConditionalDefinition {
	NSString *_label;
	NSString *_path;
	NSString *_style;
	NSString *_displayType;
	NSString *_dataType;
	NSString *_text;
	NSString *_outcomeName;
	NSString *_width;
	NSString *_height;
	NSString *_formatMask;
	NSString *_alignment;
	NSString *_valueIfNil;
	NSString *_hidden;
	NSString *_custom1;
	NSString *_custom2;
	NSString *_custom3;
	NSString *_required;
}

@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *displayType;
@property (nonatomic, retain) NSString *dataType;
@property (nonatomic, retain) NSString *required;
@property (nonatomic, retain) NSString *width;
@property (nonatomic, retain) NSString *height;
@property (nonatomic, retain) NSString *formatMask;
@property (nonatomic, retain) NSString *alignment;
@property (nonatomic, retain) NSString *valueIfNil;
@property (nonatomic, retain) NSString *hidden;
@property (nonatomic, retain) NSString *custom1;
@property (nonatomic, retain) NSString *custom2;
@property (nonatomic, retain) NSString *custom3;

@end
