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

#import "MBPageDefinition.h"
#import "MBOutcomeDefinition.h"
#import "MBFieldDefinition.h"
#import "MBConfigurationDefinition.h"

/** Service class for working with Model, View and Controller definition objects.
 *
 * Use this class to: 
 * - Set which configuration and webservice-endpoint files to use.
 * - Retrieve definitions for programmatically creating MBDocument, MBDomain, MBDomainValidator objects.
 * 
 */
@interface MBMetadataService : NSObject 

/// @name Getting a service instance
/** The shared instance */
+(MBMetadataService *) sharedInstance;

/// @name Configuration

/** The master configuration file */
@property (nonatomic, retain) NSString *configName;

/** The filename for webservice endpoints file without extension */
@property (nonatomic, retain) NSString *endpointsName;

/** Master configuration */
@property (nonatomic, readonly) MBConfigurationDefinition *configuration;

/// @name (data) model layer definitions
/** Returns a MBDomainDefinition for a domainName
 * @param domainName The name of the domain
 * @throws Throws an NSException when the domainName does not exist.
 */
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName;

/** Returns a MBDomainDefinition for a domainName
 * @param domainName The name of the domain
 * @param doThrow Determines if an NSException is thrown if the domainName does not exist
 * @throws Throws an NSException when the domainName does not exist.
 */
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName throwIfInvalid:(BOOL) doThrow;

/// @name Getting page definitions
/** Returns a MBPageDefinition for a pageName
 * @param pageName The name of the page
 * @throws Throws an NSException when the pageName does not exist.
 */
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName;
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName throwIfInvalid:(BOOL) doThrow;

/// @name Getting action definitions
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName;
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName throwIfInvalid:(BOOL) doThrow;

/// @name Getting document definitions
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName;
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName throwIfInvalid:(BOOL) doThrow;

/// @name Getting dialog definitions
-(NSArray *) dialogDefinitions;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) dialogDefinitionForPageStackName:(NSString *)pageStackName;
-(MBDialogDefinition *) dialogDefinitionForPageStackName:(NSString *)pageStackName throwIfInvalid:(BOOL) doThrow;

/// @name Gettings alert definitions
-(MBAlertDefinition *) definitionForAlertName:(NSString *)alertName;
-(MBAlertDefinition *) definitionForAlertName:(NSString *)alertName throwIfInvalid:(BOOL) doThrow;

/// @name Controller layer definitions
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow;

@end


#pragma mark -
#pragma mark Deprecated methods

#include <AvailabilityMacros.h>


@interface MBMetadataService (Deprecated)
/**
 * DEPRECATED!!!
 * Please use [[MBMetadataService sharedInstance] setConfigName:...];
 *
 * set the master configuration file 
 */
+(void) setConfigName:(NSString*) name DEPRECATED_ATTRIBUTE;


/**
 * DEPRECATED!!!
 * Please use [[MBMetadataService sharedInstance] setEndpointsName:...];
 *
 * the filename for webservice endpoints
 * @param name The filename of the endpoints file without extension
 */
+(void) setEndpointsName:(NSString*) name DEPRECATED_ATTRIBUTE;


/**
 * DEPRECATED!!!
 * Please use [[MBMetadataService sharedInstance] endpointsName];
 *
 * Returns the filename of the endpoints file
 * @return The filename of the endpoints file
 */
+(NSString *) getEndpointsName DEPRECATED_ATTRIBUTE;

@end
