//
//  MBDocumentDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBElementDefinition.h"
#import "MBDefinition.h"
@class MBDocument;

@interface MBDocumentDefinition : MBDefinition {
	NSMutableArray *_elementsSorted;
	NSMutableDictionary *_elements;
	NSString *_dataManager;
	BOOL _autoCreate;
}

- (void) addElement:(MBElementDefinition*)element;
- (BOOL) isValidChild: (NSString*) elementName;
- (NSMutableArray*) children;
- (MBElementDefinition*) childWithName:(NSString*) elementName;
- (MBElementDefinition*) elementWithPath:(NSString*) path;
- (MBAttributeDefinition*) attributeWithPath:(NSString*) path;
- (MBDocument*) createDocument;

@property (nonatomic, retain) NSString* dataManager;
@property (nonatomic, assign) BOOL autoCreate;
@end
