//
//  MBRowViewBuilder 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTypes.h"

@class MBRow;

@protocol MBRowViewBuilder <NSObject>
- (UIView *)buildRowView:(MBRow *)row withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState;
@end