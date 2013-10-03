/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBApplicationFactory.h"
#import "MBAction.h"
#import "MBMetadataService.h"
#import "MBOutcome.h"
#import "MBPage.h"
#import "MBPageDefinition.h"
#import "MBBasicViewController.h"
#import "MBTypes.h"

@implementation MBApplicationFactory

static MBApplicationFactory *_instance = nil;

+(MBApplicationFactory *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBApplicationFactory *) factory {
	@synchronized(self) {
		if(_instance != nil && _instance != factory) {
			[_instance release];
		}
		_instance = factory;
		[_instance retain];
	}
}

-(MBPage *) createPage:(MBPageDefinition *)definition 
			  document:(MBDocument*) document 
			  rootPath:(NSString*) rootPath 
			 viewState:(MBViewState) viewState 
		 withMaxBounds:(CGRect) bounds {
	return [[[MBPage alloc] initWithDefinition: definition document: document rootPath:(NSString*) rootPath viewState: viewState withMaxBounds: bounds] autorelease];
}

-(UIViewController<MBViewControllerProtocol> *) createViewController:(MBPage*) page {
    return [[[MBBasicViewController alloc] init] autorelease];
}

-(id<MBAction>) createAction:(NSString *)actionClassName {
    id action = [[NSClassFromString(actionClassName) alloc] init];
    if ([action conformsToProtocol:@protocol(MBAction)]) {
        return [action autorelease];
    } else {
        [action release];
        [NSException raise:@"Invalid action class name" format:@"You have defined an action class named '%@' in your actions configuration but there is no objc class found with that name. Check the actions configuration or create a class named '%@' that follows the MBAction protocol.", actionClassName, actionClassName];
    }
    return nil;
}

-(id<MBResultListener>) createResultListener:(NSString *)listenerClassName {
    id listener = [[NSClassFromString(listenerClassName) alloc] init];
    if ([listener conformsToProtocol:@protocol(MBResultListener)]) {
        return [listener autorelease];
    } else {
        [listener release];
        [NSException raise:@"Invalid listener class name" format:@"Listener class name %@ is invalid", listenerClassName];
    }
	return nil;
}

@end
