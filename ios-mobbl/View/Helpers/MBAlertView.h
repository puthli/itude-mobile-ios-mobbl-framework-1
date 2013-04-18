//
//  MBAlertView.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBField;
@interface MBAlertView : UIAlertView



- (void)setField:(MBField *)field forButtonWithKey:(NSString *)key;
- (MBField *)fieldForButtonAtIndex:(NSInteger) index;

@end
