/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBMatrixBuilder.h"
#import "MBPanel.h"
#import "MBMatrixViewController.h"
#import "MBViewBuilder+PanelHelper.h"

@implementation MBMatrixBuilder


-(MBMatrixViewController *) createMatrixViewController:(MBPanel *) panel {
	return [[[MBMatrixViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
}


-(UIView*)buildPanelView:(MBPanel *)panel forParent:(UIView*) parent  withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
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
    
   [parent addSubview:matrixViewController.tableView];
    
	return matrixViewController.tableView;

    
}
@end
