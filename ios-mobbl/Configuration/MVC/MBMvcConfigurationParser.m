/*
 * (C) Copyright ItudeMobile.
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

#import "MBMvcConfigurationParser.h"
#import "MBConfigurationDefinition.h"
#import "MBElementDefinition.h"
#import "MBForEachDefinition.h"
#import "MBForEachDefinition.h"
#import "MBDataManagerService.h"
#import "MBVariableDefinition.h"
#import "DataUtilites.h"

@interface MBMvcConfigurationParser()
- (void) addSystemDocuments:(MBConfigurationDefinition*) conf;
- (void) addAttribute:(MBElementDefinition*) elementDef name:(NSString*) name type:(NSString*) type;
@end

@implementation MBMvcConfigurationParser

@synthesize configAttributes = _configAttributes;
@synthesize documentAttributes = _documentAttributes;
@synthesize elementAttributes = _elementAttributes;
@synthesize attributeAttributes = _attributeAttributes;
@synthesize actionAttributes = _actionAttributes;
@synthesize outcomeAttributes = _outcomeAttributes;
@synthesize pageStackAttributes = _pageStackAttributes;
@synthesize dialogAttributes = _dialogAttributes;
@synthesize pageAttributes = _pageAttributes;
@synthesize alertAttributes = _alertAttributes;
@synthesize panelAttributes = _panelAttributes;
@synthesize forEachAttributes = _forEachAttributes;
@synthesize fieldAttributes = _fieldAttributes;
@synthesize domainAttributes = _domainAttributes;
@synthesize domainValidatorAttributes = _domainValidatorAttributes;
@synthesize variableAttributes = _variableAttributes;


- (id) parseData:(NSData *)data ofDocument:(NSString*) documentName {

    self.configAttributes = [NSArray arrayWithObjects:@"xmlns",nil];
    self.documentAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"dataManager",@"rootElement",@"autoCreate",nil];
    self.elementAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"minOccurs",@"maxOccurs",nil];
    self.attributeAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"type",@"required",@"defaultValue",nil];
    self.actionAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"className",nil];
    self.outcomeAttributes = [NSArray arrayWithObjects:@"xmlns",@"origin",@"name",@"action",@"dialog",@"stack",@"displayMode",@"transitionStyle",@"persist",@"transferDocument",@"preCondition",@"noBackgroundProcessing",@"processingMessage",nil];
    self.pageStackAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"title",@"mode",@"icon",@"groupName",@"position",nil];
	self.dialogAttributes = [NSArray arrayWithObjects:@"xmlns",@"title",@"name",@"icon",@"mode",@"showAs",@"contentType",@"decorator",@"closable",@"stackStrategy",nil];
    self.pageAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"type",@"document",@"title",@"titlePath",@"width",@"height",@"preCondition",@"style",nil];
    self.alertAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"document",@"title",@"titlePath", nil];
    self.panelAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"type",@"style",@"title",@"titlePath",@"width",@"height",@"outcome",@"path",@"preCondition",@"zoomable",nil];
    self.forEachAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"value",@"suppressRowComponent",@"preCondition",nil];
    self.variableAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"expression",nil];
    self.fieldAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"label",@"path",@"type",@"dataType",@"hint",@"required",@"outcome", @"style",@"width",@"height",@"formatMask",@"alignment",@"valueIfNil",@"hidden",@"preCondition",@"custom1",@"custom2",@"custom3",nil];
    self.domainAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"type",@"maxLength",nil];
    self.domainValidatorAttributes = [NSArray arrayWithObjects:@"xmlns",@"name",@"title",@"value",@"lowerBound",@"upperBound",nil];
    
    MBConfigurationDefinition *conf =  [super parseData:data ofDocument: documentName];
    
    if([conf definitionForDocumentName: DOC_SYSTEM_EXCEPTION] == nil) {
        [self addSystemDocuments: conf];
    }
    
    return conf;
}

- (void) dealloc
{
    [_configAttributes release];
    [_documentAttributes release];
    [_elementAttributes release];
    [_attributeAttributes release];
    [_actionAttributes release];
    [_outcomeAttributes release];
    [_pageStackAttributes release];
	[_dialogAttributes release];
    [_pageAttributes release];
    [_alertAttributes release];
    [_panelAttributes release];
    [_forEachAttributes release];
    [_variableAttributes release];
    [_fieldAttributes release];
    [_domainAttributes release];
    [_domainValidatorAttributes release];
    [super dealloc];
}

- (void) addAttribute:(MBElementDefinition*) elementDef name:(NSString*) name type:(NSString*) type {
    MBAttributeDefinition *attributeDef = [[MBAttributeDefinition new] autorelease];
    attributeDef.name = name;
    attributeDef.type = type;
    [elementDef addAttribute: attributeDef];
}

- (BOOL) processElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {

	if ([elementName isEqualToString:@"Configuration"]) { // start config file
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_configAttributes];
        
        MBConfigurationDefinition *confDef = [[MBConfigurationDefinition alloc] init];
		[_stack addObject:confDef];
        _rootConfig = confDef;
		[confDef release];
	}
    else if ([elementName isEqualToString:@"Include"]) { // include
        NSString *name = [attributeDict valueForKey:@"name"];
        
        MBMvcConfigurationParser *parser = [[MBMvcConfigurationParser new] autorelease];
		NSData *data = [NSData dataWithEncodedContentsOfMainBundle: name];
        if(data == nil) @throw [NSException exceptionWithName:@"FileNotFound" reason: name userInfo: nil];
        MBConfigurationDefinition *include = [parser parseData:data ofDocument: name];
        [_rootConfig addAll: include];
	}
	else if ([elementName isEqualToString:@"Document"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_documentAttributes];

		MBDocumentDefinition *docDef = [[MBDocumentDefinition alloc] init];
		docDef.name = [attributeDict valueForKey:@"name"];
		docDef.dataManager = [attributeDict valueForKey:@"dataManager"];
        docDef.rootElement = [attributeDict valueForKey:@"rootElement"];
		docDef.autoCreate = [[attributeDict valueForKey:@"autoCreate"] boolValue];	
        [self notifyProcessed:docDef usingSelector:@selector(addDocument:)];
		[docDef release];
	}
	else if ([elementName isEqualToString:@"Element"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_elementAttributes];

		MBElementDefinition *elementDef = [[MBElementDefinition alloc] init];
		elementDef.name = [attributeDict valueForKey:@"name"];
		elementDef.minOccurs = [[attributeDict valueForKey:@"minOccurs"] intValue];
		elementDef.maxOccurs = [[attributeDict valueForKey:@"maxOccurs"] intValue];
        [self notifyProcessed:elementDef usingSelector:@selector(addElement:)];
		[elementDef release];		
	}
	else if ([elementName isEqualToString:@"Attribute"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_attributeAttributes];

		MBAttributeDefinition *attributeDef = [[MBAttributeDefinition alloc] init];
		attributeDef.name = [attributeDict valueForKey:@"name"];
		attributeDef.type = [attributeDict valueForKey:@"type"];
		attributeDef.defaultValue = [attributeDict valueForKey:@"defaultValue"];
		attributeDef.required = [[attributeDict valueForKey:@"required"] boolValue];	
        [self notifyProcessed:attributeDef usingSelector:@selector(addAttribute:)];
		[attributeDef release];
	}
	else if ([elementName isEqualToString:@"Action"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_actionAttributes];

		MBActionDefinition *actionDef = [[MBActionDefinition alloc] init];
		actionDef.name = [attributeDict valueForKey:@"name"];
		actionDef.className = [attributeDict valueForKey:@"className"];
        [self notifyProcessed:actionDef usingSelector:@selector(addAction:)];
		[actionDef release];
	}
	else if ([elementName isEqualToString:@"Outcome"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_outcomeAttributes];

		MBOutcomeDefinition *outcomeDef = [[MBOutcomeDefinition alloc] init];
		outcomeDef.origin = [attributeDict valueForKey:@"origin"];
		outcomeDef.name = [attributeDict valueForKey:@"name"];
		outcomeDef.action = [attributeDict valueForKey:@"action"];		
		outcomeDef.dialog = [attributeDict valueForKey:@"dialog"];
        outcomeDef.pageStackName = [attributeDict valueForKey:@"stack"];
		outcomeDef.displayMode = [attributeDict valueForKey:@"displayMode"];	
        outcomeDef.transitionStyle = [attributeDict valueForKey:@"transitionStyle"];
		outcomeDef.preCondition = [attributeDict valueForKey:@"preCondition"];		
		outcomeDef.persist = [[attributeDict valueForKey:@"persist"] boolValue];	 
		outcomeDef.transferDocument = [[attributeDict valueForKey:@"transferDocument"] boolValue];	
		outcomeDef.noBackgroundProcessing = [[attributeDict valueForKey:@"noBackgroundProcessing"] boolValue];
        outcomeDef.processingMessage = [attributeDict valueForKey:@"processingMessage"];
        [self notifyProcessed:outcomeDef usingSelector:@selector(addOutcome:)];
		[outcomeDef release];
	}
    else if ([elementName isEqualToString:@"PageStack"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:self.pageStackAttributes];
		MBPageStackDefinition *pageStackDef = [[MBPageStackDefinition alloc] init];
		pageStackDef.name = [attributeDict valueForKey:@"name"];
		pageStackDef.title = [attributeDict valueForKey:@"title"];
        pageStackDef.preCondition = [attributeDict valueForKey:@"preCondition"];

		[self notifyProcessed:pageStackDef usingSelector:@selector(addPageStack:)];
		[pageStackDef release];
	}
	else if ([elementName isEqualToString:@"Dialog"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:self.dialogAttributes];
		MBDialogDefinition *dialogDef = [[MBDialogDefinition alloc] init];
		dialogDef.name = [attributeDict valueForKey:@"name"];
		dialogDef.title = [attributeDict valueForKey:@"title"];	
		dialogDef.mode = [attributeDict valueForKey:@"mode"];	
		dialogDef.iconName = [attributeDict valueForKey:@"icon"];
        dialogDef.showAs = [attributeDict valueForKey:@"showAs"];
        dialogDef.contentType = [attributeDict valueForKey:@"contentType"];
        dialogDef.decorator = [attributeDict valueForKey:@"decorator"];
        dialogDef.stackStrategy = [attributeDict valueForKey:@"stackStrategy"];
        dialogDef.closable = [[attributeDict valueForKey:@"closable"] boolValue];
        dialogDef.preCondition = [attributeDict valueForKey:@"preCondition"];
        [self notifyProcessed:dialogDef usingSelector:@selector(addDialog:)];
		[dialogDef release];
	}
	else if ([elementName isEqualToString:@"Page"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_pageAttributes];

		MBPageDefinition *pageDef = [[MBPageDefinition alloc] init];
		pageDef.name = [attributeDict valueForKey:@"name"];
		pageDef.documentName = [attributeDict valueForKey:@"document"];	
		pageDef.title = [attributeDict valueForKey:@"title"];	
		pageDef.titlePath = [attributeDict valueForKey:@"titlePath"];	
		pageDef.width = [[attributeDict valueForKey:@"width"] intValue];	
		pageDef.height = [[attributeDict valueForKey:@"height"] intValue];	
		pageDef.preCondition = [attributeDict valueForKey:@"preCondition"];	
		pageDef.style = [attributeDict valueForKey:@"style"];
		
		NSString *type = [attributeDict valueForKey:@"type"];
		if(type != nil) {
			if([@"normal" isEqualToString:type]) pageDef.pageType = MBPageTypesNormal;
			else if([@"popup" isEqualToString:type]) pageDef.pageType = MBPageTypesPopup;
			else if([@"error" isEqualToString:type]) pageDef.pageType = MBPageTypesErrorPage;
			else {
                [pageDef release];
                @throw [NSException exceptionWithName:@"InvalidPageType" reason:type userInfo:nil];
            }
		}
			
        [self notifyProcessed:pageDef usingSelector:@selector(addPage:)];
		[pageDef release];
	}
    
    else if ([elementName isEqualToString:@"Alert"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_alertAttributes];
        
        MBAlertDefinition *alertDefinition = [[MBAlertDefinition alloc] init];
        alertDefinition.type = [attributeDict valueForKey:@"type"];
        alertDefinition.documentName = [attributeDict valueForKey:@"document"];	
        alertDefinition.name = [attributeDict valueForKey:@"name"];
        alertDefinition.style = [attributeDict valueForKey:@"style"];
        alertDefinition.title = [attributeDict valueForKey:@"title"];
		alertDefinition.titlePath = [attributeDict valueForKey:@"titlePath"];
        [self notifyProcessed:alertDefinition usingSelector:@selector(addAlert:)];
        [alertDefinition release];
	}
    
	else if ([elementName isEqualToString:@"Panel"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_panelAttributes];

		MBPanelDefinition *panelDef = [[MBPanelDefinition alloc] init];
		panelDef.type = [attributeDict valueForKey:@"type"];
		panelDef.name = [attributeDict valueForKey:@"name"];
		panelDef.style = [attributeDict valueForKey:@"style"];
		panelDef.title = [attributeDict valueForKey:@"title"];	
		panelDef.titlePath = [attributeDict valueForKey:@"titlePath"];
		panelDef.width = [[attributeDict valueForKey:@"width"] intValue];	
		panelDef.height = [[attributeDict valueForKey:@"height"] intValue];
        panelDef.outcomeName = [attributeDict valueForKey:@"outcome"];
        panelDef.path = [attributeDict valueForKey:@"path"];
        panelDef.zoomable = [[attributeDict valueForKey:@"zoomable"] boolValue];
		panelDef.preCondition = [attributeDict valueForKey:@"preCondition"];
        [self notifyProcessed:panelDef usingSelector:@selector(addChild:)];
		[panelDef release];
	}	
	else if ([elementName isEqualToString:@"ForEach"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_forEachAttributes];
		
		MBForEachDefinition *forEachDef = [[MBForEachDefinition alloc] init];
		forEachDef.value = [attributeDict valueForKey:@"value"];
		forEachDef.suppressRowComponent = [[attributeDict valueForKey:@"suppressRowComponent"] boolValue];
		forEachDef.preCondition = [attributeDict valueForKey:@"preCondition"];		
        [self notifyProcessed:forEachDef usingSelector:@selector(addChild:)];
		[forEachDef release];
	}	
	else if ([elementName isEqualToString:@"Variable"]) {
		[self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_variableAttributes];
		
		MBVariableDefinition *variableDef = [[MBVariableDefinition alloc] init];
		variableDef.name = [attributeDict valueForKey:@"name"];
		variableDef.expression = [attributeDict valueForKey:@"expression"];
        [self notifyProcessed:variableDef usingSelector:@selector(addVariable:)];
		[variableDef release];
	}	
	else if ([elementName isEqualToString:@"Field"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_fieldAttributes];

		MBFieldDefinition *fieldDef = [[MBFieldDefinition alloc] init];
		fieldDef.name = [attributeDict valueForKey:@"name"];
		fieldDef.label = [attributeDict valueForKey:@"label"];
		fieldDef.path = [attributeDict valueForKey:@"path"];
		fieldDef.displayType = [attributeDict valueForKey:@"type"];	
		fieldDef.dataType = [attributeDict valueForKey:@"dataType"];
        fieldDef.hint = [attributeDict valueForKey:@"hint"];
		fieldDef.style = [attributeDict valueForKey:@"style"];	
		fieldDef.required = [attributeDict valueForKey:@"required"];	
		fieldDef.outcomeName = [attributeDict valueForKey:@"outcome"];	
		fieldDef.width = [attributeDict valueForKey:@"width"];	
		fieldDef.height = [attributeDict valueForKey:@"height"];	
		fieldDef.formatMask = [attributeDict valueForKey:@"formatMask"];
		fieldDef.alignment = [attributeDict valueForKey:@"alignment"];
		fieldDef.valueIfNil = [attributeDict valueForKey:@"valueIfNil"];
		fieldDef.hidden = [attributeDict valueForKey:@"hidden"];
		fieldDef.preCondition = [attributeDict valueForKey:@"preCondition"];		
		fieldDef.custom1 = [attributeDict valueForKey:@"custom1"];	
		fieldDef.custom2 = [attributeDict valueForKey:@"custom2"];	
		fieldDef.custom3 = [attributeDict valueForKey:@"custom3"];	
        [self notifyProcessed:fieldDef usingSelector:@selector(addChild:)];
		[fieldDef release];
	}
	else if ([elementName isEqualToString:@"Domain"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_domainAttributes];

		MBDomainDefinition *domainDef = [[MBDomainDefinition alloc] init];
		domainDef.name = [attributeDict valueForKey:@"name"];
		domainDef.type = [attributeDict valueForKey:@"type"];
		domainDef.maxLength = [[attributeDict valueForKey:@"maxLength"] asNumber];
        [self notifyProcessed:domainDef usingSelector:@selector(addDomain:)];
		[domainDef release];
	}
	else if ([elementName isEqualToString:@"DomainValidator"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_domainValidatorAttributes];

		MBDomainValidatorDefinition *validatorDef = [[MBDomainValidatorDefinition alloc] init];
		validatorDef.name = [attributeDict valueForKey:@"name"];
		validatorDef.title = [attributeDict valueForKey:@"title"];
		validatorDef.value = [attributeDict valueForKey:@"value"];
		validatorDef.lowerBound = [[attributeDict valueForKey:@"lowerBound"] asNumber];
		validatorDef.upperBound = [[attributeDict valueForKey:@"upperBound"] asNumber];
        [self notifyProcessed:validatorDef usingSelector:@selector(addValidator:)];
		[validatorDef release];
	}
	else
		return NO;
	
	return YES;
}

- (void) didProcessElement:(NSString*)elementName {
	if([elementName isEqualToString:@"Field"])
		[[_stack lastObject] performSelector:@selector(setText:) withObject:_characters];
	
//	else if ([elementName isEqualToString:@"DialogGroup"]) {
//        // TODO: This is going to need refactoring
//		// On iPad, we can have a UISplitViewController in a tab. In XML they are defined as two pageStacks in a Dialog.
//		// This means that the dialogs are automaticly added to a dialogGroup. 
//		// That is why we need to make sure that the pageStacks are also kept loccaly, like on the iPhone, because the local references are used to adress the pageStacks
//		// Thats why we copy them here afther the group has been added.
//		MBDefinition *previousDef = [_stack objectAtIndex:([_stack count]-2)];
//		MBDialogDefinition *dialogDef = [_stack lastObject];
//		for (MBDefinition *def in [dialogDef children]) {
//            [previousDef performSelector:@selector(addPageStack:) withObject:def];
//        }
//	}
	
	if (![elementName isEqualToString:@"Configuration"] && ![elementName isEqualToString:@"Include"]) { // end config file or special case for Include
		[_stack removeLastObject];	
    }
}

- (BOOL) isConcreteElement:(NSString*)element {
	return ([element isEqualToString:@"Configuration"] ||
			[element isEqualToString:@"Include"] ||
			[element isEqualToString:@"Document"] ||
			[element isEqualToString:@"Element"] ||
			[element isEqualToString:@"Attribute"] ||
			[element isEqualToString:@"Action"] ||
			[element isEqualToString:@"Outcome"] ||
			[element isEqualToString:@"Page"] ||
            [element isEqualToString:@"Alert"] ||
			[element isEqualToString:@"PageStack"] ||
			[element isEqualToString:@"Dialog"] ||
			[element isEqualToString:@"ForEach"] ||
			[element isEqualToString:@"Variable"] ||
			[element isEqualToString:@"Panel"] ||
			[element isEqualToString:@"Outcome"] ||
			[element isEqualToString:@"Field"] ||
			[element isEqualToString:@"Domain"] ||
			[element isEqualToString:@"DomainValidator"]);
}

- (BOOL) isIgnoredElement:(NSString*)element {
	return ([element isEqualToString:@"Model"] ||
			[element isEqualToString:@"Dialogs"] ||
			[element isEqualToString:@"Domains"] ||
			[element isEqualToString:@"Documents"] ||
			[element isEqualToString:@"Controller"] ||
			[element isEqualToString:@"Actions"] ||
			[element isEqualToString:@"Wiring"] ||
			[element isEqualToString:@"View"] ||
            [element isEqualToString:@"Alerts"] ||
            [element isEqualToString:@"Pages"]);
}

- (void) addExceptionDocument:(MBConfigurationDefinition*) conf {
    MBDocumentDefinition *docDef = [[MBDocumentDefinition new] autorelease];
    docDef.name = DOC_SYSTEM_EXCEPTION;
    docDef.dataManager = DATA_HANDLER_MEMORY;
    docDef.autoCreate = TRUE;
    
    MBElementDefinition *elementDef = [[MBElementDefinition new] autorelease];
    elementDef.name = @"Exception";
    elementDef.minOccurs = 1;
	
    [docDef addElement: elementDef];
    [self addAttribute: elementDef name: @"name" type: @"string"];
    [self addAttribute: elementDef name: @"description" type: @"string"];
    [self addAttribute: elementDef name: @"origin" type: @"string"];
    [self addAttribute: elementDef name: @"outcome" type: @"string"];
    [self addAttribute: elementDef name: @"path" type: @"string"];
    [self addAttribute: elementDef name: @"type" type: @"string"];
	
	MBElementDefinition *stackLine = [[MBElementDefinition new] autorelease];
    stackLine.name = @"Stackline";
    stackLine.minOccurs = 0;
    [self addAttribute: stackLine name: @"line" type: @"string"];
    [elementDef addElement: stackLine];
	
    [conf addDocument: docDef];
}

-(void) addEmptyDocument:(MBConfigurationDefinition*) conf {
	MBDocumentDefinition *docDef = [[MBDocumentDefinition new] autorelease];
    docDef.name = DOC_SYSTEM_EMPTY;
    docDef.dataManager = DATA_HANDLER_MEMORY;
    docDef.autoCreate = TRUE;
    
    MBElementDefinition *elementDef = [[MBElementDefinition new] autorelease];
    elementDef.name = @"Empty";
    elementDef.minOccurs = 1;
    [docDef addElement: elementDef];
    [conf addDocument: docDef];
}

-(void) addLanguageDocument:(MBConfigurationDefinition*) conf {
	MBDocumentDefinition *docDef = [[MBDocumentDefinition new] autorelease];
    docDef.name = DOC_SYSTEM_LANGUAGE;
    docDef.dataManager = DATA_HANDLER_MEMORY;
    docDef.autoCreate = TRUE;
    
    MBElementDefinition *elementDef = [[MBElementDefinition new] autorelease];
    elementDef.name = @"Text";
    [self addAttribute: elementDef name: @"key" type: @"string"];
    [self addAttribute: elementDef name: @"value" type: @"string"];
    elementDef.minOccurs = 0;
    [docDef addElement: elementDef];
    [conf addDocument: docDef];
}

-(void) addPropertiesDocument:(MBConfigurationDefinition*) conf {
	MBDocumentDefinition *docDef = [[MBDocumentDefinition new] autorelease];
    docDef.name = DOC_SYSTEM_PROPERTIES;
    docDef.dataManager = DATA_HANDLER_SYSTEM;
    docDef.autoCreate = TRUE;
    
    MBElementDefinition *elementDef = [[MBElementDefinition new] autorelease];
    elementDef.minOccurs = 1;
    elementDef.name = @"System";
	MBElementDefinition *propDef = [[MBElementDefinition new] autorelease];
    propDef.minOccurs = 0;
    propDef.name = @"Property";
    [self addAttribute: propDef name: @"name" type: @"string"];
    [self addAttribute: propDef name: @"value" type: @"string"];
	[elementDef addElement:propDef];
    [docDef addElement: elementDef];
	
	elementDef = [[MBElementDefinition new] autorelease];
    elementDef.minOccurs = 1;
    elementDef.name = @"Application";
	propDef = [[MBElementDefinition new] autorelease];
    propDef.minOccurs = 0;
    propDef.name = @"Property";
    [self addAttribute: propDef name: @"name" type: @"string"];
    [self addAttribute: propDef name: @"value" type: @"string"];
	[elementDef addElement:propDef];
	
    [docDef addElement: elementDef];
    [conf addDocument: docDef];
}

-(void) addDeviceDocument:(MBConfigurationDefinition*) conf {
	MBDocumentDefinition *docDef = [[MBDocumentDefinition new] autorelease];
    docDef.name = @"DeviceState";
    docDef.dataManager = DATA_HANDLER_FILE;
    docDef.autoCreate = TRUE;
    
    MBElementDefinition *elementDef = [[MBElementDefinition new] autorelease];
    elementDef.minOccurs = 1;
    elementDef.name = @"Device";
    [self addAttribute: elementDef name: @"identifier" type: @"string"];
    [docDef addElement: elementDef];
    [conf addDocument: docDef];
}

- (void) addSystemDocuments:(MBConfigurationDefinition*) conf {
	[self addExceptionDocument: conf];
	[self addEmptyDocument: conf];
	[self addPropertiesDocument: conf];
	[self addLanguageDocument: conf];
	[self addDeviceDocument: conf];
}

@end
