//
//  MBTableViewController.h
//  Core
//
//  Created by Robin Puthli on 5/18/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//
//  Extends a convenience class in UIKit to create a TableView / List type screen

#import "MBViewControllerProtocol.h"
#import "MBFontChangeListenerProtocol.h"

@class MBStyleHandler;
@class MBPage;
@class MBField;
@class MBRow;

@interface MBTableViewController : UITableViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, MBViewControllerProtocol, MBFontChangeListenerProtocol>{

    NSMutableArray *_sections;
    NSMutableDictionary *_cellReferences;
    NSMutableDictionary *_webViews;
    MBStyleHandler *_styleHandler;
    BOOL _finishedLoadingWebviews;
    MBPage *_page;

    int _fontSize;
    BOOL _fontMenuActive;
}

@property (nonatomic, assign) MBStyleHandler *styleHandler;
@property (nonatomic, retain) NSMutableDictionary *cellReferences;
@property (nonatomic, retain) NSMutableDictionary *webViews;
@property (nonatomic, assign) BOOL finishedLoadingWebviews;
@property (nonatomic, assign) int fontSize;
@property (nonatomic, assign) BOOL fontMenuActive;

// allows subclasses to attach behaviour to a field.
-(void) fieldWasSelected:(MBField *)field;

-(void)reloadAllWebViews;
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionNo;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, assign) MBPage *page;

@end
