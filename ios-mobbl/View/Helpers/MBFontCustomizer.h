//
//  MBFontCustomizer.h
//  Core
//
//  Created by Frank van Eenbergen on 4/6/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark MBFontCustomizerDelegate

@protocol MBFontCustomizerDelegate <NSObject>
@required
-(void)fontsizeIncreased:(id)sender;
-(void)fontsizeDecreased:(id)sender;
@end


#pragma mark -
#pragma mark MBFontCustomizer interface

@interface MBFontCustomizer : NSObject

- (void) addToViewController:(UIViewController<MBFontCustomizerDelegate> *)viewController animated:(BOOL)animated;

@end

