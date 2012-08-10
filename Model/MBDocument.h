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

/** XML-like structure containing all application state.
 
 This is the data structure containing application state. Its structure
 is defined by a MBDocumentDefinition. The document definition is typically defined
 in an XML configuration file named `documents.xmlx`.
 */
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

/// @name Creating a Document
/** Creates and returns an empty Document conforming to the given MBDocumentDefinition. */
- (id) initWithDocumentDefinition: (MBDocumentDefinition*) definition;
- (void) assignToDocument:(MBDocument*) target;

/** Loads a fresh copy of this document using the registered DataHandler. 
 
 See [MBDataManagerService loadFreshDocument:withArguments:forDelegate:resultSelector:errorSelector:]
 */
- (void) loadFreshCopyForDelegate:(id) delegate resultSelector:(SEL) resultSelector errorSelector:(SEL)errorSelector;
- (void) reload;

/// @name Managing document cache
- (void) clearPathCache;
- (void) clearAllCaches;

/// @name Exporting XML
/** Returns an XML representation of the Document. 
 @param level starting level of the XML representation, use 0 to start with root element.
 */
- (NSString *) asXmlWithLevel:(int)level;

@end
