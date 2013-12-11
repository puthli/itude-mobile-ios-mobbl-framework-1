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

#import "MBViewBuilder.h"
#import "MBFieldViewBuilder.h"

@interface MBCheckboxBuilder : MBFieldViewBuilder

/// @name UILabel
-(UILabel *)buildLabelForField:(MBField *)field withMaxBounds:(CGRect)bounds;
- (void)configureLabel:(UILabel *)label forField:(MBField *)field;

/// @name UISwitch
- (UISwitch *)buildSwitchForField:(MBField *)field withMaxBounds:(CGRect)bounds;
- (void)configureSwitch:(UISwitch *)switchView forField:(MBField *)field ;

// Apple Developer documentation states: The size components of the switch frame (rectangle) are ignored.
- (CGRect)frameForSwitch:(UISwitch *)switchView withMaxBounds:(CGRect)bounds;

@end
