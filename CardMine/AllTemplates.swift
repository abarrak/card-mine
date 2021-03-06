//
//  AllTemplates.swift
//  CardMine
//
//  Created by Abdullah on 4/26/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

class AllTemplates {
    // Mark: - Properties

    static var templates = [Template]()
    static var count: Int {
        get { return AllTemplates.templates.count }
    }
    static let templatesNotificationId: String = "APITemplatesArrived"
    static var errorMsg: String?

    // Mark: - Methods

    class func load() {
        CardMineClient.shared.getAllTemplates() { (success, errorString, payload) in
            performAsync {
                if success {
                    AllTemplates.templates = payload!
                } else {
                    AllTemplates.errorMsg = errorString
                }
                AllTemplates.notifyOnArrival()
            }
        }
    }

    static func notifyOnArrival() {
        NotificationCenter.default.post(name: Notification.Name(templatesNotificationId), object: nil)
    }
}
