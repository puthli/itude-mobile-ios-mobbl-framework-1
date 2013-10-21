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

#import "MBBasicPanelBuilder.h"
#import "MBPanel.h"

@implementation MBBasicPanelBuilder


-(UIView*)buildPanelView:(MBPanel *)panel  forParent:(UIView*) parent  withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
    // Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];
	
	CGRect boundsLeftOver = [self buildChildren: [panel children]
										forView: view
							   horizontalLayout: FALSE
										 bounds: bounds
									  viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: bounds boundsLeftOver: boundsLeftOver];
    
    [parent addSubview:view];
    
    return view;

}
@end
