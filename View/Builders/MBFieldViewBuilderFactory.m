//
//  MBFieldViewBuilderFactory.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBFieldViewBuilderFactory.h"
#import "MBField.h"
#import "MBButtonBuilder.h"
#import "MBTextBuilder.h"
#import "MBLabelBuilder.h"
#import <Foundation/Foundation.h>


@interface MBFieldViewBuilderFactory () 
    @property(readonly,nonatomic, retain) NSMutableDictionary *registry;
@end

@implementation MBFieldViewBuilderFactory {
    NSMutableDictionary *_registry;
    id<MBFieldViewBuilder> _defaultBuilder;
}

@synthesize registry = _registry;
@synthesize defaultBuilder = _defaultBuilder;


- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary dictionary] retain];
        _defaultBuilder = nil;
    }
    [self registerFieldViewBuilder:[[[MBButtonBuilder alloc]init] autorelease] forFieldType:C_FIELD_BUTTON];
    
    
    id<MBFieldViewBuilder> buttonBuilder = [[[MBTextBuilder alloc] init] autorelease];
    [self registerFieldViewBuilder:buttonBuilder forFieldType:C_FIELD_INPUT ];
    [self registerFieldViewBuilder:buttonBuilder forFieldType:C_FIELD_USERNAME ];
    [self registerFieldViewBuilder:buttonBuilder forFieldType:C_FIELD_PASSWORD ];
    
    id<MBFieldViewBuilder> labelBuilder = [[[MBLabelBuilder alloc] init] autorelease];
    [self registerFieldViewBuilder:labelBuilder forFieldType:C_FIELD_LABEL];
    [self registerFieldViewBuilder:labelBuilder forFieldType:C_FIELD_SUBLABEL];
        
    return self;
}

- (void)dealloc
{
    [_registry release];
    [_defaultBuilder release];
    [super dealloc];
}


- (void)registerFieldViewBuilder:(id<MBFieldViewBuilder>)fieldViewBuilder forFieldType:(NSString*)type  {
    [self registerFieldViewBuilder:fieldViewBuilder forFieldType:type forFieldStyle:nil];
}

- (void)registerFieldViewBuilder:(id<MBFieldViewBuilder>)fieldViewBuilder forFieldType:(NSString*)type forFieldStyle:(NSString *)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) {
        
        styleDict = [[NSMutableDictionary dictionary] retain];
        [self.registry setValue:styleDict forKey:type];
        [styleDict release];
    }
    
    [styleDict setObject:fieldViewBuilder forKey:style ? style : [NSNull null]];
   }


- (id<MBFieldViewBuilder>)builderForType:(NSString *)type withStyle:(NSString*)style {
    NSMutableDictionary *styleDict = [self.registry valueForKey:type];
    if (!styleDict) return self.defaultBuilder;
    
    id<MBFieldViewBuilder> builder = [styleDict valueForKey:style];
    if (!builder) builder = [styleDict objectForKey:[NSNull null]];
    if (!builder) builder = self.defaultBuilder;
    
    return builder;
 
}


-(UIView*) buildFieldView:(MBField*) field withMaxBounds:(CGRect) bounds {
    id<MBFieldViewBuilder> builder = [self builderForType:field.type withStyle:field.style];
    if (builder) return [builder buildFieldView:field withMaxBounds:bounds];
    else {
        [NSException raise:@"BuilderNotFound" format:@"No builder found for type %@ and style %@", field.type, field.style];
        return nil;
    }
}

@end
