//
//  MBViewBuilder+PanelHelper.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBViewBuilder+PanelHelper.h"
#import "MBPanel.h"
#import "MBPage.h"

@implementation MBViewBuilder (PanelHelper)
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
