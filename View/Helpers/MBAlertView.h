//
//  MBAlertView.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAlertView : UIAlertView

- (void)setOutcomeName:(NSString *)outcomeName forButtonWithKey:(NSString *)key;
- (NSString *)outcomeNameForButtonAtIndex:(NSInteger) index;

@end
