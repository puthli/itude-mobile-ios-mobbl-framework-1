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
	int _width;
	int _height;
    NSString *_outcomeName;
    NSString *_path;
	NSMutableArray *_children;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titlePath;
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *path;

- (void) addChild:(MBDefinition*)child;

@end
