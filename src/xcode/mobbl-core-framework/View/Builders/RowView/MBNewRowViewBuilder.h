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
#import "MBRowViewBuilder.h"

@interface MBNewRowViewBuilder : MBViewBuilder <MBRowViewBuilder>

/**
 * Returns a UITableViewCell using the tableView delegate to acquire an already allocated cell or allocating a new one.
 * Override this method in your own RowViewBuilder to add additional behaviour.
 * @return A UITableViewCell
 * @param tableView = The UITableView used to acquire an already allocated cell.
 * @param cellReuseIdentifier = A string used to identify a cell that is reusable.
 * @param cellStyle = An enumeration for the various styles of cells.
 * @param panel = The Panel used to build the content of the UITableViewCell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView withType:(NSString *)cellReuseIdentifier style:(UITableViewCellStyle)cellstyle panel:(MBPanel *)panel;

/**
 * Returns a UITableViewCellStyle*
 * Override this method in your own RowViewBuilder to return a specific UITableViewCellStyle.
 * @return A UITableViewCellStyle
 * @param panel = The Panel used to build the content of the UITableViewCell.
 */
- (UITableViewCellStyle) tableViewCellStyleForRow:(MBPanel *)panel;

/**
 * Returns a string that is used as reuseIdenfitier for the UITableViewCell that is build for the MBPanel.
 * Override this method in your own RowViewBuilder to return a specific CellIdentifier.
 * @return A string representation of a reuseIdentifier.
 * @param panel = The Panel used to build the content of the UITableViewCell.
 */
- (NSString *) cellReuseIdentifierForRow:(MBPanel *)panel;

/**
 * Returns UITableViewCellSelectionStyleBlue if the panel has an outcome.
 * Returns UITableViewCellSelectionStyleNone if the panel has no outcome.
 * Override this method in your own RowViewBuilder to return a specific UITableViewCellSelectionStyle
 * @return A UITableViewCellSelectionStyle
 * @param panel = The Panel used to build the content of the UITableViewCell.
 */
- (UITableViewCellSelectionStyle)cellSelectionStyleForRow:(MBPanel *)panel;

/**
 * Returns UITableViewCellAccessoryDisclosureIndicator if the panel has an outcome.
 * Returns UITableViewCellAccessoryNone if the panel has no outcome.
 * Override this method in your own RowViewBuilder to return a specific UITableViewCellAccessoryType.
 * @return A UITableViewCellAccessoryType
 * @param panel = The Panel used to build the content of the UITableViewCell.
 */
- (UITableViewCellAccessoryType)cellAccesoryTypeForRow:(MBPanel *)panel;

@end
