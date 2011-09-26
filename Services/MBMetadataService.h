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

@interface MBMetadataService : NSObject {
	MBConfigurationDefinition* _cfg;
}

+(void) setConfigName:(NSString*) name;
+(void) setEndpointsName:(NSString*) name;
+(NSString *) getEndpointsName;
	

+(MBMetadataService *) sharedInstance;
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName;
-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName throwIfInvalid:(BOOL) doThrow;
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName;
-(MBPageDefinition *) definitionForPageName:(NSString *)pageName throwIfInvalid:(BOOL) doThrow;
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName;
-(MBActionDefinition *) definitionForActionName:(NSString *)actionName throwIfInvalid:(BOOL) doThrow;
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName;
-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName;
-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName throwIfInvalid:(BOOL) doThrow;
-(MBDialogDefinition *) firstDialogDefinition;
-(MBDialogGroupDefinition *)definitionForDialogGroupName:(NSString *)dialogGroupName;
-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName throwIfInvalid:(BOOL) doThrow;
-(NSArray*) dialogs;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName;
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow;
-(MBConfigurationDefinition *) configuration;
@end
