//
//  NutritionChat.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 22/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class NutritionChat: Object {
    @objc dynamic var tweakID = ""
    @objc dynamic var isFirstMessage = false
    @objc dynamic var isLastMessage = false
    @objc dynamic var nutritionistFBID = ""
    
    override static func primaryKey() -> String? {
        return "tweakID";
    }
}
