//
//  NotificationService.swift
//  RichPush
//
//  Created by Mayank Sanganeria on 6/16/20.
//  Copyright © 2024 Leanplum. All rights reserved.
//

import UserNotifications
import CTNotificationService

class NotificationService: CTNotificationServiceExtension {

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        super.didReceive(request, withContentHandler: contentHandler)
    }
}
