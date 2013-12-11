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

#import "MBAlert.h"
#import "MBApplicationFactory.h"
#import "MBComponentFactory.h"
#import "MBViewbuilderFactory.h"
#import "MBFieldTypes.h"


@implementation MBAlert

@synthesize alertName = _alertName;
@synthesize rootPath = _rootPath;
@synthesize title = _title;
@synthesize document = _document;
@synthesize alertView = _alertView;

- (void)dealloc
{
    [_alertName release];
    [_rootPath release];
    [_title release];
    [_document release];
    [_alertView release];
    [super dealloc];
}

-(id) initWithDefinition:(MBAlertDefinition*) definition
                document:(MBDocument*) document
                rootPath:(NSString*) rootPath
                delegate:(id<UIAlertViewDelegate>)alertViewDelegate {


    if (self = [super initWithDefinition:definition document:document parent:nil])
    {
        self.rootPath = rootPath;
        self.document = document;
        self.title = definition.title;
        self.alertName = definition.name;

        // Ok; now we can build the children:
        for(MBDefinition *def in definition.children) {
			if([def isPreConditionValid:document currentPath:[[self parent] absoluteDataPath]]) {
                [self addChild: [MBComponentFactory componentFromDefinition: def document: document parent: self]];
            } 
		}
        
        self.alertView = [[[MBViewBuilderFactory sharedInstance] alertViewBuilder] buildAlertView:self forDelegate:alertViewDelegate];

    }
	return self;
}

- (MBOutcome *)outcomeForButtonAtIndex:(NSInteger)index {    
    MBField *field = [self.alertView fieldForButtonAtIndex:index];
    if (field.outcomeName.length > 0) {
        MBOutcome *outcome = [[[MBOutcome alloc] initWithOutcomeName:field.outcomeName document:self.document] autorelease];
        outcome.path = field.path;
        return outcome;
    }
    
    return nil;
}


@end
