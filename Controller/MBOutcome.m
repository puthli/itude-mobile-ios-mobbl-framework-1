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

#import "MBOutcome.h"
#import "MBOutcomeDefinition.h"
#import "MBDataManagerService.h"
#import "MBConfigurationDefinition.h"

@interface MBOutcome () {
    BOOL _transferDocumentSet;
}

@end

@implementation MBOutcome

@synthesize originName = _originName;
@synthesize outcomeName = _outcomeName;
@synthesize dialogName = _dialogName;
@synthesize originDialogName = _originDialogName;
@synthesize displayMode = _displayMode;
@synthesize transitioningStyle = _transitioningStyle;
@synthesize document = _document;
@synthesize path = _path;
@synthesize persist = _persist;
@synthesize preCondition = _preCondition;
@synthesize noBackgroundProcessing = _noBackgroundProcessing;
@synthesize transferDocument = _transferDocument;
@synthesize transferDocumentSet = _transferDocumentSet;

-(id) initWithOutcome:(MBOutcome*) outcome {
    if(self = [super init]) {
        self.originName = outcome.originName;
        self.outcomeName = outcome.outcomeName;
        self.originDialogName = outcome.originDialogName;
        self.dialogName = outcome.dialogName;
        self.displayMode = outcome.displayMode;
        self.transitioningStyle = outcome.transitioningStyle;
        self.document = outcome.document;
        self.path = outcome.path;
        self.persist = outcome.persist;
        _transferDocumentSet = outcome.transferDocumentSet;
        self.transferDocument = outcome.transferDocument;
        self.preCondition = outcome.preCondition;
        self.noBackgroundProcessing = outcome.noBackgroundProcessing;
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
        self.transitioningStyle = definition.transitioningStyle;
		self.persist = definition.persist;
		self.transferDocument = definition.transferDocument;
		self.noBackgroundProcessing = definition.noBackgroundProcessing;
		self.document = nil;
		self.document = nil;
		self.path = nil;	
        self.preCondition = definition.preCondition;
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
	return [NSString stringWithFormat:@"Outcome: dialog=%@ originName=%@ outcomeName=%@ path=%@ persist=%@ displayMode=%@ transitioningStyle=%@ preCondition=%@ noBackgroundProsessing=%@ transferDocument=%@", 
            _dialogName, _originName, _outcomeName, _path,  _persist?@"TRUE":@"FALSE", _displayMode, _transitioningStyle, _preCondition, _noBackgroundProcessing?@"TRUE":@"FALSE", _transferDocument ? @"TRUE" : @"FALSE"];
}

-(void)setTransferDocument:(BOOL)transferDocument {
    _transferDocument = transferDocument;
    _transferDocumentSet = true;
}


@end
