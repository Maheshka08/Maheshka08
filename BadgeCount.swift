//
//  BadgeCount.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 15/11/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm;
import RealmSwift;

class BadgeCount: Object {
    dynamic var badgeCount = 0;
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }

    
}
