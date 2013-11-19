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

/**
 * These are a collection of notification names that are used troughout the framework for posting notifications.
 * Notifications should never be posed with a local name, because if we do, we lose track of which notifications are posted
 */
#define ACCOUNT_CHANGED_NOTIFICATION	@"AccountChanged"

#define MODAL_VIEW_CONTROLLER_PRESENTED	@"Modal View Controller presented"
#define MODAL_VIEW_CONTROLLER_DISMISSED	@"Modal View Controller dismissed"