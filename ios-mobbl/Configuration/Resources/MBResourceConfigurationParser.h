//
//  MBResourceConfigurationFactory.h
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBConfigurationParser.h"

@interface MBResourceConfigurationParser : MBConfigurationParser {
    NSArray* _resourceAttributes;
    NSArray* _bundleAttributes;
}

@property (nonatomic, retain) NSArray* resourceAttributes;
@property (nonatomic, retain) NSArray* bundleAttributes;

@end
