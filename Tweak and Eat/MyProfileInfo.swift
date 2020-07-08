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
    
    @objc dynamic var name =  ""
    @objc dynamic var age =  ""
    @objc dynamic var gender =  ""
    @objc dynamic var weight =  ""
    @objc dynamic var height =  ""
    @objc dynamic var msisdn = ""


    @objc dynamic var foodHabits = ""
    @objc dynamic var allergies = ""
    @objc dynamic var conditions = ""
    @objc dynamic var bodyShape = ""
    @objc dynamic var goals = ""
    @objc dynamic var providerName = ""
    @objc dynamic var email = ""

    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
