//
//  MBTextBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/6/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTextBuilder.h"
#import "MBField.h"
#import <UIKit/UIKit.h>
#import "StringUtilities.h"
#import "MBWebView.h"
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h"

@implementation MBTextBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    NSString *text = [self getText:field];
    if ([text hasHTML]) {
        UIWebView *webView = [self buildWebView:field text:text withMaxBounds:bounds];
        return webView;
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 25.0)];
        [self configureLabel:label withText:text forField:field];
        return [label autorelease];
    }
}

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    NSString *text = [self getText:field];
    
    // if the text contains any html, make a webview
    if ([text hasHTML]) {
        MBWebView *webView = [self buildWebView:field text:text withMaxBounds:bounds];
        cell.opaque = NO;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:webView];
        return webView;
    }
    else {
        [self configureLabel:cell.textLabel withText:text forField:field];
        return cell.textLabel;
        
    }
}


-(MBWebView*)buildWebView:(MBField *)field text:(NSString*)text withMaxBounds:(CGRect)bounds {
    CGFloat margin = 6;
    MBWebView *webView = [[[MBWebView alloc] initWithFrame:CGRectMake(margin, margin, bounds.size.width-(margin*2), 36)] autorelease];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [webView setText:text withFont:[[[MBViewBuilderFactory sharedInstance] styleHandler] fontForField:field]];
    [self.styleHandler styleWebView:webView component:field];
    return webView;
}

-(NSString*)getText:(MBField*)field {
    
    NSString *text;
    if(field.path != nil) {
        text = [field formattedValue];
    }
    else {
        text= field.label;
    }
    return text;
}

-(void) configureLabel:(UILabel*) label withText:(NSString*)text forField:(MBField*)field {
    label.text = text;
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    [self.styleHandler styleMultilineLabel:label component:field];

}

@end
