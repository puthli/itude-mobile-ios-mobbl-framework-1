//
//  MBTableViewCellConfigurator 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBField.h"
#import "MBStyleHandler.h"

/**
  Configures an existing UITableViewCell with the content of a given MBField.

  The MBTableViewCellConfigurator configures a UITableViewCell for display. It is responsible for setting properties
  and adding necessary subviews based on the configuration in the MBField.

  There exist various subclasses of this class for different MBField types. Use MBTableViewCellConfiguratorFactory
  to obtain the correct implementation for any MBField.
*/
@interface MBTableViewCellConfigurator : NSObject

// @name Initializing a MBTableViewCellConfigurator object
- (id)initWithStyleHandler:(MBStyleHandler *)styleHandler;

// @name Getting the MBStyleHandler that is used for cell configuration
@property (nonatomic, retain) MBStyleHandler *styleHandler;

// @name Configuring a UITableViewCell
- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field;

// @name Utility methods for subclasses
- (void)addAccessoryDisclosureIndicatorToCell:(UITableViewCell *)cell;



- (void) configureView:(UIView*)view forField:(MBField*)field;
@end