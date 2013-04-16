//
//  MBSQLDataHandler.h
//  itude-mobile-iphone-core
//
//  Created by Ricardo de Wilde on 3/26/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDataHandlerBase.h"

#import "FMDatabase.h"

@interface MBSQLDataHandler : MBDataHandlerBase {
    FMDatabase *_database;
    NSString *_databaseName;
}

@property (nonatomic, retain) NSString *databaseName;

@end
