//
//  MBSectionPanelViewBuilder.m
//  itude-mobile-ios-bt-grondwet
//
//  Created by Frank van Eenbergen on 3/15/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBSectionPanelViewBuilder.h"

@implementation MBSectionPanelViewBuilder

-(UIView*)buildPanelView:(MBPanel *)panel forParent:(UIView*) parent  withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
    // Returns nil by default so the default TableView header is used
    return nil;
}

- (CGFloat)heightForPanel:(MBPanel *)panel {
    return 0;
}

@end
