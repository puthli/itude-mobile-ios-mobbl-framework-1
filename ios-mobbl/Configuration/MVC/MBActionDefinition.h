//
//  MBActionDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"

@interface MBActionDefinition : MBDefinition {
	NSString *_className;
}

@property (nonatomic, retain) NSString* className;

@end
