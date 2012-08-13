//
//  MBDefaultRowViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBFieldViewBuilder.h"
#import "MBViewBuilderFactory.h"
#import "MBDefaultRowViewBuilder.h"
#import "MBRow.h"
#import "MBLocalizationService.h"
#import "MBDevice.h"
#import "MBFontCustomizer.h"
#import "MBPage.h"
#import "MBViewBuilderDelegate.h"

@implementation MBDefaultRowViewBuilder

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

-(void) addText:(NSString *) text toCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath fromRow:(MBRow *)row field:(MBField *)field delegate:(id<MBViewBuilderDelegate>) delegate {

    MBStyleHandler *styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];

    // if the text contains any html, make a webview
    if ([self hasHTML:text]) {
        UIWebView *webView = [delegate webViewWithText:text forIndexPath:indexPath];

        cell.opaque = NO;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:webView];

        // Adds Two buttons to the navigationBar that allows the user to change the fontSize. We only add this on the iPad, because the iPhone has verry little room to paste all the buttons (refres, close, etc.)
        BOOL shouldShowFontCustomizer = [MBDevice isPad];
        if (shouldShowFontCustomizer) {

            UIViewController *parentViewcontroller = row.page.viewController;
            UIBarButtonItem *item = parentViewcontroller.navigationItem.rightBarButtonItem;

            if (item == nil || ![item isKindOfClass:[MBFontCustomizer class]]) {
                MBFontCustomizer *fontCustomizer = [[MBFontCustomizer new] autorelease];
                [fontCustomizer setButtonsDelegate:self];
                [fontCustomizer setSender:webView];
                [fontCustomizer addToViewController:parentViewcontroller animated:YES];
            }
        }

    }
    else {
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [styleHandler styleMultilineLabel:cell.textLabel component:field];

    }
}


- (UITableViewCell *)createCellForTableView:(UITableView *)tableView withType:(NSString *)cellType
                                                            style:(UITableViewCellStyle)cellstyle
{
// First build the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellType];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellstyle reuseIdentifier:cellType] autorelease];
    }
    else {
        cell.accessoryView = nil;
        for(UIView *vw in cell.contentView.subviews) [vw removeFromSuperview];
    }
    return cell;
}

- (UITableViewCell *)initCellForRow:(MBRow *)row forTableView:(UITableView *)tableView {
    NSString *type = C_REGULARCELL;
    UITableViewCellStyle style = UITableViewCellStyleDefault;

    // Loop through the fields in the row to determine the type and style of the cell
    for(MBComponent *child in [row children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            // #BINCKMOBILE-19
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {

                if ([C_FIELD_LABEL isEqualToString:field.type] ||
                        [C_FIELD_TEXT isEqualToString:field.type]){
                    // Default
                }

                if ([C_FIELD_DROPDOWNLIST isEqualToString:field.type] ||
                        [C_FIELD_DATETIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_DATESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_TIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_BIRTHDATE isEqualToString:field.type]) {
                    type = C_DROPDOWNLISTCELL;
                    style = UITableViewCellStyleValue1;
                }

                if ([C_FIELD_SUBLABEL isEqualToString:field.type]){
                    type = C_SUBTITLECELL;
                    style = UITableViewCellStyleSubtitle;
                }
                if ([C_FIELD_BUTTON isEqualToString:field.type] ||
                        [C_FIELD_CHECKBOX isEqualToString:field.type] ||
                        [C_FIELD_INPUT isEqualToString:field.type]||
                        [C_FIELD_USERNAME isEqualToString:field.type]||
                        [C_FIELD_PASSWORD isEqualToString:field.type]) {
                    type = field.style; // Not a mistake
                }
            }
        }
    }
    return [self createCellForTableView:tableView withType:type style:style];
}

