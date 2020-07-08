//
//  TweakPieChartValues.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/25/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TweakPieChartValues: Object {
    
    @objc dynamic var carbsPerc  : Int =  0
    @objc dynamic var fatPerc : Int =  0
    @objc dynamic var proteinPerc : Int =  0
    @objc dynamic var fiberPerc : Int =  0
   
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
