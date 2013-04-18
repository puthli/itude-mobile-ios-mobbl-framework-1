//
//  MBFieldViewBuilderFactory.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBField;
@class MBFieldViewBuilder;

@interface MBFieldViewBuilderFactory : NSObject

- (void)registerFieldViewBuilder:(MBFieldViewBuilder*)fieldViewBuilder forFieldType:(NSString*)type forFieldStyle:(NSString *)style;
- (void)registerFieldViewBuilder:(MBFieldViewBuilder*)fieldViewBuilder forFieldType:(NSString*)type;

@property (nonatomic, retain) MBFieldViewBuilder *defaultBuilder;
- (MBFieldViewBuilder*)builderForType:(NSString *)type withStyle:(NSString*)style;

-(UIView*) buildFieldView:(MBField*) field forParent:(UIView*)parent withMaxBounds:(CGRect) bounds;

@end
