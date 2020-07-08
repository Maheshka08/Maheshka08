//
//  OrdersInfo.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 2/6/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TweakOrdersInfo: Object {
    @objc dynamic var snapShot = ""
    @objc dynamic var deliveredOn =  0
    
    @objc dynamic var deliveryCost: Double = 0.0
    @objc dynamic var gstCost: Double = 0.0
    @objc dynamic var ingredientsCost: Double = 0.0
    @objc dynamic var lastUpdatedOn = ""
    
    @objc dynamic var orderDate = ""
    @objc dynamic var orderNumber = ""
    @objc dynamic var orderStatus = ""
    @objc dynamic var preparedOn =  0
    @objc dynamic var recipeImage = ""
    
    @objc dynamic var recipeKey = ""
    @objc dynamic var recipeName =  ""
    @objc dynamic var shippedOn = 0
    
    @objc dynamic var totalCost: Double = 0.0
    @objc dynamic var verifiedOn =  0
    
    let ingredientsItem = List<IngredientItems>()
   
    override static func primaryKey() -> String? {
        return "orderDate";
    }
}

class IngredientItems: Object {
    @objc dynamic var cost = 0
    @objc dynamic var finalProductCost: Double = 0.0
    @objc dynamic var flag = true
    @objc dynamic var gstCost: Double = 0.0
    @objc dynamic var gstPercentage: Double = 0.0
    @objc dynamic var name = ""
    @objc dynamic var qty = ""
    @objc dynamic var selectedUnit = ""
    @objc dynamic var units = ""
    
}

