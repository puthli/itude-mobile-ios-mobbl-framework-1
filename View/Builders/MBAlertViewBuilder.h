//
//  MBAlertViewBuilder.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBViewBuilder.h"

@class MBAlert;

@interface MBAlertViewBuilder : MBViewBuilder

- (UIAlertView *)buildAlertView:(MBAlert *) alert;

@end
