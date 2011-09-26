//
//  MBMatrixViewController.h
//  Core
//
//  Created by Frank van Eenbergen, Wido on 6/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
