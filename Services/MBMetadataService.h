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
/** the filename for webservice endpoints */
+(void) setEndpointsName:(NSString*) name;
+(NSString *) getEndpointsName;
	
/// @name Getting a service instance
/** The shared instance */
+(MBMetadataService *) sharedInstance;

/// @name (data) model layer definitions
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName;
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName throwIfInvalid:(BOOL) doThrow;
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName;
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName throwIfInvalid:(BOOL) doThrow;
/// @name view layer definitions
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName;
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) firstDialogDefinition;
-(MBDialogGroupDefinition *)definitionForDialogGroupName:(NSString *)dialogGroupName;
-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName throwIfInvalid:(BOOL) doThrow;
-(NSArray*) dialogs;
/// @name controller layer definitions
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName;
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName throwIfInvalid:(BOOL) doThrow;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow;
/// @name master configuration
-(MBConfigurationDefinition *) configuration;
@end
