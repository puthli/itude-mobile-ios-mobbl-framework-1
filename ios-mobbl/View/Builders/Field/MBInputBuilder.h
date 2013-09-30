//
//  MBTextBuilder.h
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBFieldViewBuilder.h"


@interface MBInputBuilder : MBFieldViewBuilder

-(void)configureView:(UIView *)view forField:(MBField *)field;

@end
