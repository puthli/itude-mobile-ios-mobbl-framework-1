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

#import "MBPanel.h"

@interface MBMatrixRowView : UIView {
	UILabel *_titleLabel;
	NSMutableArray *_fields;
	NSMutableArray *_fieldLabels;
	NSMutableDictionary *_formatMasks;
}

@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) NSMutableArray *fields;
@property(nonatomic, retain) NSMutableArray *fieldLabels;
@property(nonatomic, retain) NSMutableDictionary *formatMasks;

- (id) initWithCells:(NSArray *) cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin;
- (void) updateWithCells:(NSArray *) cells withTitle:(NSString *)title;
- (void) updateCellWidthsForCellsTotalWidth:(CGFloat)cellsTotalWidth;
+(CGFloat)heightForRowWithTitle:(BOOL)title withCells:(BOOL)cells;
-(void) setBackgroundColor:(UIColor *)color forColumAtIndex:(int)index;
-(void) setTextColor:(UIColor *)color forColumAtIndex:(int)index;
-(void) setAlignment:(NSTextAlignment)textAlignment forColumnAtIndex:(NSInteger)index;

@end
