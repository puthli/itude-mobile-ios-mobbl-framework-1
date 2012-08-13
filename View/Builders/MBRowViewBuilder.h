//
//  MBRowViewBuilder 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTypes.h"

@class MBRow;

/**
* Constructs UITableViewCells for MBRows. Implement this interface for custom UITableViewCells.
*/
@protocol MBRowViewBuilder <NSObject>
- (UITableViewCell *)buildRowView:(MBRow *)row forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState cellReferences:(NSMutableDictionary *)cellReferences forTableView:(UITableView *)tableView;
@end