//
//  MBTableViewController.m
//  Core
//
//  Created by Robin Puthli on 5/18/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//
//  Note: [self.view viewWithTag:100] = fontMenu

#import "MBRowViewBuilder.h"
#import "MBTableViewController.h"
#import "MBPanel.h"
#import "MBField.h"
#import "MBRow.h"
#import "MBViewBuilderFactory.h"
#import "MBFieldDefinition.h"
#import "MBPage.h"
#import "MBPickerController.h"
#import "MBPickerPopoverController.h"
#import "MBDevice.h"
#import "MBFontCustomizer.h"
#import "MBDatePickerController.h"


#define MAX_FONT_SIZE 20

#define C_CELL_Y_MARGIN 4

// TODO: Get the font size and name from the styleHandler
#define C_WEBVIEW_DEFAULT_FONTNAME @"arial"
#define C_WEBVIEW_DEFAULT_FONTSIZE 14
#define C_WEBVIEW_CSS @"body {font-size:%i; font-family:%@; margin:6px; margin-bottom: 12px; padding:0px;} img {padding-bottom:12px; margin-left:auto; margin-right:auto; display:block; }"

@interface MBTableViewController (hidden)

-(BOOL) hasHTML:(NSString *) text;
-(void) addText:(NSString *) text withImage:(NSString *) imageUrl toCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MBTableViewController

@synthesize styleHandler = _styleHandler;
@synthesize cellReferences = _cellReferences;
@synthesize webViews = _webViews;
@synthesize finishedLoadingWebviews = _finishedLoadingWebviews;
@synthesize sections=_sections;
@synthesize page=_page;
@synthesize fontSize = _fontSize;
@synthesize fontMenuActive = _fontMenuActive;

-(void) dealloc{
    // The following is REQUIRED to make sure no signal 10 is generated when a webview is still loading
    // while this controller is dealloced
    for(UIWebView *webView in [_webViews allValues]) {
        webView.delegate = nil;
    }
    //BINCKAPPS-635
    //ios tries to update sublayers, which calls the related uitableview to refresh
    //Uitableview then calls its delegate which has already been deallocated (an instance of this class)
    //so we manually remove the uitableview from its delegate controller when the controller gets deallocated
    [self.view removeFromSuperview];
    [_cellReferences release];
    [_webViews release];
    [_sections release];
    [super dealloc];
}

-(void) viewDidLoad{
	[super viewDidLoad];
	self.styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];
	self.cellReferences = [NSMutableDictionary dictionary];
	self.finishedLoadingWebviews = NO;
	self.webViews = [NSMutableDictionary dictionary];
	[self tableView].backgroundColor = [UIColor clearColor];
    
    // TODO: Get the font size from the styleHandler
    self.fontSize = C_WEBVIEW_DEFAULT_FONTSIZE;
    self.fontMenuActive = NO;
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return [self.sections count];
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)sectionNo {
	MBPanel *section = (MBPanel *)[self.sections objectAtIndex:sectionNo];
	NSMutableArray *rows = [section descendantsOfKind: [MBPanel class] filterUsingSelector: @selector(type) havingValue: C_ROW];
	return [rows count];
}

-(MBRow *)getRowForIndexPath:(NSIndexPath *) indexPath {
	MBPanel *section = (MBPanel *)[self.sections objectAtIndex:indexPath.section];
	NSMutableArray *rows = [section descendantsOfKind: [MBPanel class] filterUsingSelector: @selector(type) havingValue: C_ROW];
	MBRow *row = [rows objectAtIndex:indexPath.row];
	return row;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	// The height is set below
	return [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)] autorelease];	
}

// Need to call to pad the footer height otherwise the footer collapses
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return section == [self.sections count]-1?0.0f:10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 44;
	
	UIWebView *webView = [self.webViews objectForKey:indexPath];
	if (webView) {
		NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
		height = [heightString floatValue] + C_CELL_Y_MARGIN * 2;
		//webView.bounds = CGRectMake(0, 0, webView.bounds.size.width, [heightString floatValue]);
	}
    
	// Loop through the fields in the row to determine the size of multiline text cells 
	MBRow *row = [self getRowForIndexPath:indexPath];
	
	for(MBComponent *child in [row children]){
		if ([child isKindOfClass:[MBField class]]) {
			MBField *field = (MBField *)child;
			
			if ([C_FIELD_TEXT isEqualToString:field.type]){
				NSString * text;
				if(field.path != nil) {
					text = [field formattedValue];
				}
				else {
					text= field.label;
				}
				if (![self hasHTML:text]) {
					MBStyleHandler *styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];
					// calculate bounding box
					CGSize constraint = CGSizeMake(tableView.frame.size.width - 20, 50000); // TODO -- shouldn't hard code the -20 for the label size here
					CGSize size = [text sizeWithFont:[styleHandler fontForField:field] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
					height = size.height + 22; // inset
				}
			}
		}
	}
	
	
	return height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	MBRow *row = [self getRowForIndexPath:indexPath];
    id<MBRowViewBuilder> builder = [[MBViewBuilderFactory sharedInstance] rowViewBuilder];
    UITableViewCell *cell = [builder buildRowView:row forIndexPath:indexPath viewState:self.page.currentViewState cellReferences:self.cellReferences forTableView:tableView];

    return cell;

}

