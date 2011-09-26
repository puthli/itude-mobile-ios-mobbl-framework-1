//
//  MBForEach.h
//  Core
//
//  Created by Wido on 5/23/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBForEachDefinition.h"
#import "MBComponent.h"
#import "MBRow.h"
#import "MBComponentContainer.h"

@interface MBForEach : MBComponentContainer {
	
	NSMutableArray *_rows; // array of MBRows
	NSString *_value;
}

@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSString *value;

-(void) addRow: (MBRow*) row;

@end
