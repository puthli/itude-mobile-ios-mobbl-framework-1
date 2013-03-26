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
#import "FMDatabase.h"

#define C_DATABASE_NAME @"database.db"

@implementation MBSQLDataHandler{
    FMDatabase *_database;
}

- (void)dealloc
{
    [_database close];
    [_database release];
    [super dealloc];
}

- (FMDatabase *)database
{
    if (!_database) {
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:C_DATABASE_NAME];
        _database = [[FMDatabase databaseWithPath:dbPath] retain];
        [_database open];
    }
    return _database;
}



- (MBDocument *)loadDocument:(NSString *)documentName withArguments:(MBDocument *)args {
    /*
    if ([args.name isEqualToString:C_SEARCH_DOCNAME]) {
        NSString *query = [args valueForPath:C_SEARCH_QUERY_PATH];
        MBDocument *document = [[[MBMetadataService sharedInstance] definitionForDocumentName:documentName] createDocument];
        
        FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM sections WHERE simplified_context LIKE '%%%@%%' OR displayTitle LIKE '%%%@%%' OR context LIKE '%%%@%%' OR notes LIKE '%%%@%%'", query, query, query, query]];
        while ([resultSet next]) {
            [self addSectionToConstitutionDoc:document fromResultSet:resultSet];
        }
        return document;
    }
     */
    return [super loadDocument:documentName withArguments:args];
}



- (MBDocument *)loadDocument:(NSString *)documentName {
    MBDocument *document = [[[MBMetadataService sharedInstance] definitionForDocumentName:documentName] createDocument];
    /*
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM chapters"];
    while ([resultSet next]) {
        [self addChapterToConstitutionDoc:document fromResultSet:resultSet];
    }
     */
    return document;
    
}

