//
//  RecipeWallInfo.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 12/8/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//  Reviewed

import Foundation
import Realm
import RealmSwift

class TweakRecipesInfo: Object {
    @objc dynamic var snapShot = ""
    @objc dynamic var bannerImg =  ""
    
    @objc dynamic var cookingTime = ""
    @objc dynamic var crtBy = ""
    @objc dynamic var crtOn = ""
    @objc dynamic var img = ""
    
    @objc dynamic var preparationTime = ""
    @objc dynamic var serving = 0
    @objc dynamic var title = ""
    @objc dynamic var awesomeCount =  0
    @objc dynamic var id = 0
    @objc dynamic var hasVideo = false
    @objc dynamic var recipeVideoURL = ""
    @objc dynamic var canBuyDiy = false
    @objc dynamic var canBuyIngredients = false
    
    var canBuyDiyFrm =  List<CanBuyDiyFrom>()
    var canBuyDiyVendor = List<CanBuyDiyVendor>()
    var awesomeMembers = List<RecipeAwesomeMembers>()
    var nutrition = List<NutritionFacts>()
    var ingredients = List<IngredientsList>()
    var benefits = List<StringObj>()
    var instructions = List<StringObj>()
    var canBuyIngredientsCountries = List<StringObj>()
    var canBuyDIYCountries = List<StringObj>()
    
    override static func primaryKey() -> String? {
        return "crtOn";
    }
}

class CanBuyDiyFrom: Object {
    @objc dynamic var vendorId = ""
}

class CanBuyDiyVendor: Object {
    @objc dynamic var vendorId = ""
    @objc dynamic var cost: Double = 0.0
}

class RecipeAwesomeMembers: Object {
    @objc dynamic var awesomeSnapShot = ""
    @objc dynamic var aweSomeNickName = ""
    @objc dynamic var aweSomePostedOn = ""
    @objc dynamic var aweSomeMsisdn = ""
    @objc dynamic var youLiked = "false"
}

class NutritionFacts: Object {
    @objc dynamic var Calories = ""
    @objc dynamic var Carbs = ""
    @objc dynamic var Fibre = ""
    @objc dynamic var Protein = ""
    @objc dynamic var SaturatedFat = ""
    @objc dynamic var Sugars = ""
    @objc dynamic var TotalFat = ""
    
}
class StringObj: Object {
    @objc dynamic var value = ""
}

class IngredientsList: Object {
    @objc dynamic var isBuyable = false
    let isBuyableFrom = List<BuyableFrom>()
    @objc dynamic var name = ""
    @objc dynamic var qty = ""
    @objc dynamic var unit = ""
    
}

class BuyableFrom: Object {
    @objc dynamic var buyableVendorId = ""
}


