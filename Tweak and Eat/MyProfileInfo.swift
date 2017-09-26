//
//  MyProfileInfo.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/19/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class MyProfileInfo: Object {
    
    dynamic var name =  ""
    dynamic var age =  ""
    dynamic var gender =  ""
    dynamic var weight =  ""
    dynamic var height =  ""
    dynamic var msisdn = ""


    dynamic var foodHabits = ""
    dynamic var allergies = ""
    dynamic var conditions = ""
    dynamic var bodyShape = ""

    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
