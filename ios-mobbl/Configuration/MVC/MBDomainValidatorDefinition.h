//
//  MBDomainValidatorDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"

@interface MBDomainValidatorDefinition : MBDefinition {
	NSString *_title;
	NSString *_value;
	NSNumber *_lowerBound;
	NSNumber *_upperBound;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* value;
@property (nonatomic, assign) NSNumber* lowerBound;
@property (nonatomic, assign) NSNumber* upperBound;

@end
