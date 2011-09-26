//
//  MBEndPointDefinition.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDocumentDefinition.h"
#import "MBResultListenerDefinition.h"

@interface MBEndPointDefinition : MBDefinition {
	NSString *_documentIn;
	NSString *_documentOut;
	NSString *_endPointUri;
    NSMutableArray *_resultListeners;
	BOOL _cacheable;
	int _timeout;
	int _ttl;
}

@property (nonatomic, retain) NSString *documentIn;
@property (nonatomic, retain) NSString *documentOut;
@property (nonatomic, retain) NSString *endPointUri;
@property (nonatomic, assign) BOOL cacheable;
@property (nonatomic, assign) int timeout;
@property (nonatomic, assign) int ttl;

- (void) addResultListener:(MBResultListenerDefinition*) lsnr;
- (NSMutableArray*) resultListeners;

@end
