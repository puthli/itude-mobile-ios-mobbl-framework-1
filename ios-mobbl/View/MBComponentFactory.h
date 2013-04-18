//
//  MBComponentFactory.h
//  Core
//
//  Created by Wido on 23-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@class MBDefinition;
@class MBComponent;
@class MBDocument;

// This is an internal utility class; not meant to be extended or modified by applications

@interface MBComponentFactory : NSObject {
}

+(MBComponent*) componentFromDefinition: (MBDefinition*) definition document: (MBDocument*) document parent:(MBComponent *) parent;

@end
