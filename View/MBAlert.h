//
//  MBAlert.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBPanel.h"
#import "MBAlertDefinition.h"
#import "MBAlertView.h"

@interface MBAlert : MBComponentContainer {
    NSString *_alertName;
	NSString *_rootPath;
    NSString *_title;
    MBDocument *_document;
    MBAlertView *_alertView;
}

@property (nonatomic, retain) NSString *alertName;
@property (nonatomic, retain) NSString *rootPath;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) MBDocument *document;
@property (nonatomic, retain) MBAlertView *alertView;

-(id) initWithDefinition:(MBAlertDefinition*) definition
                document:(MBDocument*) document
                rootPath:(NSString*) rootPath
                delegate:(id<UIAlertViewDelegate>) alertViewDelegate;

-(NSString *)outcomeNameForButtonAtIndex:(NSInteger) index;

@end
