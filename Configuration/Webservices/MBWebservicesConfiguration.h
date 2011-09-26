//
//  MBWebserviceConfiguration.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBEndPointDefinition.h"
#import "MBResultListenerDefinition.h"

@interface MBWebservicesConfiguration : MBDefinition {
	NSMutableDictionary *_endPoints;
	NSMutableArray *_resultListeners;
}

- (void) addEndPoint:(MBEndPointDefinition *)definition;
- (MBEndPointDefinition *)getEndPointForDocumentName:(NSString *)documentName;
- (void) addResultListener:(MBResultListenerDefinition*) lsnr;
- (void) linkGlobalListeners;
@end
