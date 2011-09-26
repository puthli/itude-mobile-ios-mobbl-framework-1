//
//  DocumentDiff.h
//  Core
//
//  Created by Wido on 10-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


@class MBDocument;

@interface MBDocumentDiff : NSObject {

	NSMutableSet *_modified;
	NSMutableDictionary *_aValues;
	NSMutableDictionary *_bValues;
}

- (id) initWithDocumentA:(MBDocument*) a andDocumentB:(MBDocument*) b;
- (BOOL) isChanged;
- (BOOL) isChanged:(NSString*) path;
- (NSSet*) paths;
- (NSString*) valueOfAForPath:(NSString*) path;
- (NSString*) valueOfBForPath:(NSString*) path;

@end
