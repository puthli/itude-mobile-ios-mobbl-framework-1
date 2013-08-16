//
//  MBFireInitialOutcomes.h
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 8/16/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBAction.h"

@interface MBFireInitialOutcomes : NSObject <MBAction>

/**
 * @return the documentname that contains the initial outcomes. The default name is "InitialOutcomes"
 */
-(NSString *)documentName;

@end
