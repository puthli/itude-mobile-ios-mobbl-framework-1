//
//  UIWebView(FontResizing) 
//
//  Created by Pieter Kuijpers on 14-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIWebView (FontResizing)

#define C_WEBVIEW_DEFAULT_FONTSIZE 14

-(void)setText:(NSString *)text;
-(void)setText:(NSString *)text withFontSize:(NSInteger)fontSize;
-(void)refreshWithFontSize:(NSInteger)fontSize;

@end