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

#import "MBMatrixRowView.h"
#import "MBField.h"
#import "MBMatrixCell.h"

// Used to get a stylehandler to style components in the matrix
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h"

#define MARGIN_X 10		// default is 10
#define MARGIN_Y 5		// default is 5
#define LABELMARGIN_X 5 // default is 5

#define TITLEHEIGHT 28
#define CELLHEIGHT 22

@implementation MBMatrixRowView

@synthesize titleLabel = _titleLabel;
@synthesize fieldLabels = _fieldLabels;
@synthesize fields = _fields;
@synthesize formatMasks = _formatMasks;

- (void) dealloc
{
	[_titleLabel release];
	[_formatMasks release];
	[_fields release];
	[_fieldLabels release];
	[super dealloc];
}

- (id) initWithCells:(NSArray *) cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)columnsTotalWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin
{
	
	// Set a margin for grouped tables, because cells are always the entire width of the table.
	/*int margin = 0;
	if (table.style == UITableViewStyleGrouped) {
		margin = 10;
	}*/
	
	float cellHeight = 0;
	
	if ([title isEqualToString:@""]) title = nil;
	if (title != nil) cellHeight += TITLEHEIGHT;
	if (cells != nil) {
		cellHeight += CELLHEIGHT;
		[MBMatrixCell fixCellWidths:cells forViewWidth:columnsTotalWidth-margin*2-(LABELMARGIN_X*2)];
	}
	
	CGRect frame = CGRectMake(margin, 0.0, tableWidth-(margin*2), cellHeight);

	if (self = [super initWithFrame:frame]) {

		// Used to position the labels
		float yLabelPosition = self.frame.origin.y+3;

		// Set a clear backgroundcolor so the view does not obscure any other backgroundviews
		UIColor *defaultBackgroundColor = [UIColor clearColor];
		self.backgroundColor = defaultBackgroundColor;
		
		// Title must be nil if empty, because otherwise it will draw a high row/view
		if ([title isEqualToString:@""]) {
			title = nil;
		}
		
		// Create the label for the title 
		if (title != nil) {
			yLabelPosition += 2;
			UILabel *titleLabel = [[[UILabel alloc ] initWithFrame:CGRectMake(self.frame.origin.x+LABELMARGIN_X, yLabelPosition,  columnsTotalWidth- (margin*2)-10, 20)] autorelease];
			titleLabel.text = title;
			
			[[[MBViewBuilderFactory sharedInstance] styleHandler] styleMatrixRowTitle:titleLabel];

			[self addSubview:titleLabel];
			self.titleLabel = titleLabel;
			yLabelPosition = yLabelPosition + titleLabel.frame.size.height + MARGIN_Y - 4;
		}
		
		// Create labels for the Columns 
		if (cells != nil) {

			int columnX = LABELMARGIN_X;
			
			BOOL first = TRUE;
			
			// Create the labels and add them to the array
			self.fieldLabels = [[[NSMutableArray alloc] init] autorelease];
			self.fields = [[[NSMutableArray alloc] init] autorelease];
			
			for (MBMatrixCell *cell in cells) {
				
				// Draw only visible cells
				if (cell.hidden == FALSE) {
					UILabel *columnLabel = [[[UILabel alloc] initWithFrame:CGRectMake(columnX, yLabelPosition, cell.width-1, 15)] autorelease];
					
					columnLabel.text = [cell value];
					
					// Align the first label to the left to align it with other data like titles
					// NOTE: This is done here because here we iterate trough the cells and know which one is the first! 
					// The stylehandler doesn't know anything about a collection of cells. It just knows to style one cell
					if (first) {
						columnLabel.textAlignment = NSTextAlignmentLeft;
						first = FALSE;
					}else {
						// Default alignment
						columnLabel.textAlignment = NSTextAlignmentCenter;
					}
					
					// Apply Styling
					[[[MBViewBuilderFactory sharedInstance] styleHandler] styleMatrixRowCell:columnLabel component:cell];
					columnLabel.backgroundColor = defaultBackgroundColor;
					[self addSubview:columnLabel];
					[self.fieldLabels addObject:columnLabel];
					[self.fields addObject:cell];
					columnX += cell.width;
				}
			}
			
		}		
	}
	return self;
}

- (void) updateWithCells:(NSArray *) cells withTitle:(NSString *)title {
	self.titleLabel.text = title;
	
	if([cells count] == 0) {
	  for(UILabel *label in self.fieldLabels) label.text = @"";
	}
	
	int labelIndex = 0;
	for (int cellIndex=0; cellIndex< [cells count]; cellIndex++) {
		MBMatrixCell *cell = [cells objectAtIndex:cellIndex];
		
		// Only update values for visible cells. Otherwise a indexOutOfBounds will be generated because 
		// the number of cells is not equal to the number of labels. If cells are hidden, no label is created for so the label does not exist
		if (cell.hidden == FALSE) {
			UILabel *label = [self.fieldLabels objectAtIndex:labelIndex];
			label.text = [cell value];
			labelIndex ++;
		}		
	}
}

// This method recalculates cellWidths for a new total Width. 
- (void) updateCellWidthsForCellsTotalWidth:(CGFloat)cellsTotalWidth
{

	// Calculate the total width of the cells
	int currentCellsTotalWidth = 0;
	for (MBMatrixCell *cell in self.fields) {
		currentCellsTotalWidth += cell.width;
	}
	
	// Calculate the difference that has to be substracted from the width of every cell
	int difference = (currentCellsTotalWidth - cellsTotalWidth)/[self.fields count];
	
	
	// Iterate trough all cells and update the frame of the labels for the cells that are visible
	int labelIndex = 0;
	CGFloat labelXposition = 0;
	for (MBMatrixCell *currentCell in self.fields) {
		
		if (currentCell.hidden == FALSE) {
			UILabel *label = [self.fieldLabels objectAtIndex:labelIndex];
			
			CGRect labelFrame = label.frame;
			
			if (labelIndex == 0) {
				labelXposition = labelFrame.origin.x;
			}
			
			labelFrame.origin.x = labelXposition;
			labelFrame.size.width = currentCell.width-difference;
			
			label.frame = labelFrame;
			
			labelXposition += label.frame.size.width;
			labelIndex ++;
		}
	}
}

+(CGFloat)heightForRowWithTitle:(BOOL)title withCells:(BOOL)cells
{
	CGFloat rowHeight = 0;
	if (title) rowHeight += TITLEHEIGHT; 
	if (cells) rowHeight += CELLHEIGHT;
	return rowHeight;
}

-(void) setBackgroundColor:(UIColor *)color forColumAtIndex:(int)index
{
	UILabel *label = [self.fieldLabels objectAtIndex:index];
	label.backgroundColor = color;
}

-(void) setTextColor:(UIColor *)color forColumAtIndex:(int)index
{
	UILabel *label = [self.fieldLabels objectAtIndex:index];
	label.textColor = color;
}

-(void) setAlignment:(NSTextAlignment)textAlignment forColumnAtIndex:(NSInteger)index
{
	UILabel *label = [self.fieldLabels objectAtIndex:index];
	label.textAlignment = textAlignment;
}

@end
