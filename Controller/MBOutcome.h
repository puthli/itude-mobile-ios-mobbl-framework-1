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
