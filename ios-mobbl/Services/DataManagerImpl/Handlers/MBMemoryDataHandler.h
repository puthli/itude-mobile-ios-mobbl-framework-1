//
//  MBMemoryDataService.h
//  Core
//
//  Created by Robert Meijer on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDataHandlerBase.h"

/** retrieves and stores MBDocument instances in memory only */
@interface MBMemoryDataHandler : MBDataHandlerBase {
	NSMutableDictionary *_dictionary;
}

@end
