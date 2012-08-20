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

/** XML-like structure containing application data.
 
 This is a generic data structure containing application data. Its structure
 is made specific by a MBDocumentDefinition. Any data that is contained in MBDocuments can be drag'n'drop' ported to other platforms.
 The document definition is specified in the application configuration file which is typically named config.xmlx file. If config.xmlx becomes large, the configuration is often split into a bunch of file which are references using an <Include .../> statement in config.xmlx.
 MBDocuments are retrieved and stored using the MBDataManagerService. The document definition specifies where an MBDocument should be retrieved from (Webservice, Filesystem etc) and whether new MBDocuments shoul be auto-created. 
 Once a definition is in place (in the application configuration file) an MBDocument can be created in code using the MBMetadataService. 
 
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

/// @name Properties
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
