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
        CGFloat inset = 10.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(inset, 0.0, bounds.size.width-(2*inset), bounds.size.height)];
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
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [webView.scrollView setScrollEnabled:NO];
    webView.backgroundColor = [self.styleHandler backgroundColorField:field];
    webView.textColor = [self.styleHandler textColorForField:field];
    [webView setText:text withFont:[self.styleHandler fontForField:field]];
    [self.styleHandler styleWebView:webView component:field];
    return webView;
}

-(NSString*)getText:(MBField*)field {
    return [field formattedValue];
}

-(void) configureLabel:(UILabel*) label withText:(NSString*)text forField:(MBField*)field {
    label.text = text;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; //UILineBreakModeWordWrap;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.styleHandler styleMultilineLabel:label component:field];

}

@end
