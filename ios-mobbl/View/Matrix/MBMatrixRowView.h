//
//  MatrixRowView.h
//  Core
//
//  Created by Frank van Eenbergen on 6/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
