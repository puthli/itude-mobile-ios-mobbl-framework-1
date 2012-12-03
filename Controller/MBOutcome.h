//
//  MBOutcome.h
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBDocument.h"

@class MBOutcomeDefinition;

@interface MBOutcome : NSObject {
	NSString *_originName;
	NSString *_outcomeName;
	NSString *_dialogName;
	NSString *_originDialogName;
	NSString *_displayMode;
    NSString *_transitioningStyle;
	NSString *_path;
	BOOL _persist;
	BOOL _transferDocument;
	BOOL _noBackgroundProcessing;
	MBDocument *_document;
	NSString *_preCondition;
}

@property (nonatomic, retain) NSString *originName;
@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *dialogName;
@property (nonatomic, retain) NSString *originDialogName;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *displayMode;
@property (nonatomic, retain) NSString *transitioningStyle;
@property (nonatomic, retain) NSString *preCondition;
@property (nonatomic, retain) MBDocument *document;
@property (nonatomic, assign) BOOL persist;
@property (nonatomic, assign) BOOL transferDocument;
@property (nonatomic, assign) BOOL noBackgroundProcessing;
@property (nonatomic, assign, readonly) BOOL transferDocumentSet;

-(id) initWithOutcome:(MBOutcome*) outcome;
-(id) initWithOutcomeDefinition:(MBOutcomeDefinition*) definition;

-(id) initWithOutcomeName:(NSString *)outcomeName
				 document:(MBDocument *)document;

-(id) initWithOutcomeName:(NSString *)outcomeName
				 document:(MBDocument *)document
			   dialogName:(NSString*) dialogName;

-(BOOL) isPreConditionValid;

@end
