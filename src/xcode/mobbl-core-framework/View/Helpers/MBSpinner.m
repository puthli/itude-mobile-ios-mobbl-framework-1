/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBSpinner.h"
#import "MBActivityIndicator.h"
#import "MBMacros.h"


@implementation MBSpinner

static MBSpinner *_instance = nil;

@synthesize activityIndicatorCountForViews = _activityIndicatorCountForViews;
//@synthesize alertView = _alertView;

- (id) init
{
	self = [super init];
	if (self != nil) {
		_activityIndicatorCount = 0;
		self.activityIndicatorCountForViews = [NSMutableDictionary dictionaryWithCapacity:20];
	}
	return self;
}


- (void) dealloc
{
	[_activityIndicatorCountForViews release];
	[super dealloc];
}

+(MBSpinner *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBSpinner *) factory {
	@synchronized(self) {
		if(_instance != nil && _instance != factory) {
			[_instance release];
		}
		_instance = factory;
		[_instance retain];
	}
}

- (void)showActivityIndicator:(UIView*) view {
	// determine the maximum bounds of the screen
	CGRect bounds = [UIScreen mainScreen].applicationFrame;
	
	[self showActivityIndicator:view withBounds:bounds correctForNavigationBar:YES];
}


- (void)showActivityIndicator:(UIView*) view withBounds:(CGRect)bounds {
	[self showActivityIndicator:view withBounds:bounds correctForNavigationBar:YES];
}

- (void)showActivityIndicator:(UIView*) view withBounds:(CGRect)bounds correctForNavigationBar:(BOOL)correctNavBar{
	NSValue *key = [NSValue valueWithNonretainedObject:view];
	NSNumber *activityIndicatorCount = [self.activityIndicatorCountForViews objectForKey:key];
	
	// If the spinner does not exist, create it/show it to screen
	if (activityIndicatorCount == nil) {
		activityIndicatorCount = [NSNumber numberWithInt:1];
		
		MBActivityIndicator *blocker = nil;
		
		// correct for navbar
		// check for transforms in the view. 
		if (view.transform.a == CGAffineTransformIdentity.a
			&& view.transform.b == CGAffineTransformIdentity.b
			&& view.transform.c == CGAffineTransformIdentity.c
			&& view.transform.d == CGAffineTransformIdentity.d
			&& view.transform.tx == CGAffineTransformIdentity.tx
			&& view.transform.ty == CGAffineTransformIdentity.ty) {
			if(correctNavBar) bounds.origin.y -= 50;
			blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];		}
		else{
			// Assume transforms mean landscape orientation.
			bounds.origin.y=0;
			bounds.origin.x=0;
			blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
			blocker.center = CGPointMake(bounds.size.height/2, bounds.size.width/2);
			blocker.transform = view.transform;
		}
		[view addSubview:blocker];
		
	} 
	// If the number exists, increment it's calls
	else {
		int number = [activityIndicatorCount intValue];
		number ++;
		activityIndicatorCount = [NSNumber numberWithInt:number];
	}
	// Store the new value
	[self.activityIndicatorCountForViews setObject:activityIndicatorCount forKey:key];
}


- (void)hideActivityIndicator:(UIView *) view {
	
	NSValue *key = [NSValue valueWithNonretainedObject:view];
	NSNumber *activityIndicatorCount = [self.activityIndicatorCountForViews objectForKey:key];
	
	if (activityIndicatorCount != nil){
		int activityIndicatorCountValue = [activityIndicatorCount intValue];

		if(activityIndicatorCountValue > 0) activityIndicatorCountValue --;
		
		if(activityIndicatorCountValue == 0) {
			[self.activityIndicatorCountForViews removeObjectForKey:key];
			//[self.alertView dismissWithClickedButtonIndex:0 animated:YES];
			UIView *top = [view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]]) [top removeFromSuperview];
		}
		else {
			activityIndicatorCount = [NSNumber numberWithInt:activityIndicatorCountValue];
			[self.activityIndicatorCountForViews setObject:activityIndicatorCount forKey:key];
		}
			
	}
}


@end
