//
//  MBPanel.m
//  Core
//
//  Created by Wido on 5/21/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPanel.h"
#import "MBPanelDefinition.h"
#import "MBForEach.h"
#import "MBForEachDefinition.h"
#import "MBField.h"
#import "MBFieldDefinition.h"
#import "MBComponentFactory.h"
#import "MBViewBuilderFactory.h"
#import "MBPanelViewBuilder.h"
#import "MBDefinition.h"
#import "MBLocalizationService.h"

@implementation MBPanel

@synthesize type = _type;
@synthesize title = _title;
@synthesize width = _width;
@synthesize height = _height;

-(id) initWithDefinition:(MBPanelDefinition *)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent {
    return [self initWithDefinition: definition document: document parent: parent buildViewStructure: TRUE];
}

-(id) initWithDefinition:(MBPanelDefinition *)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent buildViewStructure:(BOOL) buildViewStructure {
	self = [super initWithDefinition:definition document: document parent: parent];
	if (self != nil) {
		self.title = definition.title;
		self.type = definition.type;
		self.width = definition.width;
		self.height = definition.height;

		if(buildViewStructure) {
            for(MBDefinition *def in definition.children) {
                if([def isPreConditionValid:document currentPath:[parent absoluteDataPath]]) [self addChild: [MBComponentFactory componentFromDefinition: def document: document parent: self]];
            }
        }
	}
	return self;
}

- (void) rebuild {
	[self.children removeAllObjects];
	MBPanelDefinition *panelDef = (MBPanelDefinition*)[self definition];
	for(MBDefinition *def in [panelDef children]) {
		if([def isPreConditionValid:self.document currentPath:[self.parent absoluteDataPath]]) [self addChild: [MBComponentFactory componentFromDefinition: def document: self.document parent: self]];
	}
}

- (void) dealloc
{
	[_type release];
	[super dealloc];
}

-(NSString*) title {
	NSString *result = _title;
	
	if(_title != nil) result = _title;
	else {
		MBPanelDefinition *definition = (MBPanelDefinition*)[self definition];
		if(definition.title != nil) result = definition.title;
		else if(definition.titlePath != nil) {
			NSString *path = definition.titlePath;
			if(![path hasPrefix:@"/"]) path = [NSString stringWithFormat:@"%@/%@", [self absoluteDataPath], path];
			// Do not localize data coming from documents; which would become very confusing
			return [[self document] valueForPath: path];
		}
	}
	return MBLocalizedStringWithoutLoggingWarnings(result);
}

-(UIView*) buildViewWithMaxBounds:(CGRect) bounds viewState:(MBViewState) viewState {
	return [[[MBViewBuilderFactory sharedInstance] panelViewBuilder] buildPanelView: self withMaxBounds: bounds viewState: viewState];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<MBPanel%@%@%@%@>\n", level, "",
							   [self attributeAsXml:@"type" withValue:_type],
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"width" withValue:[NSString stringWithFormat:@"%i", _width]],
							   [self attributeAsXml:@"height" withValue:[NSString stringWithFormat:@"%i", _height]]
							   ];
	
    [result appendString: [self childrenAsXmlWithLevel: level+2]];
	[result appendFormat:@"%*s</MBPanel>\n", level, ""];
	
	return result;
}

-(int) leftInset {
	//if([self.type isEqualToString:@"LIST"] || [self.type isEqualToString:@"MATRIX"]) return 10;
	//else 
	return [super leftInset];
}

-(int) rightInset {
	//if([self.type isEqualToString:@"LIST"] || [self.type isEqualToString:@"MATRIX"]) return 10;
	//else 
	return [super rightInset];
}

-(int) topInset {
	//if([self.type isEqualToString:@"LIST"] || [self.type isEqualToString:@"MATRIX"]) return 0;
	//else 
	return [super topInset];
}

-(int) bottomInset {
	//if([self.type isEqualToString:@"LIST"] || [self.type isEqualToString:@"MATRIX"]) return 10;
	//else 
	return [super bottomInset];
}

@end
