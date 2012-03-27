//
//  TestingMBRESTGetServiceDataHandler.h
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBRESTGetServiceDataHandler.h"

// Testing subclass of MBRESTServiceDataHandler. Makes MBRESTServiceDataHandler class
// usable in unit tests.
@interface TestingMBRESTGetServiceDataHandler : MBRESTGetServiceDataHandler

// MBDocument to be returned by loadDocument methods
@property (nonatomic, retain) MBDocument *nextResult;

// Last request used by data handler, for inspection in unit test
@property (nonatomic, retain) NSURLRequest *lastRequest;

@end
