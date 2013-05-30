//
//  MBBasicViewController+BackButton.h
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/29/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBBasicViewController.h"

@interface MBBasicViewController (BackButton)

typedef enum {
    MBBackButtonTypeDefault,
    MBBackButtonTypeArrowInverted,
    MBBackButtonTypeArrow,
}MBBackButtonType;

- (void)addCustomBackButtonWithType:(MBBackButtonType)buttonType;
- (void)addCustomBackButtonWithType:(MBBackButtonType)buttonType withTitle:(NSString *)title;

@end
