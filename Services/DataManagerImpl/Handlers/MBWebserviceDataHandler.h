//
//  MBWebserviceDataService.h
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDataHandlerBase.h"
#import "MBWebservicesConfigurationParser.h"

@interface MBWebserviceDataHandler : MBDataHandlerBase {
	MBWebservicesConfiguration *_webServiceConfiguration;
}

- (MBDocument *) loadDocument:(NSString *)documentName;
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args;
- (void) storeDocument:(MBDocument *)document;

- (MBEndPointDefinition *) getEndPointForDocument:(NSString*)name;

@end
