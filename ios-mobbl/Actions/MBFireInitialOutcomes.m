//
//  MBFireInitialOutcomes.m
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 8/16/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

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
