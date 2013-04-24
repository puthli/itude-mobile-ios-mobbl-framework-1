//
//  MBMetadataService.h
//  Core
//
//  Created by Wido on 5/20/10.
//  Copyright 2010 Itude. All rights reserved.
//

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
@interface MBMetadataService : NSObject {
	MBConfigurationDefinition* _cfg;
}

/// @name setting which configuration files are used
/** set the master configuration file */
+(void) setConfigName:(NSString*) name;
/** the filename for webservice endpoints 
 * @param name The filename of the endpoints file without extension 
 */
+(void) setEndpointsName:(NSString*) name;

/** Returns the filename of the endpoints file
 * @return The filename of the endpoints file
 */
+(NSString *) getEndpointsName;
	
/// @name Getting a service instance
/** The shared instance */
+(MBMetadataService *) sharedInstance;


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
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) firstDialogDefinition;
-(MBDialogGroupDefinition *)definitionForDialogGroupName:(NSString *)dialogGroupName;
-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName throwIfInvalid:(BOOL) doThrow;
-(MBAlertDefinition *) definitionForAlertName:(NSString *)alertName;
-(MBAlertDefinition *) definitionForAlertName:(NSString *)alertName throwIfInvalid:(BOOL) doThrow;
-(NSArray*) dialogs;
/// @name Controller layer definitions
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName;
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName throwIfInvalid:(BOOL) doThrow;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow;
/// @name Master configuration
-(MBConfigurationDefinition *) configuration;
@end
