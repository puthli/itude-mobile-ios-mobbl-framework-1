//
//  MBAlertViewBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertViewBuilder.h"

@implementation MBAlertViewBuilder

-(UIAlertView *)buildAlertView:(MBAlert *)alert {
    
    // TODO: Here is where the magic should happen
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[alert title] message:@"TODO" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    
    return alertView;
}

@end
