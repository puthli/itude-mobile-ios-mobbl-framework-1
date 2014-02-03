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

@class MBDocument;

@interface MBDocumentDiff : NSObject {

	NSMutableSet *_modified; // A collection with paths for differences in values between document A and B
	NSMutableDictionary *_aValues; // A collection with values from document A that are different with the values from document B.
	NSMutableDictionary *_bValues;// A collection with values from document B that are different with the values from document A.

}

/** 
 * Instantiates a MBDocumentDiff object with two different documents and looks for differences between the two documents
 * @param a = The first document that needs to be compared
 * @param b = The second document that needs to be compared
 * @return The instantiated MBDocumentDiff object with differences
 */
- (id) initWithDocumentA:(MBDocument*) a andDocumentB:(MBDocument*) b;

/** 
 * Checks if document A and document B are different.
 * @return Returns TRUE if any value in document A is different from document B. Returns FALSE if the documents are the same.
 */
- (BOOL) isChanged;


/**
 * Looks for differences in the values between document A and B on the suppied path
 * @param path = The path that needs to be checked for differences
 * @return Returns TRUE if the value for the given path in document A and B is different (has changed)
 */
- (BOOL) isChanged:(NSString*) path;


/** 
 * Gets a collection with paths to values that are different in document A and B
 * @return Returns an NSSet with paths to values that are different in document A and B
 */
- (NSSet*) paths;


/**
 * Returns the value for path in document A
 * @param path = The path to the element or attribute in document A
 * @return Returns a string with the value of an attribute or element on the path in document A
 */
- (NSString*) valueOfAForPath:(NSString*) path;


/**
 * Returns the value for path in document B
 * @param path = The path to the element or attribute in document B
 * @return Returns a string with the value of an attribute or element on the path in document B
 */
- (NSString*) valueOfBForPath:(NSString*) path;

@end
