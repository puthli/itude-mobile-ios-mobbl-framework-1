//
//  MBConstantsUtilities.h
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 6/4/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#ifdef SYNTHESIZE_CONSTS
# define DEFINE_CONSTANT(name, value) NSString* const name = value
#else
# define DEFINE_CONSTANT(name, value) extern NSString* const name
#endif