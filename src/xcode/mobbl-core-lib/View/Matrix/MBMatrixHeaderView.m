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

#import "MBMatrixCell.h"
#import "MBMatrixHeaderView.h"

// Used to get a stylehandler to style components in the matrix
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h"

#import "MBPage.h"
#import "MBField.h"

#define LABELINSET 5

@implementation MBMatrixHeaderView

-(id) initWithCells:(NSArray *)cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin
{
	
	
	CGFloat horizontalMargin = margin; 
	CGFloat verticalMargin = margin;
		
	// Calculate the height for the frame and the labels
	CGFloat frameHight = margin; // Set it to the margin, cause the y starts drawing on the margin
	CGFloat headerLabelHeight = 0;
	
	// To prevent giving a emtpy title
	if ([title isEqualToString:@""]) {
		title = nil;
	}
	
	
	if (title != nil) {
		frameHight += 26;
		headerLabelHeight = 24;
	}
	
	if ([cells count] > 0) {
		frameHight += 14;//28;
		// Calculate the width for the columns.
		[MBMatrixCell fixCellWidths:cells forViewWidth:columnsTotalWidth-margin*2-(LABELINSET*2)];
	}
	
	// Correct the height. This looks nicer
	if (([cells count] > 0) && title != nil) {
		//frameHight -= 10;
	}
	
	// Do some calculations to create a margin. A margin is used when tableViewStyle is grouped.
	CGRect headerFrame = CGRectMake(horizontalMargin, 0, tableWidth-(2*horizontalMargin), frameHight);
	self.frame = headerFrame;
	
	if (self = [super initWithFrame:headerFrame]) {
	
		int x = horizontalMargin+LABELINSET;
		int y = headerFrame.origin.y+verticalMargin;
		
		// Title
		if (title != nil) {
			UILabel *titleLabel = [[[UILabel alloc ] initWithFrame:CGRectMake(x, y,  headerFrame.size.width-x, headerLabelHeight)] autorelease];
			titleLabel.text = title;

			[[[MBViewBuilderFactory sharedInstance] styleHandler] styleMatrixHeaderTitle:titleLabel];
			
			[self addSubview:titleLabel];
		}

		// Do some calculations to position the columns
		int pipeLabelWidth = 4;
		y += (headerLabelHeight-4);	

		BOOL isFirst = TRUE;
		
		// Small header labels
		for (MBMatrixCell *cell in cells){
			
			// Draw only visible cells
			if (cell.hidden == FALSE) {

				int labelWidth = cell.width-pipeLabelWidth;;
				if (isFirst) {
					labelWidth = cell.width-(pipeLabelWidth/2);
				}

				
				// Name Label
				UILabel *cellLabel = [[[UILabel alloc ] initWithFrame:CGRectMake(x, y,  labelWidth, 20)] autorelease];
				cellLabel.backgroundColor = [UIColor clearColor];
				cellLabel.text = [cell value];
				
				// Apply styling
				[[[MBViewBuilderFactory sharedInstance] styleHandler] styleMatrixHeaderCell:cellLabel component:cell];

				// Align the first label to the left to align with all the data. The rest should be centerd
				if (isFirst) {
					cellLabel.textAlignment = NSTextAlignmentLeft;
					isFirst = FALSE;
				}else {
					cellLabel.textAlignment = NSTextAlignmentCenter;
				}
				
				cellLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
				[self addSubview:cellLabel];
				
				x += cellLabel.frame.size.width;
				
				// For every item except the last, add a pipe
				if (![[cells lastObject] isEqual:cell]) {
					UILabel *pipeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, pipeLabelWidth, 20)] autorelease];

					// Apply styling. The pipe must have the same apperance as the cells
					[[[MBViewBuilderFactory sharedInstance] styleHandler] styleMatrixHeaderCell:pipeLabel component:cell];

					pipeLabel.text = @"|";
					pipeLabel.textAlignment = NSTextAlignmentCenter;
					
					[self addSubview:pipeLabel];
					
					x += pipeLabel.frame.size.width;
					pipeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
				}
			}

		}	
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
	}
	
    return self;
	
}

@end
