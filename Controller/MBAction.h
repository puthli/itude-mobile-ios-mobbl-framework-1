//
//  MBOutcomeHandler.h
//  Core
//
//  Created by Robin Puthli on 4/27/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"
@class MBOutcome;
@protocol MBAction

-(MBOutcome*) execute:(MBDocument *)document withPath:(NSString *)path;

@end
