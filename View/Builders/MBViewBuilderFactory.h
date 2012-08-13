//
//  MBViewBuilder.h
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPanelViewBuilder.h"
#import "MBPageViewBuilder.h"
#import "MBForEachViewBuilder.h"
#import "MBRowViewBuilder.h"
#import "MBFieldViewBuilder.h"
#import "MBStyleHandler.h"

@interface MBViewBuilderFactory : NSObject {

	MBPanelViewBuilder *_panelViewBuilder;
	MBPageViewBuilder *_pageViewBuilder;
	MBForEachViewBuilder *_forEachViewBuilder;
	id<MBRowViewBuilder> _rowViewBuilder;
	MBFieldViewBuilder *_fieldViewBuilder;
	MBStyleHandler *_styleHandler;
	
}

@property (nonatomic, retain) MBPanelViewBuilder *panelViewBuilder;
@property (nonatomic, retain) MBPageViewBuilder *pageViewBuilder;
@property (nonatomic, retain) MBForEachViewBuilder *forEachViewBuilder;
@property (nonatomic, retain) id<MBRowViewBuilder> rowViewBuilder;
@property (nonatomic, retain) MBFieldViewBuilder *fieldViewBuilder;
@property (nonatomic, retain) MBStyleHandler *styleHandler;

+(MBViewBuilderFactory *) sharedInstance;
+(void) setSharedInstance:(MBViewBuilderFactory *) factory;


@end
