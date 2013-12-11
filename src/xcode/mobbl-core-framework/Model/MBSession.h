/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
