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
#import "UIWebView+FontResizing.h"

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

- (void)configureCell:(UITableViewCell *)cell withTextField:(MBField *)field
{

    NSString *text;
    if(field.path != nil) {
        text = [field formattedValue];
    }
    else {
        text= field.label;
    }

    MBStyleHandler *styleHandler = [[MBViewBuilderFactory sharedInstance] styleHandler];

    // if the text contains any html, make a webview
    if ([self hasHTML:text]) {
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(6, 6, 284, 36)] autorelease];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        webView.text = text;
        cell.opaque = NO;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:webView];
    }
    else {
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [styleHandler styleMultilineLabel:cell.textLabel component:field];

    }
}


- (UITableViewCell *)cellForTableView:(UITableView *)tableView withType:(NSString *)cellType
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

- (UITableViewCell *)buildCellForRow:(MBRow *)row forTableView:(UITableView *)tableView {
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
    UITableViewCell *cell = [self cellForTableView:tableView withType:type style:style];
    return cell;
}

- (void)addAccessoryDisclosureIndicatorToCell:(UITableViewCell *)cell
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";
}

- (BOOL)rowContainsButtonField:(MBRow *)row
{
    BOOL navigable     = NO;
    for(MBComponent *child in [row children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            if ([C_FIELD_BUTTON isEqualToString:field.type]){
                navigable = YES;
            }
        }
    }
    return navigable;
}

- (void)configureCell:(UITableViewCell *)cell withLabelField:(MBField *)field
{
    if (field.path != nil) {
        cell.textLabel.text = MBLocalizedString([field formattedValue]);
    } else {
        cell.textLabel.text = field.label;
    }
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

- (void)configureCell:(UITableViewCell *)cell withDropDownListField:(MBField *)field
{
    cell.textLabel.text = field.label;
    if (field.path != nil) {
        MBDomainDefinition *domain = field.domain;
        for (MBDomainValidatorDefinition *domainValidator in domain.domainValidators) {
            // JIRA: IQ-70. Changed by Frank: The rowValue is NEVER translated. The fieldValue can be
            // translated if fetched in a regular way so in that case they will never match
            if ([domainValidator.value isEqualToString:[field untranslatedValue]]) {
                cell.detailTextLabel.text =
                        [domainValidator.title length] ? domainValidator.title : domainValidator.value;
            }
        }
    }
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self addAccessoryDisclosureIndicatorToCell:cell];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

- (void)configureCell:(UITableViewCell *)cell withDateField:(MBField *)field
{
    cell.textLabel.text = field.label;
    cell.detailTextLabel.text = [field formattedValue];
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self addAccessoryDisclosureIndicatorToCell:cell];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

- (void)configureCell:(UITableViewCell *)cell withSublabelField:(MBField *)field
{
    if (field.path != nil) {
        cell.detailTextLabel.text = [field formattedValue];
    } else {
        cell.detailTextLabel.text = field.label;
    }
    cell.detailTextLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self.styleHandler styleLabel:cell.detailTextLabel component:field];
}

