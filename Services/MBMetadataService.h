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

/** Service class for loading localized configuring endpoints and config files and getting definitions. */
@interface MBMetadataService : NSObject {
	MBConfigurationDefinition* _cfg;
}

/// @name Getters and setters for properties

/** Allows the developer to set the filename of the Config file 
 @param name The filename of the config file without extension
 */
+(void) setConfigName:(NSString*) name;

/** Allows the developer to set the filename of the endpoints file
 @param name The filename of the endpoints file without extension 
 */
+(void) setEndpointsName:(NSString*) name;

/** Returns the filename of the endpoints file
 @return The filename of the endpoints file
 */
+(NSString *) getEndpointsName;
	
/// @name Getting a service instance
/** The shared instance */
+(MBMetadataService *) sharedInstance;


/// @name Getting domain definitions
/** Returns a MBDomainDefinition for a domainName
 @param domainName The name of the domain
 @throws Throws an NSException when the domainName does not exist.
 */
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName;

/** Returns a MBDomainDefinition for a domainName
 @param domainName The name of the domain
 @param doThrow Determines if an NSException is thrown if the domainName does not exist
 @throws Throws an NSException when the domainName does not exist.
 */
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName throwIfInvalid:(BOOL) doThrow;

/// @name Getting page definitions
/** Returns a MBPageDefinition for a pageName
 @param pageName The name of the page
 @throws Throws an NSException when the pageName does not exist.
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

/// @name Getting dialoggroup definitions
-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName;
-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName throwIfInvalid:(BOOL) doThrow;


-(NSArray*) dialogs;

/// @name Getting outcome definitions
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow;

/// @name Getting configuration definitions
-(MBConfigurationDefinition *) configuration;
@end
