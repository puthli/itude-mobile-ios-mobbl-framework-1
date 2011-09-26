//
//  MBResultListener.h
//  Core
//
//  Created by Wido on 6-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBDocument.h"
#import "MBResultListenerDefinition.h"

@protocol MBResultListener

-(void) handleResult:(NSString*) result requestDocument:(MBDocument*) requestDocument definition:(MBResultListenerDefinition*) definition;

@end
