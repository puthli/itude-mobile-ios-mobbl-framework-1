#import "MBFieldViewBuilder.h"
#import "MBUtil.h"
#import <UIKit/UIKit.h>

@implementation MBFieldViewBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
    NOT_IMPLEMENTED;
    return nil;
}

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    UIView *child = [self buildFieldView:field withMaxBounds:bounds] ;
    
    CGFloat width = child.frame.size.width;
    
    for (UIView *subview in cell.contentView.subviews) {
        CGRect frame = subview.frame;
        frame.origin.x -= width;
        subview.frame = frame;
    }
    
    CGFloat right = cell.bounds.size.width;
    CGRect frame = child.frame;
    frame.origin.x= right - width;
    frame.origin.y = (cell.frame.size.height - frame.size.height) / 2;
    child.frame = frame;
    child.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [cell.contentView addSubview:child];
    
    return child;
}

-(UIView *)buildFieldView:(MBField *)field forParent:(UIView *)parent withMaxBounds:(CGRect)bounds {
    
    
    if ([parent isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell*)parent;
        return [self buildFieldView:field forTableCell:cell withMaxBounds:bounds];
    } else {
        UIView *result = [self buildFieldView:field withMaxBounds:bounds];
        [parent addSubview: result];
        return result;
    }
    
}

@end