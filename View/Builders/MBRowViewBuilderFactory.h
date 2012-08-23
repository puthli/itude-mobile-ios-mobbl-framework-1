//
//  MBRowViewBuilderFactory 
//
//  Created by Pieter Kuijpers on 21-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Factory for MBRowViewBuilder instances.
*/
@interface MBRowViewBuilderFactory : NSObject

/// @name Registering MBRowViewBuilder instances
- (void)registerRowViewBuilder:(id<MBRowViewBuilder>)rowViewBuilder forRowStyle:(NSString *)style;

/// @name Getting a MBRowViewBuilder instance
@property (nonatomic, retain) id<MBRowViewBuilder> defaultBuilder;
- (id<MBRowViewBuilder>)builderForStyle:(NSString *)style;
@end