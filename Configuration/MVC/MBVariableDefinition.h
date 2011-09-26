//
//  MBVariable.h
//  Core
//
//  Created by Wido on 6/3/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"


@interface MBVariableDefinition : MBDefinition {

    NSString *_expression;
}

@property (nonatomic, retain) NSString *expression;

@end
