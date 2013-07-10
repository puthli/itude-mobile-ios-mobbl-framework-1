//
//  MBOutcome.m
//  Core
//
//  Created by Wido on 5/24/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBOutcome.h"
#import "MBOutcomeDefinition.h"
#import "MBDataManagerService.h"
#import "MBConfigurationDefinition.h"

@implementation MBOutcome

@synthesize originName = _originName;
@synthesize outcomeName = _outcomeName;
@synthesize dialogName = _dialogName;
@synthesize originDialogName = _originDialogName;
@synthesize displayMode = _displayMode;
@synthesize transitionStyle = _transitionStyle;
@synthesize document = _document;
@synthesize path = _path;
@synthesize persist = _persist;
@synthesize transferDocument = _transferDocument;
@synthesize preCondition = _preCondition;
@synthesize noBackgroundProcessing = _noBackgroundProcessing;
@synthesize processingMessage = _processingMessage;

-(id) initWithOutcome:(MBOutcome*) outcome {
    if(self = [super init]) {
        self.originName = outcome.originName;
        self.outcomeName = outcome.outcomeName;
        self.originDialogName = outcome.originDialogName;
        self.dialogName = outcome.dialogName;
        self.displayMode = outcome.displayMode;
        self.transitionStyle = outcome.transitionStyle;
        self.document = outcome.document;
        self.path = outcome.path;
        self.persist = outcome.persist;
        self.transferDocument = outcome.transferDocument;
        self.preCondition = outcome.preCondition;
        self.noBackgroundProcessing = outcome.noBackgroundProcessing;
        self.processingMessage = outcome.processingMessage;
    }
    return self;
}

-(id) initWithOutcomeName:(NSString *)outcomeName
				 document:(MBDocument *)document {
	if(self = [super init]) {
		self.outcomeName = outcomeName;
		self.document = document;
	}
	return self;
}

-(id) initWithOutcomeName:(NSString *)outcomeName
				 document:(MBDocument *)document 
			   dialogName:(NSString*) dialogName {
	if(self = [self initWithOutcomeName: outcomeName document: document]) {
		self.dialogName = dialogName;
	}
	return self;
}

-(id) initWithOutcomeDefinition:(MBOutcomeDefinition*) definition {
	if(self = [super init]) {
		self.originName = definition.origin;
		self.outcomeName = definition.name;
		self.dialogName = definition.dialog;
		self.displayMode = definition.displayMode;
        self.transitionStyle = definition.transitionStyle;
		self.persist = definition.persist;
		self.transferDocument = definition.transferDocument;
		self.noBackgroundProcessing = definition.noBackgroundProcessing;
		self.document = nil;
		self.document = nil;
		self.path = nil;	
        self.preCondition = definition.preCondition;
        self.processingMessage = definition.processingMessage;
	}
	return self;
}

-(void) dealloc {
	[_originName release];
	[_outcomeName release];
	[_dialogName release];
	[_document release];
	[_path release];
	[_preCondition release];
    [_transitionStyle release];
    [_processingMessage release];
	[super dealloc];
}

-(BOOL) isPreConditionValid {

	if(self.preCondition == nil) return TRUE;
	MBDocument *doc = self.document;
	
	if(doc == nil) doc = [[MBDataManagerService sharedInstance]loadDocument:DOC_SYSTEM_EMPTY];
	NSString *result = [doc evaluateExpression:_preCondition];
	result = [result uppercaseString];
	if([@"1" isEqualToString:result] || [@"YES" isEqualToString:result] || [@"TRUE" isEqualToString:result]) return TRUE;
	if([@"0" isEqualToString:result] || [@"NO" isEqualToString:result]  || [@"FALSE" isEqualToString:result]) return FALSE;
	
	NSString *msg = [NSString stringWithFormat:@"Expression of outcome with origin=%@ name=%@ preCondition=%@ is not boolean (%@)", _originName, _outcomeName, _preCondition, result];
	@throw [NSException exceptionWithName:@"ExpressionNotBoolean" reason:msg userInfo: nil];
}

-(NSString *) description {
	return [NSString stringWithFormat:@"Outcome: dialog=%@ originName=%@ outcomeName=%@ path=%@ persist=%@ displayMode=%@ transitionStyle=%@ preCondition=%@ noBackgroundProsessing=%@ processingMessage=%@", 
            _dialogName, _originName, _outcomeName, _path,  _persist?@"TRUE":@"FALSE", _displayMode, _transitionStyle, _preCondition, _noBackgroundProcessing?@"TRUE":@"FALSE", _processingMessage];
}

@end
