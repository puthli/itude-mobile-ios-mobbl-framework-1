//
//  UIColorUtilities.m
//  IQ
//
//  Created by Frank van Eenbergen on 3/15/11.
//  Copyright 2011 Itude Mobile. All rights reserved.
//

#import "ColorUtilities.h"


@implementation UIColor (ColorUtilities) 

// Create a color from a UIColor with a alpha value
+ (UIColor *)colorWithColor:(UIColor *)color withAlpha:(CGFloat)alpha {

	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([color CGColor]);
	int numComponents = CGColorGetNumberOfComponents([color CGColor]);
	CGFloat newComponents[4];
	
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = alpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = alpha;
			break;
		}
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	
	CGColorRelease(newColor);
	
	return retColor;
	
}

- (BOOL) isEqualToColor:(UIColor *) otherColor{
    return CGColorEqualToColor(self.CGColor, otherColor.CGColor);
}


@end
