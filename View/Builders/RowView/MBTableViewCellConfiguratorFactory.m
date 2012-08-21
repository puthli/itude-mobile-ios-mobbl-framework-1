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

@implementation MBTableViewCellConfiguratorFactory

- (id)initWithStyleHandler:(MBStyleHandler *)styleHandler
{
    self = [super init];
    if (self) {
        _styleHandler = [styleHandler retain];
    }
    return self;
}

- (MBTableViewCellConfigurator *)configuratorForFieldType:(NSString *)fieldType
{
    if ([C_FIELD_LABEL isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorLabel alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }
    if ([C_FIELD_DROPDOWNLIST isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorDropDownList alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }
    if ([C_FIELD_DATETIMESELECTOR isEqualToString:fieldType] ||
            [C_FIELD_DATESELECTOR isEqualToString:fieldType] ||
            [C_FIELD_TIMESELECTOR isEqualToString:fieldType] ||
            [C_FIELD_BIRTHDATE isEqualToString:fieldType]) {

        return [[[MBTableViewCellConfiguratorDate alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }

    if ([C_FIELD_SUBLABEL isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorSubLabel alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }

    if ([C_FIELD_CHECKBOX isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorCheckbox alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }

    if ([C_FIELD_INPUT isEqualToString:fieldType]||
            [C_FIELD_USERNAME isEqualToString:fieldType]||
            [C_FIELD_PASSWORD isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorInput alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }
    if ([C_FIELD_TEXT isEqualToString:fieldType]){
        return [[[MBTableViewCellConfiguratorText alloc] initWithStyleHandler:self.styleHandler] autorelease];
    }

    // Unknown type
    return nil;
}

- (void)dealloc
{
    [_styleHandler release];
    [super dealloc];
}


@end