//
//  MBWebView.m
//  itude-mobile-ios-bt-grondwet
//
//  Created by Frank van Eenbergen on 3/18/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBWebView.h"
#import "MBViewBuilderFactory.h"
#import "ColorUtilities.h"

@interface MBWebView () {
    NSString *_text;
    CGFloat fontSize;
    NSString *fontName;
}
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, retain) NSString *fontName;
@end

@implementation MBWebView

@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize fontSize = _fontSize;
@synthesize fontName = _fontName;

- (void)dealloc
{
    [_text release];
    [_textColor release];
    [_fontName release];
    [super dealloc];
}

#define C_WEBVIEW_DEFAULT_FONTSIZE 14
#define C_WEBVIEW_DEFAULT_FONTNAME @"arial"
#define C_WEBVIEW_CSS @"body {font-size:%i; font-family:%@; margin:6px; margin-bottom: 12px; padding:0px; color:%@; background-color:%@;} img {padding-bottom:12px; margin-left:auto; margin-right:auto; display:block; }"


-(void)setText:(NSString *)text withFont:(UIFont *)font
{
    [self setText:text withFontSize:[font pointSize] fontName:[font fontName]];
}


- (void)setText:(NSString *)text withFontSize:(CGFloat)newFontSize fontName:(NSString *)newFontName {
    
    self.text = text;
    self.fontName = newFontName;
    self.fontSize = newFontSize;
    
    [self refreshFont];
    // If needed, resize view in webViewDidFinishLoad of delegate
}


#pragma mark -
#pragma mark Reload and Refresh methods

- (void)refreshFont {
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>%@</style></head><body id='page'>%@</body></html>",[self buildCSS], self.text];
    [self loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}


#pragma mark -
#pragma mark Getters and Setters

- (void)setFont:(UIFont *)font {
    if (font) {
        self.fontSize = font.pointSize;
        self.fontName = font.fontName;
    }
}

-(UIFont *)font {
    if (self.fontName.length > 0 && self.fontSize > 0) {
        return [UIFont fontWithName:self.fontName size:self.fontSize];
    }
    return nil;
}

- (UIColor *)textColor {
    // Fallback Scenario. We MUST have a textColor in case the user has set none
    if (!_textColor) {
        _textColor = [[UIColor blackColor] retain];
    }
    return _textColor;
}

#pragma mark -
#pragma mark Helpers

- (NSString *)buildCSS {
    NSString *textColor = [self.textColor hexValue];
    // TODO: If the backgroundColor is clearColor, this translates to black.
    NSString *backgroundColor = [self.backgroundColor hexValue];
    return [NSString stringWithFormat:C_WEBVIEW_CSS, (int) self.fontSize, self.fontName, textColor, backgroundColor];
}

@end
