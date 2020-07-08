//
//  Constants.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 9/23/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Realm;
import RealmSwift;

class ConstantsTable: Object {
    dynamic var constName = "";
    dynamic var constValue = "";
    
    override static func primaryKey() -> String? {
        return "constName";
    }
}
