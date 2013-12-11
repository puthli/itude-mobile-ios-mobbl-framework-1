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

#import "MBForEachViewBuilder.h"
#import "MBForEach.h"
#import "MBStyleHandler.h"

@implementation MBForEachViewBuilder

-(UIView*) buildForEachView:(MBForEach*) forEach forParent:(UIView*) parent  withMaxBounds:(CGRect) maxBounds viewState:(MBViewState) viewState {
	// One that we surely want to support here is the UITableView
	// For now do a simple implementation
	
	// Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];  
	[forEach setupKeyboardHiding: view];
	
	CGRect boundsLeftOver = [self buildChildren: forEach.rows
										forView: view
							   horizontalLayout: FALSE
										 bounds: maxBounds
									  viewState: viewState];
	
	boundsLeftOver = [self buildChildren: forEach.children
								 forView: view
						horizontalLayout: FALSE
								  bounds: boundsLeftOver
							   viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: maxBounds boundsLeftOver: boundsLeftOver];
	[[self styleHandler] applyStyle:forEach forView:view viewState: viewState];

	return view;	
}

@end
