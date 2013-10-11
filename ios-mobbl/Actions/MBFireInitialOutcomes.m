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

#import "MBFireInitialOutcomes.h"
#import "MBOutcome.h"
#import "MBDocument.h"
#import "MBDataManagerService.h"
#import "MBApplicationController.h"

@implementation MBFireInitialOutcomes

-(NSString *)documentName {
    return @"InitialOutcomes";
}

-(MBOutcome*) execute:(MBDocument *)document withPath:(NSString *)path {
	MBDocument *initialOutcomes = [[MBDataManagerService sharedInstance] loadDocument:[self documentName]];
	for(MBElement *element in [initialOutcomes valueForPath:@"/Outcome"]) {
        
		MBOutcome *oc = [[[MBOutcome alloc] init] autorelease];
		oc.outcomeName = [element valueForAttribute:@"action"];
        oc.pageStackName = [element valueForAttribute:@"pageStack"];
        
        // For backwards compatibility
        if (oc.pageStackName.length == 0) {
            oc.pageStackName = [element valueForPath:@"@dialog"];
        }
		
		oc.noBackgroundProcessing = TRUE;
		oc.transferDocument = FALSE;

		[self performSelectorOnMainThread:@selector(handleOutcomeOnMainThread:) withObject:oc waitUntilDone:TRUE];
	}

	return nil;
}

-(void) handleOutcomeOnMainThread:(MBOutcome*) outcome {
	[[MBApplicationController currentInstance] handleOutcome:outcome];
}

-(void) activatePageStackWithName:(NSString*) name {
    [[MBApplicationController currentInstance] activatePageStackWithName:name];
}

@end
