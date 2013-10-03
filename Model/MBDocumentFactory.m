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
#import "MBDocumentFactory.h"
#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBXmlDocumentParser.h"
#import "MBJsonDocumentParser.h"
#import "MBMobbl1DocumentParser.h"

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

- (MBDocument*) documentWithData:(NSData *)data withType:(NSString*)type andDefinition: (MBDocumentDefinition*) definition {

	if ([PARSER_XML isEqualToString:type]) {
		return [MBXmlDocumentParser documentWithData:data andDefinition:definition];
	}
	else
	if ([PARSER_MOBBL1 isEqualToString:type]) {
		return [MBMobbl1DocumentParser documentWithData:data andDefinition:definition];
	}
    else
    if ([PARSER_JSON isEqualToString:type]) {
        return [MBJsonDocumentParser documentWithData:data andDefinition:definition];
    }
	else @throw [NSException exceptionWithName:@"UnknownDataType" reason:type userInfo:nil];
}

@end
