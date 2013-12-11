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

// #undef DEBUG

/** Logging macros that are only compiled in for DEBUG targets 
 * DLog(format, ...) for debug statements
 * WLog(format, ...) for warning statements
 * for example DLog(@"%@ %d", "The value of integer x is", x);
 */

// better logging
#ifdef DEBUG
#define DLog(format, ...)	NSLog( @"[%p] %@:%d %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )
#else
#define DLog(...)			{}
#endif

#ifdef DEBUG
#define WLog(format, ...)	NSLog( @"[%p] %@:%d %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )
#else
#define WLog(...)			{}
#endif

