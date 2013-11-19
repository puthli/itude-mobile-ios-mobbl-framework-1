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
