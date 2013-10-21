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

#import "MBButtonBuilder.h"
#import "MBStyleHandler.h"

@implementation MBButtonBuilder

- (CGRect) sizeForButton:(MBField*) field withMaxBounds:(CGRect) bounds  {
    CGFloat width = field.width > 0 ? field.width : 100; // 100 px is the default width
    CGFloat height = field.height > 0 ? field.height : 30; // 30 px is the default height
    CGRect frame = CGRectMake(0, 0, width, height);
    frame.origin.y = (bounds.size.height/2)-(frame.size.height/2);
    frame.origin.x = bounds.size.width-frame.size.width-10; // 10 px margin
    return frame;
}

-(UIView*)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    
	UIButton *button = [[self styleHandler] createStyledButton:field];
	if (button == nil) button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = [self sizeForButton:field withMaxBounds:bounds];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	NSString *text = field.label;
	
	[button setTitle:text forState:UIControlStateNormal];
    [button addTarget:field action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[[self styleHandler] styleButton:button component:field];
	return button;

}

@end
