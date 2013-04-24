//
//  MBResource.h
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBResourceDefinition : MBDefinition {
	NSString *_resourceId;
	NSString *_url;
	BOOL _cacheable;
	int _ttl;
}

@property (nonatomic, retain) NSString* resourceId;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, assign) BOOL cacheable;
@property (nonatomic, assign) int ttl;

@end
