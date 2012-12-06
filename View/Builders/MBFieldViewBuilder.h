//
//  MBFieldViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBFieldTypes.h"
@class MBField;

@interface MBFieldViewBuilder : MBViewBuilder
-(UIView*) buildFieldView:(MBField*) field forParent:(UIView*)parent withMaxBounds:(CGRect) bounds;
@end
