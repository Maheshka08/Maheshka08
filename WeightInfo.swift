//
//  WeightInfo.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 8/5/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WeightInfo: Object {
    
    @objc dynamic var datetime =  ""
    @objc dynamic var weight = 0.0
    @objc dynamic var timeIn : Date = Date()
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
