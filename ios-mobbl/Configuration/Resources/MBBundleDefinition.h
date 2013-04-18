//
//  MBBundleDefinition.h
//  Core
//
//  Created by Wido on 8-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefinition.h"

@interface MBBundleDefinition : MBDefinition {
	NSString *_languageCode;
	NSString *_url;
}

@property (nonatomic, retain) NSString *languageCode;
@property (nonatomic, retain) NSString *url;
			 

@end
