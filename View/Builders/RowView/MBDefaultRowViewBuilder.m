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
#import "MBComponentContainer.h"
#import "MBPanel.h"
#import "MBDevice.h"
#import "MBTableViewCellConfiguratorFactory.h"
#import "MBTableViewCellConfigurator.h"
#import "StringUtilities.h"

@interface MBDefaultRowViewBuilder()
@property (nonatomic, retain) MBTableViewCellConfiguratorFactory *tableViewCellConfiguratorFactory;
@end

@implementation MBDefaultRowViewBuilder

@synthesize tableViewCellConfiguratorFactory = _tableViewCellConfiguratorFactory;

- (void)dealloc
{
    [_tableViewCellConfiguratorFactory release];
    [super dealloc];
}

- (MBTableViewCellConfiguratorFactory *)tableViewCellConfiguratorFactory
{
    if (!_tableViewCellConfiguratorFactory) {
        _tableViewCellConfiguratorFactory = [[MBTableViewCellConfiguratorFactory alloc]
                initWithStyleHandler:self.styleHandler];
    }
    return _tableViewCellConfiguratorFactory;
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

- (UITableViewCell *)buildCellForRow:(MBComponentContainer *)row forTableView:(UITableView *)tableView {
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

- (BOOL)rowContainsButtonField:(MBComponentContainer *)row
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

- (void)addButtonsToCell:(UITableViewCell *)cell forRow:(MBComponentContainer *)row
{
    NSMutableArray *buttons = nil;
    NSString *fieldstyle = nil;
    for (MBComponent *child in [row children]) {
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *) child;
            if ([field.definition isPreConditionValid:row.document currentPath:[field absoluteDataPath]]) {
                if ([C_FIELD_BUTTON isEqualToString:field.type]){
                    if ([C_FIELD_STYLE_NETWORK isEqualToString:[field style]]) {
                        UIView *buttonView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilderFactory]  buildFieldView:field withMaxBounds:CGRectZero];
                        [field setResponder:buttonView];
                        if (buttons == nil) {
                            buttons = [[[NSMutableArray alloc]initWithObjects:buttonView,nil] autorelease];
                        }else {
                            [buttons addObject:buttonView];
                        }
                    }
                    if ([C_FIELD_STYLE_NAVIGATION isEqualToString:[field style]]) {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.accessoryView.isAccessibilityElement = YES;
                        cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";
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

    // Style for a Panel with type "ROW"
    if ([self outcomeNameFor:row]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (UITableViewCell *)buildTableViewCellFor:(MBComponentContainer *)component forIndexPath:(NSIndexPath *)indexPath viewState:(MBViewState)viewState forTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self buildCellForRow:component forTableView:tableView];

    // Loop through the fields in the row to determine the content of the cell
    for(MBComponent *child in [component children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;
            field.responder = nil;

            // #BINCKMOBILE-19
            if ([field.definition isPreConditionValid:component.document currentPath:[field absoluteDataPath]]) {

                MBTableViewCellConfigurator *cellConfigurator = [self.tableViewCellConfiguratorFactory configuratorForFieldType:field.type];
                [cellConfigurator configureCell:cell withField:field];
            }
        }
    }

    [self addButtonsToCell:cell forRow:component];

    CGRect bounds = cell.bounds;
    // If the bounds are set for a field with buttons, then the view get's all messed up.
    if (![MBDevice isPad] && ![self rowContainsButtonField:component]) {
        bounds.size.width = tableView.frame.size.width;
    }
    cell.bounds = bounds;

    
    if (![self rowContainsButtonField:component] && ![self outcomeNameFor:component]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(CGFloat)heightForComponent:(MBComponentContainer *)component atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
    CGFloat height = 44;

    // Loop through the fields in the row to determine the size of multiline text cells
    for(MBComponent *child in [component children]){
        if ([child isKindOfClass:[MBField class]]) {
            MBField *field = (MBField *)child;

            if ([C_FIELD_TEXT isEqualToString:field.type]) {
                NSString * text;
                if(field.path != nil) {
                        text = [field formattedValue];
                    }
                else {
                        text= field.label;
                    }
                if (![text hasHTML]) {
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

- (NSString *)outcomeNameFor:(MBComponentContainer *)component
{
    NSString *outcomeName = nil;
    if ([component isKindOfClass:[MBPanel class]]) {
        outcomeName = [((MBPanel *)component) outcomeName];
    }
    return outcomeName;
}

@end
