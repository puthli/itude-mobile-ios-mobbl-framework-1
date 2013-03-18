//
//  MBWebView.h
//  itude-mobile-ios-bt-grondwet
//
//  Created by Frank van Eenbergen on 3/18/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBWebView : UIWebView

@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) NSString *text;

-(void)setText:(NSString *)text withFont:(UIFont *)font;

-(void)refreshFont;


@end
