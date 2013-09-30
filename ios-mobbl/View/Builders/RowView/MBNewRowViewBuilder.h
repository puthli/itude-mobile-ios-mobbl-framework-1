//
//  MBNewRowViewBuilder.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/3/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBRowViewBuilder.h"

@interface MBNewRowViewBuilder : MBViewBuilder <MBRowViewBuilder>

- (UITableViewCell *)cellForTableView:(UITableView *)tableView withType:(NSString *)cellType style:(UITableViewCellStyle)cellstyle panel:(MBPanel *)panel;

@end
