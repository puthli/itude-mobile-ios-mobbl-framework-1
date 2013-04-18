//
//  MBURLConnectionDataHandler.h
//  itude-mobile-iphone-core
//
//  Created by Pieter Kuijpers on 27-03-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBWebserviceDataHandler.h"

// Delegate used for callbacks in asynchronous http request. //
@interface MBRequestDelegate : NSObject // <NSURLConnectionDelegate> from iOS 5 on
{
	
	BOOL _finished;
	NSMutableData *_data;
	NSURLConnection *_connection;
	NSError *_err;
	NSURLResponse *_response;
	
}

@property BOOL finished;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSError *err;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSMutableData *data;

@end

// Abstract superclass for DataHandler that use a NSURLConnection to access data.
@interface MBURLConnectionDataHandler : MBWebserviceDataHandler

@end
