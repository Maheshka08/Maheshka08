//
//  Announcements.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 11/11/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Announcements: Object {
    
    @objc dynamic var postedOn = "";
    @objc dynamic var imageUrl = "";
    @objc dynamic var announcement = "";
    @objc dynamic var timeIn = NSDate()
    
    override static func primaryKey() -> String? {
        return "postedOn";
    }
}
