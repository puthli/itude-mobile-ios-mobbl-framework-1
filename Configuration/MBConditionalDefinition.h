//
//  MBConditionalDefinition.h
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBConditionalDefinition : MBDefinition {

	NSString *_preCondition;
}

@property (nonatomic, retain) NSString* preCondition;
@end
