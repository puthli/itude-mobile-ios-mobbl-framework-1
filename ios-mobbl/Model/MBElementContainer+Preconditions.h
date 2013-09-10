//
//  MBElementContainer+Preconditions.h
//  Binck
//
//  Created by Frank van Eenbergen on 9/10/13.
//  Copyright (c) 2013 Itude Mobile BV. All rights reserved.
//

#import "MBElementContainer.h"

@interface MBElementContainer (Preconditions)

- (int) evaluateIndexExpression:(NSMutableString*) combinedExpression forElementName:(NSString*) elementName;
- (NSString*) substituteExpressions:(NSString*) expression usingNilMarker:(NSString*) nilMarker currentPath:(NSString*) currentPath ;
//- (NSString*) substituteExpressionsNew:(NSString *)expression usingNilMarker:(NSString*) nilMarker currentPath:(NSString*) currentPath;

@end
