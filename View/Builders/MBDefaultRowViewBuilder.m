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
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
#import "MBDevice.h"

@implementation MBDefaultRowViewBuilder


- (UITableViewCell *)buildRowView:(MBRow *)row forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState cellReferences:(NSMutableDictionary *)cellReferences forTableView:(UITableView *)tableView {
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

    CGRect labelSize = CGRectZero;
    CGRect subLabelSize = CGRectZero;

    // Loop through the fields in the row to determine the content of the cell
    for(MBComponent *child in [row children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            field.responder = nil;

            // #BINCKMOBILE-19
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {

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
                    [cellReferences setObject:field forKey:indexPath];
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
                    [cellReferences setObject:field forKey:indexPath];
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
                        [cellReferences setObject:field forKey:indexPath];
                    }
                    if ([C_FIELD_STYLE_POPUP isEqualToString:fieldstyle]) {
                        showAccesoryDisclosureIndicator = NO;
                        [cellReferences setObject:field forKey:indexPath];
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
                    [cellReferences setObject:field forKey:indexPath];
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
                    [cellReferences setObject:field forKey:indexPath];
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
            bounds.size.width = tableView.frame.size.width;
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

//        [self addText:text withImage:img toCell:cell atIndexPath:indexPath];

    }

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
