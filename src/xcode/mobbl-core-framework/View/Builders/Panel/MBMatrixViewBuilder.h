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
- (void)setAlignment:(NSTextAlignment)textAlignment forColumnAtIndex:(NSInteger)index inCell:(UITableViewCell *)cell;

@end
