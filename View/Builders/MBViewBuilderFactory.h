//
//  MBViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPanelViewBuilderFactory.h"
#import "MBPageViewBuilder.h"
#import "MBAlertViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBRowViewBuilder.h"
#import "MBFieldViewBuilderFactory.h"
#import "MBStyleHandler.h"

@class MBRowViewBuilderFactory;

@interface MBViewBuilderFactory : NSObject {

	MBPageViewBuilder *_pageViewBuilder;
    MBAlertViewBuilder *_alertViewBuilder;
	MBForEachViewBuilder *_forEachViewBuilder;
	MBStyleHandler *_styleHandler;
}

@property (nonatomic, retain, readonly) MBPanelViewBuilderFactory *panelViewBuilderFactory;
@property (nonatomic, retain) MBPageViewBuilder *pageViewBuilder;
@property (nonatomic, retain) MBAlertViewBuilder *alertViewBuilder;
@property (nonatomic, retain) MBForEachViewBuilder *forEachViewBuilder;
@property (nonatomic, retain) MBStyleHandler *styleHandler;
@property (nonatomic, retain, readonly) MBFieldViewBuilderFactory *fieldViewBuilderFactory;
@property (nonatomic, retain, readonly) MBRowViewBuilderFactory *rowViewBuilderFactory;

/**
* Return the default MBRowViewBuilder.
*
* Use MBRowViewBuilderFactory:builderForStyle to get a custom MBRowViewBuilder for a given row style.
*/
- (id<MBRowViewBuilder>)rowViewBuilder;

+(MBViewBuilderFactory *) sharedInstance;
+(void) setSharedInstance:(MBViewBuilderFactory *) factory;



@end
