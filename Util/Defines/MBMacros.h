//
//  MBMacros.h
//  Core
//
//  Created by Daniel Salber on 6/29/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

// #undef DEBUG

/** Logging macros that are only compiled in for DEBUG targets 
 * DLog(format, ...) for debug statements
 * WLog(format, ...) for warning statements
 * for example DLog(@"%@ %d", "The value of integer x is", x);
 */

// better logging
#ifdef DEBUG
#define DLog(format, ...)	NSLog( @"[%p] %@:%d %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )
#else
#define DLog(...)			{}
#endif

#ifdef DEBUG
#define WLog(format, ...)	NSLog( @"[%p] %@:%d %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )
#else
#define WLog(...)			{}
#endif

