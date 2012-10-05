//
//  MBMobbl1ServerDataHandler.m
//  Core
//
//  Created by Robin Puthli on 6/10/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMobbl1ServerDataHandler.h"
#import "MBDocumentFactory.h"
#import "MBDataManagerService.h"
#import "MBCacheManager.h"
#import "MBProperties.h"
#import "MBDevice.h"

#import <CommonCrypto/CommonDigest.h>

@interface MBMobbl1ServerDataHandler (hidden)

-(MBDocument *) getRequestDocumentForApplicationID:(NSString*) applicationID;
-(MBDocument *) doLoadFreshDocument:(NSString *)documentName withArguments:(MBDocument *)doc;


@end

@implementation MBMobbl1ServerDataHandler


//
// expects an argument Document of type MBMobbl1Request
-(MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)doc{

	BOOL cacheable = FALSE;
	
    // Look for any cached result. If there; return it
	MBEndPointDefinition *endPoint = [self getEndPointForDocument:documentName];
	cacheable = [endPoint cacheable];
	
	if(cacheable) {
		MBDocument *result = [MBCacheManager documentForKey:[doc uniqueId]];
		if(result != nil) return result;
	}

	return [self doLoadFreshDocument:documentName withArguments:doc];
}

//
// expects an argument Document of type MBMobbl1Request
-(MBDocument *) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument *)doc{
	return [self doLoadFreshDocument:documentName withArguments:doc];
}

//
// expects an argument Document of type MBMobbl1Request
-(MBDocument *) doLoadFreshDocument:(NSString *)documentName withArguments:(MBDocument *)doc{
    
	// TODO: Retrieve these settings from a property file somewhere
	NSString *universeID = [MBProperties valueForProperty:@"mobblUniverseID"];
	NSString *iPhoneUIDPrefix = ([MBDevice isPad]?[MBProperties valueForProperty:@"iPadUIDPrefix"]:[MBProperties valueForProperty:@"iPhoneUIDPrefix"]);
	NSString *iPhoneUID = [NSString stringWithFormat:@"%@ %@",iPhoneUIDPrefix,[MBDevice identifier]];
    NSString *iOSVersion = [MBDevice iOSVersionAsString];
	NSString *deviceName = [MBDevice deviceName];
	
	// package the incoming document in a StrayClient envelope
	NSString *applicationID = [doc valueForPath:@"Request[0]/@name"];
	MBDocument *mobblDoc = [self getRequestDocumentForApplicationID:applicationID];
	MBElement *mobblRequest = [mobblDoc valueForPath:@"StrayClient[0]/SendDataDetails[0]/request[0]"];
	for (MBElement *parameter in [doc valueForPath:@"Request[0]/Parameter"]) {
		MBElement *mobblParameter = [mobblRequest createElementWithName:@"parameter"];
		NSString *key = [parameter valueForAttribute:@"key"];
		NSString *value = [parameter valueForAttribute:@"value"];
		[mobblParameter setValue:key forAttribute:@"key"];
		[mobblParameter setValue:value forAttribute:@"value"];
		// subparameters
		for (MBElement *subparameter in [parameter elementsWithName:@"Subparameter"]) {
			MBElement *mobblSubparameter = [mobblParameter createElementWithName:@"subparameter"];
			NSString *key = [subparameter valueForAttribute:@"key"];
			NSString *value = [subparameter valueForAttribute:@"value"];
			[mobblSubparameter setValue:key forAttribute:@"key"];
			[mobblSubparameter setValue:value forAttribute:@"value"];
		}
		
	}
	
	MBElement *sendData = [mobblDoc valueForPath:@"StrayClient[0]"];
	
	// ======== Mobbl1 generic stuff =========
	NSDate *currentDate = [[[NSDate alloc] init] autorelease];
	NSString *dateTime = [NSString stringWithFormat:@"%@ %@", [(NSString *)[currentDate description] substringToIndex:10], [(NSString *)[(NSString *)[currentDate description] substringFromIndex:11] substringToIndex:8]];
	//
	[sendData setValue:@"http://straysystems.com/xsd/strayclient" forAttribute:@"xmlns"];
	[sendData setValue:@"SendData" forAttribute:@"command"];
	[sendData setValue:universeID forAttribute:@"universeID"];
	[sendData setValue:dateTime forAttribute:@"dateTime"];
	[sendData setValue:iPhoneUID forAttribute:@"iPhoneUID"];
    [sendData setValue:iOSVersion forAttribute:@"iOSVersion"];
	[sendData setValue:deviceName forAttribute:@"deviceName"];
	
	// Generate MD5 hash
	NSString *md5String = [NSString stringWithFormat:@"%@%@%@", dateTime, iPhoneUID, [MBProperties valueForProperty:@"mobblSecret"]];
	const char *cStr = [md5String UTF8String];
	unsigned char md5Result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), md5Result );
	NSString *md5Hash = [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						 md5Result[0], md5Result[1],
						 md5Result[2], md5Result[3],
						 md5Result[4], md5Result[5],
						 md5Result[6], md5Result[7],
						 md5Result[8], md5Result[9],
						 md5Result[10], md5Result[11],
						 md5Result[12], md5Result[13],
						 md5Result[14], md5Result[15]
						 ];
	[sendData setValue:md5Hash forAttribute:@"messageID"];
	
	self.documentFactoryType = PARSER_MOBBL1;
    
    MBDocument *result = nil;
    
    @try {
        result = [super loadDocument:documentName withArguments:mobblDoc];
        BOOL cacheable = FALSE;
        MBEndPointDefinition *endPoint = [self getEndPointForDocument:documentName];
        cacheable = [endPoint cacheable];
        if(cacheable) {
            [MBCacheManager setDocument:result forKey:[doc uniqueId] timeToLive:endPoint.ttl];
        }
    }
    @catch (NSException *exception) {
        [MBCacheManager expireDocumentForKey:[doc uniqueId]];
        @throw exception;
    }
    @finally {
        
    }
	
	return result;
}

-(MBDocument *) getRequestDocumentForApplicationID:(NSString*) applicationID{
	MBDocument *requestDoc = [[MBDataManagerService sharedInstance] loadDocument:@"MBMobbl1Request"];
	[[requestDoc valueForPath:@"StrayClient[0]"] setValue:applicationID forAttribute:@"applicationID"];
	return requestDoc;
}


@end
