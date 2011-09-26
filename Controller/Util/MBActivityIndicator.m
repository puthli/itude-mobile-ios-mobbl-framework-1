//
//  MBActivityIndicator.m
//  Core
//
//  Created by Wido on 8-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "MBStyleHandler.h"

#define ACTIVITYINDICATORSIZE 35 //Original was 24

@implementation MBActivityIndicator


-(id) initWithFrame:(CGRect)frame{
	if(self = [super initWithFrame:frame]){
		
		/*
		// Original Code showed a box around the activityIndicator/spinning wheel
		int width = 120;
		int height = 80;
		int x = frame.size.width / 2 - width / 2;
		int y = frame.size.height / 2 - height / 2;
		CGRect visibleFrame = CGRectMake(frame.origin.x + x, frame.origin.y + y, width, height);
		UIView *visibleBackground = [[[UIView alloc] initWithFrame:visibleFrame] autorelease];
		visibleBackground.layer.cornerRadius = 20.0;
		visibleBackground.layer.borderColor = [[UIColor grayColor] CGColor];
		visibleBackground.layer.borderWidth = 1;

		visibleBackground.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
		[self addSubview:visibleBackground];
		*/
		
		// Set a transparant backgroundColor so it looks like the background is faded out
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
		
		// Create the Activity/spinning wheel
		CGRect activityInset = CGRectInset(frame, (frame.size.width - ACTIVITYINDICATORSIZE) / 2, (frame.size.height - ACTIVITYINDICATORSIZE) / 2);
		UIActivityIndicatorView *aiv = [[[UIActivityIndicatorView alloc] initWithFrame:activityInset] autorelease];
		[aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		//[aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[self addSubview:aiv];
		[aiv startAnimating];
	}
	return self;
}

@end
