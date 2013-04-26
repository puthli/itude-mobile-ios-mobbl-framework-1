//
//  MBNavigateDefinition.h
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"

@interface MBOutcomeDefinition : MBDefinition {
	NSString *_origin;
	NSString *_action;
	NSString *_dialog;
	NSString *_displayMode;
    NSString *_transitionStyle;
	NSString *_preCondition;
	BOOL _persist;
	BOOL _transferDocument;
	BOOL _noBackgroundProcessing;
}

@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSString *pageStackName;
@property (nonatomic, retain) NSString *displayMode;
@property (nonatomic, retain) NSString *transitionStyle;
@property (nonatomic, retain) NSString *preCondition;
@property (nonatomic, assign) BOOL persist;
@property (nonatomic, assign) BOOL transferDocument;
@property (nonatomic, assign) BOOL noBackgroundProcessing;

@end
