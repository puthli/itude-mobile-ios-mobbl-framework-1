//
//  MBValueChangeListenerProtocol.h
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MBValueChangeListenerProtocol

@optional
- (BOOL) valueWillChange:(NSString*) value originalValue:(NSString*) originalValue forPath:(NSString*) path;
- (void) valueChanged:(NSString*) value originalValue:(NSString*) originalValue forPath:(NSString*) path;

@end
