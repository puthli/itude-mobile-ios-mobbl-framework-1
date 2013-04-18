//
//  MBDataServiceProtocol.h
//  Core
//
//  Created by Robert Meijer, Wido on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDocument.h"
#import "MBDataHandler.h"

/** Protocol for loading and storing MBDocument instances.
 */
@protocol MBDataHandler

/// @name Loading a document
/** Loads a document. May return a cached value.
@param documentName the name of the document as defined in `documents.xmlx`
*/
- (MBDocument *) loadDocument:(NSString *)documentName;

/**
 Loads a document, ignoring any cached values.
*/
- (MBDocument *) loadFreshDocument:(NSString *)documentName;

/** Loads a document with arguments. May return a cached value.
 @param documentName the name of the document as defined in `documents.xmlx`
 @param args MBDocument containing arguments.
 */
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args;

/** Loads a document with arguments, ignoring any cached values. */
- (MBDocument *) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument*) args;

/// @name Storing a document
/** Stores the given document. */
- (void) storeDocument:(MBDocument *)document;

@end
