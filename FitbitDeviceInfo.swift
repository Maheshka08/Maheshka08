//
//  FitbitDeviceInfo.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 2/22/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FitbitDeviceInfo: Object {
    @objc dynamic var snapShot = ""
    @objc dynamic var deviceActive =  0
    
    @objc dynamic var deviceId = 0
    @objc dynamic var deviceLogo = ""
    @objc dynamic var deviceName = ""
  
    override static func primaryKey() -> String? {
        return "deviceId";
    }
}

