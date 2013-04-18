//
//  MBForEachDefinition.h
//  Core
//
//  Created by Robin Puthli on 5/21/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBForEachDefinition.h"
#import "MBDefinition.h"
#import "MBVariableDefinition.h"
#import "MBConditionalDefinition.h"

@interface MBForEachDefinition : MBConditionalDefinition {
	NSString *_value;
	NSMutableArray *_children;
	NSMutableDictionary *_variables;
	BOOL _suppressRowComponent;

}

@property (nonatomic, retain) NSString* value;
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, retain) NSMutableDictionary* variables;
@property (nonatomic, assign) BOOL suppressRowComponent;

- (void) addChild:(MBDefinition*)child;
- (void) addVariable:(MBVariableDefinition*)variable;
- (MBVariableDefinition*) variable:(NSString*)name;

@end
