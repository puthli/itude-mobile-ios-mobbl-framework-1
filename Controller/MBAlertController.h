//
//  MBAlertController.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/23/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBAlertDefinition;
@class MBOutcome;

@interface MBAlertController : NSObject

- (void)handleAlert:(MBAlertDefinition *)alertDef forOutcome:(MBOutcome *)outcomeToProcess;

@end
