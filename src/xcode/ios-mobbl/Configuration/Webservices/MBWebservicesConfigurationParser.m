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

#import "MBWebservicesConfigurationParser.h"
#import "MBWebservicesConfiguration.h"

@implementation MBWebservicesConfigurationParser

- (id) parseData:(NSData*)data ofDocument:(NSString*) documentName {

    MBWebservicesConfiguration *config = [super parseData: data ofDocument:documentName];
    [config linkGlobalListeners];
    
    return config;
}

- (BOOL) processElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"EndPoints"]) { // start config file
		MBWebservicesConfiguration *confDef = [[MBWebservicesConfiguration alloc] init];
		[_stack addObject:confDef];
		[confDef release];
	}
	else if ([elementName isEqualToString:@"EndPoint"]) {
		MBEndPointDefinition *endpointDef = [[MBEndPointDefinition alloc] init];
		endpointDef.documentIn = [attributeDict valueForKey:@"documentIn"];
		endpointDef.documentOut = [attributeDict valueForKey:@"documentOut"];
		endpointDef.endPointUri = [attributeDict valueForKey:@"endPoint"];
		endpointDef.cacheable = [[attributeDict valueForKey:@"cacheable"] boolValue];	
		endpointDef.ttl = [[attributeDict valueForKey:@"ttl"] intValue];

		NSString *timeOutStr = [attributeDict valueForKey:@"timeout"];
		if(timeOutStr != nil) endpointDef.timeout = [timeOutStr intValue];
		else endpointDef.timeout = 30;

		[[_stack lastObject] performSelector:@selector(addEndPoint:) withObject:endpointDef];
		[_stack addObject:endpointDef];
		[endpointDef release];
	}
	else if ([elementName isEqualToString:@"ResultListener"]) {
		MBResultListenerDefinition *lsnr = [[MBResultListenerDefinition alloc] init];
		lsnr.name = [attributeDict valueForKey:@"name"];
		lsnr.matchExpression = [attributeDict valueForKey:@"matchExpression"];
		[[_stack lastObject] performSelector:@selector(addResultListener:) withObject:lsnr];
		[_stack addObject:lsnr];
		[lsnr release];
	}
	else
		return NO;

	return YES;
}

- (void) didProcessElement:(NSString*)elementName {
	if (![elementName isEqualToString:@"EndPoints"]) // end config file
		[_stack removeLastObject];	
}

- (BOOL) isConcreteElement:(NSString*)element {
	return [element isEqualToString:@"EndPoints"] ||
           [element isEqualToString:@"EndPoint"]  ||
           [element isEqualToString:@"ResultListener"];
}

- (BOOL) isIgnoredElement:(NSString*)element {
    return [element isEqualToString:@"ResultListeners"];
}

@end
