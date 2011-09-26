//
//  ForEachViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBTypes.h"

@class MBForEach;

@interface MBForEachViewBuilder : MBViewBuilder {

}

-(UIView*) buildForEachView:(MBForEach*) forEach withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState;

@end
