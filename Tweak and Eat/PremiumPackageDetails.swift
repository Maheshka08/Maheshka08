//
//  PremiumPackageDetails.swift
//  Tweak and Eat
//
//  Created by Apple on 4/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class PremiumPackageDetails: Object {
    
    @objc dynamic var snapShot = ""
    @objc dynamic var packageName =  ""
    @objc dynamic var packageImage = ""
    @objc dynamic var packageDescription = ""
    @objc dynamic var packageId = ""
    
    @objc dynamic var packageRating: Double = 0.0
    @objc dynamic var addedToCart = false
  
    @objc dynamic var singlePackQty =  0
    @objc dynamic var multiplePackQty = 0
    @objc dynamic var familyPackQty = 0
    @objc dynamic var createdOn = ""

    @objc dynamic var defaultSinglePackCost: Double = 0.0
    @objc dynamic var defaultMultiplePackCost: Double = 0.0
    @objc dynamic var defaultFamilyPackCost: Double = 0.0
    
    let packageDefaultCost = List<PackagePrice>()

    
   
    override static func primaryKey() -> String? {
        return "createdOn";
    }
}

class PackagePrice: Object {
    @objc dynamic var countryCode = ""
    @objc dynamic var currency = ""
    @objc dynamic var price = 0.0
}

