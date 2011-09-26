//
//  MBDocument.h
//  Core
//
//  Created by Wido Riezebos on 5/19/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBElement.h"
#import "MBElementContainer.h"
#import "MBDocumentDefinition.h"

@interface MBDocument : MBElementContainer {
	MBDocumentDefinition *_definition;
	NSMutableDictionary *_sharedContext;
	NSMutableDictionary *_pathCache;

@private
	
	// Stores the document that was used as an argument when this document was loaded
	// Needed to be able to reload the document (using the same arguments)
	MBDocument *_argumentsUsed;
}

@property (nonatomic, retain) NSMutableDictionary *sharedContext;
@property (nonatomic, retain) MBDocument *argumentsUsed;

- (id) initWithDocumentDefinition: (MBDocumentDefinition*) definition;
- (void) assignToDocument:(MBDocument*) target;
- (void) loadFreshCopyForDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL)errorSelector;
- (void) reload;
- (void) clearPathCache;
- (void) clearAllCaches;
- (NSString *) asXmlWithLevel:(int)level;

@end
