//
//  MBRowViewBuilder 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTypes.h"

@class MBRow;
@protocol MBViewBuilderDelegate;

/**
* Constructs UITableViewCells for MBRows. Implement this interface for custom UITableViewCells.
*/
@protocol MBRowViewBuilder <NSObject>
- (UITableViewCell *)buildRowView:(MBRow *)row forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState
                     forTableView:(UITableView *)tableView delegate:(id <MBViewBuilderDelegate>)delegate;
@end