//
//  MBMatrixCell.h
//  Core
//
//  Created by Frank van Eenbergen on 6/11/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBField.h"

@interface MBMatrixCell : NSObject {
	NSString *_value;
	NSString *_style;
	int _width;
	int _height;
	NSString *_alignment;
	double _delta;
	BOOL _hidden;
	MBField *_field;
	MBPage *_page;
}

@property (nonatomic, retain)NSString *value;
@property (nonatomic, retain)NSString *style;
@property (nonatomic, retain)MBField *field;
@property (nonatomic, retain)MBPage *page;

@property (nonatomic, assign)int width;
@property (nonatomic, assign)int height;
@property (nonatomic, assign)NSString *alignment;
@property (nonatomic, assign)double delta;
@property (nonatomic, assign)BOOL hidden;

+ (MBMatrixCell *)cellWithValue:(NSString *)value;
+ (MBMatrixCell *)cellForField:(MBField *)field;
+ (void) fixCellWidths:(NSArray *)cells forViewWidth:(int) viewWidth;

- (void) updateValue;

@end
