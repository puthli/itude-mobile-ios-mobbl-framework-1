//
//  MBDefinition.h
//  Core
//
//  Created by Wido on 13-5-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@class MBDocument;

@interface MBDefinition : NSObject {
	NSString *_name;
}

@property (nonatomic, retain) NSString *name;

- (NSString *) attributeAsXml:(NSString*)name withValue:(id) attrValue;
- (NSString *) asXmlWithLevel:(int)level;
- (void) validateDefinition;
- (BOOL) isPreConditionValid:(MBDocument*) document  currentPath:(NSString*) currentPath;


@end
