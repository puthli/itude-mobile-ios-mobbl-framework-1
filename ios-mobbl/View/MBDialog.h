//
//  MBDialog.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/26/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBComponent.h"

@class MBDialogDefinition;

@interface MBDialog : MBComponent

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *iconName;
@property(nonatomic,retain) NSString *dialogMode;
@property(nonatomic,retain) NSString *contentType;
@property(nonatomic,retain) NSString *decorator;
@property(nonatomic,retain) NSString *stackStrategy;
@property(nonatomic,retain) NSMutableArray *pageStacks;

- (id)initWithDefinition:(MBDialogDefinition *)definition;

@end
