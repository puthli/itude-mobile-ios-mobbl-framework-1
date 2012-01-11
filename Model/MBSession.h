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

/**
 * Returns the current session instance
 * @return the shared instance of MBSession
 */
+ (MBSession *) sharedInstance;


/**
 * Sets the given sessions as the instance
 * @param session
 */
+ (void) setSharedInstance:(MBSession *) session;



/*********************** IMPORTANT MESSAGE ***********************/
/* The methods below are not implemented. They return nil or FALSE and do nothing.
 * Override these methods in an instance specific for your app; and register it app startup with setSharedInstance */
/*****************************************************************/


/**
 * Should return the session document that stores the current session state
 * @note IMPORTANT: THIS METHOD IS NOT IMPLEMENTED! It needs to be overridden in a superclass
 * @return Should return a MBDocument that keeps track of the current session state 
 * (e.g. A MBDocument that stores the current session state)
 */
- (MBDocument*) document;

/**
 * Should logOff the current session (e.g. clear the current session state from the session document)
 * @note IMPORTANT: THIS METHOD IS NOT IMPLEMENTED! It needs to be overridden in a superclass
 */
- (void) logOff;

/**
 * Should return the loggedOn state of the current session
 * @note IMPORTANT: THIS METHOD IS NOT IMPLEMENTED! It needs to be overridden in a superclass
 * @return Should return TRUE if the session is logged on. Should return FALSE if the session is logged off.
 */
- (BOOL) loggedOn;

@end
