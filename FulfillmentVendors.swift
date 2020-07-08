//
//  FulfillmentVendors.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 3/13/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FulfillmentVendors: Object {
    
    @objc dynamic var snapShot = ""
    @objc dynamic var canSellDiy = false
    @objc dynamic var canSellIngredients = false
    @objc dynamic var fcmGroupName = ""
    @objc dynamic var logo =  ""
    @objc dynamic var name = ""
    @objc dynamic var warningMessage = ""
    
    
    override static func primaryKey() -> String? {
        return "snapShot";
    }
}
