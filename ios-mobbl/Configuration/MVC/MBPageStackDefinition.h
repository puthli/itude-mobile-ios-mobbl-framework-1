//
//  MBPageStackDefinition.h
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBPageStackDefinition : MBDefinition {
	NSString *_title;
	NSString *_mode;
	NSString *_icon;
	NSString *_groupName;
	NSString *_position;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* mode;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* groupName;
@property (nonatomic, retain) NSString* position;

@end
