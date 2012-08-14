//
//  MBViewBuilderDelegate 
//
//  Created by Pieter Kuijpers on 13-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

@class MBField;

/**
* Callback methods used by ViewBuilders to notify clients of the creation of (sub)views.
*/
@protocol MBViewBuilderDelegate

- (void)viewBuilder:(id)viewBuilder didCreateInteractiveField:(MBField *)field atIndexPath:(NSIndexPath *)indexPath;

@end