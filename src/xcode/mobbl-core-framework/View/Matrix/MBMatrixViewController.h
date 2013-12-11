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

#import "MBMatrixViewBuilder.h"
#import "MBPanel.h"
#import "MBMatrixCell.h"

@interface MBMatrixViewController : UITableViewController {
	MBPanel *_matrixPanel;
	UIView * _headerView;
	MBPanel *_headerPanel;
	CGFloat _columnsTotalWidth;
	NSMutableArray *_rows;
	NSMutableDictionary *_cellReferences;
	MBMatrixViewBuilder *_matrixViewBuilder;
}

@property (nonatomic, retain)MBPanel *matrixPanel;
@property (nonatomic, retain)UIView *headerView;
@property (nonatomic, retain)MBPanel *headerPanel;
@property (nonatomic, assign)CGFloat columnsTotalWidth;
@property (nonatomic, retain)NSMutableArray *rows;
@property (nonatomic, retain)MBMatrixViewBuilder *matrixViewBuilder;

- (void) updateMatrixRows;
- (void) refreshMatrixData;
- (void) initializeTableViewCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath;
- (void) styleMatrixCell:(MBMatrixCell*) cell;
- (UIView *) constructHeaderView;

// allows subclasses to attach behaviour to a field.
-(void) fieldWasSelected:(MBField *)field;

// allows subclasses to call or modify the behaviour after selecting a row
- (void) handleSelectionOfRowAtIndexPath:(NSIndexPath *)indexPath;

@end
