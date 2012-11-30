//
//  BinckControllerUtil.h
//  Binck
//
//  Created by Wido on 14-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBBasicViewController.h"
@class MBDocument;

@interface NSObject(Utilities)
-(void) setRequestParameter:(NSString *)value forKey:(NSString *)key forDocument:(MBDocument *)doc;
@end

@interface NSString(BinckUtilities)
- (double)doubleValueDutch;
- (float)floatValueDutch;
- (NSString*)replaceAdditionalHTMLTags;
- (NSString*)getCurrencyCode;
@end
