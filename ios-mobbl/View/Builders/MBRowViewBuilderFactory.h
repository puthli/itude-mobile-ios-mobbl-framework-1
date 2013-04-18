//
//  MBRowViewBuilderFactory 
//
//  Created by Pieter Kuijpers on 21-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTypes.h"
#import "MBRowTypes.h"

@protocol MBRowViewBuilder;
@class MBPanel;

/**
* Factory for MBRowViewBuilder instances.
*/
@interface MBRowViewBuilderFactory : NSObject

/// @name Registering MBRowViewBuilder instances
- (void)registerRowViewBuilder:(id<MBRowViewBuilder>)rowViewBuilder forRowType:(NSString*)type forRowStyle:(NSString *)style;
- (void)registerRowViewBuilder:(id<MBRowViewBuilder>)rowViewBuilder forRowType:(NSString*)type;



/// @name Getting a MBRowViewBuilder instance
@property (nonatomic, retain) id<MBRowViewBuilder> defaultBuilder;
- (id<MBRowViewBuilder>)builderForType:(NSString *)type withStyle:(NSString*)style;

/// @name Implementation of MBRowViewBuilder protocol
-(UITableViewCell *)buildTableViewCellFor:(MBPanel *)panel forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState forTableView:(UITableView *)tableView;
- (CGFloat)heightForPanel:(MBPanel *)panel atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView;

@end