-(BOOL) hasHTML:(NSString *) text{
	BOOL result = NO;
	NSString * lowercaseText = [text lowercaseString];
	NSRange found = [lowercaseText rangeOfString:@"<html>"];
	if (found.location != NSNotFound) result = YES;
	
	found = [lowercaseText rangeOfString:@"<body>"];
	if (found.location != NSNotFound) result = YES;
    
	found = [lowercaseText rangeOfString:@"<b>"];
	if (found.location != NSNotFound) result = YES;
    
	found = [lowercaseText rangeOfString:@"<br>"];
	if (found.location != NSNotFound) result = YES;
    
	return result;
}

-(void) addText:(NSString *) text withImage:(NSString *) imageUrl toCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
	MBStyleHandler *styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];
	
	// if the text contains any html, make a webview
	if ([self hasHTML:text]) {
		UIWebView *webView = [self.webViews objectForKey:indexPath];
		if (webView==nil){
			webView = [[self initWebView] autorelease];
			webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[self.webViews setObject:webView forKey:indexPath];
		}
		
		// TODO: get the css from the stylehandler
		NSString *css = [NSString stringWithFormat:C_WEBVIEW_CSS, self.fontSize, C_WEBVIEW_DEFAULT_FONTNAME];
		
		// TODO: put the imageUrl in html tags
		NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>%@</style></head><body id='page'>%@%@</body></html>",css, imageUrl, text];
		[webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
		cell.opaque = NO;
		cell.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:webView];
        
        // Adds Two buttons to the navigationBar that allows the user to change the fontSize. We only add this on the iPad, because the iPhone has verry little room to paste all the buttons (refres, close, etc.)
        BOOL shouldShowFontCustomizer = [MBDevice isPad];
        if (shouldShowFontCustomizer) {
            
            UIViewController *parentViewcontroller = self.page.viewController;            
            UIBarButtonItem *item = parentViewcontroller.navigationItem.rightBarButtonItem;
            
            if (item == nil || ![item isKindOfClass:[MBFontCustomizer class]]) {
                MBFontCustomizer *fontCustomizer = [[MBFontCustomizer new] autorelease];
                [fontCustomizer setButtonsDelegate:self];
                [fontCustomizer setSender:webView];
                [fontCustomizer addToViewController:parentViewcontroller animated:YES];
            }
        }
        
	}
	else{
		cell.textLabel.text = text;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		[styleHandler styleMultilineLabel:cell.textLabel component:[self.cellReferences objectForKey:indexPath]];
		
	}
	
	
}

