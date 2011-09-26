//
//  MBCacheWriter.h
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface MBCacheWriter : NSOperation {
    NSMutableDictionary *_registry;
    NSMutableDictionary *_documentTypes;
    NSMutableDictionary *_ttls;
    NSString *_registryFileName;
    NSString *_ttlsFileName;
    NSString *_fileName;
    NSData *_data;
	NSMutableDictionary *_temporaryMemoryCache;
    NSString *_key;
}

@property (nonatomic, retain) NSMutableDictionary *registry;
@property (nonatomic, retain) NSMutableDictionary *documentTypes;
@property (nonatomic, retain) NSString *registryFileName;
@property (nonatomic, retain) NSMutableDictionary *ttls;
@property (nonatomic, retain) NSString *ttlsFileName;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSMutableDictionary *temporaryMemoryCache;
@property (nonatomic, retain) NSString *key;

- (id) initWithRegistry:(NSMutableDictionary*) registry 
	   registryFileName:(NSString*) registryFileName 
		  documentTypes:(NSMutableDictionary*) documentTypes
				   ttls:(NSMutableDictionary*) ttls
		   ttlsFileName:(NSString*) ttlsFileName 
			   fileName:(NSString*) fileName 
				   data:(NSData*) data
   temporaryMemoryCache:(NSMutableDictionary*) temporaryMemoryCache
					key:(NSString*) key;

@end
