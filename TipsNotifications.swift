//
//  TipsNotifications.swift
//  Tweak and Eat
//
//  Created by admin on 5/25/17.
//  Copyright © 2017 Viswa Gopisetty. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class DailyTipsNotify: Object {
    
    @objc dynamic var pkg_evt_id = " ";
    @objc dynamic var selectedDate = "";
    @objc dynamic var selectedTime = "";
    @objc dynamic var tipNotificationMessage = " ";
    @objc dynamic var timeIn = Date()
    
    override static func primaryKey() -> String? {
        return "pkg_evt_id";
    }    
}
