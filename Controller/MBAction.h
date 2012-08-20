//
//  MBOutcomeHandler.h
//  Core
//
//  Created by Robin Puthli on 4/27/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"
@class MBOutcome;

/** Business rule or unit of application logic. Typical use is to influence the flow of navigation between screens during authentication sequences or purchase flows. 
 */
@protocol MBAction

-(MBOutcome*) execute:(MBDocument *)document withPath:(NSString *)path;

@end
