//
//  MBAttributeDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDefinition.h"
#import "MBDomainDefinition.h"


@interface MBAttributeDefinition : MBDefinition {
	NSString *_type;
	NSString *_defaultValue;
	NSString *_dataType;
	BOOL _required;
	MBDomainDefinition *_domainDefinition;
}

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* defaultValue;
@property (nonatomic, assign) BOOL required;

- (NSString*) dataType;

@end
