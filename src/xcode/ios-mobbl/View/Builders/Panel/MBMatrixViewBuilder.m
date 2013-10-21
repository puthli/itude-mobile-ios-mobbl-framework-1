/*
 * (C) Copyright ItudeMobile.
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

-(void) setAlignment:(NSTextAlignment)textAlignment forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell
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
		NSString *msg = [NSString stringWithFormat:@"The cell has no subview of type %@!",[MBMatrixRowView class]];
		@throw [[[NSException alloc] initWithName:@"NoColumnsFound" reason: msg userInfo:nil] autorelease];
	}
	
	return matrixRowView;
}

@end
