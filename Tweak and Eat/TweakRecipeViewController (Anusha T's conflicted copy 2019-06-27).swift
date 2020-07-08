//
//  TweakRecipeViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/28/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import AVFoundation

class Recipes {
    @objc  var snapShot: String
    @objc  var bannerImg: String
    
    @objc  var cookingTime: String
    @objc  var crtBy: String
    @objc  var crtOn: String
    @objc  var img: String
    
    @objc  var preparationTime: String
    @objc  var serving: Int
    @objc  var title: String
    @objc  var awesomeCount: Int
    @objc  var hasVideo: Bool
    @objc  var recipeVideoURL: String
    @objc  var canBuyDiy: Bool
    @objc  var canBuyIngredients: Bool
    var canBuyDiyFrm: [CanBuyDIYFrom]
    var canBuyDiyVendor: [CanBuyDIYVendor]
    var awesomeMembers: [AwesomeLikedMembers]
    var nutritionFacts: [NutritionFactsVal]
    var ingredients: [Ingredients]
    var benefits: [StringValue]
    var instructions: [StringValue]
    var canBuyIngredientsCountries: [StringValue]
    var canBuyDIYCountries: [StringValue]


    
    init(snap: String, bannerImage: String, cookTime: String, createdBy: String, createdOn: String, image: String, prepTime: String, servings: Int, recipeTitle: String, awesomeCnt: Int, hasVid: Bool, recipeVidUrl: String, canBuyDIY: Bool, canBuyIngr: Bool, canBuyDIYFrom: [CanBuyDIYFrom], canBuyDIYVendor: [CanBuyDIYVendor], awesomeMembers: [AwesomeLikedMembers], nutritionFacts: [NutritionFactsVal], ingredients: [Ingredients], benefits: [StringValue], instructions: [StringValue], canBuyIngredientsCountries: [StringValue], canBuyDIYCountries: [StringValue]) {
        self.snapShot = snap
        self.bannerImg = bannerImage
        self.cookingTime = cookTime
        self.crtBy = createdBy
        self.crtOn = createdOn
        self.img = image
        self.preparationTime = prepTime
        self.serving = servings
        self.title = recipeTitle
        self.awesomeCount = awesomeCnt
        self.hasVideo = hasVid
        self.recipeVideoURL = recipeVidUrl
        self.canBuyDiy = canBuyDIY
        self.canBuyIngredients = canBuyIngr
        self.canBuyDiyFrm = canBuyDIYFrom
        self.canBuyDiyVendor = canBuyDIYVendor
        self.awesomeMembers = awesomeMembers
        self.nutritionFacts = nutritionFacts
        self.benefits = benefits
        self.ingredients = ingredients
        self.instructions = instructions
        self.canBuyIngredientsCountries = canBuyIngredientsCountries
        self.canBuyDIYCountries = canBuyDIYCountries
        
    }
}

class CanBuyDIYFrom {
    @objc  var vendorId: String
    init(vendorID: String) {
        self.vendorId = vendorID
    }
}

class CanBuyDIYVendor {
    @objc  var vendorId: String
    @objc  var cost: Double
    init(vendorID: String, cost: Double) {
        self.vendorId = vendorID
        self.cost = cost
    }
}

class AwesomeLikedMembers {
    @objc  var awesomeSnapShot: String
    @objc  var aweSomeNickName: String
    @objc  var aweSomePostedOn: String
    @objc  var aweSomeMsisdn: String
    @objc  var youLiked: String
    
    init(awesomeSnapShot: String, aweSomeNickName: String, aweSomePostedOn: String, aweSomeMsisdn: String, youLiked: String) {
        self.awesomeSnapShot = awesomeSnapShot
        self.aweSomeNickName = aweSomeNickName
        self.aweSomePostedOn = aweSomePostedOn
        self.aweSomeMsisdn = aweSomeMsisdn
        self.youLiked = youLiked
    }
}

class NutritionFactsVal {
    @objc  var calories: String
    @objc  var carbs: String
    @objc  var fibre: String
    @objc  var protein: String
    @objc  var saturatedFat: String
    @objc  var sugars: String
    @objc  var totalFat: String
    
    init(calories: String, carbs: String, fibre: String, protein: String, saturatedFat: String, sugars: String, totalFat: String) {
        self.calories = calories
        self.carbs = carbs
        self.fibre = fibre
        self.protein = protein
        self.saturatedFat = saturatedFat
        self.sugars = sugars
        self.totalFat = totalFat
        
    }
    
}

class StringValue {
    @objc  var value: String
    init(value: String) {
        self.value = value
    }
}

class Ingredients {
    @objc  var isBuyable: Bool
    var isBuyableFrom: [BuyableFrm]
    @objc  var name: String
    @objc  var qty: String
    @objc  var unit: String
    init(isBuyable: Bool, isBuyableFrom: [BuyableFrm], name: String, qty: String, unit: String) {
        self.isBuyable = isBuyable
        self.isBuyableFrom = isBuyableFrom
        self.name = name
        self.qty = qty
        self.unit = unit
    }
    
}

class BuyableFrm {
    @objc  var buyableVendorId: String
    init(buyableVendorId: String) {
        self.buyableVendorId = buyableVendorId
    }
}

class TweakRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AwesomeButtonCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var noRecipesLbl: UILabel!
    @IBOutlet weak var noRecipesView: UIView!
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    
    @objc var tweakRecipesRef : DatabaseReference!;
    @objc var vendorsRef : DatabaseReference!;
    @IBOutlet weak var recipeWallTableView: UITableView!;
    
    var tweakRecipesInfo = [Recipes]()
    var vendorsInfo : Results<FulfillmentVendors>?;
    let realm :Realm = try! Realm();
    @objc var allCountryArray = NSMutableArray()
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var countryCodesParentView: UIView!
    @IBOutlet weak var countryCodePickerView: UIPickerView!
   
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    @objc var player: AVAudioPlayer?;
    
    @objc var nicKName : String = "";
    @objc var sex : String = "";
    @objc var userMsisdn : String = "";
    var isLiked : Bool?;
    @objc var Number : String = "";
    var myProfileInfo : Results<MyProfileInfo>?;
    @objc var countryCode = "";
    
    @IBOutlet weak var cartBtn: UIBarButtonItem!;
    
    @IBAction func noRecipesOkTapped(_ sender: Any) {
        self.noRecipesView.isHidden = true;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
            return self.allCountryArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      
            return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
    
            
            let cellDictionary = self.allCountryArray[row] as! NSDictionary;
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width,height: 60));
            
            myView.backgroundColor = UIColor.white;
            
            let imageView = UIImageView(frame: CGRect(10, 10, 40, 40))
            let imageUrl = cellDictionary["ctr_flag_url"] as AnyObject as? String
            imageView.sd_setImage(with: URL(string: imageUrl!));
            
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            let countryLabel = UILabel(frame: CGRect(imageView.frame.maxX + 30, 0, 150, 60))
            countryLabel.text = cellDictionary["ctr_name"] as AnyObject as? String
            let countryCodeLabel = UILabel(frame: CGRect(myView.frame.size.width - 70, 0, 70, 60))
           // countryCodeLabel.text = "\(cellDictionary["ctr_phonecode"] as AnyObject as! Int)"
            
            myView.addSubview(countryLabel)
            myView.addSubview(countryCodeLabel)
            myView.addSubview(imageView)
            
            return myView
      
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            
            let cellDictionary = self.allCountryArray[row] as! NSDictionary;
            print(cellDictionary)
            if cellDictionary.count > 0 {
                self.countryCode = "\(cellDictionary["ctr_phonecode"] as AnyObject as! Int)"
                self.title = (cellDictionary["ctr_name"] as AnyObject as? String)!
                    + " RECIPES";
            }
     
    }
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom);
        backButton.setImage(UIImage(named: "backIcon"), for: .normal);
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton);
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func allRecipesTapped(_ sender: Any) {
        self.title = "ALL RECIPES"
        // self.delDB()
        self.getFirebaseData()
        self.countryCodesParentView.isHidden = true

        
    }
    @IBAction func pickerDoneAction(_ sender: Any) {
//        if self.countryCode == "91" {
//            self.title = "INDIAN RECIPES"
//        } else if self.countryCode == "62" {
//            self.title = "INDONESIAN RECIPES"
//        } else if self.countryCode == "65" {
//            self.title = "SINGAPORE RECIPES"
//        } else if self.countryCode == "60" {
//            self.title = "MALAYSIAN RECIPES"
//        } else if self.countryCode == "63" {
//            self.title = "PHILIPPINE RECIPES"
//        } else if self.countryCode == "1" {
//            self.title = "USA RECIPES"
//        }
                    //self.delDB()
                    self.getRecipesByCountry()
        self.countryCodesParentView.isHidden = true
    }
    
    
    @IBAction func pickerCancelAction(_ sender: Any) {
        self.countryCodesParentView.isHidden = true
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if self.noRecipesView.isHidden == false {
            return;
        }
        self.allCountryArray = NSMutableArray()
        self.getAllCountryCodes()

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        
      //  self.title = "ALL RECIPES"
        self.addBackButton();
        bundle = Bundle.init(path: path!)! as Bundle;
        self.countryCodesParentView.isHidden = true
        self.countryCodePickerView.delegate = self
        self.countryCodePickerView.dataSource = self
        
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
        }
        self.title  = bundle.localizedString(forKey: "recipe_wall", value: nil, table: nil);
        countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        
       
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPES");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS1");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS2");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS3");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS4");
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPESS5");
        
        
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self);
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name;
            sex = myProfObj.gender;
            Number = myProfObj.msisdn;
            
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        tweakRecipesRef = Database.database().reference().child("Recipes");
        vendorsRef = Database.database().reference().child("FulfilmentVendors");
        self.tweakRecipesRef.observe(.childChanged, with: { (snapshot) in
            self.foundSnapshot(snapshot)
        })
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        vendorsRef.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dispatch_group1 = DispatchGroup();
                dispatch_group1.enter();
                
                for vendors in snapshot.children.allObjects as! [DataSnapshot] {
                    let vendorObj = vendors.value as? [String : AnyObject];
                    let venObj = FulfillmentVendors();
                    venObj.snapShot = vendors.key;
                    venObj.canSellDiy = vendorObj?["canSellDiy"] as AnyObject as! Bool;
                    venObj.canSellIngredients = vendorObj?["canSellIngredients"] as AnyObject as! Bool;
                    venObj.fcmGroupName = vendorObj?["fcmGroupName"] as AnyObject as! String;
                    venObj.logo = vendorObj?["logo"] as AnyObject as! String;
                    venObj.name = vendorObj?["name"] as AnyObject as! String;
                    if !(vendorObj?["warningMessage"] as AnyObject is NSNull) {
                        venObj.warningMessage = vendorObj?["warningMessage"] as AnyObject as! String;
                    }
                    saveToRealmOverwrite(objType: FulfillmentVendors.self, objValues: venObj);
                }
                dispatch_group1.leave();
                dispatch_group1.notify(queue: DispatchQueue.main) {
                    self.getFirebaseData();
                    
                }
            }
        })
    }
    
    func foundSnapshot(_ snapshot: DataSnapshot){
        let idChanged = snapshot.key
        var rowVal = 0
        if snapshot.childrenCount > 0 {
            let dispatch_group = DispatchGroup();
            dispatch_group.enter();
            
            
                let recipeObj = snapshot.value as? [String : AnyObject];
                
                let recipeItemObj = Recipes(snap: snapshot.key, bannerImage: self.getRecipeVal(recipeObj: recipeObj!, val: "bannerImg", type: String.self) as! String, cookTime: self.getRecipeVal(recipeObj: recipeObj!, val: "cookingTime", type: String.self) as! String, createdBy: self.getRecipeVal(recipeObj: recipeObj!, val: "crtBy", type: String.self) as! String, createdOn: "\(self.getRecipeVal(recipeObj: recipeObj!, val: "crtOn", type: NSNumber.self) as! NSNumber)", image: self.getRecipeVal(recipeObj: recipeObj!, val: "img", type: String.self) as! String, prepTime: self.getRecipeVal(recipeObj: recipeObj!, val: "preparationTime", type: String.self) as! String, servings: self.getRecipeVal(recipeObj: recipeObj!, val: "serving", type: Int.self) as! Int, recipeTitle: self.getRecipeVal(recipeObj: recipeObj!, val: "title", type: String.self) as! String, awesomeCnt: self.getRecipeVal(recipeObj: recipeObj!, val: "awesomeCount", type: Int.self) as! Int, hasVid: self.getRecipeVal(recipeObj: recipeObj!, val: "hasVideo", type: Bool.self) as! Bool, recipeVidUrl: self.getRecipeVal(recipeObj: recipeObj!, val: "videoPath", type: String.self) as! String, canBuyDIY: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyDiy", type: Bool.self) as! Bool, canBuyIngr: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyIngredients", type: Bool.self) as! Bool, canBuyDIYFrom: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyFrom", returningClass: CanBuyDIYFrom.self) as! [CanBuyDIYFrom], canBuyDIYVendor: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyVendor", returningClass: CanBuyDIYVendor.self) as! [CanBuyDIYVendor], awesomeMembers: self.getArrayValues(recipeObj: recipeObj!, val: "awesomeMembers", returningClass: AwesomeLikedMembers.self) as! [AwesomeLikedMembers], nutritionFacts: self.getArrayValues(recipeObj: recipeObj!, val: "nutrition", returningClass: NutritionFactsVal.self) as! [NutritionFactsVal], ingredients: self.getArrayValues(recipeObj: recipeObj!, val: "ingredients", returningClass: Ingredients.self) as! [Ingredients], benefits: self.getArrayValues(recipeObj: recipeObj!, val: "benefits", returningClass: StringValue.self) as! [StringValue], instructions: self.getArrayValues(recipeObj: recipeObj!, val: "instructions", returningClass: StringValue.self) as! [StringValue], canBuyIngredientsCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyIngredientsCountries", returningClass: StringValue.self) as! [StringValue], canBuyDIYCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyCountries", returningClass: StringValue.self) as! [StringValue]);
                if let indexPathRow = self.tweakRecipesInfo.index(where: {$0.snapShot == idChanged}) {
                    self.tweakRecipesInfo[indexPathRow] = recipeItemObj
                    rowVal = indexPathRow
                }
            
            dispatch_group.leave()
            dispatch_group.notify(queue: DispatchQueue.main) {
                let indexPosition = IndexPath(row: rowVal, section: 0)
                self.recipeWallTableView.reloadRows(at: [indexPosition], with: .none)

                
                
            }
            
        }
        
       
        //Process new coordinates
    }
    
    @IBAction func cacrtBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "orders", sender: self);
    }
    
    func getRecipeVal<T>(recipeObj: [String: AnyObject], val: String, type: T.Type) -> AnyObject {
        if (recipeObj.index(forKey: val) != nil) {
            if !(recipeObj[val] as AnyObject is NSNull) {
            return recipeObj[val] as AnyObject
            }
        }
        if type == Bool.self {
           return false as AnyObject
        } else if type == String.self {
            return "" as AnyObject
        } else if type == Int.self {
            return 0 as AnyObject
        } else if type == NSNumber.self {
            return 0 as AnyObject
        }
        return AnyObject.self as AnyObject
    }
    
    func getArrayValues<T>(recipeObj: [String: AnyObject], val: String, returningClass: T.Type) -> AnyObject {
        print(returningClass)
        if (recipeObj.index(forKey: val) != nil) {
            if !(recipeObj[val] as AnyObject is NSNull) {
                if returningClass == CanBuyDIYFrom.self {
                    let recipeArray = recipeObj[val] as AnyObject as! NSMutableArray

                    var canBuyDiyArray = [CanBuyDIYFrom]()
                    for obj in recipeArray {
                        let canBuy = CanBuyDIYFrom(vendorID: obj as! String)
                        canBuyDiyArray.append(canBuy)
                    }
                    return canBuyDiyArray as AnyObject
                    
                } else if returningClass == CanBuyDIYVendor.self {
                    let canBuyDiyVen = recipeObj[val] as AnyObject as! NSMutableArray
                    var canBuyDiyVenObj = [CanBuyDIYVendor]();
                    for val in canBuyDiyVen {
                        let valDict = val as! [String: AnyObject];
                        let canBuyVen = CanBuyDIYVendor(vendorID: "", cost: 0.0)
                        for (key,value) in valDict {
                            if key == "vendorId" {
                                canBuyVen.vendorId = value as AnyObject as! String
                                //canBuyDiyVenObj.vendorI = value as AnyObject as! String;
                            }
                            if key == "cost" {
                                canBuyVen.cost = value as AnyObject  as! Double;
                                
                            }
                        }
                        canBuyDiyVenObj.append(canBuyVen);
                        
                    }
                     return canBuyDiyVenObj as AnyObject
                } else if returningClass == AwesomeLikedMembers.self {
                    let awesomeMembers = recipeObj[val]  as? [String : AnyObject];
                    let awesomeCount = self.getRecipeVal(recipeObj: recipeObj, val: "awesomeCount", type: Int.self) as! Int
                    var awesomeLikedMembers = [AwesomeLikedMembers]()

                    if awesomeCount != 0 && awesomeMembers != nil {
                        for members in awesomeMembers! {
                            let awesomeMemObj = AwesomeLikedMembers(awesomeSnapShot: "", aweSomeNickName: "", aweSomePostedOn: "", aweSomeMsisdn: "", youLiked: "")
                            let number = (members.value["msisdn"] as AnyObject) as! String;
                            if number == UserDefaults.standard.value(forKey: "msisdn") as! String {
                                awesomeMemObj.youLiked = "true"
                            }else {
                                awesomeMemObj.youLiked = "false"
                            }
                            awesomeMemObj.awesomeSnapShot = members.key
                            awesomeMemObj.aweSomeNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateFormatter = DateFormatter();
                            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject;
                            
                            awesomeMemObj.aweSomePostedOn = dateArrayElement as! String;
                            awesomeMemObj.aweSomeMsisdn = (members.value["msisdn"] as AnyObject) as! String;
                            awesomeLikedMembers.append(awesomeMemObj);
                        }
                    }
                            return awesomeLikedMembers as AnyObject
                } else if returningClass == NutritionFactsVal.self {
                    let nutritions = recipeObj[val]  as? [String : AnyObject]
                    var nutrition = [NutritionFactsVal]()
                    if nutritions != nil{
                        let factsObj = NutritionFactsVal(calories: "", carbs: "", fibre: "", protein: "", saturatedFat: "", sugars: "", totalFat: "")
                        
                        for (key, value) in nutritions!{
                            if key == "Calories" {
                                factsObj.calories = value as! String
                            }
                            if key == "Carbs" {
                                factsObj.carbs = value as! String
                            }
                            if key == "Fibre" {
                                factsObj.fibre = value as! String
                            }
                            if key == "Protein" {
                                factsObj.protein = value as! String
                            }
                            if key == "Total Fat" {
                                factsObj.totalFat = value as! String
                            }
                            if key == "Sugars" {
                                factsObj.sugars = value as! String
                            }
                            
                            if key == "SaturatedFat" {
                                factsObj.saturatedFat = value as! String
                            }
                            
                        }
                        nutrition.append(factsObj)
                        
                    }
                    return nutrition as AnyObject
                } else if returningClass == Ingredients.self {
                    let ingredients = recipeObj[val]  as! NSMutableArray
                    var ingredientsList = [Ingredients]()
                    if ingredients.count > 0 {
                        for ingredient in ingredients{
                            if ingredient is NSNull {
                            } else {
                                let ingredientsObj = Ingredients(isBuyable: false, isBuyableFrom: [], name: "", qty: "", unit: "")
                                for (key,value) in ingredient as! [String: AnyObject] {
                                    if key == "name" {
                                        ingredientsObj.name = value as! String
                                    }
                                    if key == "qty" {
                                        ingredientsObj.qty = value as! String
                                    }
                                    if key == "unit" {
                                        ingredientsObj.unit = value as! String
                                    }
                                    if key == "isBuyable"{
                                        ingredientsObj.isBuyable = value as! Bool
                                    }
                                    if key == "isBuyableFrom" {
                                        print(value)
                                        let isBuyableFrom = value as AnyObject as! NSMutableArray
                                        for val in isBuyableFrom {
                                            let isBuyableObj = BuyableFrm(buyableVendorId: val as! String)
                                            ingredientsObj.isBuyableFrom.append(isBuyableObj)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                ingredientsList.append(ingredientsObj)
                                
                            }
                            
                        }
                    }
                              return ingredientsList as AnyObject
                } else if returningClass == StringValue.self {
                        var stringArray = [StringValue]()
                    let tempArray = recipeObj[val]  as! NSMutableArray
                    if tempArray.count > 0 {
                    
                        for temp in tempArray{
                            if temp is NSNull {
                            } else {
                                let benefitsObj = StringValue(value:  temp as! String);
                                stringArray.append(benefitsObj);
                                
                            }
                            
                        }
                    }
                        return stringArray as AnyObject
                    

                }
            }
        }
//        else {
//        return canBuyDiyArray as AnyObject
//        }
        return [AnyObject]() as AnyObject
    }
    
    @objc func getRecipesByCountry() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        tweakRecipesRef.queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.tweakRecipesInfo = []
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject];
                    if !((recipeObj?["activeCountries"] as AnyObject) is NSNull) {
                        let activeCountriesArray = recipeObj!["activeCountries"] as AnyObject as! NSMutableArray;
                        //   activeCountriesArray = ["99"]
                        for activeCountries in activeCountriesArray {
                            //    let activeCountry = "99"
                            let activeCountry = "\(activeCountries)";
                            if activeCountry == self.countryCode {
                                
                                
                               let recipeItemObj = Recipes(snap: tweakRecipes.key, bannerImage: self.getRecipeVal(recipeObj: recipeObj!, val: "bannerImg", type: String.self) as! String, cookTime: self.getRecipeVal(recipeObj: recipeObj!, val: "cookingTime", type: String.self) as! String, createdBy: self.getRecipeVal(recipeObj: recipeObj!, val: "crtBy", type: String.self) as! String, createdOn: "\(self.getRecipeVal(recipeObj: recipeObj!, val: "crtOn", type: NSNumber.self) as! NSNumber)", image: self.getRecipeVal(recipeObj: recipeObj!, val: "img", type: String.self) as! String, prepTime: self.getRecipeVal(recipeObj: recipeObj!, val: "preparationTime", type: String.self) as! String, servings: self.getRecipeVal(recipeObj: recipeObj!, val: "serving", type: Int.self) as! Int, recipeTitle: self.getRecipeVal(recipeObj: recipeObj!, val: "title", type: String.self) as! String, awesomeCnt: self.getRecipeVal(recipeObj: recipeObj!, val: "awesomeCount", type: Int.self) as! Int, hasVid: self.getRecipeVal(recipeObj: recipeObj!, val: "hasVideo", type: Bool.self) as! Bool, recipeVidUrl: self.getRecipeVal(recipeObj: recipeObj!, val: "videoPath", type: String.self) as! String, canBuyDIY: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyDiy", type: Bool.self) as! Bool, canBuyIngr: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyIngredients", type: Bool.self) as! Bool, canBuyDIYFrom: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyFrom", returningClass: CanBuyDIYFrom.self) as! [CanBuyDIYFrom], canBuyDIYVendor: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyVendor", returningClass: CanBuyDIYVendor.self) as! [CanBuyDIYVendor], awesomeMembers: self.getArrayValues(recipeObj: recipeObj!, val: "awesomeMembers", returningClass: AwesomeLikedMembers.self) as! [AwesomeLikedMembers], nutritionFacts: self.getArrayValues(recipeObj: recipeObj!, val: "nutrition", returningClass: NutritionFactsVal.self) as! [NutritionFactsVal], ingredients: self.getArrayValues(recipeObj: recipeObj!, val: "ingredients", returningClass: Ingredients.self) as! [Ingredients], benefits: self.getArrayValues(recipeObj: recipeObj!, val: "benefits", returningClass: StringValue.self) as! [StringValue], instructions: self.getArrayValues(recipeObj: recipeObj!, val: "instructions", returningClass: StringValue.self) as! [StringValue], canBuyIngredientsCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyIngredientsCountries", returningClass: StringValue.self) as! [StringValue], canBuyDIYCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyCountries", returningClass: StringValue.self) as! [StringValue]);
                                    self.tweakRecipesInfo.append(recipeItemObj)

                            }
                        }
                        
                    }
                    
                }
                print("recipes:\(self.tweakRecipesInfo)")

                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.tweakRecipesInfo = self.tweakRecipesInfo.sorted(by: { $0.snapShot > $1.snapShot })

                    print(self.tweakRecipesInfo)
                    if self.tweakRecipesInfo.count == 0 {
                        self.noRecipesView.isHidden = false;
                        
                        self.noRecipesLbl.text = self.bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil);                    }
                    self.recipeWallTableView.reloadData();
                    
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "No recipes found!")
            }
            
        })
    }
    
    @objc func getAllCountryCodes() {
        
        APIWrapper.sharedInstance.getAllOtherCountryCodes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                   
                    self.countryCodesParentView.isHidden = false
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    for dict in response[TweakAndEatConstants.DATA] as AnyObject as! NSArray {
                        let dictionary = dict as! NSDictionary
                        self.allCountryArray.add(dictionary)
//                        if (dictionary["ctr_active"] as AnyObject) as! Bool == true {
//                            
//                        }
                    }
                   
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        // self.allCountryArray = response[TweakAndEatConstants.DATA] as AnyObject as! NSArray
                        print( self.allCountryArray)
                        
                        if self.allCountryArray.count > 0 {
                            let countryDict = self.allCountryArray[0] as! NSDictionary
                            self.countryCode = "\(countryDict["ctr_phonecode"] as AnyObject as! Int)"

                        
                         //   let imageUrl = countryDict["ctr_flag_url"] as AnyObject as? String
                           
                            
                        }
                    }
                    self.countryCodePickerView.reloadAllComponents()
                }
            } else {
                //error
                print("error")
                TweakAndEatUtils.hideMBProgressHUD()
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            TweakAndEatUtils.hideMBProgressHUD()
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        }
    }
    
    
    @objc func getFirebaseData() {
        
        tweakRecipesRef.queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.tweakRecipesInfo = []
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject];
                    
                     let recipeItemObj = Recipes(snap: tweakRecipes.key, bannerImage: self.getRecipeVal(recipeObj: recipeObj!, val: "bannerImg", type: String.self) as! String, cookTime: self.getRecipeVal(recipeObj: recipeObj!, val: "cookingTime", type: String.self) as! String, createdBy: self.getRecipeVal(recipeObj: recipeObj!, val: "crtBy", type: String.self) as! String, createdOn: "\(self.getRecipeVal(recipeObj: recipeObj!, val: "crtOn", type: NSNumber.self) as! NSNumber)", image: self.getRecipeVal(recipeObj: recipeObj!, val: "img", type: String.self) as! String, prepTime: self.getRecipeVal(recipeObj: recipeObj!, val: "preparationTime", type: String.self) as! String, servings: self.getRecipeVal(recipeObj: recipeObj!, val: "serving", type: Int.self) as! Int, recipeTitle: self.getRecipeVal(recipeObj: recipeObj!, val: "title", type: String.self) as! String, awesomeCnt: self.getRecipeVal(recipeObj: recipeObj!, val: "awesomeCount", type: Int.self) as! Int, hasVid: self.getRecipeVal(recipeObj: recipeObj!, val: "hasVideo", type: Bool.self) as! Bool, recipeVidUrl: self.getRecipeVal(recipeObj: recipeObj!, val: "videoPath", type: String.self) as! String, canBuyDIY: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyDiy", type: Bool.self) as! Bool, canBuyIngr: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyIngredients", type: Bool.self) as! Bool, canBuyDIYFrom: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyFrom", returningClass: CanBuyDIYFrom.self) as! [CanBuyDIYFrom], canBuyDIYVendor: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyVendor", returningClass: CanBuyDIYVendor.self) as! [CanBuyDIYVendor], awesomeMembers: self.getArrayValues(recipeObj: recipeObj!, val: "awesomeMembers", returningClass: AwesomeLikedMembers.self) as! [AwesomeLikedMembers], nutritionFacts: self.getArrayValues(recipeObj: recipeObj!, val: "nutrition", returningClass: NutritionFactsVal.self) as! [NutritionFactsVal], ingredients: self.getArrayValues(recipeObj: recipeObj!, val: "ingredients", returningClass: Ingredients.self) as! [Ingredients], benefits: self.getArrayValues(recipeObj: recipeObj!, val: "benefits", returningClass: StringValue.self) as! [StringValue], instructions: self.getArrayValues(recipeObj: recipeObj!, val: "instructions", returningClass: StringValue.self) as! [StringValue], canBuyIngredientsCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyIngredientsCountries", returningClass: StringValue.self) as! [StringValue], canBuyDIYCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyCountries", returningClass: StringValue.self) as! [StringValue]);
                    self.tweakRecipesInfo.append(recipeItemObj)
                }
                print("recipes:\(self.tweakRecipesInfo)")
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
//                    let sortProperties = [SortDescriptor(keyPath: "snapShot", ascending: false)];
//                    self.tweakRecipesInfo = self.tweakRecipesInfo!.sorted(by: sortProperties);
                    self.tweakRecipesInfo = self.tweakRecipesInfo.sorted(by: { $0.snapShot > $1.snapShot })

                    self.recipeWallTableView.reloadData();
                    
                }
                
            }
            
        })
    }
    
    @objc func incrementID() -> Int {
        let realm = try! Realm();
        return (realm.objects(TweakRecipesInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return self.tweakRecipesInfo.count;
            
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecipeWallTableViewCell;
        let cellDictionary = self.tweakRecipesInfo[indexPath.row];
        if self.tweakRecipesInfo.count == 0 {
            self.noRecipesView.isHidden = false;
           
            self.noRecipesLbl.text = bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil);
//            TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil))
        }
        let hasVideo =  cellDictionary.hasVideo as AnyObject as! Bool;
        if hasVideo == true {
            cell.videoIcon.isHidden = false
        } else {
            cell.videoIcon.isHidden = true
        }
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self;
        }
        cell.cellIndexPath = indexPath.row;
        cell.myIndexPath = indexPath;
        cell.recipeTitleLabel.text = cellDictionary.title as AnyObject as? String;
        let canBuyIngredientsCountry = cellDictionary.canBuyIngredientsCountries;
        print(canBuyIngredientsCountry)
        
        let canBuyDIYCountries = cellDictionary.canBuyDIYCountries;
        print(canBuyDIYCountries)
        
        cell.awesomeLbl1.text = bundle.localizedString(forKey: "awesome", value: nil, table: nil)
        cell.shareLabel.text = bundle.localizedString(forKey: "share", value: nil, table: nil)
        
        //        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
        //      countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        
        //        if self.countryCode == "91" {
        //          //   self.cartBtn.isEnabled = true
        //        if cellDictionary["canBuyIngredients"] as AnyObject as? Bool == true  && canBuyIngredientsCountry.count > 0 {
        //            cell.buyIngredientsIconBtn.isHidden = false;
        //            cell.buyIngredientsIconTrailingConstraint.constant = -45;
        //        } else {
        //            cell.buyIngredientsIconBtn.isHidden = true;
        //        }
        //        if cellDictionary["canBuyDiy"] as AnyObject as? Bool == true && canBuyDIYCountries.count > 0 {
        //            cell.buyDIYIconBtn.isHidden = false;
        //            cell.buyIngredientsIconTrailingConstraint.constant = 8;
        //        } else {
        //            cell.buyDIYIconBtn.isHidden = true;
        //        }
        //        if (cellDictionary["canBuyDiy"] as AnyObject as? Bool == true && canBuyDIYCountries.count > 0 && cellDictionary["canBuyIngredients"] as AnyObject as? Bool == true && canBuyDIYCountries.count > 0) || cellDictionary["canBuyDiy"] as AnyObject as? Bool == true && canBuyDIYCountries.count > 0 && cellDictionary["canBuyIngredients"] as AnyObject as? Bool == true && canBuyIngredientsCountry.count > 0  {
        //            cell.buyDIYIconBtn.isHidden = false
        //            cell.buyIngredientsIconBtn.isHidden = false
        //
        //        }
        //        } else {
        //             //  self.cartBtn.isEnabled = false
        //            }
        //   }
        //        if cellDictionary["canBuyDiy"] as AnyObject as? Bool == true && cellDictionary["canBuyIngredients"] as AnyObject as? Bool == true  {
        //            cell.buyDIYIconBtn.isHidden = false
        //            cell.buyIngredientsIconBtn.isHidden = false
        //            cell.buyIngredientsIconTrailingConstraint.constant = 8
        //
        //        } else {
        //            cell.buyDIYIconBtn.isHidden = true
        //            cell.buyIngredientsIconBtn.isHidden = true
        //        }
        let imageUrl = cellDictionary.img as AnyObject as? String;
        cell.recipeImageView?.sd_setImage(with: URL(string: imageUrl!));
        let recipeNutritions = cellDictionary.nutritionFacts;
        for nutrition in recipeNutritions {
            let carbs = bundle.localizedString(forKey: "carbs", value: nil, table: nil)
            
            let calories = bundle.localizedString(forKey: "calories", value: nil, table: nil)
            cell.carbsLbl.attributedText =  setAttributedStringForLabel(mainString: "\(carbs) \(nutrition.carbs)", stringToColor: nutrition.carbs)
            cell.caloriesLabel.attributedText = setAttributedStringForLabel(mainString: "\(calories) \(nutrition.calories)", stringToColor: nutrition.calories)
        }
        //        if let awesomeCount = cellDictionary["awesomeCount"] as AnyObject as? Int {
        //            cell.awesomeLabel.text = "\(awesomeCount)" + " awesome"
        //        } else {
        //           cell.awesomeLabel.text = "0 awesome"
        //        }
        cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon"), for: .normal)
        let awesomeMem = cellDictionary.awesomeMembers
        for mem in awesomeMem {
            
            if mem.youLiked  == "true" {
                cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon_hover"), for: .normal);
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailedRecipe", sender: self)
    }
    
    @objc func setAttributedStringForLabel(mainString: String, stringToColor: String) -> NSAttributedString {
        let main_string = mainString;
        let string_to_color = stringToColor;
        
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range)
        return attribute
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailedRecipe") {
            let benifitsArray = NSMutableArray();
            let nutritionFactsArray = NSMutableArray();
            let ingredientsArray = NSMutableArray();
            let instructionsArray = NSMutableArray();
            let awesomeArray = NSMutableArray();
            let destination = segue.destination as! RecipeDetailsViewController;
            let myIndexPath = self.recipeWallTableView.indexPathForSelectedRow;
            let cellDict = self.tweakRecipesInfo[(myIndexPath?.row)!];
            destination.hasVideo = cellDict.hasVideo ;
            destination.videoPath = cellDict.recipeVideoURL ;
            destination.snapshotKey = cellDict.snapShot ;
            destination.canBuyDiy = cellDict.canBuyDiy ;
            destination.canBuyIngredients = cellDict.canBuyIngredients ;
            destination.canBuyDiyVendor = cellDict.canBuyDiyVendor ;
            destination.canBuyDiyFrm = cellDict.canBuyDiyFrm;
            let benifitsDict = cellDict.benefits;
            let nutritionFactsDict = cellDict.nutritionFacts;
            let instructionsDict = cellDict.instructions;
            let ingredientsDict = cellDict.ingredients;
            
            if benifitsDict.count > 0 {
                var i = 0
                for benifit in benifitsDict {
                    i += 1
                    let value: String = "\(i)" + ". " + benifit.value
                    benifitsArray.add(value)
                }
            }
            
            if nutritionFactsDict.count > 0 {
                for nutritionFact  in nutritionFactsDict {
                    
                    if nutritionFact.calories != "" {
                        nutritionFactsArray.add("Calories : " + nutritionFact.calories);
                    }
                    if nutritionFact.carbs != "" {
                        destination.carbs = nutritionFact.carbs;
                        nutritionFactsArray.add("Carbs : " + nutritionFact.carbs);
                    }
                    if nutritionFact.fibre != "" {
                        nutritionFactsArray.add("Fibre : " + nutritionFact.fibre);
                    }
                    if nutritionFact.protein != "" {
                        nutritionFactsArray.add("Protein : " + nutritionFact.protein);
                    }
                    if nutritionFact.saturatedFat != "" {
                        nutritionFactsArray.add("Saturated Fat : " + nutritionFact.saturatedFat);
                    }
                    if nutritionFact.sugars != "" {
                        nutritionFactsArray.add("Sugars : " + nutritionFact.sugars);
                    }
                    if nutritionFact.totalFat != "" {
                        nutritionFactsArray.add("Total Fat : " + nutritionFact.totalFat);
                    }
                }
            }
            
            if instructionsDict.count > 0 {
                var i = 0
                for instruction in instructionsDict {
                    i += 1
                    let value: String = "\(i)" + ". " + instruction.value;
                    instructionsArray.add(value);
                    
                }
            }
            
            if ingredientsDict.count > 0 {
                for ingredient in ingredientsDict {
                    let value: String = ingredient.name + " - " + ingredient.qty;
                    ingredientsArray.add(value);
                    
                }
            }
            var tempDict : [String:AnyObject] = [:]
            let awesomeMembers = cellDict.awesomeMembers
            if cellDict.awesomeCount != 0 {
                for members in awesomeMembers {
                    tempDict["nickName"] = members.aweSomeNickName as AnyObject;
                    tempDict["postedOn"] = members.aweSomePostedOn as AnyObject;
                    tempDict["msisdn"] = members.aweSomeMsisdn as AnyObject;
                    awesomeArray.add(tempDict);
                    
                }
                destination.tempArray = awesomeArray;
            }
            destination.benifitsArray = benifitsArray;
            destination.nutritionFactsArray = nutritionFactsArray;
            destination.instructionsArray = instructionsArray;
            destination.ingredientsArray = ingredientsArray;
            destination.ingredientsDict = ingredientsDict;
            destination.cookingTime = (cellDict.cookingTime as AnyObject as? String)!;
            destination.prepTime = (cellDict.preparationTime as AnyObject as? String)!;
            destination.recipeTitle = (cellDict.title as AnyObject as? String)!;
            destination.imgString = (cellDict.img as AnyObject as? String)!;
            
        }
    }
    //Awesome Button delegate methods
    
    @objc func cellTappedAwesome(_ cell: RecipeWallTableViewCell) {
        
        self.updateAwesomeMembers(cell);
    }
    
    @objc func updateAwesomeMembers(_ cell: RecipeWallTableViewCell) {
        if UserDefaults.standard.value(forKey: "COUNTRY_ISO") != nil {
            let eventName = TweakAndEatUtils.getEventNames(countryISO: UserDefaults.standard.value(forKey: "COUNTRY_ISO") as AnyObject as! String, eventName: "awesome_any_recipe_on_recipe_wall")
            print(eventName)
            Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "Awesome any recipe On Recipe wall"])
        }
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        
   
        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
        let currentTime = Int64(currentTimeStamp)
        let cellDict = self.tweakRecipesInfo[self.myIndexPath.row]
        let snap = cellDict.snapShot
        var aweSomeCount = cellDict.awesomeCount
        let awesomeMem = cellDict.awesomeMembers
        for mem in awesomeMem {
            if mem.youLiked == "true" {
                let awesomeSnap = mem.awesomeSnapShot
                cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover"), for: UIControl.State.normal)
                aweSomeCount -= 1
//                if let awesomeMemb = self.realm.object(ofType: TweakRecipesInfo.self, forPrimaryKey: cellDict["crtOn"] as! String) {
//                    let recipeObj = TweakRecipesInfo()
//                    recipeObj.snapShot = awesomeMemb.snapShot
//                    recipeObj.bannerImg = awesomeMemb.bannerImg
//                    recipeObj.cookingTime = awesomeMemb.cookingTime
//                    recipeObj.crtBy = awesomeMemb.crtBy
//                    recipeObj.crtOn = awesomeMemb.crtOn
//                    recipeObj.img = awesomeMemb.img
//                    recipeObj.preparationTime = awesomeMemb.preparationTime
//                    recipeObj.serving = awesomeMemb.serving
//                    recipeObj.title = awesomeMemb.title
//                    recipeObj.awesomeCount = aweSomeCount
//                    recipeObj.id = awesomeMemb.id
//                    recipeObj.hasVideo = awesomeMemb.hasVideo
//                    recipeObj.recipeVideoURL = awesomeMemb.recipeVideoURL
//                    recipeObj.canBuyDiy = awesomeMemb.canBuyDiy
//                    recipeObj.canBuyIngredients = awesomeMemb.canBuyIngredients
//                    recipeObj.canBuyDiyFrm = awesomeMemb.canBuyDiyFrm
//                    recipeObj.canBuyDiyVendor = awesomeMemb.canBuyDiyVendor
//                    recipeObj.nutrition = awesomeMemb.nutrition
//                    recipeObj.ingredients = awesomeMemb.ingredients
//                    recipeObj.benefits = awesomeMemb.benefits
//                    recipeObj.instructions = awesomeMemb.instructions
//                    recipeObj.canBuyIngredientsCountries = awesomeMemb.canBuyIngredientsCountries
//                    recipeObj.canBuyDIYCountries = awesomeMemb.canBuyDIYCountries
//                    recipeObj.awesomeMembers.removeAll()
//                    saveToRealmOverwrite(objType: TweakRecipesInfo.self, objValues: recipeObj)
//                }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                DispatchQueue.global(qos: .background).async {
                    // Bounce back to the main thread to update the UI
                    
                    self.tweakRecipesRef.child(snap).child("awesomeMembers").child(awesomeSnap).removeValue()
                    
                    self.tweakRecipesRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon"), for: .normal)

                    }
                }
                return
            }
        }
        
        cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover"), for: UIControl.State.normal)
        aweSomeCount += 1
