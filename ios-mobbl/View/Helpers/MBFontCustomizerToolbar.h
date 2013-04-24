//
//  MBFontCustomizerToolbar.h
//  Core
//
//  Created by Frank van Eenbergen on 4/7/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MBFontCustomizerToolbar : UIToolbar {
    
    UIBarButtonItem *_increaseFontSizeButton;
    UIBarButtonItem *_decreaseFontSizeButton;
    
    id _buttonsDelegate;
    id _sender;
}

@property(nonatomic,retain) UIBarButtonItem *increaseFontSizeButton;
@property(nonatomic,retain) UIBarButtonItem *decreaseFontSizeButton;

@property(nonatomic,retain) id buttonsDelegate;
@property(nonatomic,retain) id sender;

- (void) addBarButtonItem :(UIBarButtonItem *)barButtonItem animated:(BOOL) animated;

@end
