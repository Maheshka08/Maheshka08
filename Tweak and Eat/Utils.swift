//
//  Utils.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 9/23/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation;
import RealmSwift;

// Return 1 constant realm object from Constants table
func GetConstantItem(itemFor: String) -> ConstantsTable {
    var thisUserConstants = ConstantsTable();
    let userConstants = uiRealm.objects(ConstantsTable.self).filter("constName == %@", itemFor);
    if userConstants.count > 0 {
        thisUserConstants = userConstants[0];
    }
    return thisUserConstants;
}
