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

@class MBDocument;

/**
* Common superclass of configuration definitions.
*
* A MOBBL application is for a large part defined in XML configuration files. On startup,
* the framework parses these configuration files and creates MBDefinition objects for the
* configuration.
*/
@interface MBDefinition : NSObject {
	NSString *_name;
}

/// @name Getting the definition's name
/** Value of the `name` property of the XML element in the configuration. */
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSDictionary *customAttributes;

/// @name Checking definition validity
/** Checks the validity of the configuration.
*
* This method is called after parsing a configuration item and should be implemented by subclasses
* to check the validity of the configuration. The method is expected to throw an NSException when
* the definition is invalid.
*
* The default implementation is empty.
*/
- (void) validateDefinition;

/// @name Using conditional definitions
/** Checks the validity of any preconditions that are defined with this definition.
*
* Definitions that use this should implement MBConditionalDefinition. The default implementation
* always returns `YES`.
*/
- (BOOL) isPreConditionValid;
- (BOOL) isPreConditionValid:(MBDocument*) document  currentPath:(NSString*) currentPath;

/// @name Exporting to XML
- (NSString *) attributeAsXml:(NSString*)name withValue:(id) attrValue;
- (NSString *) booleanAsXml:(NSString*)name withValue:(BOOL) attrValue;
- (NSString *) asXmlWithLevel:(int)level;


@end
