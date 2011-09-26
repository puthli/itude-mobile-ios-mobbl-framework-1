//
//  MBDataManager.h
//  Core
//
//  Created by Wido on 5/20/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDataHandlerBase.h"
#import "MBDocument.h"
#import "MBDataHandler.h"

#define DATA_HANDLER_MEMORY @"MBMemoryDataHandler"
#define DATA_HANDLER_FILE @"MBFileDataHandler"
#define DATA_HANDLER_SYSTEM @"MBSystemDataHandler"
#define DATA_HANDLER_WS_REST @"MBRESTServiceDataHandler"
#define DATA_HANDLER_WS_MOBBL @"MBMobbl1ServerDataHandler"

#define MAX_CONCURRENT_OPERATIONS 5

@interface MBDataManagerService : NSObject {
	NSMutableDictionary *_registeredHandlers;
	NSOperationQueue *_operationQueue;
}

+ (MBDataManagerService *) sharedInstance;

- (MBDocument *) loadDocument:(NSString *)documentName;
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args;
- (MBDocument *) createDocument:(NSString *)documentName;
- (void) loadDocument:(NSString *)documentName forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;
- (void) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

- (void) storeDocument:(MBDocument *)document;
- (void) storeDocument:(MBDocument *)document forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

- (void) registerDataHandler:(id<MBDataHandler>) handler withName:(NSString*) name;
- (void) deregisterDelegate: (id) delegate;
	
- (void) setMaxConcurrentOperations:(int) max;
@end
