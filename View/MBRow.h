//
//  MBContainerRow.h
//  Core
//
//  Created by Robin Puthli on 5/21/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponent.h"
#import "MBElement.h"
#import "MBDefinition.h"
#import "MBComponentContainer.h"


@interface MBRow : MBComponentContainer {
	int _index;
}

@property (nonatomic, assign) int index;

@end
