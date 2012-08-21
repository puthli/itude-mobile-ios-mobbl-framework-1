//
//  MBTableViewCellConfiguratorFactory 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <MBStyleHandler.h>
#import "MBTableViewCellConfiguratorFactory.h"
#import "MBFieldTypes.h"
#import "MBTableViewCellConfiguratorLabel.h"
#import "MBTableViewCellConfiguratorDropDownList.h"
#import "MBTableViewCellConfiguratorDate.h"
#import "MBTableViewCellConfiguratorSubLabel.h"
#import "MBTableViewCellConfiguratorCheckbox.h"
#import "MBTableViewCellConfiguratorInput.h"
#import "MBTableViewCellConfiguratorText.h"

@interface MBTableViewCellConfiguratorFactory()
@property (nonatomic, retain) NSMutableDictionary *registeredImplementations;
@end

@implementation MBTableViewCellConfiguratorFactory

@synthesize styleHandler = _styleHandler;
@synthesize registeredImplementations = _registeredImplementations;

- (id)initWithStyleHandler:(MBStyleHandler *)styleHandler
{
    self = [super init];
    if (self) {
        _styleHandler = [styleHandler retain];
    }
    return self;
}

- (void)registerDefaultImplementations
{
    MBTableViewCellConfiguratorLabel *labelConf = [[MBTableViewCellConfiguratorLabel alloc]
                                                                                     initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:labelConf forFieldType:C_FIELD_LABEL];
    [labelConf release];

    MBTableViewCellConfiguratorDropDownList *dropDownConf = [[MBTableViewCellConfiguratorDropDownList alloc]
                                                                                     initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:dropDownConf forFieldType:C_FIELD_DROPDOWNLIST];
    [dropDownConf release];

    MBTableViewCellConfiguratorDate *dateConf = [[MBTableViewCellConfiguratorDate alloc]
                                                                                     initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:dateConf forFieldType:C_FIELD_DATETIMESELECTOR];
    [self registerTableViewCellConfigurator:dateConf forFieldType:C_FIELD_DATESELECTOR];
    [self registerTableViewCellConfigurator:dateConf forFieldType:C_FIELD_TIMESELECTOR];
    [self registerTableViewCellConfigurator:dateConf forFieldType:C_FIELD_BIRTHDATE];
    [dateConf release];

    MBTableViewCellConfiguratorSubLabel *sublabelConf = [[MBTableViewCellConfiguratorSubLabel alloc]
                                                                                                      initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:sublabelConf forFieldType:C_FIELD_SUBLABEL];
    [sublabelConf release];

    MBTableViewCellConfiguratorCheckbox *checkboxConf = [[MBTableViewCellConfiguratorCheckbox alloc]
                                                                                              initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:checkboxConf forFieldType:C_FIELD_CHECKBOX];
    [checkboxConf release];

    MBTableViewCellConfiguratorInput *inputConf = [[MBTableViewCellConfiguratorInput alloc]
                                                                                     initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:inputConf forFieldType:C_FIELD_INPUT];
    [self registerTableViewCellConfigurator:inputConf forFieldType:C_FIELD_USERNAME];
    [self registerTableViewCellConfigurator:inputConf forFieldType:C_FIELD_PASSWORD];
    [inputConf release];

    MBTableViewCellConfiguratorText *textConf = [[MBTableViewCellConfiguratorText alloc]
                                                                                  initWithStyleHandler:self.styleHandler];
    [self registerTableViewCellConfigurator:textConf forFieldType:C_FIELD_TEXT];
    [textConf release];
}

- (NSMutableDictionary *)registeredImplementations
{
    if (!_registeredImplementations) {
        _registeredImplementations = [[NSMutableDictionary dictionary] retain];
        [self registerDefaultImplementations];
    }
    return _registeredImplementations;
}

- (void)registerTableViewCellConfigurator:(MBTableViewCellConfigurator *)configurator forFieldType:(NSString *)type
{
    [self.registeredImplementations setObject:configurator forKey:type];
}

- (MBTableViewCellConfigurator *)configuratorForFieldType:(NSString *)fieldType
{
    return [self.registeredImplementations objectForKey:fieldType];
}

- (void)dealloc
{
    [_styleHandler release];
    [_registeredImplementations release];
    [super dealloc];
}


@end