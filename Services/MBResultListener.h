//
//  MBResultListener.h
//  Core
//
//  Created by Wido on 6-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBDocument.h"
#import "MBResultListenerDefinition.h"
/** Protocol for processing results call to a server.
 
 Classes which use this protocol can be added to the webservice endpoint definition file (typically endpoints.xmlx) to catch errors or provide logic for specific server responses.
 
 The MBRESTServiceDataHandler uses regular expression matching to match a return value from a server to a MBResultListener. This allows logic to handle server responses to be added flexibly and in a central place.
 
 */
@protocol MBResultListener

-(void) handleResult:(NSString*) result requestDocument:(MBDocument*) requestDocument definition:(MBResultListenerDefinition*) definition;

@end
