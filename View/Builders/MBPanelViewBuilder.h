//
//  MBPanelViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBTableViewController.h"
#import "MBTypes.h"

@class MBPanel;
@class MBMatrixViewController;

@interface MBPanelViewBuilder : MBViewBuilder {

}

-(UIView*) buildPanelView:(MBPanel*) panel withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState;
-(MBTableViewController *) createTableViewController:(MBPanel *) panel;
-(MBMatrixViewController *) createMatrixViewController:(MBPanel *) panel;

-(UIView*) buildListPanel:(MBPanel*) panel withMaxBounds:(CGRect) bounds;
-(UIView *)buildMatrixPanel:(MBPanel *) panel withMaxBounds:(CGRect) bounds;

-(NSString *) getAccessibilityLabelForPanel:(MBPanel *)panel;

@end
