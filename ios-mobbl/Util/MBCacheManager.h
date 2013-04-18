//
//  MBCacheManager.h
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDocument.h"

@interface MBCacheManager : NSObject {
    NSMutableDictionary *_registry;
    NSMutableDictionary *_documentTypes;
    NSMutableDictionary *_ttls;
    NSMutableDictionary *_temporaryMemoryCache;
    NSOperationQueue *_operationQueue;
    NSString *_registryFileName;
	NSString *_ttlsFileName;
}

+(NSData*) dataForKey:(NSString*) key;
+(void) setData:(NSData*) data forKey:(NSString*) key timeToLive:(int) ttl;
+(void) expireDataForKey:(NSString*) key;
+(void) expireDocumentForKey:(NSString*) key;
+(void) expireAllDocuments;
+(MBDocument*) documentForKey:(NSString*) key;
+(void) setDocument:(MBDocument*) document forKey:(NSString*) key timeToLive:(int) ttl;

@end
