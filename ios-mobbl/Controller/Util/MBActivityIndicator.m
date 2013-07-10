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

@interface MBActivityIndicator()

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UILabel *messageLabel;

@end

@implementation MBActivityIndicator

@synthesize indicatorView = _indicatorView;
@synthesize messageLabel = _messageLabel;
@synthesize message = _message;

- (void)dealloc {
    [_message release];
    [_indicatorView release];
    [_messageLabel release];
    [super dealloc];
}

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
		self.indicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:activityInset] autorelease];
		[self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		//[aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[self addSubview:self.indicatorView];
		[self.indicatorView startAnimating];
	}
	return self;
}

#define OVERLAY_WIDTH 150
#define OVERLAY_HEIGHT 150
- (void)showWithMessage:(NSString *)message {
    
    message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];

    CGRect innerOverlayFrame = [self getCenterOfFrame:self.frame];
    UIView *innerOverlay = [[UIView alloc] initWithFrame:innerOverlayFrame];
    [innerOverlay setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.8]];
    [innerOverlay.layer setCornerRadius:15.0];
    
    CGRect overlayLabelFrame = CGRectMake(0, OVERLAY_HEIGHT - 75, OVERLAY_WIDTH, 75);
    self.messageLabel = [[[UILabel alloc] initWithFrame:overlayLabelFrame] autorelease];
    [self.messageLabel setBackgroundColor:[UIColor clearColor]];
    [self.messageLabel setTextColor:[UIColor whiteColor]];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setText:message];
    [innerOverlay addSubview:self.messageLabel];
    
    CGRect indicatorFrame = CGRectMake(50, 40, 50, 50);
    [self.indicatorView setFrame:indicatorFrame];
    [self.indicatorView removeFromSuperview];
    [innerOverlay addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    [self addSubview:innerOverlay];
    [innerOverlay release];
}

- (void)setMessage:(NSString *)message {
    if (_message != message) {
        [_message release];
        _message = message;
        [_message retain];
        [self.messageLabel setText:message];
    }
}

- (CGRect)getCenterOfFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake((frame.size.width/2) - OVERLAY_WIDTH/2, (frame.size.height/2) - OVERLAY_WIDTH/2, OVERLAY_WIDTH, OVERLAY_HEIGHT);
    return newFrame;
}

@end
