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

#import "MBComponent.h"
#import "MBElement.h"
#import "MBDefinition.h"
#import "MBComponentContainer.h"

/** Created by an MBForEach depending on the data used in an MBPage. MRRow instances are created by the MOBBL Framework when an MBPage is constructed by an MBViewBuilder. 
 * MBForEach instances are defined in a page definition in the application definition file(s). MBRow instances are NOT in the definition files because they are created dynamically for each element of data found in the MBDocument that matches the MBForEach definition. To create MBRow instances the ForEach element in the definition should contain a Panel element with type="ROW"
 * You never need to subclass an MBRow */

@interface MBForEachItem : MBComponentContainer {
	int _index;
}

@property (nonatomic, assign) int index;

@end
