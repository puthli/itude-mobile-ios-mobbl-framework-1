//
//  MBDataServiceBase.h
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDataHandler.h"
#import "MBDocument.h"

@interface MBDataHandlerBase : NSObject <MBDataHandler> {
}

- (MBDocument *) loadDocument:(NSString *)documentName;
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args;
- (void) storeDocument:(MBDocument *)document;

@end
