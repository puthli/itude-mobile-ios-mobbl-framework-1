//
//  UIColorUtilities.h
//  IQ
//
//  Created by Frank van Eenbergen on 3/15/11.
//  Copyright 2011 Itude Mobile. All rights reserved.
//



@interface UIColor (ColorUtilities) 

// Create a color from a UIColor with a alpha value
/**
 * Creates a UIColor object with a UIColor and aplha value 
 * @param color = The color that needs to be created with alpha value
 * @param alpha = the alpha value. Must be between 0.0 and 1.0
 * @return Returns a UIColor object with the color from color-parameter and sets the alpha given in the alpha-parameter 
 * @note This method is verry usefull when creating gradients with a transparant color 
 * Calling [UIColor clearColor] returns a black clear color which is visible) when the gradient should be white for example
 */
+ (UIColor *)colorWithColor:(UIColor *)color withAlpha:(CGFloat)alpha;


/**
 * Compares the CGColor of self to the CGColor of the otherColor
 * @param otherColor = the color that needs to be compared
 * @return Returns true if the colors match
 */
- (BOOL) isEqualToColor:(UIColor *) otherColor;

/**
 * Creates a NSString object with a HEX color value.
 * @return Returns a string representation of a HEX color value (e.g. "#FF0000").
 */
- (NSString *) hexValue;

/**
 * Creates a NSString object with a CSS rgba value.
 * @return Returns a string representation of a rgba color value (e.g. "rgba(255,255,0,0.5)").
 */
- (NSString *) rgbaValue;

@end
