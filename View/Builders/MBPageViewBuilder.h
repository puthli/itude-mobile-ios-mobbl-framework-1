//
//  MBPageViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBTypes.h"

@class MBPage;

@interface MBPageViewBuilder : MBViewBuilder {

}

-(UIView*) buildPageView:(MBPage*) page withMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState;

@end
