//
//  MBPageDefinition.h
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBPanelDefinition.h"

enum MBPageTypes {
	MBPageTypesNormal=0, MBPageTypesPopup=1, MBPageTypesErrorPage=2
};
typedef NSUInteger MBPageType;


@interface MBPageDefinition : MBPanelDefinition {
	NSString *_documentName;
	NSString *_rootPath;
	MBPageType _pageType;
}

@property (nonatomic, retain) NSString* rootPath;
@property (nonatomic, assign) MBPageType pageType;

- (NSString*) documentName;
- (void) setDocumentName:(NSString *) name;

- (NSString *) asXmlWithLevel:(int)level;

@end
