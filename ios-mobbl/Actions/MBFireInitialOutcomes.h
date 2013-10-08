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

/**
 * Handles all initial outcomes in the initial outcomes document
 */
- (void)handleInitialOutcomes;

/**
 * This method activates the first pagestach in the initial outcomes document and ensures that the first tab is selected. 
 * Override this method to change this behaviour
 */
- (void)activateFirstPageStack;

@end
