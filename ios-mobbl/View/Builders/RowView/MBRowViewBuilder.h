//
//  MBRowViewBuilder 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTypes.h"

@class MBPanel;

/**
* Constructs UITableViewCells for MBRows. Implement this interface for custom UITableViewCells.
*/
@protocol MBRowViewBuilder <NSObject>
- (UITableViewCell *)buildTableViewCellFor:(MBPanel *)component forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState forTableView:(UITableView *)tableView;
- (CGFloat)heightForPanel:(MBPanel *)panel atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView;
@end