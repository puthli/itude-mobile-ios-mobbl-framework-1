//
//  MBFontCustomizerProtocol.h
//  Core
//
//  Created by Frank van Eenbergen on 4/7/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MBFontChangeListenerProtocol 

@required
- (void) fontsizeIncreased:(id)sender;
- (void) fontsizeDecreased:(id)sender;

/*
// Not yet implemented or called anywhere
@optional
- (void) fontChanged:(UIFont *)changedFont;
- (void) fontSizeReset;
*/

@end
