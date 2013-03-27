//
//  MBSQLDataHandler.m
//  itude-mobile-iphone-core
//
//  Created by Ricardo de Wilde on 3/26/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBSQLDataHandler.h"
#import "MBMetadataService.h"

#import "FMResultSet.h"

#define C_DATABASE_NAME @"database.db"
#define C_GENERIC_SQL_REQUEST @"MBGenericSQLRequest"

@implementation MBSQLDataHandler

@synthesize databaseName = _databaseName;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.databaseName = C_DATABASE_NAME;
	}
	return self;
}

- (void)dealloc
{
    [_database close];
    [_database release];
    [_databaseName release];
    [super dealloc];
}

- (FMDatabase *)database
{
    if (!_database) {
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
        _database = [[FMDatabase databaseWithPath:dbPath] retain];
        [_database open];
    }
    return _database;
}

- (MBDocument *)loadDocument:(NSString *)documentName withArguments:(MBDocument *)args {
    MBDocument *document = [[[MBMetadataService sharedInstance] definitionForDocumentName:documentName] createDocument];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", documentName];
    BOOL firstParameter = YES;
    
    for (MBElement *parameter in [args valueForPath:@"/Query[0]/Parameter"]) {
        NSString *key  = [parameter valueForAttribute:@"key"];
        NSString *value = [parameter valueForAttribute:@"value"];
        
        query = [NSString stringWithFormat:@"%@ %@ %@ LIKE '%%%@%%'", query, (firstParameter?@"WHERE":@"AND"), key, value];
        firstParameter = NO;
    }
    
    FMResultSet *resultSet = [self.database executeQuery:query];
    while ([resultSet next]) {
        [self addResultSet:resultSet toDocument:document];
    }
    return document;
}

- (MBDocument *)loadDocument:(NSString *)documentName {
    MBDocument *document = [[[MBMetadataService sharedInstance] definitionForDocumentName:documentName] createDocument];
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", documentName]];
    while ([resultSet next]) {
        [self addResultSet:resultSet toDocument:document];
    }
    
    return document;
    
}

- (void)addResultSet:(FMResultSet*)resultSet toDocument:(MBDocument*)document {
    MBDocumentDefinition *documentDefinition = [[MBMetadataService sharedInstance] definitionForDocumentName:document.name];
    MBElementDefinition *elementDefinition = [[documentDefinition children]objectAtIndex:0];
    MBElement *resultSetRow = [document createElementWithName:[elementDefinition name]];
    NSArray *resultSetColumnNames = [elementDefinition attributes];
    for (int i=0; i<[resultSetColumnNames count]; i++) {
        NSString *columnName = [[resultSetColumnNames objectAtIndex:i] valueForKey:@"name"];
        NSString *columnValue = [resultSet stringForColumn:columnName];
        [resultSetRow setValue:columnValue forAttribute:columnName];
    }
}

@end