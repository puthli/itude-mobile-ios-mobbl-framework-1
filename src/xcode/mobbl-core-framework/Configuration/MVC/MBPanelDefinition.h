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

#import "MBFieldDefinition.h"
#import "MBDefinition.h"
#import "MBConditionalDefinition.h"

@interface MBPanelDefinition : MBConditionalDefinition {
	NSString *_type;
	NSString *_style;
	NSString *_title;
	NSString *_titlePath;
    BOOL zoomable;
	int _width;
	int _height;
    NSString *_outcomeName;
    NSString *_path;
	NSMutableArray *_children;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titlePath;
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, assign) BOOL zoomable;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, retain) NSString *outcomeName;
@property (nonatomic, retain) NSString *path;

- (void) addChild:(MBDefinition*)child;

@end
