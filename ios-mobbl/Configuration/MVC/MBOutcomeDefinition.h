//
//  MBNavigateDefinition.h
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"

@interface MBOutcomeDefinition : MBDefinition

@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSString *dialog;
@property (nonatomic, retain) NSString *pageStackName;
@property (nonatomic, retain) NSString *displayMode;
@property (nonatomic, retain) NSString *transitionStyle;
@property (nonatomic, retain) NSString *preCondition;
@property (nonatomic, retain) NSString *processingMessage;
@property (nonatomic, assign) BOOL persist;
@property (nonatomic, assign) BOOL transferDocument;
@property (nonatomic, assign) BOOL noBackgroundProcessing;

@end
