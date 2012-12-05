//
//  MBTableViewCellConfiguratorFactory 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBStyleHandler;
@class MBTableViewCellConfigurator;

/**
   Factory class for MBTableViewCellConfigurator instances.
*/
@interface MBTableViewCellConfiguratorFactory : NSObject

/** The MBStyleHandler to be used for constructing the UITableViewCells */
@property (nonatomic, retain) MBStyleHandler *styleHandler;
@property (nonatomic,retain) MBTableViewCellConfigurator *defaultConfigurator;

- (id)initWithStyleHandler:(MBStyleHandler *)styleHandler;

/**
* Registers the MBTableViewConfigurator implementation to use for the given [MBField type].
*/
- (void)registerTableViewCellConfigurator:(MBTableViewCellConfigurator *)configurator forFieldType:(NSString *)type;

/**
* @return the correct MBTableViewCellConfigurator for the given [MBField type]
*/
- (MBTableViewCellConfigurator *)configuratorForFieldType:(NSString *)fieldType;

@end