//
//  MBConfigurationParserProtocol.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@protocol MBConfigurationParserProtocol

@required
- (BOOL) processElement:(NSString*)elementName attributes:(NSDictionary*)attributeDict;
- (BOOL) isConcreteElement:(NSString*)element;
- (BOOL) isIgnoredElement:(NSString*)element;

@optional
- (void) didProcessElement:(NSString*)elementName;

@end
