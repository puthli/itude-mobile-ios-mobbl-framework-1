//
//  MBFireInitialOutcomes.m
//  itude-mobile-ios-core
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

- (void)handleInitialOutcomes {
	MBDocument *initialOutcomes = [[MBDataManagerService sharedInstance] loadDocument:[self documentName]];
	for(MBElement *element in [initialOutcomes valueForPath:@"/Outcome"]) {
        MBOutcome *outcome = [self outcomeForElement:element];
		[self performSelectorOnMainThread:@selector(handleOutcomeOnMainThread:) withObject:outcome waitUntilDone:TRUE];
	}
}

// Make sure the first tab is selected
- (void)activateFirstPageStack {
    MBDocument *initialOutcomes = [[MBDataManagerService sharedInstance] loadDocument:[self documentName]];
    MBElement *element = [initialOutcomes valueForPath:@"/Outcome[0]"];
    MBOutcome *outcome = [self outcomeForElement:element];
    [self activatePageStackWithName:outcome.pageStackName];
}

-(void) handleOutcomeOnMainThread:(MBOutcome*) outcome {
	[[MBApplicationController currentInstance] handleOutcome:outcome];
}

-(void) activatePageStackWithName:(NSString*) name {
    [[MBApplicationController currentInstance] activatePageStackWithName:name];
}


#pragma mark -
#pragma mark MBAction protocol

-(MBOutcome*) execute:(MBDocument *)document withPath:(NSString *)path {
    [self handleInitialOutcomes];
    
    // Make sure the first tab is selected
    [self activateFirstPageStack];
	return nil;
}


#pragma mark -
#pragma mark Util

- (MBOutcome *)outcomeForElement:(MBElement *)element {
    MBOutcome *oc = [[[MBOutcome alloc] init] autorelease];
    oc.outcomeName = [element valueForAttribute:@"action"];
    oc.pageStackName = [element valueForAttribute:@"pageStack"];
    
    // For backwards compatibility
    if (oc.pageStackName.length == 0) {
        oc.pageStackName = [element valueForPath:@"@dialog"];
    }
    
    oc.noBackgroundProcessing = TRUE;
    oc.transferDocument = FALSE;
    
    return oc;
}

@end
