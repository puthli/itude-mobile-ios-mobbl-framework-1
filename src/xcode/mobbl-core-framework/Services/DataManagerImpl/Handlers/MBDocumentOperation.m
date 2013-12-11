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

#import "MBMacros.h"
#import "MBDocumentOperation.h"
#import "MBMetadataService.h"

@implementation MBDocumentOperation

@synthesize dataHandler = _dataHandler;
@synthesize document = _document;
@synthesize documentName = _documentName;
@synthesize arguments = _arguments;
@synthesize loadFreshCopy = _loadFreshCopy;

- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler document:(MBDocument*) document
{
	self = [super init];
	if (self != nil) {
		self.dataHandler = dataHandler;
		self.document = document;
        self.loadFreshCopy = NO;
	}
	return self;
}

- (id) initWithDataHandler:(id<MBDataHandler>) dataHandler documentName:(NSString*) documentName arguments:(MBDocument*) arguments
{
	self = [super init];
	if (self != nil) {
		self.dataHandler = dataHandler;
		self.documentName = documentName;
		self.arguments = arguments;
        self.loadFreshCopy = NO;
	}
	return self;
}

- (void) dealloc
{
	[_documentName release];
	[_arguments release];
	[_document release];
	[super dealloc];
}


-(void) setDelegate:(id) delegate resultCallback:(SEL) resultSelector errorCallback:(SEL) errorSelector {
	_delegate = delegate;
	_resultCallback = resultSelector;
	_errorCallback = errorSelector;
}

-(id) delegate {
	return _delegate;	
}

-(MBDocument*) load {

	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
#ifndef DEBUG
#pragma unused(now)
#endif
	
	MBDocument *arguments = [[self.arguments copy] autorelease];

	MBDocument *doc;
    if (self.loadFreshCopy){
        if(self.arguments == nil) doc = [self.dataHandler loadFreshDocument:self.documentName];
        else doc = [self.dataHandler loadFreshDocument:self.documentName withArguments: arguments];
    }
    else{
        if(self.arguments == nil) doc = [self.dataHandler loadDocument:self.documentName];
        else doc = [self.dataHandler loadDocument:self.documentName withArguments: arguments];
    }
	if(doc == nil) {
		MBDocumentDefinition *docDef = [[MBMetadataService sharedInstance]definitionForDocumentName: self.documentName];
		if([docDef autoCreate]) doc = [docDef createDocument];	
	}
	doc.argumentsUsed = self.arguments;
	DLog(@"Loading of document %@ took %0.3f seconds", self.documentName, [NSDate timeIntervalSinceReferenceDate] - now);
	return doc;
}
	
-(void) store {
	[self.dataHandler storeDocument: self.document];
}

- (void) main {

	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	@try {
		if(_document == nil) {
			MBDocument *document = [self load];
			if(_resultCallback != nil) [_delegate performSelectorOnMainThread:_resultCallback withObject:document waitUntilDone:YES];
		}
		else {
			[self store];
			if(_resultCallback != nil) [_delegate performSelectorOnMainThread:_resultCallback withObject:nil waitUntilDone:YES];
		}
	}
	@catch (NSException *e) {
		WLog(@"Exception during Document Operation: %@, %@", e.name, e.reason);
		if(_errorCallback != nil) [_delegate performSelectorOnMainThread:_errorCallback withObject:e waitUntilDone:YES];
	}
	@finally {
		[pool release];
	}
}

@end
