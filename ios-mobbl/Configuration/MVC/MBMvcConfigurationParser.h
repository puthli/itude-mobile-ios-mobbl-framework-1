//
//  MBXmlDefinitionReader.h
//  Core
//
//  Created by Mark on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBConfigurationParser.h"
#import "MBConfigurationDefinition.h"

@interface MBMvcConfigurationParser : MBConfigurationParser {

    @private
    NSArray* _configAttributes;
    NSArray* _documentAttributes;
    NSArray* _elementAttributes;
    NSArray* _attributeAttributes;
    NSArray* _actionAttributes;
    NSArray* _outcomeAttributes;
    NSArray* _pageStackAttributes;
	NSArray* _dialogAttributes;
    NSArray* _pageAttributes;
    NSArray* _alertAttributes;
    NSArray* _panelAttributes;
    NSArray* _forEachAttributes;
    NSArray* _fieldAttributes;
    NSArray* _domainAttributes;
    NSArray* _domainValidatorAttributes;
	NSArray* _variableAttributes;
    
    MBConfigurationDefinition *_rootConfig;
}

@property (nonatomic, retain) NSArray* configAttributes;
@property (nonatomic, retain) NSArray* documentAttributes;
@property (nonatomic, retain) NSArray* elementAttributes;
@property (nonatomic, retain) NSArray* attributeAttributes;
@property (nonatomic, retain) NSArray* actionAttributes;
@property (nonatomic, retain) NSArray* outcomeAttributes;
@property (nonatomic, retain) NSArray* pageStackAttributes;
@property (nonatomic, retain) NSArray* dialogAttributes;
@property (nonatomic, retain) NSArray* pageAttributes;
@property (nonatomic, retain) NSArray* alertAttributes;
@property (nonatomic, retain) NSArray* panelAttributes;
@property (nonatomic, retain) NSArray* forEachAttributes;
@property (nonatomic, retain) NSArray* variableAttributes;
@property (nonatomic, retain) NSArray* fieldAttributes;
@property (nonatomic, retain) NSArray* domainAttributes;
@property (nonatomic, retain) NSArray* domainValidatorAttributes;

@end
