//
//  NotificationService.swift
//  CleverTapRichNotificationExtension
//
//  Created by Mehera on 17/04/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UserNotifications


class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler : ((UNNotificationContent) -> Void)?
    var content        : UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler:
        @escaping (UNNotificationContent) -> Void) {
        // call to record the Notification viewed
               
        super.didReceive(request, withContentHandler: contentHandler)

        self.contentHandler = contentHandler
        self.content        = (request.content.mutableCopy()
            as? UNMutableNotificationContent)
        if let bca = self.content {
            func save(_ identifier: String,
                      data: Data, options: [AnyHashable: Any]?)
                -> UNNotificationAttachment? {
                    let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString,
                        isDirectory: true)
                    do {
                        try FileManager.default.createDirectory(at: directory,
                                                                withIntermediateDirectories: true,
                                                                attributes: nil)
                        let fileURL = directory.appendingPathComponent(identifier)
                        try data.write(to: fileURL, options: [])
                        return try UNNotificationAttachment.init(identifier: identifier,
                                                                 url: fileURL,
                                                                 options: options)
                    } catch {}
                    return nil
            }
            
            func exitGracefully(_ reason: String = "") {
                let bca    = request.content.mutableCopy()
                    as? UNMutableNotificationContent
                bca!.title = reason
                contentHandler(bca!)
            }
            
            DispatchQueue.main.async {
                guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
                    return exitGracefully()
                }
                let userInfo : [AnyHashable: Any] = request.content.userInfo
                guard let attachmentURL = userInfo["mediaURL"] as? String else {
                    return exitGracefully()
                }
                guard let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
                    return exitGracefully()
                }
                guard let attachment = save("image.png", data: imageData, options: nil) else {
                    return exitGracefully()
                }
                content.attachments = [attachment]
                contentHandler(content)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bca =  self.content {
            contentHandler(bca)
        }
    }
    
    
}