//        if let awesomeMemb = self.realm.object(ofType: TweakRecipesInfo.self, forPrimaryKey: cellDict["crtOn"] as! String) {
//            let recipeObj = TweakRecipesInfo()
//            recipeObj.snapShot = awesomeMemb.snapShot
//            recipeObj.bannerImg = awesomeMemb.bannerImg
//            recipeObj.cookingTime = awesomeMemb.cookingTime
//            recipeObj.crtBy = awesomeMemb.crtBy
//            recipeObj.crtOn = awesomeMemb.crtOn
//            recipeObj.img = awesomeMemb.img
//            recipeObj.preparationTime = awesomeMemb.preparationTime
//            recipeObj.serving = awesomeMemb.serving
//            recipeObj.title = awesomeMemb.title
//            recipeObj.awesomeCount = aweSomeCount
//            recipeObj.id = awesomeMemb.id
//            recipeObj.hasVideo = awesomeMemb.hasVideo
//            recipeObj.recipeVideoURL = awesomeMemb.recipeVideoURL
//            recipeObj.canBuyDiy = awesomeMemb.canBuyDiy
//            recipeObj.canBuyIngredients = awesomeMemb.canBuyIngredients
//            recipeObj.canBuyDiyFrm = awesomeMemb.canBuyDiyFrm
//            recipeObj.canBuyDiyVendor = awesomeMemb.canBuyDiyVendor
//            recipeObj.nutrition = awesomeMemb.nutrition
//            recipeObj.ingredients = awesomeMemb.ingredients
//            recipeObj.benefits = awesomeMemb.benefits
//            recipeObj.instructions = awesomeMemb.instructions
//            recipeObj.canBuyIngredientsCountries = awesomeMemb.canBuyIngredientsCountries
//            recipeObj.canBuyDIYCountries = awesomeMemb.canBuyDIYCountries
//            let awesomeMemObj = RecipeAwesomeMembers()
//            let number = (self.userMsisdn as AnyObject) as! String;
//            if number == UserDefaults.standard.value(forKey: "msisdn") as! String {
//                awesomeMemObj.youLiked = "true"
//            }else {
//                awesomeMemObj.youLiked = "false"
//            }
//            awesomeMemObj.awesomeSnapShot = snap
//            awesomeMemObj.aweSomeNickName = (self.nicKName as AnyObject) as! String
//            let milisecond = currentTime as AnyObject;
//            let dateFormatter = DateFormatter();
//            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
//            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
//            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject;
//
//            awesomeMemObj.aweSomePostedOn = dateArrayElement as! String;
//            awesomeMemObj.aweSomeMsisdn = (self.userMsisdn as AnyObject) as! String;
//            recipeObj.awesomeMembers.append(awesomeMemObj)
//            saveToRealmOverwrite(objType: TweakRecipesInfo.self, objValues: recipeObj)
//        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global(qos: .background).async {
            // Bounce back to the main thread to update the UI
            
            self.tweakRecipesRef.child(snap).child("awesomeMembers").childByAutoId().setValue(["msisdn" : self.userMsisdn as AnyObject, "postedOn" : currentTime as AnyObject,"nickName": self.nicKName as AnyObject])
            
            self.tweakRecipesRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
            DispatchQueue.main.async {
                cell.awesomeBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 2.0,
                               delay: 0,
                               usingSpringWithDamping: 0.2,
                               initialSpringVelocity: 6.0,
                               options: .allowUserInteraction,
                               animations: { [weak self] in
                                cell.awesomeBtn.transform = .identity
                                cell.awesomeBtn.setImage(UIImage(named: "awesome_icon_hover")!, for: UIControl.State.normal);
                    },
                               completion: nil)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        self.awesomePopUpSound()
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    @objc func awesomePopUpSound(){
        guard let url = Bundle.main.url(forResource: "AwesomePopUpSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func cellTappedOnAwesomeLabel(_ cell: RecipeWallTableViewCell, sender: UITapGestureRecognizer) {
        
        self.updateAwesomeMembers(cell)
    }
    
    @objc func cellTappedShare(_ cell: RecipeWallTableViewCell){
        let cellDict = self.tweakRecipesInfo[(cell.myIndexPath?.row)!];
       
        let snapshotKey = cellDict.snapShot;
        let items = [URL(string: "http://www.tweakandeat.com/recipes/recipedetails.html?rid=\(snapshotKey)")!]
        print(items);
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
//        TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "coming_soon", value: nil, table: nil))
    }
    
    @objc func cellTappedBuyIngredientsIcon(_ cell: RecipeWallTableViewCell, sender: Any){
        if (sender as! UIButton).imageView?.image == UIImage(named: "buy_ingredients_icon") {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Now you can buy ingredients for this recipe. Please click on recipe image for more details.")
        }
    }
    
    @objc func cellTappedBuyDIYIcon(_ cell: RecipeWallTableViewCell, sender: Any){
        if (sender as! UIButton).imageView?.image == UIImage(named: "buy_diy_kit_icon") {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Now you can buy \"Do It Yourself (DIY) Kit\" for this recipe. Please click on recipe image for more details.")
        }
    }
    
    @objc func cellTappedShareLabel(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer){
        let cellDict = self.tweakRecipesInfo[(cell.myIndexPath?.row)!];
        
        let snapshotKey = cellDict.snapShot;
        let items = [URL(string: "http://www.tweakandeat.com/recipes/recipedetails.html?rid=\(snapshotKey)")!]
        print(items);
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func cellTappedSubView(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer){
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
