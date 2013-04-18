//
//  MBComponentContainer.h
//  Core
//
//  Created by Wido on 6/5/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponent.h"

@interface MBComponentContainer : MBComponent{
	NSMutableArray *_children;

}

@property (nonatomic, retain) NSMutableArray *children;

-(id) initWithDefinition:(id)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent;

- (void) addChild: (MBComponent*) child;
- (NSString *) childrenAsXmlWithLevel:(int)level;

@end
