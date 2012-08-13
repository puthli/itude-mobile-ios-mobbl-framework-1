//
//  MBContainerRow.m
//  Core
//
//  Created by Wido on 5/23/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBRow.h"
#import "MBForEachDefinition.h"
#import "MBViewBuilderFactory.h"
#import "MBDefaultRowViewBuilder.h"
#import "MBPage.h"

@implementation MBRow

@synthesize index = _index;

- (void) dealloc
{
	[super dealloc];
}

-(NSString *) componentDataPath {
	MBForEachDefinition *def = (MBForEachDefinition*)[self definition];
	NSString *path = [NSString stringWithFormat:@"%@[%i]", [def value], _index];
	return [self substituteExpressions: path];
}

-(UIView*) buildViewWithMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState {
	return [[[MBViewBuilderFactory sharedInstance] rowViewBuilder] buildRowView: self withMaxBounds: bounds viewState: viewState];
}

-(NSString*) evaluateExpression:(NSString*) variableName {
	MBForEachDefinition *eachDef = (MBForEachDefinition*) [[self parent] definition];
	MBVariableDefinition *varDef = [eachDef variable: variableName];
	if(varDef == nil) return [[self parent] evaluateExpression:variableName];
	
	if([@"currentPath()" isEqualToString:varDef.expression]||[@"currentpath()" isEqualToString:varDef.expression]) return [self absoluteDataPath];
	if([@"rootPath()"    isEqualToString:varDef.expression]||[@"rootpath()"    isEqualToString:varDef.expression]) return [[self page] rootPath];
	
	NSString *value;
	if([varDef.expression hasPrefix:@"/"] || [varDef.expression rangeOfString:@":"].length > 0) {
		value = varDef.expression;
	}
	else {
		NSString *componentPath = [self substituteExpressions: [self componentDataPath]];
        
        //start: added by Xiaochen
        //in config file, when the expression of a variable does not contain ":" or a prefix "/", componentPath needs to be reset. 
		if(![componentPath hasPrefix:@"/"] && [componentPath rangeOfString:@":"].length == 0) {
			componentPath = [NSString stringWithFormat:@"%@/%@", [self.page absoluteDataPath], componentPath];
		}
		//end.
        
		value = [NSString stringWithFormat:@"%@/%@", componentPath, varDef.expression];
	}
	return [[self document] valueForPath: value];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<MBRow index=%i>\n", level, "", _index];
    [result appendString: [self childrenAsXmlWithLevel: level+2]];
	[result appendFormat:@"%*s</MBRow>\n", level, ""];
	
	return result;
}

@end
