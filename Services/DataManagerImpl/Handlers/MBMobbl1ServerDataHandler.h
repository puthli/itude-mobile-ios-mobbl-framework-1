//
//  MBMobbl1ServerDataHandler.h
//  Core
//
//  Created by Robin Puthli on 6/10/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBRESTServiceDataHandler.h"

/** retrieves and sends MBDocument instances to and from the MobblServer webservice proxy.

 * MobblServer is a JavaEE server component that provides high performance transformation and compression of XML payloads to and from third party webservices. MobblServer also contains checksum based security features. 
 * The MBMobbl1ServerDataHandler provides out-of-the-box network connectivity to a MobblServer instance running on a server. 
 * A typical use case is where MobblServer transforms parts of SOAP xml messages to a JSON format and passes them on to the mobile app. The reverse route also works, allowing apps to pass compact JSON messages to MobblServer which inflates them into SOAP xml messages.
 
*/
@interface MBMobbl1ServerDataHandler : MBRESTServiceDataHandler {

}

@end
