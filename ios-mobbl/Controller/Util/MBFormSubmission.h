//
//  MBFormSubmission.h
//  Core
//
//  Created by Robin Puthli on 6/18/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//
// Generic form handling. Move to Core later after this has been ironed out.



#import "MBAction.h"


@interface MBFormSubmission : NSObject<MBAction> {

}


// subclasses can validate the incoming document in this method and throw exceptions if necessary.
- (void) validateDocument:(MBDocument *) document withPath:(NSString *) path;

@end