- (void)addButtonsToCell:(UITableViewCell *)cell forRow:(MBRow *)row
{
    NSMutableArray *buttons = nil;
    NSString *fieldstyle = nil;
    for (MBComponent *child in [row children]) {
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *) child;
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {
                if ([C_FIELD_BUTTON isEqualToString:field.type]){
                    if ([C_FIELD_STYLE_NETWORK isEqualToString:[field style]]) {
                        UIView *buttonView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilder]  buildButton:field withMaxBounds:CGRectZero];
                        [field setResponder:buttonView];
                        if (buttons == nil) {
                            buttons = [[[NSMutableArray alloc]initWithObjects:buttonView,nil] autorelease];
                        }else {
                            [buttons addObject:buttonView];
                        }
                    }
                    if ([C_FIELD_STYLE_NAVIGATION isEqualToString:[field style]]) {
                        [self addAccessoryDisclosureIndicatorToCell:cell];
                    }
                    fieldstyle = [field style];
                }
            }
        }
    }

    if ([self rowContainsButtonField:row]) {
        if ([C_FIELD_STYLE_NETWORK isEqualToString:fieldstyle] && [buttons count] > 0) {

            CGRect buttonsFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            UIView *buttonsView = [[[UIView alloc] initWithFrame:buttonsFrame] autorelease];
            // Let the width of the view resize to the parent view to reposition any buttons
            buttonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            // Disabled: row is not a MBPanel, will probably crash
            //[[[MBViewBuilderFactory sharedInstance] styleHandler] applyStyle:buttonsView panel:(MBPanel *)row viewState:viewState];
            buttonsFrame = buttonsView.frame;

            CGFloat spaceBetweenButtons = 10;
            NSUInteger buttonXposition = (NSUInteger) buttonsFrame.size.width;
            for (UIView *button in buttons) {
                CGRect buttonFrame = button.frame;
                buttonXposition -= buttonFrame.size.width;
                buttonFrame.origin.x = buttonXposition;
                buttonFrame.origin.y = (NSUInteger) (buttonsFrame.size.height - buttonFrame.size.height) / 2;
                button.frame = buttonFrame;
                // Make sure that when the parent view resizes, the buttons get repositioned as wel
                button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

                [buttonsView addSubview:button];
                buttonXposition -= spaceBetweenButtons;
            }

            [cell.contentView addSubview:buttonsView];

            // Don't make the cell selectable because the buttons will handle the action
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        //set a default selecitonStyle, selection style can be overwritten by subclass but useful if subclass changes its value
        else if ([C_FIELD_STYLE_NAVIGATION isEqualToString:fieldstyle]) {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else if ([C_FIELD_STYLE_POPUP isEqualToString:fieldstyle]) {
            // A popUp does not navigate so, don't make the cell selectable
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell withCheckboxField:(MBField *)field
{
// store field for retrieval in didSelectRowAtIndexPath
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];

    // Always check the untranslated value
    if ([@"true" isEqualToString:[field untranslatedValue] ]) {
                        switchView.on = YES;
                    }
    if (!cell.textLabel.text){
                        cell.textLabel.text = field.label;
                    }
    [switchView addTarget:field action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];

    // reformat the frame
    NSInteger leftMargin = 10;
    CGRect frame = CGRectMake(
                    cell.contentView.frame.size.width - switchView.frame.size.width - leftMargin,
                    cell.contentView.frame.size.height / 2 - (switchView.frame.size.height / 2 + 1),
                    switchView.frame.size.width, switchView.frame.size.height + 20);
    switchView.frame = frame;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:switchView];
    switchView.isAccessibilityElement = YES;
    switchView.accessibilityLabel = [NSString stringWithFormat:@"switch_%@", cell.textLabel.text];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

- (void)configureCell:(UITableViewCell *)cell withInputField:(MBField *)field
{
// store field for retrieval in didSelectRowAtIndexPath
    UIView *inputFieldView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilder]  buildTextField:field withMaxBounds:CGRectZero];
    field.responder = inputFieldView;
    // TODO: should label of a INPUTFIELD field be displayed if there is already a LABEL field in the row?
    if (!cell.textLabel.text){
                        cell.textLabel.text = field.label;
                    }

    // reformat the frame
    CGRect frame = CGRectMake(0,
                    cell.contentView.frame.size.height / 2 - inputFieldView.frame.size.height / 2 + 2,
                    inputFieldView.frame.size.width, inputFieldView.frame.size.height);
    inputFieldView.frame = frame;
    [cell.contentView addSubview:inputFieldView];

    // modified for KIF Testing
    // inputFieldView is the super view of the real UITextField that we should use in KIF method call +
    // (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
    // therefore we should explicitly make the real UITextField accessible and give it a special label to
    // be identified in KIF
    UITextField *textField = [inputFieldView.subviews objectAtIndex:0];
    textField.isAccessibilityElement = YES;
    textField.accessibilityLabel = [NSString stringWithFormat:@"input_%@", cell.textLabel.text];

    [self.styleHandler styleTextfield:inputFieldView component:field];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

- (UITableViewCell *)buildRowView:(MBRow *)row forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState
                     forTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self buildCellForRow:row forTableView:tableView];

    // Loop through the fields in the row to determine the content of the cell
    for(MBComponent *child in [row children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            field.responder = nil;

            // #BINCKMOBILE-19
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {

                if ([C_FIELD_LABEL isEqualToString:field.type]){
                    [self configureCell:cell withLabelField:field];
                }
                if ([C_FIELD_DROPDOWNLIST isEqualToString:field.type]){
                    [self configureCell:cell withDropDownListField:field];
                }
                if ([C_FIELD_DATETIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_DATESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_TIMESELECTOR isEqualToString:field.type] ||
                        [C_FIELD_BIRTHDATE isEqualToString:field.type]) {

                    [self configureCell:cell withDateField:field];
                }

                if ([C_FIELD_SUBLABEL isEqualToString:field.type]){
                    [self configureCell:cell withSublabelField:field];
                }

                if ([C_FIELD_CHECKBOX isEqualToString:field.type]){
                    [self configureCell:cell withCheckboxField:field];
                }

                if ([C_FIELD_INPUT isEqualToString:field.type]||
                        [C_FIELD_USERNAME isEqualToString:field.type]||
                        [C_FIELD_PASSWORD isEqualToString:field.type]){
                    [self configureCell:cell withInputField:field];
                }
                if ([C_FIELD_TEXT isEqualToString:field.type]){
                    [self configureCell:cell withTextField:field];
                }
            }
        }
    }

    [self addButtonsToCell:cell forRow:row];

    CGRect bounds = cell.bounds;
    // If the bounds are set for a field with buttons, then the view get's all messed up.
    if (![MBDevice isPad] && ![self rowContainsButtonField:row]) {
        bounds.size.width = tableView.frame.size.width;
    }
    cell.bounds = bounds;

    if (![self rowContainsButtonField:row]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
