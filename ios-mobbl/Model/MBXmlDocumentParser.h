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

#import "MBDocument.h"
#import "MBDocumentDefinition.h"
#import "MBDocumentParserProtocol.h"

@interface MBXmlDocumentParser : NSObject <MBDocumentParserProtocol, NSXMLParserDelegate>{
	NSMutableArray *_stack;
	NSMutableArray *_pathStack;
	MBDocumentDefinition *_definition;
	NSMutableString *_characters;
	NSString *_rootElementName;
	MBElementContainer *_rootElement;
    BOOL _copyRootAttributes;
}

+ (MBDocument*) documentWithData:(NSData *)data andDefinition: (MBDocumentDefinition*) definition;
+ (void) parseFragment:(NSData *)data intoDocument:(MBDocument*) document rootPath:(NSString*) rootPath copyRootAttributes:(BOOL) copyRootAttributes;
- (MBDocument*) parse:(NSData *)data usingDefinition: (MBDocumentDefinition*) definition;
- (NSString*) currentPath;




@end
