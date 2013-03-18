//
//  MBPanel.h
//  Core
//
//  Created by Robin Puthli on 5/21/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponent.h"
#import "MBComponentContainer.h"

@class MBPanelDefinition;

/** Basic building block of an MBPage.
 * MBPanel instances are defined in a page definition in the application definition file(s).
 * You never need to subclass an MBPanel */

@interface MBPanel : MBComponentContainer {

	NSString *_type;
	NSString *_title;
    NSString *_titlePath;
	int _width;
	int _height;
    BOOL _zoomable;
    NSString *_outcomeName;
    NSString *_path;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titlePath;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) BOOL zoomable;
@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *path;

- (id) initWithDefinition:(MBPanelDefinition *)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent buildViewStructure:(BOOL) buildViewStructure;
- (void) rebuild;

@end