- (UITableViewCell *)buildRowView:(MBRow *)row forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState
                     forTableView:(UITableView *)tableView delegate:(id <MBViewBuilderDelegate>)delegate
{
    NSString *text     = nil;
    NSString *fieldstyle  = nil;
    BOOL navigable     = NO;
    BOOL showAccesoryDisclosureIndicator  = NO;
    UIView *inputFieldView = nil;
    NSMutableArray *buttons = nil;
    UISwitch *switchView = nil;
    MBField *labelField = nil;
    MBField *subLabelField = nil;

    CGRect labelSize = CGRectZero;
    CGRect subLabelSize = CGRectZero;
    UITableViewCell *cell = [self initCellForRow:row forTableView:tableView];

    // Loop through the fields in the row to determine the content of the cell
    for(MBComponent *child in [row children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            field.responder = nil;

            // #BINCKMOBILE-19
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {

                if ([C_FIELD_LABEL isEqualToString:field.type]){
                    if(field.path != nil) {
                        cell.textLabel.text = MBLocalizedString([field formattedValue]);
                    }
                    else {
                        cell.textLabel.text = field.label;
                    }
                    labelField = field;
                    labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
                }
                if ([C_FIELD_DROPDOWNLIST isEqualToString:field.type]){
                    cell.textLabel.text = field.label;
                    labelField = field;
                    if(field.path != nil) {
                        MBDomainDefinition * domain = field.domain;
                        for (MBDomainValidatorDefinition *domainValidator in domain.domainValidators){
                            if ([domainValidator.value isEqualToString:[field untranslatedValue]]) {	// JIRA: IQ-70. Changed by Frank: The rowValue is NEVER translated. The fieldValue can be translated if fetched in a regular way so in that case they will never match
                                cell.detailTextLabel.text =
                                        [domainValidator.title length] ? domainValidator.title : domainValidator.value;							                              }
                        }
                    }
                    labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
                    [delegate viewBuilder:self didCreateInteractiveField:field
                              atIndexPath:indexPath];
                    showAccesoryDisclosureIndicator = YES;
                }
                if ([C_FIELD_DATETIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_DATESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_TIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_BIRTHDATE isEqualToString:field.type]) {

                    cell.textLabel.text = field.label;
                    labelField = field;
                    cell.detailTextLabel.text = [field formattedValue];
                    labelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
                    [delegate viewBuilder:self didCreateInteractiveField:field
                              atIndexPath:indexPath];
                    showAccesoryDisclosureIndicator = YES;

                }


                if ([C_FIELD_SUBLABEL isEqualToString:field.type]){
                    if(field.path != nil) {
                        cell.detailTextLabel.text = [field formattedValue];
                    }
                    else {
                        cell.detailTextLabel.text = field.label;
                    }
                    subLabelSize = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
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
                        [delegate viewBuilder:self didCreateInteractiveField:field
                                  atIndexPath:indexPath];
                    }
                    if ([C_FIELD_STYLE_POPUP isEqualToString:fieldstyle]) {
                        showAccesoryDisclosureIndicator = NO;
                        [delegate viewBuilder:self didCreateInteractiveField:field
                                  atIndexPath:indexPath];
                    }
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
                    if (!cell.textLabel.text){
                        cell.textLabel.text = field.label;
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
                    [delegate viewBuilder:self didCreateInteractiveField:field atIndexPath:indexPath];
                    // TODO: should label of a INPUTFIELD field be displayed if there is already a LABEL field in the row?
                    if (!cell.textLabel.text){
                        cell.textLabel.text = field.label;
                    }
                    labelField = field;
                }
                if ([C_FIELD_TEXT isEqualToString:field.type]){
                    if(field.path != nil) {
                        text = [field formattedValue];
                    }
                    else {
                        text= field.label;
                    }
                    [self addText:text toCell:cell atIndexPath:indexPath fromRow:row field:field delegate:delegate];
                    [delegate viewBuilder:self didCreateInteractiveField:field atIndexPath:indexPath];
                }
                [self.styleHandler styleTextfield:inputFieldView component:field];
            }
        }
    }

    CGRect bounds = cell.bounds;
    // If the bounds are set for a field with buttons, then the view get's all messed up.
    if (![MBDevice isPad] && !navigable && ![C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle] && [buttons count]<=0) {
        bounds.size.width = tableView.frame.size.width;
    }
    cell.bounds = bounds;

    cell.textLabel.frame = labelSize;
    cell.detailTextLabel.frame = subLabelSize;

    [self.styleHandler styleLabel:cell.textLabel component:labelField];
    [self.styleHandler styleLabel:cell.detailTextLabel component:subLabelField];

    if (navigable) {
        if ([C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle] && [buttons count]>0) {

            CGRect buttonsFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            UIView *buttonsView = [[[UIView alloc] initWithFrame:buttonsFrame] autorelease];
            // Let the width of the view resize to the parent view to reposition any buttons
            buttonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            [[[MBViewBuilderFactory sharedInstance] styleHandler] applyStyle:buttonsView panel:(MBPanel *)row viewState:viewState];
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

@end
