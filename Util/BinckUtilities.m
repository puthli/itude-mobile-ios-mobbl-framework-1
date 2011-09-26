//
//  BinckControllerUtil.m
//  Binck
//
//  Created by Wido on 14-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "BinckUtilities.h"
#import "MBDocument.h"
#import "MBElement.h"


@implementation NSObject(Utilities)

-(void) setRequestParameter:(NSString *)value forKey:(NSString *)key forDocument:(MBDocument *)doc{
	MBElement *request = [doc valueForPath:@"Request[0]"];
	MBElement *parameter = [request createElementWithName:@"Parameter"];
	[parameter setValue:key forAttribute:@"key"];
	[parameter setValue:value forAttribute:@"value"];
}

@end

@implementation NSString(BinckUtilities)

- (double)doubleValueDutch {
	
	// if we have a comma, replace with a dot
	NSString *converted = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
//	converted = [converted stringByReplacingOccurrencesOfString:@"," withString:@"."];
	return [converted doubleValue];
}

- (float)floatValueDutch {

	// if we have a comma, replace with a dot
	NSString *converted = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
//	converted = [converted stringByReplacingOccurrencesOfString:@"," withString:@"."];
	return [converted floatValue];
}
@end
