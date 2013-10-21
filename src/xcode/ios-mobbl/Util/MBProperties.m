/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
