//
//  MBViewBuilderDelegate 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

@class MBField;

/**
* Callback methods used by ViewBuilders to notify clients of the creation of (sub)views.
*/
@protocol MBViewBuilderDelegate

- (void)viewBuilder:(id)viewBuilder didCreateInteractiveField:(MBField *)field atIndexPath:(NSIndexPath *)indexPath;

/**
 * Asks the delegate for a UIWebView. The delegate is responsible for creating a webview (or reusing an existing one).
 * The delegate should just create an empty UIWebView: initialization with subviews should be left to the
 * MBViewBuilder instance.
 *
 * @return a new or reused UIWebView for the given indexPath.
 */
- (UIWebView *)webViewWithText:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

@end