// callback when pickerView value changes
-(void)observeValueForKeyPath:(NSString *)keyPath
					 ofObject:(id)object
					   change:(NSDictionary *)change
					  context:(void *)context
{
	
    if ([keyPath isEqual:@"value"]) {
		[self.tableView reloadData];
	}
}	


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// use the first field we come across to trigger keyboard dismissal
	for(MBField *field in [self.cellReferences allValues]){
		[[field page] resignFirstResponder];
		break;
	}
    
	MBField *field = [self.cellReferences objectForKey:indexPath];
	[self fieldWasSelected:field];
	
	if ([C_FIELD_DROPDOWNLIST isEqualToString:field.type]) { //ds
		
		[field addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
		// iPad supports popovers, which are a nicer and better way to let the user make a choice from a dropdownlist
		if ([MBDevice isPad]) {
			MBPickerPopoverController *picker = [[[MBPickerPopoverController alloc] initWithField:field] autorelease];
			//picker.field = field;
			UIView *cell = [tableView cellForRowAtIndexPath:indexPath];
			UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
			// We permit all arrow directions, except up and down because in 99 percent of all cases the apple framework will place the popover on a weird and ugly location with arrowDirectionUp
			[popover presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight animated:YES];
			picker.popover = popover;
            [popover release];
		} 
		// On devices with a smaller screensize it's better to use a scrollWheel
		else {
			MBPickerController * pickerController = [[[MBPickerController alloc] initWithNibName:@"MBPicker" bundle:nil] autorelease];
			pickerController.field = field;
			[field setViewData:pickerController forKey:@"pickerController"]; // let the page retain the picker controller
			UIView * superview = [tableView window];
			[pickerController presentWithSuperview:superview];
		}
        
		
	} else if ([C_FIELD_DATETIMESELECTOR isEqualToString:field.type] ||
               [C_FIELD_DATESELECTOR isEqualToString:field.type] ||
               [C_FIELD_TIMESELECTOR isEqualToString:field.type] || 
               [C_FIELD_BIRTHDATE isEqualToString:field.type]) {
        
        [field addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        MBDatePickerController *dateTimePickerController = [[[MBDatePickerController alloc] initWithNibName:@"MBDatePicker" bundle:nil] autorelease];
        dateTimePickerController.field = field;
        [field setViewData:dateTimePickerController forKey:@"datePickerController"];
        
        // Determine the datePickerModeStyle
        UIDatePickerMode datePickerMode = UIDatePickerModeDateAndTime;
        if ([C_FIELD_DATESELECTOR isEqualToString:field.type] || 
            [C_FIELD_BIRTHDATE isEqualToString:field.type]) {
            datePickerMode = UIDatePickerModeDate;
        }else if ([C_FIELD_TIMESELECTOR isEqualToString:field.type]) {
            datePickerMode = UIDatePickerModeTime;
        }
        dateTimePickerController.datePickerMode = datePickerMode;
        
        if ([C_FIELD_BIRTHDATE isEqualToString:field.type]) {
            dateTimePickerController.maximumDate = [NSDate date];
        }
        
        UIView *superView = [tableView window];
        [dateTimePickerController presentWithSuperview:superView];
        
        
    } else if (field && [field outcomeName]) {
        //[field handleOutcome:[field outcomeName] withPathArgument: [field absoluteDataPath]];//commented by Xiaochen
		[field handleOutcome:[field outcomeName] withPathArgument: [field evaluatedDataPath]];//added by Xiaochen: this covers the case when field path has an indexed expressions while the commented one does not
        
	} 
    
}

// allows subclasses to attach behaviour to a field.
-(void) fieldWasSelected:(MBField *)field{
    
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionNo{
	NSString *title = nil;
	MBPanel *section = (MBPanel *)[self.sections objectAtIndex:sectionNo];
	title = [section title];
	return title;
}


// UIWebViewDelegate methods
-(void) webViewDidFinishLoad:(UIWebView *)webView{
	BOOL done = YES;
	
	for (UIWebView *w in [self.webViews allValues]){
		if (w.loading) {
			done=NO;
		}
	}
	
	if (done) {
		
		for (UIWebView *w in [self.webViews allValues]){
			// reset the frame to something small, somehow this triggers UIKit to recalculate the height
			webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, 1);
			[webView sizeToFit];
		}
		if (!self.finishedLoadingWebviews) {
			self.finishedLoadingWebviews = YES;
			[self.tableView reloadData];
		}
	}
}

-(void) rebuildView {
	
}

-(UIWebView*)initWebView {
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(6, 6, 284, 36)] autorelease];
	webView.delegate = self;
	return webView;
}


-(void)reloadAllWebViews{
    for (UIWebView *webView in [self.webViews allValues]) {
        self.finishedLoadingWebviews = NO;
        NSString *innerHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
		NSString *css = [NSString stringWithFormat:C_WEBVIEW_CSS, self.fontSize, C_WEBVIEW_DEFAULT_FONTNAME];
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>%@</style></head><body id='page'>%@</body></html>",css, innerHTML];
        [webView loadHTMLString:htmlString baseURL:nil];
    }
}


#pragma mark -
#pragma mark MBFontChangeListenerProtocol methods

-(void)fontsizeIncreased:(id)sender {
    if (self.fontSize < MAX_FONT_SIZE) {
        self.fontSize ++;
        [self reloadAllWebViews];
    }
}

-(void)fontsizeDecreased:(id)sender {
    if (self.fontSize > C_WEBVIEW_DEFAULT_FONTSIZE) {
        self.fontSize --;
        [self reloadAllWebViews];
    }
}


@end
