//
//  MBBasicViewController+BackButton.m
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/29/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBBasicViewController+BackButton.h"
#import "MBApplicationController.h"

#import "MBPage.h"

@implementation MBBasicViewController (BackButton)



-(void)addCustomBackButtonWithType:(MBBackButtonType)buttonType {
    [self addCustomBackButtonWithType:buttonType withTitle:nil];
}

-(void)addCustomBackButtonWithType:(MBBackButtonType)buttonType withTitle:(NSString *)title {
    
    if ([self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem *button = nil;
        if (buttonType == MBBackButtonTypeDefault || buttonType == MBBackButtonTypeArrowInverted) {
            button = [self createCustomBackButtonWithType:buttonType withTitle:title];
        }
        else {
            button = [self createCustomBackButtonWithType:buttonType withIcon:[self imageForButtonType:buttonType]];
        }
        
        [self.navigationItem setLeftBarButtonItem:button animated:NO];
        //[self.navigationItem.leftBarButtonItem setWidth:button.frame.size.width];
    }
    
}


- (void)backButtonPressed:(id)sender {
    // Apply custom transition and pop the viewController
    id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:self.page.transitionStyle];
    [style applyTransitionStyleToViewController:self.navigationController forMovement:MBTransitionMovementPop];
    [self.navigationController popViewControllerAnimated:[style animated]];
}


#pragma mark -
#pragma mark Helper methods

// margin added to back button
#define kBackButtonMarginRight 7.0f
// padding added to back button
#define kBackButtonPadding 10.0f

- (UIBarButtonItem *)createCustomBackButtonWithType:(MBBackButtonType)buttonType withTitle:(NSString *)title
{
    UIButton *button = [[UIButton new] autorelease];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Setup Image
    UIImage *image = [self imageForButtonType:buttonType];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Setup the title
    if (title.length > 0) {
        UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
        CGSize textSize = [title sizeWithFont:font];
        UIImage *image = [button backgroundImageForState:UIControlStateNormal];
        CGSize buttonSize = CGSizeMake(textSize.width + kBackButtonPadding * 2, image.size.height);
        [button setFrame:CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height)];
        [button setTitle:title forState:UIControlStateNormal];
        
        [button.titleLabel setFont:font];
        [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithRed:67.0f/255.0f green:3.0f/255.0f blue:38.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        CGFloat margin = floorf((button.frame.size.height - textSize.height) / 2);
        CGFloat marginRight = kBackButtonMarginRight;
        CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginLeft, margin, marginRight)];
    }
    else {
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

// Returns an UIBarButtonItem with an icon
- (UIBarButtonItem *) createCustomBackButtonWithType:(MBBackButtonType)buttonType withIcon:(UIImage *)iconImage {
    return [[UIBarButtonItem alloc] initWithImage:iconImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
}


- (UIImage *)imageForButtonType:(MBBackButtonType)buttonType {
    switch (buttonType) {
        case MBBackButtonTypeDefault: {
            UIImage *image = [UIImage imageNamed:@"backButtonDefault.png"];
            return [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:0.0f];
        }
        case MBBackButtonTypeArrowInverted: {
            UIImage *image = [UIImage imageNamed:@"backButtonArrowInverted.png"];
            return [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:0.0f];
        }
        case MBBackButtonTypeArrow: {
            return [UIImage imageNamed:@"backButtonIconArrowWhite.png"];
        }
        default:
            break;
    }
    
    return nil;
}

@end