// Chapter columns
/*
typedef enum {
	CHAPTER_ID = 0,
    CHAPTER_INDEX = 1,
    CHAPTER_NAME = 2,
    CHAPTER_DISPLAY_NAME = 3,
    CHAPTER_DESCRIPTION = 4,
} CHAPTERS;

// Section Columns
typedef enum {
	SECTION_ID = 0,
    SECTION_CHAPTER_ID = 1,
    SECTION_ARTICLE = 2,
    SECTION_TITLE = 3,
    SECTION_DISPLAY_TITLE = 4,
    SECTION_DISPLAY_TITLE_SHORT = 5,
    SECTION_CONTEXT = 6,
    SECTION_SIMPLIFIED_CONTEXT = 7,
    SECTION_NOTES = 8,
    SECTION_REMOVED = 9,
    
} SECTIONS;

- (void)addChapterToConstitutionDoc:(MBDocument *)doc fromResultSet:(FMResultSet *)chapterResultSet {
    
    // Parse the Chapters
    NSString *chapterId = [chapterResultSet stringForColumnIndex:CHAPTER_ID];
    NSString *index = [chapterResultSet stringForColumnIndex:CHAPTER_INDEX];
    NSString *name = [chapterResultSet stringForColumnIndex:CHAPTER_NAME];
    NSString *displayName = [chapterResultSet stringForColumnIndex:CHAPTER_DISPLAY_NAME];
    NSString *description = [chapterResultSet stringForColumnIndex:CHAPTER_DESCRIPTION];
    
    MBElement *chapterElement = [doc createElementWithName:EL_CHAPTER];
    [chapterElement setValue:chapterId forAttribute:EL_CHAPTER_ATTR_ID];
    [chapterElement setValue:index forAttribute:EL_CHAPTER_ATTR_INDEX];
    [chapterElement setValue:name forAttribute:EL_CHAPTER_ATTR_NAME];
    [chapterElement setValue:displayName forAttribute:EL_CHAPTER_ATTR_DISPLAY_NAME];
    
    [self createElementInElement:chapterElement withElementName:EL_CHAPTER_DESCRIPTION bodyText:description];
    
    // Add the sections
    NSArray *args = [NSArray arrayWithObjects:chapterId, nil];
    FMResultSet *sectionResultSet = [self.database executeQuery:@"SELECT * FROM sections WHERE chapter_id=?" withArgumentsInArray:args];
    while ([sectionResultSet next]) {
        [self addSectionToChapter:chapterElement fromResultSet:sectionResultSet];
    }
    
}

- (void)addSectionToConstitutionDoc:(MBDocument *)doc fromResultSet:(FMResultSet *)sectionResultSet {
    NSString *chapterId = [sectionResultSet stringForColumnIndex:SECTION_CHAPTER_ID];
    MBElement *chapterElement = [self chapterElementForChapterId:chapterId inConstitutionDoc:doc];
    [self addSectionToChapter:chapterElement fromResultSet:sectionResultSet];
}


- (void)addSectionToChapter:(MBElement *)chapterElement fromResultSet:(FMResultSet *)sectionResultSet {
    // Parse the Sections
    NSString *sectionId = [sectionResultSet stringForColumnIndex:SECTION_ID];
    NSString *article = [sectionResultSet stringForColumnIndex:SECTION_ARTICLE];
    NSString *title = [sectionResultSet stringForColumnIndex:SECTION_TITLE];
    NSString *displayTitle = [sectionResultSet stringForColumnIndex:SECTION_DISPLAY_TITLE];
    NSString *displayTitleShort = [sectionResultSet stringForColumnIndex:SECTION_DISPLAY_TITLE_SHORT];
    NSString *context = [sectionResultSet stringForColumnIndex:SECTION_CONTEXT];
    NSString *simplifiedContext = [sectionResultSet stringForColumnIndex:SECTION_SIMPLIFIED_CONTEXT];
    NSString *notes = [sectionResultSet stringForColumnIndex:SECTION_NOTES];
    NSString *removed = [sectionResultSet stringForColumnIndex:SECTION_REMOVED];
    
    MBElement *sectionElement = [chapterElement createElementWithName:EL_CHAPTER_SECTION];
    [sectionElement setValue:sectionId forAttribute:EL_CHAPTER_SECTION_ATTR_ID];
    [sectionElement setValue:article forAttribute:EL_CHAPTER_SECTION_ATTR_ARTICLE];
    [sectionElement setValue:title forAttribute:EL_CHAPTER_SECTION_ATTR_TITLE];
    [sectionElement setValue:displayTitle forAttribute:EL_CHAPTER_SECTION_ATTR_DISPLAY_TITLE];
    [sectionElement setValue:displayTitleShort forAttribute:EL_CHAPTER_SECTION_ATTR_DISPLAY_TITLE_SHORT];
    
    [sectionElement setValue:removed forAttribute:EL_CHAPTER_SECTION_ATTR_REMOVED];
    
    [self createElementInElement:sectionElement withElementName:EL_CHAPTER_SECTION_CONTEXT bodyText:context];
    [self createElementInElement:sectionElement withElementName:EL_CHAPTER_SECTION_SIMPLIFIED_CONTEXT bodyText:simplifiedContext];
    [self createElementInElement:sectionElement withElementName:EL_CHAPTER_SECTION_NOTES bodyText:notes];
}

- (void)createElementInElement:(MBElement *)element withElementName:(NSString *)elementName bodyText:(NSString *)text
{
    MBElement *newElement = [element createElementWithName:elementName];
    [newElement setBodyText:text];
}

- (MBElement *)chapterElementForChapterId:(NSString *)chapterId inConstitutionDoc:(MBDocument *)doc {
    for (MBElement *chapterElement in [doc elementsWithName:@"Chapter"]) {
        if ([[chapterElement valueForPath:@"@id"] isEqualToString:chapterId]) {
            return chapterElement;
        }
    }
    
    // If element does not exist
    MBElement *chapterElement = nil;
    FMResultSet *chapterResultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM chapters WHERE chapter_id LIKE '%@'", chapterId]];
    if ([chapterResultSet next]) {
        // Parse the Chapters
        NSString *cId = [chapterResultSet stringForColumnIndex:CHAPTER_ID];
        NSString *index = [chapterResultSet stringForColumnIndex:CHAPTER_INDEX];
        NSString *name = [chapterResultSet stringForColumnIndex:CHAPTER_NAME];
        NSString *displayName = [chapterResultSet stringForColumnIndex:CHAPTER_DISPLAY_NAME];
        NSString *description = [chapterResultSet stringForColumnIndex:CHAPTER_DESCRIPTION];
        
        chapterElement = [doc createElementWithName:EL_CHAPTER];
        [chapterElement setValue:cId forAttribute:EL_CHAPTER_ATTR_ID];
        [chapterElement setValue:index forAttribute:EL_CHAPTER_ATTR_INDEX];
        [chapterElement setValue:name forAttribute:EL_CHAPTER_ATTR_NAME];
        [chapterElement setValue:displayName forAttribute:EL_CHAPTER_ATTR_DISPLAY_NAME];
        
        [self createElementInElement:chapterElement withElementName:EL_CHAPTER_DESCRIPTION bodyText:description];
    }
    return chapterElement;
}
*/
@end