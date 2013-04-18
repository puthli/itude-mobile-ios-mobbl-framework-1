//
//  MBSpinner.h
//  Core
//
//  Created by Robin Puthli on 7/4/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//
//  This class provides convenient methods or pages that need to put up a spinner.  



@interface MBSpinner : NSObject {

	NSMutableDictionary *_activityIndicatorCountForViews;
	int _activityIndicatorCount;
	//UIAlertView *_alertView;
	
}

@property (nonatomic, retain) NSMutableDictionary *activityIndicatorCountForViews;
//@property (nonatomic, retain) UIAlertView * alertView;

+(MBSpinner *) sharedInstance ;
+(void) setSharedInstance:(MBSpinner *) factory;

// Shows the ActivityIndicator with correction for the navigationBar and the entire screen as bounds
- (void)showActivityIndicator:(UIView *) view;
- (void)showActivityIndicator:(UIView *) view withBounds:(CGRect)bounds;
- (void)showActivityIndicator:(UIView *) view withBounds:(CGRect)bounds correctForNavigationBar:(BOOL)correctNavBar;


- (void)hideActivityIndicator:(UIView *) view;

@end
