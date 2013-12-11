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

#import "MBDataHandler.h"
#import "MBDocument.h"

@interface MBDocumentOperation : NSOperation {

	id<MBDataHandler> _dataHandler;
	NSString *_documentName;
	MBDocument *_document;
	MBDocument *_arguments;
	SEL _resultCallback;
	SEL _errorCallback;
	id _delegate;
    BOOL _loadFreshCopy;
}

@property (nonatomic, assign) id<MBDataHandler> dataHandler;
@property (nonatomic, retain) NSString *documentName;
@property (nonatomic, retain) MBDocument *arguments;
@property (nonatomic, retain) MBDocument *document;
@property (assign) BOOL loadFreshCopy;

- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler documentName:(NSString*) documentName arguments:(MBDocument*) arguments;
- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler document:(MBDocument*) document;
- (void) setDelegate:(id) delegate resultCallback:(SEL) resultSelector errorCallback:(SEL) errorSelector;
- (id) delegate;
- (MBDocument*) load;

@end
