//
//  MBOutcomeListenerProtocol.h
//  Core
//
//  Created by Wido on 2-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOutcome.h"

@protocol MBOutcomeListenerProtocol

@required
- (void) outcomeProduced:(MBOutcome*) outcome;

@end
