//
//  MBComponent.h
//  Core
//
//  Created by Wido 5/21/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"
#import "MBOutcome.h"
#import "MBValueChangeListenerProtocol.h"
#import "MBTypes.h"

@class MBViewController;
@class MBPage;
@class MBComponentContainer;

@interface MBComponent : NSObject {
	
@private
	MBDefinition *_definition;
	MBComponentContainer *_parent;
	NSString *_style;
	NSDictionary *_viewData;
    BOOL _markedForDestruction;
	int _leftInset;
	int _rightInset;
	int _topInset;
	int _bottomInset;
}

@property (nonatomic, assign) MBDefinition *definition;
@property (nonatomic, assign) MBComponentContainer *parent;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, assign) BOOL markedForDestruction;
@property (nonatomic, assign) int leftInset;
@property (nonatomic, assign) int rightInset;
@property (nonatomic, assign) int topInset;
@property (nonatomic, assign) int bottomInset;

- (id) initWithDefinition:(id)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent;
- (UIView*) buildViewWithMaxBounds:(CGRect) bounds forParent:(UIView*)parent viewState:(MBViewState) viewState;
- (void) handleOutcome:(MBOutcome *)outcome;
- (void) handleOutcome:(NSString *)outcomeName withPathArgument:(NSString*) path;
- (NSString*) substituteExpressions:(NSString*) expression;
- (NSString *) componentDataPath;
- (NSString *) absoluteDataPath;
- (NSString *) evaluatedDataPath;
- (MBDocument*) document;
- (MBPage*) page;
- (BOOL) resignFirstResponder;
- (BOOL) resignFirstResponder:(UIView*) view;
- (void) setupKeyboardHiding:(UIView*) view;
- (void) setViewData:(id) value forKey:(NSString*) key;
- (id) viewDataForKey:(NSString*) key;
- (NSString*) evaluateExpression:(NSString*) variableName;
- (NSString *) asXmlWithLevel:(int)level;
- (NSString*) attributeAsXml:(NSString*)name withValue:(id) attrValue;
- (void) translatePath;
- (void) registerViewController:(UIViewController*) controller;
- (NSMutableArray*) descendantsOfKind:(Class) clazz;
- (NSMutableArray*) descendantsOfKind:(Class) clazz filterUsingSelector:(SEL) selector havingValue:(id) value;
- (NSMutableArray*) childrenOfKind:(Class) clazz;
- (NSMutableArray*) childrenOfKind:(Class) clazz filterUsingSelector:(SEL) selector havingValue:(id) value;
- (id) firstDescendantOfKind:(Class) clazz; 
- (id) firstDescendantOfKind:(Class) clazz filterUsingSelector:(SEL) selector havingValue:(id) value;
- (id) firstChildOfKind:(Class) clazz;
- (id) firstChildOfKind:(Class) clazz filterUsingSelector:(SEL) selector havingValue:(id) value;
- (void) registerValueChangeListener:(id<MBValueChangeListenerProtocol>) listener forPath:(NSString*) path;
- (void) unregisterValueChangeListener:(id<MBValueChangeListenerProtocol>) listener;
- (void) unregisterValueChangeListener:(id<MBValueChangeListenerProtocol>) listener forPath:(NSString*) path;
- (BOOL) notifyValueWillChange:(NSString*) value originalValue:(NSString*) currentValue forPath:(NSString*) path;
- (void) notifyValueChanged:(NSString*) value originalValue:(NSString*) currentValue forPath:(NSString*) path;
- (NSString*) name;
@end
