//
//  MBFileDataHandler.m
//  Core
//
//  Created by Wido on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBMacros.h"
#import "MBFileDataHandler.h"
#import "MBDocumentFactory.h"
#import "MBMetadataService.h"
#import "NSData+Base64.h"

@interface MBFileDataHandler()
  -(NSString*) determineFileName:(NSString*) documentName;
  -(BOOL) encryptionNeeded:(NSString*)absPath;
@end


@implementation MBFileDataHandler

- (MBDocument *) loadDocument:(NSString *)documentName {
	
	DLog(@"Load %@", documentName);
	NSString *absPath = [self determineFileName:documentName];
	MBDocumentDefinition *docDef = [[MBMetadataService sharedInstance] definitionForDocumentName: documentName];
	
	NSData *data = nil;
	if ([self encryptionNeeded:absPath]) {
		NSData *encodedData = [NSData dataWithContentsOfFile:absPath];
		NSString *base64String = [[[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding] autorelease];
		data = [NSData dataFromBase64String:base64String];
		
		// Debug purposes
		//NSString *plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		//DLog(@"Encoded document: %@ \n Decoded document: %@", base64String, plainText);
	}
	else {
		data = [NSData dataWithContentsOfFile: absPath];
	}
	
	if(data == nil || [data length] < 1) return nil;
	else return [[MBDocumentFactory sharedInstance] documentWithData: data withType: PARSER_XML andDefinition:docDef];
}

- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument *)args {
    // File does not know what to do with arguments; so just ignore them
    return [self loadDocument: documentName];
}

- (void) storeDocument:(MBDocument *)document {

	if(document != nil) {
		NSString *fileName = [NSString stringWithFormat:@"%@.gla", [document name]];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *absPath = [documentsDirectory stringByAppendingPathComponent: fileName];
		NSError *error;
		
		NSString *xml = [document asXmlWithLevel:0];
		
		DLog(@"Writing document %@ to %@", [document name], absPath);
		
		NSData *plainTextData = [xml dataUsingEncoding:NSUTF8StringEncoding];
		xml = [plainTextData base64EncodedString];
		
		DLog(@"Encoding document");
		
		BOOL success = [xml writeToFile:absPath atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
		if(!success) WLog(@"Error writing document %@ to %@: %i %@", [document name], absPath, [error code], [error domain]);

	}
}

-(NSString*) determineFileName:(NSString*) documentName {
	NSString *fileName = [NSString stringWithFormat:@"%@.xmlx", documentName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *absPath = [documentsDirectory stringByAppendingPathComponent: fileName];

	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:absPath];
	if(fileExists) return absPath;
	else {
		NSString *glaFileName = [NSString stringWithFormat:@"%@.gla", documentName];
		absPath = [documentsDirectory stringByAppendingPathComponent: glaFileName];
		
		fileExists = [[NSFileManager defaultManager] fileExistsAtPath:absPath];
		if(fileExists) return absPath;
		
		NSString *absPathInBundle = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: fileName];
		if (![[NSFileManager defaultManager] fileExistsAtPath:absPathInBundle]){
			fileName = glaFileName;
		}
	}
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: fileName];
}

-(BOOL) encryptionNeeded:(NSString*)absPath{
	if ([absPath hasSuffix:@".xmlx"]) {
		return NO;
	}
	return YES;
}

@end
