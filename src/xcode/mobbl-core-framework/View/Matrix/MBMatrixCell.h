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

#import "MBField.h"

@interface MBMatrixCell : NSObject {
	NSString *_value;
	NSString *_style;
	int _width;
	int _height;
	NSString *_alignment;
	double _delta;
	BOOL _hidden;
	MBField *_field;
	MBPage *_page;
}

@property (nonatomic, retain)NSString *value;
@property (nonatomic, retain)NSString *style;
@property (nonatomic, retain)MBField *field;
@property (nonatomic, retain)MBPage *page;

@property (nonatomic, assign)int width;
@property (nonatomic, assign)int height;
@property (nonatomic, assign)NSString *alignment;
@property (nonatomic, assign)double delta;
@property (nonatomic, assign)BOOL hidden;

+ (MBMatrixCell *)cellWithValue:(NSString *)value;
+ (MBMatrixCell *)cellForField:(MBField *)field;
+ (void) fixCellWidths:(NSArray *)cells forViewWidth:(int) viewWidth;

- (void) updateValue;

@end
