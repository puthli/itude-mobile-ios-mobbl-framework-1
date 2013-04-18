//
//  MBForEach.h
//  Core
//
//  Created by Wido on 5/23/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBForEachDefinition.h"
#import "MBComponent.h"
#import "MBForEachItem.h"
#import "MBComponentContainer.h"

/** Iterator for creating MBPanel instances based on the data in an MBPage. 
 * MBForEach instances are defined in a page definition in the application definition file(s).
 * You never need to subclass an MBForEach */

@interface MBForEach : MBComponentContainer {
	
	NSMutableArray *_rows; // array of MBRows
	NSString *_value;
}

@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSString *value;

-(void) addRow: (MBForEachItem*) row;

@end
