//
//  MBElementContainer.h
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

@class MBElement;
@class MBDocument;

@interface MBElementContainer : NSObject {
	NSMutableDictionary *_elements; // Dictionary of lists of elements
	MBElementContainer *_parent;
}

@property (nonatomic, assign) MBElementContainer *parent;

- (id) init;
- (MBElement*) createElementWithName: (NSString*) name;
- (MBElement*) createElementWithName: (NSString*) name atIndex:(NSInteger)index;
- (void) deleteElementWithName: (NSString*) name atIndex:(int) index;
- (void) deleteAllChildElements;
- (void) addElement: (MBElement*) element;
- (void) addElement: (MBElement*) element atIndex:(NSInteger)index;
- (NSMutableDictionary*) elements;
- (id) valueForPath:(NSString *)path;
- (id) valueForPath:(NSString*)path translatedPathComponents:(NSMutableArray*) translatedPathComponents;
- (void) setValue:(NSString*)value forPath:(NSString *)path;
- (NSMutableArray*) elementsWithName: (NSString*) name;
- (id) definition;
- (id) valueForPathComponents:(NSMutableArray*)pathComponents withPath: (NSString*) originalPath nillIfMissing:(BOOL) nillIfMissing translatedPathComponents:(NSMutableArray*)translatedPathComponents;
- (NSString*) name;
- (NSMutableDictionary*) sharedContext;
- (void) setSharedContext:(NSMutableDictionary*) sharedContext;
- (MBDocument*) getDocumentFromSharedContext:(NSString*) documentName;
- (void) registerDocumentWithSharedContext:(MBDocument*) document;
- (MBDocument*) document;
- (NSString*) documentName;
- (NSString*) evaluateExpression:(NSString*) expression;
- (NSString*) evaluateExpression:(NSString*) expression currentPath:(NSString*) currentPath;
- (NSString*) uniqueId;
- (void) sortElements:(NSString*) elementName onAttributes:(NSString*) attributeNames;

@end
