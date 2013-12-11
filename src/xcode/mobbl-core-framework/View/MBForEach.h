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

#import "MBForEachDefinition.h"
#import "MBComponent.h"
#import "MBForEachItem.h"
#import "MBComponentContainer.h"

/** Iterator for creating MBPanel instances based on the data in an MBPage. 
 * MBForEach instances are defined in a page definition in the application definition file(s).
 * You never need to subclass an MBForEach */

@interface MBForEach : MBComponentContainer {
	
	NSMutableArray *_rows; // array of MBRows
	NSString *_value;
}

@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSString *value;

-(void) addRow: (MBForEachItem*) row;

@end
