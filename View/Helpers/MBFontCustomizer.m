/*
 * (C) Copyright Google Inc.
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

#import "MBFontCustomizer.h"
#import "MBFontCustomizerToolbar.h"

#define DEFAULT_WEBVIEW_FONT_SIZE 14
#define DEFAULT_WEBVIEW_FONT_NAME @"arial"


@implementation MBFontCustomizer

@synthesize toolBar = _toolBar;
@synthesize buttonsDelegate = _buttonsDelegate;
@synthesize sender = _sender;

- (id)init {
    self = [super init];
    if (self) {
        _toolBar = [MBFontCustomizerToolbar new];
        [self setCustomView:_toolBar];
    }
    return self;
}

- (void)dealloc {
    [_toolBar release];
    [super dealloc];
}

- (void) addToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // Give the toolbar the same appearance
    UIColor *tintColor = viewController.navigationController.navigationBar.tintColor;
    _toolBar.tintColor = tintColor;
    

    // Add existing buttons
    UIBarButtonItem *item = viewController.navigationItem.rightBarButtonItem;
    if (item != nil) {
        // Workaround. Adding the original BarbuttonItem fails somehow! A empty spot will show in most cases. So therefor we copy everything from the original Button (added by the framework, which can be a refresh or close button)
        // IMPORTANT NOTE: This ONLY supports buttons with icons or titles. Not any system Item!
        UIBarButtonItem *itemCopy = nil;
        if (item.image != nil) {
            itemCopy = [[[UIBarButtonItem alloc] initWithImage:item.image style:item.style target:item.target action:item.action] autorelease];
        }
        else {
            itemCopy = [[[UIBarButtonItem alloc] initWithTitle:item.title style:item.style target:item.target action:item.action] autorelease];
        }
        
        if (itemCopy != nil) {
            [_toolBar addBarButtonItem:itemCopy animated:YES];
        }
        
        // If all else fails, try to add the original button.
        else {
            [_toolBar addBarButtonItem:item animated:YES];
        }
        
    }
      
    [viewController.navigationItem setRightBarButtonItem:self animated:animated];
}

- (void)setButtonsDelegate:(id)buttonsDelegate {
    if (_buttonsDelegate != buttonsDelegate) {
        [_buttonsDelegate release];
        _buttonsDelegate = buttonsDelegate;
        [_buttonsDelegate retain];
        
        [_toolBar setButtonsDelegate:_buttonsDelegate];
    }
}

- (void)setSender:(id)sender {
    if (_sender != sender) {
        [_sender release];
        _sender = sender;
        [_sender retain];
        
        [_toolBar setSender:_sender];
    }
    
}

@end
