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


+ (UIColor *)colorWithColor:(UIColor *)color withAlpha:(CGFloat)alpha {

    // Get the individual color components in RGBA.
    struct ColorComponents colorComponents = [color colorComponents];
    colorComponents.a = alpha;
    
    // Create the new UIColor from the RGBA color components
    CGColorRef colorRef = [self newColorRefFromColorComponents:colorComponents];
	UIColor *newColor = [UIColor colorWithCGColor:colorRef];
	CGColorRelease(colorRef);
	
	return newColor;
	
}

- (BOOL) isEqualToColor:(UIColor *) otherColor{
    return CGColorEqualToColor(self.CGColor, otherColor.CGColor);
}


- (NSString *) hexValue {    
    struct ColorComponents colorComponents = [self colorComponents];
    int red = (int)(colorComponents.r * 255);
    int green = (int)(colorComponents.g * 255);
    int blue = (int)(colorComponents.b * 255);
    return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X", red, green, blue];
}

-(NSString *)rgbaValue {
    struct ColorComponents colorComponents = [self colorComponents];
    int red = (int)(colorComponents.r * 255);
    int green = (int)(colorComponents.g * 255);
    int blue = (int)(colorComponents.b * 255);
    return [NSString stringWithFormat:@"rgba(%i,%i,%i,%f)",red,green,blue,colorComponents.a];
}


#pragma mark -
#pragma mark Helper methods

/**
 * @param struct ColorComponents The color components used to build a new CGColorRef
 * @return A retained CGColorRef object created from the colorComponents
 */
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

/**
 * Creates a struct ColorComponents object of self. self is a UIColor.
 * @return struct ColorComponents
 */
- (struct ColorComponents) colorComponents {
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
			// Grayscale
            components.r = oldComponents[0];
            components.g = oldComponents[0];
            components.b = oldComponents[0];
            components.a = oldComponents[1];
			break;
		}
		case 4:
		{
			// RGBA
            components.r = oldComponents[0];
            components.g = oldComponents[1];
            components.b = oldComponents[2];
            components.a = oldComponents[3];
			break;
		}
        default:
        {
            // When no color found
            components.r = 0;
            components.g = 0;
            components.b = 0;
            components.a = 1;
            DLog(@"Warning! Unrecognized ColorSpace for Color: %@.",color);
        }
	}
    
    return components;
}


@end
