//
//  MBMatrixBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBMatrixBuilder.h"
#import "MBPanel.h"
#import "MBMatrixViewController.h"
#import "MBViewBuilder+PanelHelper.h"

@implementation MBMatrixBuilder


-(MBMatrixViewController *) createMatrixViewController:(MBPanel *) panel {
	return [[[MBMatrixViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
}


-(UIView*)buildPanelView:(MBPanel *)panel withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
	MBMatrixViewController *matrixViewController = [self createMatrixViewController:panel];
	
	if(panel.height != 0) {
		CGRect bounds2 =  matrixViewController.tableView.bounds;
		bounds2.size.height = panel.height;
		matrixViewController.tableView.bounds = bounds2;
	}
	
	matrixViewController.matrixPanel = panel;
	[panel registerViewController: matrixViewController];
	//matrixViewController.page = panel.page;
	matrixViewController.title = panel.title;
	
	
	
	// TODO: The bounds of the height are to high in portraitmode on the iPad. Find out why!
	UITableView *tableView = matrixViewController.tableView;
	CGRect currentBounds = tableView.bounds;
    currentBounds.size.width = MAX(bounds.size.width, currentBounds.size.width);
    currentBounds.size.height = MAX(bounds.size.height, currentBounds.size.height);
	
	tableView.bounds = currentBounds;
	
	
	//add accessibilityLabel for ui automation
	matrixViewController.tableView.accessibilityLabel = [self getAccessibilityLabelForPanel:panel];
    
	return matrixViewController.tableView;

    
}
@end
