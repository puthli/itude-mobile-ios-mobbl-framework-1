//
//  MBProperties.m
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBProperties.h"
#import "MBConfigurationDefinition.h"
#import "MBDataManagerService.h"

static MBProperties *_instance = nil;

@implementation MBProperties

+(MBProperties *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        _propertiesDoc = [[MBDataManagerService sharedInstance] loadDocument: DOC_SYSTEM_PROPERTIES];
        _propertiesCache = [NSMutableDictionary new];
        _systemPropertiesCache = [NSMutableDictionary new];
    }
    return self;
}

- (void) dealloc
{
    [_propertiesDoc release];
    [_propertiesCache release];
    [_systemPropertiesCache release];
    [super dealloc];
}

-(NSString*) getValueForProperty:(NSString*) key {
    NSString *value = [_propertiesCache valueForKey: key];
    if(value == nil) {
        NSString *path = [NSString stringWithFormat:@"/Application[0]/Property[name='%@']/@value", key];
        value = [_propertiesDoc valueForPath:path];
        if(value != nil) [_propertiesCache setValue:value forKey: key];
    }
    return value;
}

-(NSString*) getValueForSystemProperty:(NSString*) key {
    NSString *value = [_systemPropertiesCache valueForKey: key];
    if(value == nil) {
        NSString *path = [NSString stringWithFormat:@"/System[0]/Property[name='%@']/@value", key];
        value = [_propertiesDoc valueForPath:path];
        if(value != nil) [_systemPropertiesCache setValue:value forKey: key];
    }
    return value;
}

+(NSString*) valueForProperty:(NSString*) key {
   return [[self sharedInstance] getValueForProperty:key];   
}

+(NSString*) valueForSystemProperty:(NSString*) key {
    return [[self sharedInstance] getValueForSystemProperty:key];   
}

@end
