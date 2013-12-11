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

#import "MBConfigurationParser.h"
#import "MBConfigurationDefinition.h"

@interface MBMvcConfigurationParser : MBConfigurationParser {

    @private
    NSArray* _configAttributes;
    NSArray* _documentAttributes;
    NSArray* _elementAttributes;
    NSArray* _attributeAttributes;
    NSArray* _actionAttributes;
    NSArray* _outcomeAttributes;
    NSArray* _pageStackAttributes;
	NSArray* _dialogAttributes;
    NSArray* _pageAttributes;
    NSArray* _alertAttributes;
    NSArray* _panelAttributes;
    NSArray* _forEachAttributes;
    NSArray* _fieldAttributes;
    NSArray* _domainAttributes;
    NSArray* _domainValidatorAttributes;
	NSArray* _variableAttributes;
    
    MBConfigurationDefinition *_rootConfig;
}

@property (nonatomic, retain) NSArray* configAttributes;
@property (nonatomic, retain) NSArray* documentAttributes;
@property (nonatomic, retain) NSArray* elementAttributes;
@property (nonatomic, retain) NSArray* attributeAttributes;
@property (nonatomic, retain) NSArray* actionAttributes;
@property (nonatomic, retain) NSArray* outcomeAttributes;
@property (nonatomic, retain) NSArray* pageStackAttributes;
@property (nonatomic, retain) NSArray* dialogAttributes;
@property (nonatomic, retain) NSArray* pageAttributes;
@property (nonatomic, retain) NSArray* alertAttributes;
@property (nonatomic, retain) NSArray* panelAttributes;
@property (nonatomic, retain) NSArray* forEachAttributes;
@property (nonatomic, retain) NSArray* variableAttributes;
@property (nonatomic, retain) NSArray* fieldAttributes;
@property (nonatomic, retain) NSArray* domainAttributes;
@property (nonatomic, retain) NSArray* domainValidatorAttributes;

@end
