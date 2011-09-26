//
//  MBScriptService.h
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface MBScriptService : NSObject {

	@private
	UIWebView *_webView;
}

+(MBScriptService *) sharedInstance;
-(NSString*) evaluate:(NSString*) expression;

@end
