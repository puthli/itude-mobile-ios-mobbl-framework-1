//
//  UIColorUtilities.m
//  IQ
//
//  Created by Frank van Eenbergen on 3/15/11.
//  Copyright 2011 Itude Mobile. All rights reserved.
//

#import "ColorUtilities.h"
#import "MBMacros.h"

@implementation UIColor (ColorUtilities)


struct ColorComponents {
    CGFloat r,g,b,a;
};


// Create a color from a UIColor with a alpha value
+ (UIColor *)colorWithColor:(UIColor *)color withAlpha:(CGFloat)alpha {

    
    struct ColorComponents colorComponents = [color colorComponentsWithAlpha:alpha];
    CGColorRef colorRef = [self newColorRefFromColorComponents:colorComponents];
    
	UIColor *newColor = [UIColor colorWithCGColor:colorRef];
	
	CGColorRelease(colorRef);
	
	return newColor;
	
}

- (BOOL) isEqualToColor:(UIColor *) otherColor{
    return CGColorEqualToColor(self.CGColor, otherColor.CGColor);
}


- (NSString *) hexValue {    
    struct ColorComponents colorComponents = [self colorComponentsWithAlpha:1.0];
    int red = (int)(colorComponents.r * 255);
    int green = (int)(colorComponents.g * 255);
    int blue = (int)(colorComponents.b * 255);
    
    return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X", red, green, blue];
}

#pragma mark -
#pragma mark Helper methods

+ (CGColorRef) newColorRefFromColorComponents:(struct ColorComponents) colorComponents{
    CGFloat newComponents[4];
    newComponents[0] = colorComponents.r;
    newComponents[1] = colorComponents.g;
    newComponents[2] = colorComponents.b;
    newComponents[3] = colorComponents.a;
    
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef color = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
    return color;
}

- (struct ColorComponents) colorComponentsWithAlpha:(CGFloat)alpha  {
    UIColor *color = self;
    
    // oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([color CGColor]);
	int numComponents = CGColorGetNumberOfComponents([color CGColor]);
    struct ColorComponents components;
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
            components.r = oldComponents[0];
            components.g = oldComponents[0];
            components.b = oldComponents[0];
            components.a = alpha;
			break;
		}
		case 4:
		{
			//RGBA
            components.r = oldComponents[0];
            components.g = oldComponents[1];
            components.b = oldComponents[2];
            components.a = alpha;
			break;
		}
        default:
        {
            //RGBA
            components.r = oldComponents[0];
            components.g = oldComponents[0];
            components.b = oldComponents[0];
            components.a = alpha;
            DLog(@"Warning! Unrecognized ColorSpace for Color: %@.",color);
        }
	}
    
    return components;
}


@end
