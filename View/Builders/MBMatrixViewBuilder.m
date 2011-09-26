//
//  MatrixViewBuilder.m
//  Core
//
//  Created by Frank van Eenbergen on 6/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMatrixViewBuilder.h"

//#import "MBField.h"

#import "MBMatrixHeaderView.h"
#import "MBMatrixRowView.h"

#define CELLREUSEIDENTIFIER @"matrix-cell"

@interface MBMatrixViewBuilder () 

- (MBMatrixRowView *)findMatrixRowViewForCell:(UITableViewCell *)cell;

@end


@implementation MBMatrixViewBuilder

static MBMatrixViewBuilder *_instance = nil;

// Get a instance
+(MBMatrixViewBuilder *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (MBMatrixHeaderView *)createHeaderUsingColumnTitles:(NSArray *)columnTitles withHeaderTitle:(NSString *)rowTitle withColumnsWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat) tableWidth withMargin:(CGFloat)margin
{
	MBMatrixHeaderView *headerView = [[MBMatrixHeaderView alloc] initWithCells:columnTitles withTitle:rowTitle withColumnsTotalWidth:columnsTotalWidth withTableWidth:tableWidth withMargin:margin];
	[headerView autorelease];
	return headerView;
}

- (MBMatrixRowView *)createRowForCells:(NSArray *)cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin
{
	MBMatrixRowView *rowView = [[MBMatrixRowView alloc] initWithCells:cells withTitle:title withColumnsTotalWidth:columnsTotalWidth withTableWidth:tableWidth withMargin:margin];
	[rowView autorelease];
	return rowView;
}

- (CGFloat)calculateHeightForRowWithTitle:(BOOL)withTitle withCells:(BOOL)withCells 
{
	return [MBMatrixRowView heightForRowWithTitle:withTitle withCells:withCells];
}

#pragma mark -
#pragma mark UI-styling for columns

-(void) setColor:(UIColor *)color forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell 
{
	MBMatrixRowView *matrixRowView = [self findMatrixRowViewForCell:cell];
	[matrixRowView setTextColor:color forColumAtIndex:index];
}

-(void) setAlignment:(UITextAlignment)textAlignment forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell
{
	MBMatrixRowView *matrixRowView = [self findMatrixRowViewForCell:cell];
	[matrixRowView setAlignment:textAlignment forColumnAtIndex:index];
}

// Searches and returns the MatrixRowView in the subviews of a cell
- (MBMatrixRowView *)findMatrixRowViewForCell:(UITableViewCell *)cell {

	MBMatrixRowView *matrixRowView = nil;
	
	// Look for the MatrixRowView in the Contentview of the cell
	for (UIView *view in cell.contentView.subviews) {
		if ([view isKindOfClass:[MBMatrixRowView class]]) {
			matrixRowView = (MBMatrixRowView *)view;
			break;
		} 
	}
	
	// Throw error when there is no MatrixRowView found
	if (matrixRowView == nil) {
		NSString *msg = [NSString stringWithFormat:@"The cell has no subview of type @%!",[MBMatrixRowView class]];
		@throw [[NSException alloc] initWithName:@"NoColumnsFound" reason: msg userInfo:nil];
	}
	
	return matrixRowView;
}

@end
