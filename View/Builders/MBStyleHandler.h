//
//  MBStyleHandler.h
//  Core
//
//  Created by Wido on 31-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponent.h"
#import "MBMatrixCell.h"
#import "MBSplitViewController.h"
@class MBPanel;
@class MBField;
@class MBComponent;

@interface MBStyleHandler : NSObject {

}

- (void) applyStyle:(id) component forView:(UIView*) view viewState:(MBViewState) viewState;

- (void) styleLabel:(UIView*) view component:(MBField*) field;
- (void) styleMultilineLabel:(UIView*) view component:(MBField*) field;
- (void) styleTextfield:(UIView*) view component:(MBField*) field;
- (void) styleWebView:(UIView*) view component:(MBField*) field;
- (void) styleButton:(UIView *) view component:(MBField *) field;
- (void) styleMatrixHeaderTitle:(UIView *)view;
- (void) styleMatrixHeaderCell:(UIView *)view component:(MBMatrixCell *)cell;
- (void) styleMatrixRowTitle:(UIView *)view;
- (void) styleMatrixRowCell:(UIView *)view component:(MBMatrixCell *)cell;
- (void) styleNavigationBar:(UINavigationBar*) bar;
- (void) styleTabBarController:(UITabBarController *) tabBarController;
- (void) styleToolbar:(UIToolbar *)toolbar;
- (void) styleDatePicker:(UIDatePicker *)datePicker component:(MBField *)field;

- (CGSize) sizeForSplitViewController:(MBSplitViewController *) splitViewcontroller;
- (CGRect) sizeForTextField:(MBField*) field withMaxBounds:(CGRect) bounds ;
- (CGRect) sizeForLabel:(MBField*) field withMaxBounds:(CGRect) bounds ;

- (CGFloat) heightForField:(MBField *) field forTableView:(UITableView *)tableView;
- (UIFont *) fontForField:(MBField *) field;
- (UIColor *) textColorForField:(MBField *)field;
- (UIColor *) backgroundColorField:(MBField *)field;

- (UIButton *)createStyledButton:(MBField *)field;

// The following methods are listed public so you can override them in a subclass
// You should not normally call them; use the generic method above for that
- (void) applyStyle:(UIView *)view page:(MBPage *)page viewState:(MBViewState)viewState;
- (void) applyStyle:(UIView *)view panel:(MBPanel *)panel viewState:(MBViewState) viewState;
- (void) applyStyle:(UIView *)view field:(MBField *)field viewState:(MBViewState) viewState;
- (void) applyInsetsForComponent:(MBComponent *) component;
@end
