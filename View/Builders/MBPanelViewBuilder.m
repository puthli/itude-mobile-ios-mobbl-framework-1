//
//  MBPanelViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPanelViewBuilder.h"
#import "MBTableViewController.h"
#import "MBMatrixViewController.h"
#import "MBComponentFactory.h"
#import "MBPanel.h"
#import "MBStyleHandler.h"
#import "MBTypes.h"
#import "MBPage.h"

// container types
#define C_SECTION @"SECTION"


@implementation MBPanelViewBuilder

-(MBTableViewController *) createTableViewController:(MBPanel *) panel {
	return [[[MBTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

-(MBMatrixViewController *) createMatrixViewController:(MBPanel *) panel {
	return [[[MBMatrixViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

-(UIView*) buildBasicPanel:(MBPanel*) panel 
			 withMaxBounds:(CGRect) maxBounds 
				 viewState:(MBViewState) viewState {

    // Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];  
	
	CGRect boundsLeftOver = [self buildChildren: [panel children]
										forView: view
							   horizontalLayout: FALSE
										 bounds: maxBounds
									  viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: maxBounds boundsLeftOver: boundsLeftOver];
    return view;
}

-(UIView *)buildRowPanelView:(MBPanel *) panel withMaxBounds:(CGRect) maxBounds viewState:(MBViewState) viewState{
    // Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];  
	
	CGRect boundsLeftOver = [self buildChildren: [panel children]
										forView: view
							   horizontalLayout: FALSE
										 bounds: maxBounds
									  viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: maxBounds boundsLeftOver: boundsLeftOver];
	
	return view;
}

-(UIView*) buildListPanel:(MBPanel*) panel withMaxBounds:(CGRect) bounds {
	
	MBTableViewController *tableViewController = [self createTableViewController:panel];
    // Make sure the viewcontroller is retained by the panel:
    [panel registerViewController: tableViewController];
     
	tableViewController.page = panel.page;
	tableViewController.title = panel.title;
	
	// determine sections and pass them to the tableViewController
	NSMutableArray *sections = [panel descendantsOfKind: [MBPanel class] filterUsingSelector: @selector(type) havingValue: C_SECTION];
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
	
	return tableViewController.tableView;
}

-(UIView *)buildMatrixPanel:(MBPanel *) panel withMaxBounds:(CGRect) bounds {

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

-(UIView*) buildPanelView:(MBPanel*) panel withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState{
	
    UIView *view;
    
	if([[panel type] isEqualToString:@"PLAIN"]) {
        view = [self buildBasicPanel: panel withMaxBounds: bounds viewState: viewState];
        
		UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:bounds];
		scrollView.contentSize = view.frame.size;
		
		[scrollView addSubview:view];
		[scrollView autorelease];
		view = scrollView;
		
		//add accessibilityLabel for ui automation
		view.accessibilityLabel = [self getAccessibilityLabelForPanel:panel];
	} 
	else if([[panel type] isEqualToString:@"LIST"]) {
		view = [self buildListPanel: panel withMaxBounds: bounds];
	}
	
	else if([[panel type] isEqualToString:@"MATRIX"]) {
		view = [self buildMatrixPanel: panel withMaxBounds: bounds];
	}
	else {
        // Build a non scrolling basic panel
        
        view = [self buildBasicPanel: panel withMaxBounds: bounds viewState: viewState];
		
        // Only setup auto hiding if there is no scroller; the hiding mechanism currently uses a button
		// that snoops the first touch event; making it harder to scroll (you need to move immediately to start scrolling)
		[panel setupKeyboardHiding: view];
	}	
	
	[[self styleHandler] applyStyle:panel forView:view viewState: viewState];
	return view;		
}

/***Give an accessible label to a tableview for ui autiomation***/
//if panel is the only child of a page, use title of the page;
//otherwise use the name of the panel
-(NSString *) getAccessibilityLabelForPanel:(MBPanel *)panel {
	if ([panel.parent isKindOfClass:[MBPage class]]) {
		NSArray *children = [panel.parent childrenOfKind:[MBPanel class]];
		if ([children count] == 1) {
			return [(MBPage*)[panel parent] title];
		}
		else {
			return panel.name;
		}
	}
	return nil;
}

@end
