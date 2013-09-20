//
//  MBFontCustomizer.m
//  Core
//
//  Created by Frank van Eenbergen on 4/6/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import "MBFontCustomizer.h"
#import "MBLocalizationService.h"
#import "MBMacros.h"

#define C_BUTTON_TAG_FONT_INCREASE 991
#define C_BUTTON_TAG_FONT_DECREASE 992

@interface MBFontCustomizer () {
    id _viewController;

    UIBarButtonItem *_increaseFontSizeButton;
    UIBarButtonItem *_decreaseFontSizeButton;
}
@property(nonatomic, assign) id<MBFontCustomizerDelegate> viewController;
@property(nonatomic,retain) UIBarButtonItem *increaseFontSizeButton;
@property(nonatomic,retain) UIBarButtonItem *decreaseFontSizeButton;

@end

@implementation MBFontCustomizer


@synthesize viewController = _viewController;

@synthesize increaseFontSizeButton = _increaseFontSizeButton;
@synthesize decreaseFontSizeButton = _decreaseFontSizeButton;

- (void)dealloc {
    [_increaseFontSizeButton release];
    [_decreaseFontSizeButton release];
    [super dealloc];
}

- (void) addToViewController:(UIViewController<MBFontCustomizerDelegate> *)viewController animated:(BOOL)animated {
    
    self.viewController = viewController;
    if (!self.viewController) {
        WLog(@"WARNING! no buttonsDelegate set in the MBFontCustomizer");
    }
    
    // Add existing buttons (This functionality is only supported from iOS 5 and up)
    if ([viewController.navigationItem respondsToSelector:@selector(rightBarButtonItems)]) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:viewController.navigationItem.rightBarButtonItems];
        
        // Prevent the adding of several one set of FontResizeItems (in case a developer tries to add multiple copies)
        if (![self itemsContainFontResizeButtons:items]) {
            [self setupButtons];
            [items addObject:self.decreaseFontSizeButton];
            [items addObject:self.increaseFontSizeButton];
            [viewController.navigationItem setRightBarButtonItems:items animated:animated];
        }
    }
}


#pragma mark -
#pragma mark Util

- (void)setupButtons {
    if (!self.increaseFontSizeButton && !self.decreaseFontSizeButton) {
        UIImage *increaseIcon = [UIImage imageNamed:@"icon_font_up.png"];
        UIImage *decreaseIcon = [UIImage imageNamed:@"icon_font_down.png"];

        self.decreaseFontSizeButton = [[[UIBarButtonItem alloc] initWithImage:decreaseIcon style:UIBarButtonItemStyleBordered target:self.viewController action:@selector(fontsizeDecreased:)] autorelease];
        self.increaseFontSizeButton = [[[UIBarButtonItem alloc] initWithImage:increaseIcon style:UIBarButtonItemStyleBordered target:self.viewController action:@selector(fontsizeIncreased:)] autorelease];
        
        self.decreaseFontSizeButton.tag = C_BUTTON_TAG_FONT_DECREASE;
        self.increaseFontSizeButton.tag = C_BUTTON_TAG_FONT_INCREASE;
    }
}

- (BOOL)itemsContainFontResizeButtons:(NSArray *)items {
    for (UIBarButtonItem *item in items) {
        if (item.tag == C_BUTTON_TAG_FONT_INCREASE || item.tag == C_BUTTON_TAG_FONT_DECREASE) {
            return TRUE;
        }
    }
    return FALSE;
}


@end


