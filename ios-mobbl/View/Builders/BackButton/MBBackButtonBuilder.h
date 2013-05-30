//
//  MBBackButtonBuilder.h
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/30/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

@protocol MBBackButtonBuilder <NSObject>

@required
- (UIBarButtonItem *)buildBackButton;
- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title;

@end