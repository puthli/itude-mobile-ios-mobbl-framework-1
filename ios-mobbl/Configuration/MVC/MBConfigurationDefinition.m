//
//  MBConfigurationDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBMacros.h"
#import "MBConfigurationDefinition.h"

@implementation MBConfigurationDefinition

- (id) init {
	if (self = [super init]) {
		_domainTypes = [NSMutableDictionary new];
		_documentTypes = [NSMutableDictionary new];
		_actionTypes = [NSMutableDictionary new];
		_outcomeTypes = [NSMutableArray new];
		_dialogs = [NSMutableDictionary new];
		_pageTypes = [NSMutableDictionary new];
        _alerts = [NSMutableDictionary new];
	}
	return self;
}

- (void) dealloc {
	[_domainTypes release];
	[_documentTypes release];
	[_actionTypes release];
	[_outcomeTypes release];
    [_dialogs release];
	[_pageTypes release];
    [_alerts release];
	[super dealloc];
}

- (void) addAll:(MBConfigurationDefinition*) otherConfig {
	for(MBDocumentDefinition *def in [otherConfig.documents allValues]) [self addDocument:def];
	for(MBDomainDefinition *def in [otherConfig.domains allValues]) [self addDomain:def];
	for(MBActionDefinition *def in [otherConfig.actions allValues]) [self addAction:def];
	for(MBOutcomeDefinition *def in otherConfig.outcomes) [self addOutcome:def];
	for(MBDialogDefinition *def in [otherConfig.dialogs allValues]) [self addDialog:def];
	for(MBPageDefinition *def in [otherConfig.pages allValues]) [self addPage:def];
    for(MBAlertDefinition *def in [otherConfig.alerts allValues]) [self addAlert:def];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Configuration>\n", level, ""];
	// ===== Model =====
    [result appendFormat: @"%*s<Model>\n", level+2, ""];
	[result appendFormat: @"%*s<Domains>\n", level+4, ""];
	for (MBDomainDefinition* domain in [_domainTypes allValues])
		[result appendString: [domain asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</Domains>\n", level+4, ""];
	[result appendFormat: @"%*s<Documents>\n", level+4, ""];
	for (MBDocumentDefinition* document in [_documentTypes allValues])
		[result appendString: [document asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</Documents>\n", level+4, ""];
	[result appendFormat: @"%*s</Model>\n", level+2, ""];
    // ===== Model =====
    
    // ===== Controller =====
	[result appendFormat: @"%*s<Controller>\n", level+2, ""];
	[result appendFormat: @"%*s<Actions>\n", level+4, ""];
	for (MBActionDefinition* action in [_actionTypes allValues])
		[result appendString: [action asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</Actions>\n", level+4, ""];
	[result appendFormat: @"%*s<Wiring>\n", level+4, ""];
	for (MBOutcomeDefinition* outcome in _outcomeTypes)
		[result appendString: [outcome asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</Wiring>\n", level+4, ""];
	[result appendFormat: @"%*s</Controller>\n", level+2, ""];
    // ===== Controller =====

    // ===== View =====
	[result appendFormat: @"%*s<View>\n", level+2, ""];
    
    // Build Dialogs
    [result appendFormat: @"%*s<Dialogs>\n", level+4, ""];
	for (MBDialogDefinition* dialog in [_dialogs allValues])
		[result appendString: [dialog asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</Dialogs>\n", level+4, ""];
	
    // Pages
    for (MBPageDefinition* page in [_pageTypes allValues])
		[result appendString: [page asXmlWithLevel:level+4]];
    
    // Alerts
    [result appendFormat: @"%*s<Alerts>\n", level+4, ""];
    for (MBAlertDefinition *alert in [_alerts allValues]) 
        [result appendString:[alert asXmlWithLevel:level+6]];
    [result appendFormat: @"%*s</Alerts>\n", level+4, ""];
	[result appendFormat: @"%*s</View>\n", level+2, ""];
    // ===== View =====
    
	[result appendFormat: @"%*s</Configuration>\n", level, ""];

	return result;
}

- (void) addDomain:(MBDomainDefinition*)domain {
    if([_domainTypes valueForKey:domain.name] != nil) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Domain" withName:domain.name];
	}
	[_domainTypes setValue:domain forKey:domain.name];
}

- (void) addDocument:(MBDocumentDefinition*)document {
    if([_documentTypes valueForKey:document.name] != nil && ![document.name isEqualToString:DOC_SYSTEM_EXCEPTION]) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Document" withName:document.name];
	}
	[_documentTypes setValue:document forKey:document.name];
}

- (void) addAction:(MBActionDefinition*)action {
    if([_actionTypes valueForKey:action.name] != nil) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Action" withName:action.name];
	}
	[_actionTypes setValue:action forKey:action.name];
}

- (void) addOutcome:(MBOutcomeDefinition*)outcome {
	[_outcomeTypes addObject:outcome];
}

- (void) addDialog:(MBDialogDefinition*)dialog {
    if([_dialogs valueForKey:dialog.name] != nil) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Dialog" withName:dialog.name];
	}
	[_dialogs setObject:dialog forKey:dialog.name];
}

- (void) addPage:(MBPageDefinition*)page {
    if([_pageTypes valueForKey:page.name] != nil) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Page" withName:page.name];
	}
	[_pageTypes setValue:page forKey:page.name];
}

- (void)addAlert:(MBAlertDefinition *)alert {
    if ([_alerts valueForKey:alert.name] != nil) {
        [self logDefinitionOverriddenWarningForDefinitionType:@"Alert" withName:alert.name];
    }
    [_alerts setValue:alert forKey:alert.name];
}

-(MBDomainDefinition *) definitionForDomainName:(NSString *)domainName {
	return [_domainTypes objectForKey:domainName];
}

-(MBPageDefinition*) definitionForPageName:(NSString*) name {
	return [_pageTypes objectForKey:name];
}

-(MBActionDefinition *) definitionForActionName:(NSString *)actionName {
	return [_actionTypes objectForKey:actionName];
}

-(MBDialogDefinition *) definitionForDialogName:(NSString *)dialogName {
	return [_dialogs objectForKey:dialogName];
}

-(MBDocumentDefinition *) definitionForDocumentName:(NSString *)documentName {
	return [_documentTypes objectForKey:documentName];
}

- (MBAlertDefinition *)definitionForAlertName:(NSString *)alertName {
    return [_alerts objectForKey:alertName];
}

-(NSArray*) outcomeDefinitionsForOrigin:(NSString *)originName {
	NSMutableArray *result = [[NSMutableArray alloc]init];
	
	for(MBOutcomeDefinition* oc in _outcomeTypes)
	{
		if([oc.origin isEqualToString: originName] || [oc.origin isEqualToString:@"*"]) [result addObject: oc];
	}
	[result autorelease];
    return result;
}

-(NSArray*) outcomeDefinitionsForOrigin:(NSString*) originName outcomeName:(NSString*) outcomeName {
	NSMutableArray *result = [[[NSMutableArray alloc]init] autorelease];
	
	// First look for specific matches
	for(MBOutcomeDefinition* oc in _outcomeTypes)
	{
		if([oc.origin isEqualToString: originName] && [oc.name isEqualToString:outcomeName]) [result addObject: oc];
	}
	
	// If there are no specific matches; and there are wildcard matches (outcomeName matches and origin='*') then add these:
	if([result count] == 0) {
		for(MBOutcomeDefinition* oc in _outcomeTypes)
		{
			if([oc.origin isEqualToString:@"*"] && [oc.name isEqualToString:outcomeName]) [result addObject: oc];
		}
	}
	return result;
}

-(NSMutableDictionary*) domains {
	return _domainTypes;	
}

-(NSMutableDictionary*) documents {
	return _documentTypes;	
}

-(NSMutableDictionary*) actions {
	return _actionTypes;	
}

-(NSMutableArray*) outcomes {
	return _outcomeTypes;	
}

-(NSMutableDictionary*) dialogs {
	return _dialogs;	
}

-(NSMutableDictionary*) pages {
	return _pageTypes;	
}

-(NSMutableDictionary*)alerts {
    return _alerts;
}

#pragma mark -
#pragma mark Helpers

- (void)logDefinitionOverriddenWarningForDefinitionType:(NSString *)definitionType withName:(NSString *)name {
    WLog(@"%@ definition overridden: multiple definitions for %@ with name %@",definitionType, definitionType, name);
}

@end
