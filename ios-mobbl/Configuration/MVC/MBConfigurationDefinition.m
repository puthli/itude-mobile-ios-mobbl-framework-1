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
		_pageStacks = [NSMutableDictionary new];
		_dialogGroups = [NSMutableDictionary new];
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
	[_pageStacks release];
    [_dialogGroups release];
	[_pageTypes release];
    [_alerts release];
	[super dealloc];
}

- (void) addAll:(MBConfigurationDefinition*) otherConfig {
	for(MBDocumentDefinition *def in [otherConfig.documents allValues]) [self addDocument:def];
	for(MBDomainDefinition *def in [otherConfig.domains allValues]) [self addDomain:def];
	for(MBActionDefinition *def in [otherConfig.actions allValues]) [self addAction:def];
	for(MBOutcomeDefinition *def in otherConfig.outcomes) [self addOutcome:def];
	for(MBPageStackDefinition *def in [otherConfig.pageStacks allValues]) [self addPageStack:def];
	for(MBDialogGroupDefinition *def in [otherConfig.dialogGroups allValues]) [self addDialogGroup:def];
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
    
    // Build pageStacks
    [result appendFormat: @"%*s<PageStacks>\n", level+4, ""];
	for (MBPageStackDefinition* pageStack in [_pageStacks allValues])
		[result appendString: [pageStack asXmlWithLevel:level+6]];
	[result appendFormat: @"%*s</PageStacks>\n", level+4, ""];
	
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
		WLog(@"Domain definition overridden: multiple definitions for domain with name %@", domain.name);
	}
	[_domainTypes setValue:domain forKey:domain.name];
}

- (void) addDocument:(MBDocumentDefinition*)document {
    if([_documentTypes valueForKey:document.name] != nil && ![document.name isEqualToString:DOC_SYSTEM_EXCEPTION]) {
		WLog(@"Document definition overridden: multiple definitions for document with name %@", document.name);
	}
	[_documentTypes setValue:document forKey:document.name];
}

- (void) addAction:(MBActionDefinition*)action {
    if([_actionTypes valueForKey:action.name] != nil) {
		WLog(@"Action definition overridden: multiple definitions for action with name %@", action.name);
	}
	[_actionTypes setValue:action forKey:action.name];
}

- (void) addOutcome:(MBOutcomeDefinition*)outcome {
	[_outcomeTypes addObject:outcome];
}

- (void) addPageStack:(MBPageStackDefinition*)pageStack {
    if([_pageStacks valueForKey:pageStack.name] != nil) {
		WLog(@"PageStack definition overridden: multiple definitions for pageStack with name %@", pageStack.name);
	}
	[_pageStacks setObject:pageStack forKey:pageStack.name];
}

- (void) addDialogGroup:(MBDialogGroupDefinition*)dialogGroup {
    if([_dialogGroups valueForKey:dialogGroup.name] != nil) {
		WLog(@"DialogGroup definition overridden: multiple definitions for dialogGroup with name %@", dialogGroup.name);
	}
	[_dialogGroups setObject:dialogGroup forKey:dialogGroup.name];
}

- (void) addPage:(MBPageDefinition*)page {
    if([_pageTypes valueForKey:page.name] != nil) {
		WLog(@"Page definition overridden: multiple definitions for page with name %@", page.name);
	}
	[_pageTypes setValue:page forKey:page.name];
}

- (void)addAlert:(MBAlertDefinition *)alert {
    if ([_alerts valueForKey:alert.name] != nil) {
        WLog(@"Alert definition overridden: multiple definitions for alert with name %@",alert.name);
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

-(MBPageStackDefinition *) definitionForPageStackName:(NSString *)pageStackName {
	return [_pageStacks objectForKey:pageStackName];
}

-(MBDialogGroupDefinition *) definitionForDialogGroupName:(NSString *)dialogGroupName {
	return [_dialogGroups objectForKey:dialogGroupName];
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

-(NSMutableDictionary*) pageStacks {
	return _pageStacks;	
}

-(NSMutableDictionary*) dialogGroups {
	return _dialogGroups;	
}

-(NSMutableDictionary*) pages {
	return _pageTypes;	
}

-(NSMutableDictionary*)alerts {
    return _alerts;
}

@end
