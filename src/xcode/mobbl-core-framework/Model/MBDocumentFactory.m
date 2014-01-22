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

#import "MBDocumentFactory.h"
#import "MBDocumentParser.h"
#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBXmlDocumentParser.h"
#import "MBJsonDocumentParser.h"

static MBDocumentFactory *_instance = nil;

@implementation MBDocumentFactory

+ (MBDocumentFactory *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _registeredDocumentParsers = [NSMutableDictionary new];
        [self registerDocumentParser:[[MBJsonDocumentParser new] autorelease] withName: PARSER_JSON];
        [self registerDocumentParser:[[MBXmlDocumentParser new] autorelease] withName: PARSER_XML];
        
    }
    return self;
}


- (void) registerDocumentParser:(id<MBDocumentParser>) parser withName:(NSString*) name {
    [_registeredDocumentParsers setObject: parser forKey: name];
}

- (id <MBDocumentParser>)  parserForType:(NSString *)type {
	   
	id parser = [_registeredDocumentParsers objectForKey: type];
	if(parser == nil) {
        @throw [NSException exceptionWithName:@"UnknownDataType" reason:type userInfo:nil];
	}
	return parser;
}


- (MBDocument*) documentWithData:(NSData *)data withType:(NSString*)type andDefinition: (MBDocumentDefinition*) definition {
    return [[self parserForType:type] documentWithData:data andDefinition:definition];
}

@end
