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
#import "MBDefinition.h"
#import "MBConditionalDefinition.h"

@class MBDomainDefinition;

@interface MBFieldDefinition : MBConditionalDefinition {
	NSString *_label;
	NSString *_path;
	NSString *_style;
	NSString *_displayType;
	NSString *_dataType;
    NSString *_required;
	NSString *_text;
    NSString *_hint;
	NSString *_outcomeName;
	NSString *_width;
	NSString *_height;
	NSString *_formatMask;
	NSString *_alignment;
	NSString *_valueIfNil;
	NSString *_hidden;
}

@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *hint;
@property (nonatomic, retain) NSString *displayType;
@property (nonatomic, retain) NSString *dataType;
@property (nonatomic, retain) NSString *required;
@property (nonatomic, retain) NSString *width;
@property (nonatomic, retain) NSString *height;
@property (nonatomic, retain) NSString *formatMask;
@property (nonatomic, retain) NSString *alignment;
@property (nonatomic, retain) NSString *valueIfNil;
@property (nonatomic, retain) NSString *hidden;


@end
