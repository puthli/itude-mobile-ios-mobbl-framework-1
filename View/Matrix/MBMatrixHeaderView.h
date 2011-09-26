//
//  MatrixHeaderView.h
//  Core
//
//  Created by Frank van Eenbergen on 6/7/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPanel.h"

@interface MBMatrixHeaderView : UIView {
 
}

-(id) initWithCells:(NSArray *)cells withTitle:(NSString *)title withColumnsTotalWidth:(CGFloat)totalColumnsWidth withTableWidth:(CGFloat)tableWidth withMargin:(CGFloat)margin;

@end
