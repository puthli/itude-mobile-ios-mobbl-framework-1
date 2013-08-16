//
//  MBDialogDefinition.h
//  Core
//
//  Created by Frank van Eenbergen on 13-10-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBConditionalDefinition.h"
@class MBPageStackDefinition;

@interface MBDialogDefinition : MBConditionalDefinition

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *mode;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *showAs;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *decorator;
@property (nonatomic, retain) NSString *stackStrategy;
@property (nonatomic, retain) NSMutableArray *pageStacks;

- (void) addPageStack:(MBPageStackDefinition*)child;

@end
