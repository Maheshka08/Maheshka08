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
func GetConstantItem(itemFor: String) -> Constants {
    var thisUserConstants = Constants();
    let userConstants = uiRealm.objects(Constants.self).filter("constName == %@", itemFor);
    if userConstants.count > 0 {
        thisUserConstants = userConstants[0];
    }
    return thisUserConstants;
}
