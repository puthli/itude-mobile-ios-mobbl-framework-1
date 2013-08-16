//
//  MBActivityIndicator.h
//  Core
//
//  Created by Wido on 8-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface MBActivityIndicator : UIView

@property (nonatomic, retain) NSString *message;

- (void)showWithMessage:(NSString *)message;

@end
