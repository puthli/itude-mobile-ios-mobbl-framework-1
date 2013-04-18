//
//  MBListBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBListBuilder.h"
#import "MBPanel.h"
#import "MBTableViewController.h"
#import "MBPanelTypes.h"
#import "MBViewBuilder+PanelHelper.h"

@implementation MBListBuilder


-(MBTableViewController *) createTableViewController:(MBPanel *) panel {
	return [[[MBTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

-(UIView*)buildPanelView:(MBPanel *)panel forParent:(UIView*) parent  withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
	MBTableViewController *tableViewController = [self createTableViewController:panel];
    // Make sure the viewcontroller is retained by the panel:
    [panel registerViewController: tableViewController];
    
	tableViewController.page = panel.page;
	tableViewController.title = panel.title;
    tableViewController.zoomable = panel.zoomable;
	
	// determine sections and pass them to the tableViewController
	NSMutableArray *sections = [panel descendantsOfKind: [MBPanel class] filterUsingSelector: @selector(type) havingValue: C_PANEL_SECTION];
	if ([sections count]==0) {
		// special case, UITableView needs at least one section, so use the Panel as the section
		[sections addObject:panel];
	}
	tableViewController.sections = sections;
	
	// Use the height from the xml
	if(panel.height != 0) {
		CGRect bounds =  tableViewController.tableView.bounds;
		bounds.size.height = panel.height;
		tableViewController.tableView.bounds = bounds;
	}
	
	// TODO: The bounds of the height are to high in portraitmode on the iPad. Find out why!
	UITableView *tableView = tableViewController.tableView;
	CGRect currentBounds = tableView.bounds;
    currentBounds.size.width = MAX(bounds.size.width, currentBounds.size.width);
    currentBounds.size.height = MAX(bounds.size.height, currentBounds.size.height);
	
	tableView.bounds = currentBounds;
	
	//add accessibilityLabel for ui automation
	NSString *label = [self getAccessibilityLabelForPanel:panel];
	[tableView setIsAccessibilityElement: YES];
	[tableView setAccessibilityLabel: label];
    
    [parent addSubview:tableView];
	
	return tableView;

}

@end
