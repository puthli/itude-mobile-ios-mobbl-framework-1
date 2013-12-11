/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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
