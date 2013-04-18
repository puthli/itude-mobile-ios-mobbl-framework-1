//
//  MBDomainDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDomainValidatorDefinition.h"
#import "MBDefinition.h"

@interface MBDomainDefinition : MBDefinition {
	NSString *_type;
	NSNumber *_maxLength;
	NSMutableArray *_validators;
}

- (void) addValidator:(MBDomainValidatorDefinition*)validator;
- (void) removeValidatorAtIndex:(NSUInteger)index;

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSMutableArray* domainValidators;
@property (nonatomic, assign) NSNumber* maxLength;

@end
