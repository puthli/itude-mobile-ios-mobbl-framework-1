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
#import "MBComponentContainer.h"

@class MBPanelDefinition;

/** Basic building block of an MBPage.
 * MBPanel instances are defined in a page definition in the application definition file(s).
 * You never need to subclass an MBPanel */

@interface MBPanel : MBComponentContainer {

	NSString *_type;
	NSString *_title;
    NSString *_titlePath;
	int _width;
	int _height;
    BOOL _zoomable;
    NSString *_outcomeName;
    NSString *_path;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titlePath;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) BOOL zoomable;
@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *path;

- (id) initWithDefinition:(MBPanelDefinition *)definition document:(MBDocument*) document parent:(MBComponentContainer *) parent buildViewStructure:(BOOL) buildViewStructure;
- (void) rebuild;

@end
