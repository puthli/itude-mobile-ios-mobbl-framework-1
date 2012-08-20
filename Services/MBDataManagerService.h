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
#define DATA_HANDLER_WS_REST_GET @"MBRESTGetServiceDataHandler"
#define DATA_HANDLER_WS_MOBBL @"MBMobbl1ServerDataHandler"

#define MAX_CONCURRENT_OPERATIONS 5

/** Service class for loading and storing MBDocument instances.

 Every MBDocument is associated with a specific MBDataHandler in the document definition (see MBDocumentDefinition). When accessing
 documents using for instance loadDocument: , its associated DataHandler is used to perform the actual operation. For this to work, the
 name of the DataHandler must be registered using registerDataHandler:withName: first.

 */
@interface MBDataManagerService : NSObject {
	NSMutableDictionary *_registeredHandlers;
	NSOperationQueue *_operationQueue;
}

/// @name Getting a service instance
/** The shared instance */
+ (MBDataManagerService *) sharedInstance;

/// @name Configuring the service

/** Registers a MBDataHandler.
 @param handler the MBDataHandler instance
 @param name registration name.
 */
- (void) registerDataHandler:(id<MBDataHandler>) handler withName:(NSString*) name;

/** Removes the given MBDataHandler from the list of supported DataHandlers. */
- (void) deregisterDelegate: (id) delegate;

/** Sets the maximum number of asynchronous operations that can be active at the same time. */
- (void) setMaxConcurrentOperations:(int) max;

/// @name Creating a document

/** Creates a new MBDocument.
 @param documentName name of the document as defined in `documents.xmlx`.
 */
- (MBDocument *) createDocument:(NSString *)documentName;

/// @name Accessing a document synchronously

/** See [MBDataHandler loadDocument:] */
- (MBDocument *) loadDocument:(NSString *)documentName;

/** See [MBDataHandler loadDocument:withArguments:] */
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args;

/** See [MBDataHandler loadFreshDocument:] */
- (MBDocument *) loadFreshDocument:(NSString *)documentName;

/** See [MBDataHandler loadFreshDocument:withArguments:] */
- (MBDocument *) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument*) args;

/** See [MBDataHandler storeDocument:] */
- (void) storeDocument:(MBDocument *)document;

/// @name Accessing a document asynchronously

/** See [MBDataHandler loadDocument:].
 @param delegate delegate object that is called on completion
 @param resultSelector selector on delegate that is called on success. Selector is called with the loaded MBDocument as parameter.
 @param errorSelector selector on delegate that is called on error. No parameters are passed.
 */
- (void) loadDocument:(NSString *)documentName forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

/** See [MBDataHandler loadDocument:withArguments] and loadDocument:forDelegate:resultSelector:errorSelector: */
- (void) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

/** See [MBDataHandler loadFreshDocument:] and loadDocument:forDelegate:resultSelector:errorSelector: */
- (void) loadFreshDocument:(NSString *)documentName forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

/** See [MBDataHandler loadFreshDocument:withArguments:] and loadDocument:forDelegate:resultSelector:errorSelector: */
- (void) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument*) args forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;

/** See [MBDataHandler storeDocument:] and loadDocument:forDelegate:resultSelector:errorSelector: */
- (void) storeDocument:(MBDocument *)document forDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL) errorSelector;


@end
