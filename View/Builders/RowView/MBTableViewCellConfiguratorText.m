//
//  MBTableViewCellConfiguratorText 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <MBViewBuilderFactory.h>
#import "MBTableViewCellConfiguratorText.h"
#import "UIWebView+FontResizing.h"
#import "StringUtilities.h"

@implementation MBTableViewCellConfiguratorText

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{

    NSString *text;
    if(field.path != nil) {
        text = [field formattedValue];
    }
    else {
        text= field.label;
    }

    MBStyleHandler *styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];

    // if the text contains any html, make a webview
    if ([text hasHTML]) {
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(6, 6, 284, 36)] autorelease];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        webView.text = text;
        cell.opaque = NO;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:webView];
    }
    else {
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [styleHandler styleMultilineLabel:cell.textLabel component:field];

    }
}

@end