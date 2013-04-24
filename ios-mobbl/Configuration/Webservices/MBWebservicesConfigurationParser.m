//
//  MBEndPointFactory.m
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
