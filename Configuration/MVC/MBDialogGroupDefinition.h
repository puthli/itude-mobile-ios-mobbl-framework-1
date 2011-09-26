//
//  MBDialogGroupDefinition.h
//  Core
//
//  Created by Frank van Eenbergen on 13-10-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBDialogGroupDefinition : MBDefinition {
	NSString *_title;
	NSString *_mode;
	NSString *_icon;
	
	NSMutableDictionary *_children;
	NSMutableArray *_childrenSorted;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* mode;
@property (nonatomic, retain) NSString* icon;

- (NSMutableArray*) children;

@end
