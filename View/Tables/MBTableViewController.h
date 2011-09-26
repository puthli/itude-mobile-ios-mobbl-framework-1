//
//  MBTableViewController.h
//  Core
//
//  Created by Robin Puthli on 5/18/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//
//  Extends a convenience class in UIKit to create a TableView / List type screen

#import "MBViewControllerProtocol.h"

@class MBStyleHandler;
@class MBPage;
@class MBField;
@class MBRow;

@interface MBTableViewController : UITableViewController <UIWebViewDelegate, MBViewControllerProtocol>{

	NSMutableArray *_sections;
	NSMutableDictionary *_cellReferences;
	NSMutableDictionary *_webViews;
	MBStyleHandler *_styleHandler;
	BOOL _finishedLoadingWebviews;
	MBPage *_page;
}

// allows subclasses to attach behaviour to a field.
-(void) fieldWasSelected:(MBField *)field;
-(UIWebView*) initWebView;
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionNo;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, assign) MBPage *page;

@end
