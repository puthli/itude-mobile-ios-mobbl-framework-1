//
//  MBViewControllerProtocol.h
//  Core
//
//  Created by Wido on 6/2/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


@class MBPage;

@protocol MBViewControllerProtocol

- (void) setPage:(MBPage*) page;
- (MBPage*) page;

- (void) rebuildView;

@end
