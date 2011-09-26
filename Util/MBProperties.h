//
//  MBProperties.h
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPropertiesConstants.h"
#import "MBDocument.h"

@interface MBProperties : NSObject {
    @private
    MBDocument *_propertiesDoc;
    NSMutableDictionary *_propertiesCache;
    NSMutableDictionary *_systemPropertiesCache;
}

+(NSString*) valueForProperty:(NSString*) key;
+(NSString*) valueForSystemProperty:(NSString*) key;

@end
