//
//  MBDialogDecorator.h
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBDialogDecorator <NSObject>
@required
- (void)decorateViewController:(UIViewController *)viewController displayMode:(NSString*) displayMode;
@end
