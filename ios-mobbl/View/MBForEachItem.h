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

/** Created by an MBForEach depending on the data used in an MBPage. MRRow instances are created by the MOBBL Framework when an MBPage is constructed by an MBViewBuilder. 
 * MBForEach instances are defined in a page definition in the application definition file(s). MBRow instances are NOT in the definition files because they are created dynamically for each element of data found in the MBDocument that matches the MBForEach definition. To create MBRow instances the ForEach element in the definition should contain a Panel element with type="ROW"
 * You never need to subclass an MBRow */

@interface MBForEachItem : MBComponentContainer {
	int _index;
}

@property (nonatomic, assign) int index;

@end
