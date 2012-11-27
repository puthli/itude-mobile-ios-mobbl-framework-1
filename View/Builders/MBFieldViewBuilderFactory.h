//
//  MBFieldViewBuilderFactory.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBField;
@protocol MBFieldViewBuilder;

@interface MBFieldViewBuilderFactory : NSObject

/// @name Registering MBRowViewBuilder instances
- (void)registerFieldViewBuilder:(id<MBFieldViewBuilder>)fieldViewBuilder forFieldType:(NSString*)type forFieldStyle:(NSString *)style;
- (void)registerFieldViewBuilder:(id<MBFieldViewBuilder>)fieldViewBuilder forFieldType:(NSString*)type;

/// @name Getting a MBRowViewBuilder instance
@property (nonatomic, retain) id<MBFieldViewBuilder> defaultBuilder;
- (id<MBFieldViewBuilder>)builderForType:(NSString *)type withStyle:(NSString*)style;

-(UIView*) buildFieldView:(MBField*) field withMaxBounds:(CGRect) bounds;


@end
