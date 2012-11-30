//
//  MBTableViewController.m
//  Core
//
//  Created by Robin Puthli on 5/18/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//
//  Note: [self.view viewWithTag:100] = fontMenu

#import "MBTableViewController.h"
#import "MBPanel.h"
#import "MBField.h"
#import "MBRow.h"
#import "MBViewBuilderFactory.h"
#import "MBFieldViewBuilder.h"
#import "MBFieldDefinition.h"
#import "MBStyleHandler.h"
#import "MBPage.h"
#import "MBPickerController.h"
#import "MBPickerPopoverController.h"
#import "MBDevice.h"
#import "MBFontCustomizer.h"
#import "MBLocalizationService.h"
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
	// TODO: Put this into a rowBuilder class
	
	NSString *label    = nil;
	NSString *sublabel = nil;
	NSString *text     = nil;
	NSString *fieldstyle  = nil;
	BOOL navigable     = NO;
	BOOL showAccesoryDisclosureIndicator  = NO;
	NSString *cellType = C_REGULARCELL;
	UITableViewCellStyle cellstyle = UITableViewCellStyleDefault;
	UIView *inputFieldView = nil;
	NSMutableArray *buttons = nil;
	UISwitch *switchView = nil;
	MBField *labelField = nil;
	MBField *subLabelField = nil;
	
	//
	// Loop through the fields in the row to determine the content of the cell
	MBRow *row = [self getRowForIndexPath:indexPath];
	
	CGRect labelSize = CGRectZero;
	CGRect subLabelSize = CGRectZero;
    
	for(MBComponent *child in [row children]){
		if ([child isKindOfClass:[MBField class]]) {
			MBField *field = (MBField *)child;
			field.responder = nil;
			
			// #BINCKMOBILE-19
			if ([field.definition isPreConditionValid:self.page.document currentPath:[field absoluteDataPath]]) {
                
				if ([C_FIELD_LABEL isEqualToString:field.type]){
					if(field.path != nil) {
						label = MBLocalizedString([field formattedValue]);
					}
					else {
						label = field.label;
					}
					labelField = field;
					labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
				}
				if ([C_FIELD_DROPDOWNLIST isEqualToString:field.type]){
					label = field.label;
					labelField = field;
					if(field.path != nil) {
						MBDomainDefinition * domain = field.domain;
						for (MBDomainValidatorDefinition *domainValidator in domain.domainValidators){
							if ([domainValidator.value isEqualToString:[field untranslatedValue]]) {	// JIRA: IQ-70. Changed by Frank: The rowValue is NEVER translated. The fieldValue can be translated if fetched in a regular way so in that case they will never match
								sublabel = domainValidator.title;//[field value];									// JIRA: IQ-70. Added by Frank: This value can be translated
								if ([sublabel length] == 0) sublabel = domainValidator.value;			// JIRA: IQ-70. Changed by Frank: Only pick the title if the field has no value
							}
						}
					}
					cellstyle = UITableViewCellStyleValue1;
					cellType = C_DROPDOWNLISTCELL;
					labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
					[self.cellReferences setObject:field forKey:indexPath];
					showAccesoryDisclosureIndicator = YES;
				}
                if ([C_FIELD_DATETIMESELECTOR isEqualToString:field.type] ||
                    [C_FIELD_DATESELECTOR isEqualToString:field.type] ||
                    [C_FIELD_TIMESELECTOR isEqualToString:field.type] ||
                    [C_FIELD_BIRTHDATE isEqualToString:field.type]) {
                    
                    label = field.label;
					labelField = field;
                    sublabel = [field formattedValue];
					cellstyle = UITableViewCellStyleValue1;
					cellType = C_DROPDOWNLISTCELL;
					labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
					[self.cellReferences setObject:field forKey:indexPath];
					showAccesoryDisclosureIndicator = YES;
                    
                }
                
                
				if ([C_FIELD_SUBLABEL isEqualToString:field.type]){
					if(field.path != nil) {
						sublabel = [field formattedValue];
					}
					else {
						sublabel = field.label;
					}
					subLabelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
					cellType = C_SUBTITLECELL;
					cellstyle = UITableViewCellStyleSubtitle;
					subLabelField = field;
                    
				}
				if ([C_FIELD_BUTTON isEqualToString:field.type]){
					// store field for retrieval in didSelectRowAtIndexPath
					navigable = YES;
					fieldstyle = [field style];
					if ([C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle]) {
						UIView *buttonView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilder]  buildButton:field withMaxBounds:CGRectZero];
						[field setResponder:buttonView];
						if (buttons == nil) {
							buttons = [[[NSMutableArray alloc]initWithObjects:buttonView,nil] autorelease];
						}else {
							[buttons addObject:buttonView];
						}
					}
					if ([C_FIELD_STYLE_NAVIGATION isEqualToString:fieldstyle]) {
						showAccesoryDisclosureIndicator = YES;
						[self.cellReferences setObject:field forKey:indexPath];
					}
					if ([C_FIELD_STYLE_POPUP isEqualToString:fieldstyle]) {
						showAccesoryDisclosureIndicator = NO;
						[self.cellReferences setObject:field forKey:indexPath];
					}
					cellType = fieldstyle;
				}
				if ([C_FIELD_CHECKBOX isEqualToString:field.type]){
					// store field for retrieval in didSelectRowAtIndexPath
					fieldstyle = [field style];
					// TODO: move to fieldViewBuilder
					switchView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
                    // Always check the untranslated value 
					if ([@"true" isEqualToString:[field untranslatedValue] ]) {
						switchView.on = YES;
					}
					if (!label){
						label = field.label;
					}
					labelField = field;
					[switchView addTarget:field action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
				}
				
				if ([C_FIELD_INPUT isEqualToString:field.type]||
					[C_FIELD_USERNAME isEqualToString:field.type]||
					[C_FIELD_PASSWORD isEqualToString:field.type]){
					// store field for retrieval in didSelectRowAtIndexPath
					inputFieldView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilder]  buildTextField:field withMaxBounds:CGRectZero];
					field.responder = inputFieldView;
					[self.cellReferences setObject:field forKey:indexPath];
					// TODO: should label of a INPUTFIELD field be displayed if there is already a LABEL field in the row?
					if (!label){
						label = field.label;
					}
					labelField = field;
					cellType = field.type;
					
				}
				if ([C_FIELD_TEXT isEqualToString:field.type]){
					if(field.path != nil) {
						text = [field formattedValue];
					}
					else {
						text= field.label;
					}
					[self.cellReferences setObject:field forKey:indexPath];
				}
				[self.styleHandler styleTextfield:inputFieldView component:field];
			}
		}
	}
    
	//
	// Now build the cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellType];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:cellstyle reuseIdentifier:cellType] autorelease];
		CGRect bounds = cell.bounds;
		// If the bounds are set for a field with buttons, then the view get's all messed up. 
		if (![MBDevice isPad] && !navigable && ![C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle] && [buttons count]<=0) {
			bounds.size.width = self.view.frame.size.width;
		}
		cell.bounds = bounds;
		cell.textLabel.frame = labelSize;
		cell.detailTextLabel.frame = subLabelSize;
	}
	else {
		cell.accessoryView = nil;
		for(UIView *vw in cell.contentView.subviews) [vw removeFromSuperview];
	}
    
	cell.textLabel.text = label;
	[self.styleHandler styleLabel:cell.textLabel component:labelField];
    
	cell.detailTextLabel.text = sublabel;
	[self.styleHandler styleLabel:cell.detailTextLabel component:subLabelField];
    
	if (text) {
        
		// TODO: delegate this to a separate builder, webView used for textArea has complexity we don't need here 
        
		// TODO: include image if present in page
		NSString *img = @"";
        
		[self addText:text withImage:img toCell:cell atIndexPath:indexPath];
        
	}
    
	if (navigable) {
		if ([C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle] && [buttons count]>0) {
			
			CGRect buttonsFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
			UIView *buttonsView = [[[UIView alloc] initWithFrame:buttonsFrame] autorelease];
			// Let the width of the view resize to the parent view to reposition any buttons
			buttonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
			[[[MBViewBuilderFactory sharedInstance] styleHandler] applyStyle:buttonsView panel:(MBPanel *)row viewState:self.page.currentViewState];
			buttonsFrame = buttonsView.frame;
			
			CGFloat spaceBetweenButtons = 10;
			NSUInteger buttonXposition = buttonsFrame.size.width;
			for (UIView *button in buttons) {
				CGRect buttonFrame = button.frame;
				buttonXposition -= buttonFrame.size.width;
				buttonFrame.origin.x = buttonXposition;
				buttonFrame.origin.y = (NSUInteger)(buttonsFrame.size.height-buttonFrame.size.height)/2;
				button.frame = buttonFrame;
				// Make sure that when the parent view resizes, the buttons get repositioned as wel
				button.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
				
				[buttonsView addSubview:button];
				buttonXposition -= spaceBetweenButtons;
			}
			
			[cell.contentView addSubview:buttonsView];
			
			// Don't make the cell selectable because the buttons will handle the action
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
        //added by Xiaochen: 
        //set a default selecitonStyle, selection style can be overwritten by subclass but useful if subclass changes its value
		else if([C_FIELD_STYLE_NAVIGATION isEqualToString:fieldstyle]){
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		else if([C_FIELD_STYLE_POPUP isEqualToString:fieldstyle]){
			// A popUp does not navigate so, don't make the cell selectable
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
        
	}
	else{
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (showAccesoryDisclosureIndicator) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.accessoryView.isAccessibilityElement = YES;
		cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";
	}
	
	if (inputFieldView) {
		// reformat the frame
		CGRect frame = CGRectMake(0, cell.contentView.frame.size.height/2 - inputFieldView.frame.size.height/2 + 2, inputFieldView.frame.size.width, inputFieldView.frame.size.height);
		inputFieldView.frame = frame;
		[cell.contentView addSubview:inputFieldView];
        
        //modified for KIF Testing
        //inputFieldView is the super view of the real UITextField that we should use in KIF method call + (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
        //therefore we should explicitly make the real UITextField accessible and give it a special label to be identified in KIF
        UITextField *textField = [inputFieldView.subviews objectAtIndex:0];
        textField.isAccessibilityElement = YES;
        textField.accessibilityLabel = [NSString stringWithFormat:@"input_%@", cell.textLabel.text];
	}
	if (switchView) {
		// reformat the frame
        NSInteger leftMargin = 10;
		CGRect frame = CGRectMake(cell.contentView.frame.size.width - switchView.frame.size.width-leftMargin, cell.contentView.frame.size.height/2 - (switchView.frame.size.height/2 + 1), switchView.frame.size.width, switchView.frame.size.height+20);
		switchView.frame = frame;
        switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[cell.contentView addSubview:switchView];
        switchView.isAccessibilityElement = YES;
        switchView.accessibilityLabel = [NSString stringWithFormat:@"switch_%@", cell.textLabel.text];
		//cell.accessoryView = switchView;
	}
	
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
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(6, 6, 284, 36)];
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
