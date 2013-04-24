//
//  MBResultListener.h
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBResultListenerDefinition : MBDefinition {
	NSString *_matchExpression;
	NSMutableArray *_matchParts;
}

@property (nonatomic, retain) NSString *matchExpression;
@property (nonatomic, retain) NSArray *matchParts;

- (BOOL) matches:(NSString*) result;

@end
