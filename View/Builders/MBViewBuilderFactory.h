/*
 * (C) Copyright Google Inc.
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


@class MBPanelViewBuilder;
@class MBPageViewBuilder;
@class MBForEachViewBuilder;
@class MBRowViewBuilder;
@class MBFieldViewBuilder;
@class MBStyleHandler;

@interface MBViewBuilderFactory : NSObject {

	MBPanelViewBuilder *_panelViewBuilder;
	MBPageViewBuilder *_pageViewBuilder;
	MBForEachViewBuilder *_forEachViewBuilder;
	MBRowViewBuilder *_rowViewBuilder;
	MBFieldViewBuilder *_fieldViewBuilder;
	MBStyleHandler *_styleHandler;
	
}

@property (nonatomic, retain) MBPanelViewBuilder *panelViewBuilder;
@property (nonatomic, retain) MBPageViewBuilder *pageViewBuilder;
@property (nonatomic, retain) MBForEachViewBuilder *forEachViewBuilder;
@property (nonatomic, retain) MBRowViewBuilder *rowViewBuilder;
@property (nonatomic, retain) MBFieldViewBuilder *fieldViewBuilder;
@property (nonatomic, retain) MBStyleHandler *styleHandler;

+(MBViewBuilderFactory *) sharedInstance;
+(void) setSharedInstance:(MBViewBuilderFactory *) factory;


@end
