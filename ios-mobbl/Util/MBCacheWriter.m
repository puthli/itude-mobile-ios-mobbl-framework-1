/*
 * (C) Copyright ItudeMobile.
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

#import "MBMacros.h"
#import "MBCacheWriter.h"

@implementation MBCacheWriter

@synthesize registry = _registry;
@synthesize registryFileName = _registryFileName;
@synthesize documentTypes = _documentTypes;
@synthesize ttls = _ttls;
@synthesize ttlsFileName = _ttlsFileName;
@synthesize fileName = _fileName;
@synthesize data = _data;
@synthesize temporaryMemoryCache = _temporaryMemoryCache;
@synthesize key = _key;

- (id) initWithRegistry:(NSMutableDictionary*) registry 
	   registryFileName:(NSString*) registryFileName 
		  documentTypes:(NSMutableDictionary*) documentTypes
				   ttls:(NSMutableDictionary*) ttls
		   ttlsFileName:(NSString*) ttlsFileName 
			   fileName:(NSString*) fileName 
				   data:(NSData*) data
   temporaryMemoryCache:(NSMutableDictionary*) temporaryMemoryCache
					key:(NSString*) key
{
    self = [super init];
    if (self != nil) {
        self.registry = [[registry copy] autorelease];
		self.documentTypes = [[documentTypes copy] autorelease];
		self.ttls = [[ttls copy] autorelease];
        self.registryFileName = registryFileName;
        self.fileName = fileName;
        self.data = data;
		self.ttlsFileName = ttlsFileName;
    }
    return self;
}

- (void) dealloc
{
    [_registry release];
    [_fileName release];
    [_documentTypes release];
    [_ttls release];
    [_ttlsFileName release];
    [_data release];
    [_key release];
    [_temporaryMemoryCache release];
    [super dealloc];
}

- (void) main {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @try {
		
		NSMutableDictionary *combined = [[NSMutableDictionary new] autorelease];
		for(NSString *key in [self.registry allKeys]) {
			NSString *value = [self.registry valueForKey:key];
			NSString *docType = [self.documentTypes valueForKey:key];
			if(docType != nil) value = [NSString stringWithFormat:@"%@:%@", value, docType];
			[combined setValue:value forKey:key];
		}
		
		BOOL success = [self.ttls writeToFile:self.ttlsFileName atomically: YES];
		success &= [combined writeToFile:self.registryFileName atomically: YES];
		
		if(success && self.data != nil) {
			NSError *error;
			success &= [self.data writeToFile:self.fileName options:0 error:&error];
			if(!success) WLog(@"Error caching data in %@: %i, %@", self.fileName, [error code], [error domain]);
		}
		else {
			if(!success) WLog(@"Could not store the cache registry info in %@ and/or %@; skipping writing to the cache!", self.registryFileName, self.ttlsFileName);
		}
    }
    @finally {
		// Make sure the data is released from the temporary cache; since writing is finished
		@synchronized(_temporaryMemoryCache) {
			if(_key != nil) [_temporaryMemoryCache removeObjectForKey:_key];
		}
        [pool release];
    }
}
@end
