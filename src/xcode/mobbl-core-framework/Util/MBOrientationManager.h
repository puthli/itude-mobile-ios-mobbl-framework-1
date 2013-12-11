/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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


@interface MBOrientationManager : NSObject {

}
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
@property (nonatomic, assign) BOOL shouldAutorotate;

/// @name Getting a service instance
/** The shared instance */
+ (MBOrientationManager *) sharedInstance;

/**
 * Checks if the given interfaceOrientation is supported
 * @param interfaceOrientation = the interfaceOrientation that needs to be compared with all supported interfaceOrientations
 * @return Returns TRUE if the provided interfaceOrientation is supported. 
 */
- (BOOL) supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

//// iOS 5.1 and lower
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;


// iOS 6.0 and higher
- (BOOL) shouldAutorotate;
//- (NSUInteger)supportedInterfaceOrientations;

@end
