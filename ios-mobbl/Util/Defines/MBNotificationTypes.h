//
//  MBNotificationTypes.h
//  Core
//
//  Created by Frank van Eenbergen on 11/17/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

/**
 * These are a collection of notification names that are used troughout the framework for posting notifications.
 * Notifications should never be posed with a local name, because if we do, we lose track of which notifications are posted
 */
#define ACCOUNT_CHANGED_NOTIFICATION	@"AccountChanged"

#define MODAL_VIEW_CONTROLLER_PRESENTED	@"Modal View Controller presented"
#define MODAL_VIEW_CONTROLLER_DISMISSED	@"Modal View Controller dismissed"