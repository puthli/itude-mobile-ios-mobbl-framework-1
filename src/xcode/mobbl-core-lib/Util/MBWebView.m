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
    [self loadHTMLString:[self buildHtmlString] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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

#define C_WEBVIEW_HTML @"<html><head><style type='text/css'>%@</style></head><body id='page'>%@</body></html>"
#define C_WEBVIEW_CSS @"body {font-size:%i; font-family:%@; margin:6px; margin-bottom: 12px; padding:0px; color:%@; background-color:%@;} img {padding-bottom:12px; margin-left:auto; margin-right:auto; display:block; }"

- (NSString *)buildCSS {
    NSString *textColor = [self.textColor rgbaValue];
    NSString *backgroundColor = [self.backgroundColor rgbaValue];
    return [NSString stringWithFormat:C_WEBVIEW_CSS, (int) self.fontSize, self.fontName, textColor, backgroundColor];
}

- (NSString *)buildHtmlString {
    return [NSString stringWithFormat:C_WEBVIEW_HTML,[self buildCSS], self.text];
}

@end
