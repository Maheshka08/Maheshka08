//
//  UserPackagesNutritionChat.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 16/05/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserPackagesNutritionChat: Object {
    
    @objc dynamic var chatID = ""
    @objc dynamic var isFirstMessage = false
    @objc dynamic var isLastMessage = false
    @objc dynamic var nutritionistFBID = ""
    
    override static func primaryKey() -> String? {
        return "chatID";
    }
}
