//
//  MBFontCustomizer.h
//  Core
//
//  Created by Frank van Eenbergen on 4/6/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MBFontChangeListenerProtocol.h"
//#import "MBFontCustomizerToolbar.m"

@class MBFontCustomizerToolbar;

@interface MBFontCustomizer : UIBarButtonItem {
    MBFontCustomizerToolbar *_toolBar;
    id _buttonsDelegate;
    id _sender;
}

@property(nonatomic, retain) MBFontCustomizerToolbar *toolBar;
@property(nonatomic, retain) id buttonsDelegate;
@property(nonatomic, retain) id sender;

- (void) addToViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

