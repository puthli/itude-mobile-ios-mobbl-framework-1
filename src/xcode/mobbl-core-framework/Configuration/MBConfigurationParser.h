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

#import "MBConfigurationParserProtocol.h"
#import "StringUtilities.h"

@interface MBConfigurationParser : NSObject <MBConfigurationParserProtocol, NSXMLParserDelegate> {
	NSMutableArray *_stack;
	NSMutableString *_characters;
	NSString *_documentName;
}

@property (nonatomic, retain) NSString* documentName;

- (id) parseData:(NSData*)data ofDocument:(NSString*) documentName;
- (void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string;

- (BOOL) processElement:(NSString*)elementName attributes:(NSDictionary*)attributeDict;
- (void) didProcessElement:(NSString*)elementName;

- (BOOL) isConcreteElement:(NSString*)element;
- (BOOL) isIgnoredElement:(NSString*)element;

- (BOOL) checkAttributesForElement:(NSString*) elementName withAttributes:(NSDictionary*) attributes withValids:(NSArray*) valids;
- (void) notifyProcessed:(id) object usingSelector:(SEL) selector;

@end
