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

@interface MBPanel : MBComponentContainer {

	NSString *_type;
	NSString *_title;
	int _width;
	int _height;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

- (id) initWithDefinition:(MBPanelDefinition *)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent buildViewStructure:(BOOL) buildViewStructure;
- (void) rebuild;

@end
