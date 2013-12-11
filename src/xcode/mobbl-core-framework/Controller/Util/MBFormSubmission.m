/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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

#import "MBFormSubmission.h"
#import "MBDataManagerService.h"
#import "MBDocument.h"
#import "MBOutcome.h"
#import "MBMacros.h"
#import "MBServerException.h"

#define C_GENERIC_REQUEST @"MBGenericRequest"

@interface MBFormSubmission (hidden)
-(void) setRequestParameter:(NSString *)value forKey:(NSString *)key forDocument:(MBDocument *)doc;
@end

@implementation MBFormSubmission
-(MBOutcome *) execute:(MBDocument *)document withPath:(NSString *)path{
	
	[self validateDocument:document withPath:path];
	
	MBOutcome *outcome = nil;
    NSString *outcomeName;
	
	// get request name from document
	MBElement *rootElement = [[[[document elements] allValues] objectAtIndex:0] objectAtIndex:0]; //TODO: check arrays are not empty else exceptions will be raised
	NSString *requestName = rootElement.name;
	
	// get outcome names from document
	NSString *outcomeOK = [rootElement valueForAttribute:@"outcomeOK"];
	
	// set up generic request
	MBDocument *request = [[MBDataManagerService sharedInstance] loadDocument:C_GENERIC_REQUEST];
	[request setValue:requestName forPath:@"Request[0]/@name"];
	
	// copy the attributes to the generic request
	MBElementDefinition * elementDefinition = [rootElement definition];
	NSArray * attributesArray = [elementDefinition attributes];

	for (MBAttributeDefinition * attributeDefinition in attributesArray) {
		
		// skip outcomeOK and
		NSString * attributeName = [attributeDefinition name];
		if (![attributeName isEqualToString:@"outcomeOK"] && ![attributeName isEqualToString:@"outcomeERROR"]) {
			NSString * value = [rootElement valueForAttribute:attributeName];
			[self setRequestParameter:value forKey:attributeName forDocument:request];
		}
	}
	DLog(@"+REQUEST = %@", request);
	
	// retrieve generic response
	MBDocument *response = [[MBDataManagerService sharedInstance] loadDocument:@"MBGenericResponse" withArguments:request];

	DLog(@"+RESPONSE = %@", response);

	NSString *body = [response valueForPath:@"Response[0]/@body"];
	NSString *error = [response valueForPath:@"Response[0]/@error"];

	// if error, throw error with errormessage
	if (error) {
		DLog(@"Error returned by server: %@", error);
		// use body rather than error since server-side puts error code in error and error message in body
		@throw [MBServerException exceptionWithName: @"Server message" reason:body userInfo:nil];
	}

	// if success, add OK action to document and navigate to confirmation page
	else if (outcomeOK == nil) {
		[response setValue:outcomeOK forPath:@"Response[0]/@outcomeName"];
		
		outcomeName = @"OUTCOME-MBFormSubmissionOK";
		outcome = [[MBOutcome alloc] initWithOutcomeName: outcomeName document: response];
	}
	else {
		outcomeName = outcomeOK;
		outcome = [[MBOutcome alloc] initWithOutcomeName: outcomeName document: response];
	} 
	
	[outcome autorelease];
	return outcome;
}

- (void) validateDocument:(MBDocument *) document withPath:(NSString *) path{
	// subclasses should implement this method to perform validation
}

-(void) setRequestParameter:(NSString *)value forKey:(NSString *)key forDocument:(MBDocument *)doc{
	MBElement *request = [doc valueForPath:@"Request[0]"];
	MBElement *parameter = [request createElementWithName:@"Parameter"];
	[parameter setValue:key forAttribute:@"key"];
	[parameter setValue:value forAttribute:@"value"];
}

@end
