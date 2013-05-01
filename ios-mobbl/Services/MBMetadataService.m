//
//  MBMetadataService.m
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBMacros.h"
#import "MBMetadataService.h"
#import "MBMvcConfigurationParser.h"
#import "DataUtilites.h"

static MBMetadataService *_instance = nil;
static NSString *_configName = @"config";
static NSString *_endpointsName = @"endpoints";

@implementation MBMetadataService

+(void) setConfigName:(NSString*) name {
    _configName = name;

	@synchronized(self) {
		[_instance release];
		_instance = nil;
	}
}

+(void) setEndpointsName:(NSString*) name {
    _endpointsName = name;
}

+(NSString *) getEndpointsName{
	return _endpointsName;
}

+(MBMetadataService *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

-(id) init {
	self = [super init];
	if(self != nil) {
		MBMvcConfigurationParser *parser = [MBMvcConfigurationParser new];
		NSData *data = [NSData dataWithEncodedContentsOfMainBundle:_configName];
		_cfg = [[parser parseData:data ofDocument: _configName] retain];
        [parser release];        
	}
	return self;
}

-(void) dealloc {
	[_cfg release];
	[super dealloc];
}

-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName {
	return [self definitionForDocumentName:documentName throwIfInvalid: TRUE];
}

-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName throwIfInvalid:(BOOL) doThrow {
	MBDocumentDefinition *docDef = [_cfg definitionForDocumentName: documentName];
	if(docDef == nil && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Document with name %@ not defined", documentName];
		@throw [[[NSException alloc]initWithName:@"DocumentNotDefined" reason:msg userInfo:nil]autorelease];
	}
	return docDef;
}

-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName {
	return [self definitionForDomainName: domainName throwIfInvalid: TRUE];
}

-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName throwIfInvalid:(BOOL) doThrow {
	MBDomainDefinition *domDef = [_cfg definitionForDomainName: domainName];
	if(domDef == nil && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Domain with name %@ not defined", domainName];
		@throw [[[NSException alloc]initWithName:@"DomainNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return domDef;
}

-(MBPageDefinition *) definitionForPageName:(NSString *)pageName {
    return [self definitionForPageName: pageName throwIfInvalid: TRUE];
}

-(MBPageDefinition *) definitionForPageName:(NSString *)pageName throwIfInvalid:(BOOL) doThrow {
	MBPageDefinition *pageDef = [_cfg definitionForPageName: pageName];
	if(pageDef == nil && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Page with name %@ not defined", pageName];
		@throw [[[NSException alloc]initWithName:@"PageNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return pageDef;
}

-(MBActionDefinition *) definitionForActionName:(NSString *)actionName {
	return [self definitionForActionName: actionName throwIfInvalid: TRUE];
}

-(MBActionDefinition *) definitionForActionName:(NSString *)actionName throwIfInvalid:(BOOL) doThrow {
	MBActionDefinition *actionDef = [_cfg definitionForActionName: actionName];
	if(actionDef == nil && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Action with name %@ not defined", actionName];
		@throw [[[NSException alloc]initWithName:@"ActionNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return actionDef;
}

-(MBDialogDefinition *)definitionForDialogName:(NSString *)dialogName {
	return [self definitionForDialogName:dialogName throwIfInvalid:TRUE];
}

-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName throwIfInvalid:(BOOL) doThrow {
	MBDialogDefinition *dialogDefinition = [_cfg definitionForDialogName:dialogName];
	if(dialogDefinition == nil && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Dialog with name %@ not defined", dialogName];
		@throw [[[NSException alloc]initWithName:@"DialogNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return dialogDefinition;
}

-(MBDialogDefinition *) dialogDefinitionForPageStackName:(NSString *)pageStackName {
	return [self dialogDefinitionForPageStackName:pageStackName throwIfInvalid:TRUE];
}

-(MBDialogDefinition *) dialogDefinitionForPageStackName:(NSString *)pageStackName throwIfInvalid:(BOOL) doThrow {
    for (MBDialogDefinition *dialogDef in [_cfg.dialogs allValues]) {
        for (MBPageStackDefinition *stackDef in dialogDef.pageStacks) {
            if ([pageStackName isEqualToString:stackDef.name]) {
                return dialogDef;
            }
        }
        
        // in case we have an implicit stack
        if (dialogDef.pageStacks.count == 0 && [dialogDef.name isEqualToString:pageStackName]) {
            return dialogDef;
        }
    }
    
	if(doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Dialog for stack %@ not defined", pageStackName];
		@throw [[[NSException alloc]initWithName:@"DialogNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return nil;
}

- (NSArray *)dialogs {
    return [[_cfg dialogs] allValues];
}


- (MBAlertDefinition *)definitionForAlertName:(NSString *)alertName {
    return [self definitionForAlertName:alertName throwIfInvalid:TRUE];
}

- (MBAlertDefinition *)definitionForAlertName:(NSString *)alertName throwIfInvalid:(BOOL)doThrow {
    MBAlertDefinition *alertDef = [_cfg definitionForAlertName:alertName];
    if (alertDef == nil && doThrow) {
        NSString *msg = [NSString stringWithFormat: @"Alert with name %@ not defined", alertName];
		@throw [[[NSException alloc]initWithName:@"AlertNotDefined" reason:msg userInfo:nil] autorelease];
    }
	return alertDef;
}

// For now do not raise an exception if an outcome is not defined
-(NSArray *) outcomeDefinitionsForOrigin:(NSString *)originName {
	
	NSArray *lst = [_cfg outcomeDefinitionsForOrigin: originName];
	if(lst == nil || [lst count] == 0) WLog(@"WARNING No outcomes defined for origin %@ ", originName);

	return lst;
}

-(NSArray*) outcomeDefinitionsForOrigin:(NSString*) originName outcomeName:(NSString*) outcomeName {
	return [self outcomeDefinitionsForOrigin:originName outcomeName: outcomeName throwIfInvalid: TRUE];
}

-(NSArray*) outcomeDefinitionsForOrigin:(NSString*) originName outcomeName:(NSString*) outcomeName throwIfInvalid:(BOOL) doThrow {
	NSArray *ocDefs = [_cfg outcomeDefinitionsForOrigin:originName outcomeName:outcomeName];
	if([ocDefs count] == 0 && doThrow) {
		NSString *msg = [NSString stringWithFormat: @"Outcome with originName=%@ outcomeName=%@ not defined", originName, outcomeName];
		@throw [[[NSException alloc]initWithName:@"ActionNotDefined" reason:msg userInfo:nil] autorelease];
	}
	return ocDefs;
}

-(MBConfigurationDefinition*) configuration {
	return _cfg;	
}

@end
