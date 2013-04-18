//
//  MatrixViewBuilder.h
//  Core
//
//  Created by Frank van Eenbergen on 6/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMatrixHeaderView.h"
#import "MBMatrixRowView.h"
#import "MBPanel.h"

@interface MBMatrixViewBuilder : NSObject {

}

+(MBMatrixViewBuilder *) sharedInstance;

// Header 
- (MBMatrixHeaderView *)createHeaderUsingColumnTitles:(NSArray *)columnTitles withHeaderTitle:(NSString *)rowTitle withColumnsWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat) tableWidth withMargin:(CGFloat)margin;

// Cells/Rows
- (MBMatrixRowView *)createRowForCells:(NSArray *)cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin;
- (CGFloat)calculateHeightForRowWithTitle:(BOOL)withTitle withCells:(BOOL)withCells ;

// Styling of columns
// Sets the color of a given column in a cell. Note: cell must be created trough the MatrixViewBuilder. Otherwise colors may not be set
- (void)setColor:(UIColor *)color forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell;
- (void)setAlignment:(UITextAlignment)textAlignment forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell;

@end
