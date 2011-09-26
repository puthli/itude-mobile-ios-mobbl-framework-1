//
//  MBSession.h
//  Core
//
//  Created by Wido
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"

@interface MBSession : NSObject {

}

+ (MBSession *) sharedInstance;
+ (void) setSharedInstance:(MBSession *) session;

- (MBDocument*) document;
- (void) logOff;
- (BOOL)loggedOn;

@end
