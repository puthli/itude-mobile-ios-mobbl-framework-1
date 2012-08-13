//
//  MBViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


@class MBPanelViewBuilder;
@class MBPageViewBuilder;
@class MBForEachViewBuilder;
@class MBDefaultRowViewBuilder;
@class MBFieldViewBuilder;
@class MBStyleHandler;

@interface MBViewBuilderFactory : NSObject {

	MBPanelViewBuilder *_panelViewBuilder;
	MBPageViewBuilder *_pageViewBuilder;
	MBForEachViewBuilder *_forEachViewBuilder;
	MBDefaultRowViewBuilder *_rowViewBuilder;
	MBFieldViewBuilder *_fieldViewBuilder;
	MBStyleHandler *_styleHandler;
	
}

@property (nonatomic, retain) MBPanelViewBuilder *panelViewBuilder;
@property (nonatomic, retain) MBPageViewBuilder *pageViewBuilder;
@property (nonatomic, retain) MBForEachViewBuilder *forEachViewBuilder;
@property (nonatomic, retain) MBDefaultRowViewBuilder *rowViewBuilder;
@property (nonatomic, retain) MBFieldViewBuilder *fieldViewBuilder;
@property (nonatomic, retain) MBStyleHandler *styleHandler;

+(MBViewBuilderFactory *) sharedInstance;
+(void) setSharedInstance:(MBViewBuilderFactory *) factory;


@end
