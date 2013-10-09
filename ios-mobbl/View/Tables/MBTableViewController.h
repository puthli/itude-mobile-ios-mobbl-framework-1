/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBViewControllerProtocol.h"
#import "MBFontChangeListenerProtocol.h"

@class MBStyleHandler;
@class MBPage;
@class MBField;
@class MBForEachItem;

/** Extends a convenience class in UIKit to create a TableView / List type screen based on an MBPage definition. The page definition is generally stored in the file config.xmlx or in a file referenced by config.xmlx using the <Include ... /> directive. 
 */
@interface MBTableViewController : UITableViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, MBViewControllerProtocol, MBFontChangeListenerProtocol>{

    NSMutableArray *_sections;
    NSMutableDictionary *_webViews;
    MBStyleHandler *_styleHandler;
    BOOL _finishedLoadingWebviews;
    MBPage *_page;
    BOOL _zoomable;
}

@property (nonatomic, assign) MBStyleHandler *styleHandler;
//@property (nonatomic, retain) NSMutableDictionary *cellReferences;
@property (nonatomic, retain) NSMutableDictionary *webViews;
@property (nonatomic, assign) BOOL finishedLoadingWebviews;
@property (nonatomic, assign) BOOL zoomable;

// allows subclasses to attach behaviour to a field.
-(void) fieldWasSelected:(MBField *)field;

-(void)reloadAllWebViews;
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionNo;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, assign) MBPage *page;

@end
