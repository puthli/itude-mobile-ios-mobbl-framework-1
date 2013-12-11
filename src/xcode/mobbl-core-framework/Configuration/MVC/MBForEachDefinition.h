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

#import "MBForEachDefinition.h"
#import "MBDefinition.h"
#import "MBVariableDefinition.h"
#import "MBConditionalDefinition.h"

@interface MBForEachDefinition : MBConditionalDefinition {
	NSString *_value;
	NSMutableArray *_children;
	NSMutableDictionary *_variables;
	BOOL _suppressRowComponent;

}

@property (nonatomic, retain) NSString* value;
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, retain) NSMutableDictionary* variables;
@property (nonatomic, assign) BOOL suppressRowComponent;

- (void) addChild:(MBDefinition*)child;
- (void) addVariable:(MBVariableDefinition*)variable;
- (MBVariableDefinition*) variable:(NSString*)name;

@end
