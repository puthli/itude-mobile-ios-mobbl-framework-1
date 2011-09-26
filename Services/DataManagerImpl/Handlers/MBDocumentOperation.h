//
//  MBDocumentLoader.h
//  Core
//
//  Created by Wido on 10-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
}

@property (nonatomic, assign) id<MBDataHandler> dataHandler;
@property (nonatomic, retain) NSString *documentName;
@property (nonatomic, retain) MBDocument *arguments;
@property (nonatomic, retain) MBDocument *document;

- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler documentName:(NSString*) documentName arguments:(MBDocument*) arguments;
- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler document:(MBDocument*) document;
- (void) setDelegate:(id) delegate resultCallback:(SEL) resultSelector errorCallback:(SEL) errorSelector;
- (id) delegate;
- (MBDocument*) load;

@end
