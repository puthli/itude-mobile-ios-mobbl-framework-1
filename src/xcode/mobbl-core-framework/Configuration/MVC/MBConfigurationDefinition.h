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

#import "MBDomainDefinition.h"
#import "MBDocumentDefinition.h"
#import "MBAttributeDefinition.h"
#import "MBActionDefinition.h"
#import "MBOutcomeDefinition.h"
#import "MBPageStackDefinition.h"
#import "MBDialogDefinition.h"
#import "MBPageDefinition.h"
#import "MBAlertDefinition.h"
#import "MBDefinition.h"
#import "MBOrderedMutableDictionary.h"

#define DOC_SYSTEM_EMPTY                  @"MBEmpty"
#define DOC_SYSTEM_LANGUAGE               @"MBBundle"
#define DOC_SYSTEM_EXCEPTION              @"MBException"
#define DOC_SYSTEM_EXCEPTION_TYPE_SERVER  @"MBServerException"
#define PATH_SYSTEM_EXCEPTION_NAME        @"/Exception[0]/@name"
#define PATH_SYSTEM_EXCEPTION_DESCRIPTION @"/Exception[0]/@description"
#define PATH_SYSTEM_EXCEPTION_ORIGIN      @"/Exception[0]/@origin"
#define PATH_SYSTEM_EXCEPTION_OUTCOME     @"/Exception[0]/@outcome"
#define PATH_SYSTEM_EXCEPTION_PATH        @"/Exception[0]/@path"
#define PATH_SYSTEM_EXCEPTION_TYPE        @"/Exception[0]/@type"

#define DOC_SYSTEM_PROPERTIES             @"MBApplicationProperties"

@interface MBConfigurationDefinition : MBDefinition {
	NSMutableDictionary *_domainTypes;
	NSMutableDictionary *_documentTypes;
	NSMutableDictionary *_actionTypes;
	NSMutableArray *_outcomeTypes;
	NSMutableDictionary *_pageTypes;
	MBOrderedMutableDictionary *_dialogs;
    NSMutableDictionary *_alerts;
}

- (NSString *) asXmlWithLevel:(int)level;
- (void) addDomain:(MBDomainDefinition*)domain;
- (void) addDocument:(MBDocumentDefinition*)document;
- (void) addAction:(MBActionDefinition*)action;
- (void) addOutcome:(MBOutcomeDefinition*)outcome;
- (void) addPage:(MBPageDefinition*)page;
- (void) addDialog:(MBDialogDefinition*)dialog;
- (void) addAlert:(MBAlertDefinition*)alert;

- (MBDomainDefinition *) definitionForDomainName:(NSString *)domainName;
- (MBPageDefinition*) definitionForPageName:(NSString*) name;
- (MBActionDefinition *) definitionForActionName:(NSString *)actionName;
- (MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName;
- (MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName;
- (MBAlertDefinition *) definitionForAlertName:(NSString *)alertName;
- (NSArray*) outcomeDefinitionsForOrigin:(NSString *)originName;
- (NSArray*) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
- (MBOrderedMutableDictionary*) dialogs;
- (NSMutableDictionary*) domains;
- (NSMutableDictionary*) actions;
- (NSMutableArray*) outcomes;
- (NSMutableDictionary*) documents;
- (NSMutableDictionary*) pages;
- (NSMutableDictionary*) alerts;
- (void) addAll:(MBConfigurationDefinition*) otherConfig;


@end
