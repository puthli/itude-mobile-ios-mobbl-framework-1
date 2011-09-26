//
//  MBOrientationManager.m
//  Core
//
//  Created by Frank van Eenbergen on 2/1/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import "MBOrientationManager.h"


@implementation MBOrientationManager

+ (BOOL) supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	// For now, we only support portrait
	if (interfaceOrientation == UIInterfaceOrientationPortrait ||
		interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return YES;
	}else {
		return NO;
	}
}

@end
