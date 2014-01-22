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

//	Parses Mobbl1 ServerResponse Documents

#import "MBDocumentParser.h"

@class MBElement;
@class MBDefinition;
@class MBElementContainer;
@class MBElementDefinition;

@interface MBJsonDocumentParser : NSObject <MBDocumentParser>{

}
+ (MBDocument*) documentWithString:(NSString *)string andDefinition: (MBDocumentDefinition*) definition;

-(MBDocument *) parseJsonString:(NSString *)jsonString usingDefinition:(MBDocumentDefinition *)definition;
-(void) parseJsonValue:(id) jsonValue usingDefinition:(MBDefinition *)definition withElement:(MBElementContainer *) element;

@end
