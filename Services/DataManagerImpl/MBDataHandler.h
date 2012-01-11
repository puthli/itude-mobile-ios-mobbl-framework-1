//
//  MBDataServiceProtocol.h
//  Core
//
//  Created by Robert Meijer, Wido on 5/3/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBDocument.h"
#import "MBDataHandler.h"

@protocol MBDataHandler

- (MBDocument *) loadDocument:(NSString *)documentName;
- (MBDocument *) loadFreshDocument:(NSString *)documentName;
- (MBDocument *) loadDocument:(NSString *)documentName withArguments:(MBDocument*) args;
- (MBDocument *) loadFreshDocument:(NSString *)documentName withArguments:(MBDocument*) args;
- (void) storeDocument:(MBDocument *)document;

@end
