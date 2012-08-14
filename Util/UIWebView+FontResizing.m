//
//  UIWebView(FontResizing) 
//
//  Created by Pieter Kuijpers on 14-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "UIWebView+FontResizing.h"


@implementation UIWebView (FontResizing)

#define C_WEBVIEW_DEFAULT_FONTNAME @"arial"
#define C_WEBVIEW_CSS @"body {font-size:%i; font-family:%@; margin:6px; margin-bottom: 12px; padding:0px;} img {padding-bottom:12px; margin-left:auto; margin-right:auto; display:block; }"

- (void)setText:(NSString *)text
{
    [self setText:text withFontSize:C_WEBVIEW_DEFAULT_FONTSIZE];
}

- (void)setText:(NSString *)text withFontSize:(NSInteger)fontSize
{
    NSString *css = [NSString stringWithFormat:C_WEBVIEW_CSS, fontSize, C_WEBVIEW_DEFAULT_FONTNAME];
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>%@</style></head><body id='page'>%@</body></html>",css, text];
    [self loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

    // If needed, resize view in webViewDidFinishLoad of delegate
}

- (void)refreshWithFontSize:(NSInteger)fontSize
{
    NSString *text = [self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    if (text.length > 0) {
        [self setText:text withFontSize:fontSize];
    }
}

@end