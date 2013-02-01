//
//  MBContainerDefinition.h
//  Core
//
//  Created by Wido on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBFieldDefinition.h"
#import "MBDefinition.h"
#import "MBConditionalDefinition.h"

@interface MBPanelDefinition : MBConditionalDefinition {
	NSString *_type;
	NSString *_style;
	NSString *_title;
	NSString *_titlePath;
    BOOL _zoomable;
	int _width;
	int _height;
	NSMutableArray *_children;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titlePath;
@property (nonatomic, assign) BOOL zoomable; // currently only for panels of type LIST
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

- (void) addChild:(MBDefinition*)child;

@end
