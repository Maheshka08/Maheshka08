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
import CleverTapSDK

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
    @objc  var isVeg: Bool
    @objc var isImmBooster: Bool
    
    var canBuyDiyFrm: [CanBuyDIYFrom]
    var canBuyDiyVendor: [CanBuyDIYVendor]
    var awesomeMembers: [AwesomeLikedMembers]
    var nutritionFacts: [NutritionFactsVal]
    var ingredients: [Ingredients]
    var benefits: [StringValue]
    var instructions: [StringValue]
    var canBuyIngredientsCountries: [StringValue]
    var canBuyDIYCountries: [StringValue]
    var activeCountries: [StringValue]
    
    init(snap: String, bannerImage: String, cookTime: String, createdBy: String, createdOn: String, image: String, prepTime: String, servings: Int, recipeTitle: String, awesomeCnt: Int, isImmBooster: Bool, hasVid: Bool, recipeVidUrl: String, canBuyDIY: Bool, canBuyIngr: Bool, isVeg: Bool, canBuyDIYFrom: [CanBuyDIYFrom], canBuyDIYVendor: [CanBuyDIYVendor], awesomeMembers: [AwesomeLikedMembers], nutritionFacts: [NutritionFactsVal], ingredients: [Ingredients], benefits: [StringValue], instructions: [StringValue], canBuyIngredientsCountries: [StringValue], canBuyDIYCountries: [StringValue], activeCountries: [StringValue]) {
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
        self.isVeg = isVeg
        self.isImmBooster = isImmBooster
        self.canBuyDiyFrm = canBuyDIYFrom
        self.canBuyDiyVendor = canBuyDIYVendor
        self.awesomeMembers = awesomeMembers
        self.nutritionFacts = nutritionFacts
        self.benefits = benefits
        self.ingredients = ingredients
        self.instructions = instructions
        self.canBuyIngredientsCountries = canBuyIngredientsCountries
        self.canBuyDIYCountries = canBuyDIYCountries
        self.activeCountries = activeCountries
        
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

class TweakRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AwesomeButtonCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        //        let searchPredicate = NSPredicate(format: "title == %@", searchController.searchBar.text!)
        //        let array = (tweakRecipesInfo as NSArray).filtered(using: searchPredicate)
        let tempArr = tweakRecipesInfo.filter({$0.title.localizedCaseInsensitiveContains(searchController.searchBar.text!)})
        filteredTableData = tempArr
        //if filteredTableData.count > 0 {
        self.recipeWallTableView.reloadData()
        //}
    }
    
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var awesomeCountLabel2: UILabel!
    @IBOutlet weak var awesomeCountLabel1: UILabel!
    @IBOutlet weak var sampleRecTitleLbl2: UILabel!
    @IBOutlet weak var sampleRecTitleLbl1: UILabel!
    @IBOutlet weak var sampleRecipeImageView2: UIImageView!
    @IBOutlet weak var sampleRecipeImageView1: UIImageView!
    @IBOutlet weak var immunityBoosterRecipeView: UIView!
    @IBOutlet weak var immBoosterInnerView: UIView!
    var sampleRecipesArray = [String]()
    @objc var refreshPage: Int = 10
    var loadingData = false
    var tempRecipesArray = [Recipes]()
    @IBOutlet weak var foodTypeView: UIView!
    var recipeTitle = ""
    var isVegOrNonVeg = false
    var isVegetarian = false
    var filteredTableData = [Recipes]()
    var resultSearchController = UISearchController()
    @IBOutlet weak var noRecipesLbl: UILabel!
    @IBOutlet weak var noRecipesView: UIView!
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var recTitle = ""
    var backButton = UIButton()
    @IBOutlet weak var immunityBoosterBtn: UIButton!
    @objc var tweakRecipesRef : DatabaseReference!;
    @IBOutlet weak var topBannerBtn: UIButton!
    @IBOutlet weak var topBannerHeightConstraint: NSLayoutConstraint!
    @objc var vendorsRef : DatabaseReference!;
    @IBOutlet weak var recipeWallTableView: UITableView!;
    var isPremiumMember = false
    var tweakRecipesInfo = [Recipes]()
    var vendorsInfo : Results<FulfillmentVendors>?;
    let realm :Realm = try! Realm();
    @objc var allCountryArray = NSMutableArray()
    var showImmunityBoosterRecipes = false
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var countryCodesParentView: UIView!
    @IBOutlet weak var countryCodePickerView: UIPickerView!
    var ptpPackage = ""
    var topBannersDict = [String: AnyObject]()
    var topBannerImageLink = ""
    var topBannerImage = ""
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    @objc var player: AVAudioPlayer?;
    var immBoosterBtnUrlStrArray = [String]()
    var immBoosterTextImageUrl = ""
    @objc var nicKName : String = "";
    @objc var sex : String = "";
    @objc var userMsisdn : String = "";
    var isLiked : Bool?;
    @objc var Number : String = "";
    var myProfileInfo : Results<MyProfileInfo>?;
    @objc var countryCode = "";
    var selectedIndex = 0
    var sampleRecArray = [Recipes]()
    @IBOutlet weak var cartBtn: UIBarButtonItem!;    
    @IBOutlet weak var vegBtn: UIButton!
    @IBOutlet weak var nonVegBtn: UIButton!
    @IBOutlet weak var textImageViewHeightCOnstraint: NSLayoutConstraint!
    var isImmunityBoosterSelected = false
    var immunityStickerUrl = ""
    var vegStickerUrl = ""
    var nonVegStickerUrl = ""
    var premiumPackagesArray = NSMutableArray()
    @IBOutlet weak var myAiBPIndiaBtn: UIButton!
    @IBAction func myAiBPSubscribe(_ sender: Any) {
        DispatchQueue.main.async {
                             MBProgressHUD.showAdded(to: self.view, animated: true);
                             }
               self.moveToAnotherView(promoAppLink: self.ptpPackage)
    }
    @IBOutlet weak var myAiBPtn: UIButton!
   
    @IBOutlet weak var myTweakAndEatBtn: UIButton!
    
    func goToHomePage() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
           let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.navigationController?.pushViewController(clickViewController!, animated: true)
          
       }
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            self.premiumPackagesArray = NSMutableArray()
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        
                    }
                    
                }
                
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if packageObj.count == 0 {
                        self.goToHomePage()
                        return
                    }
                    self.performSegue(withIdentifier: "fromImmunityBoostToMore", sender: packageObj)
                }
            }
        })
    }
    
    @IBAction func sampleRecipe1Tapped(_ sender: Any) {
      
        let cellDict = self.sampleRecArray.first
           self.performSegue(withIdentifier: "sampleRecipes", sender: cellDict)
    }
    @IBAction func sampleRecipe2Tapped(_ sender: Any) {
    let cellDict = self.sampleRecArray.last
             self.performSegue(withIdentifier: "sampleRecipes", sender: cellDict)

    }
    @IBAction func myAiBpIndSubscribe(_ sender: Any) {
        DispatchQueue.main.async {
                      MBProgressHUD.showAdded(to: self.view, animated: true);
                      }
        self.moveToAnotherView(promoAppLink: "-AiDPwdvop1HU7fj8vfL")
    }
    @IBAction func mytweakAndEatSubscribe(_ sender: Any) {
        DispatchQueue.main.async {
                      MBProgressHUD.showAdded(to: self.view, animated: true);
                      }
                      self.moveToAnotherView(promoAppLink: "-IndIWj1mSzQ1GDlBpUt")
    }
    func immunityBoosterRecipes() {
        self.isVegOrNonVeg = true
                   // self.isImmunityBoosterSelected = true
                           DispatchQueue.main.async {
                            self.immunityBoosterBtn.backgroundColor = UIColor.orange
                               self.nonVegBtn.backgroundColor = UIColor.white
                               self.vegBtn.backgroundColor = UIColor.white
                               self.vegBtn.setTitleColor(.black, for: .normal)
                               self.nonVegBtn.setTitleColor(.black, for: .normal)
                             self.immunityBoosterBtn.setTitleColor(.white, for: .normal)
                           }
             if isPremiumMember == true {
            self.isImmunityBoosterSelected = true
//                 DispatchQueue.main.async {
//                self.filterBarButton.isEnabled = false
//                self.filterBarButton.tintColor = .white
//                }
                //MBProgressHUD.showAdded(to: self.view, animated: true)
                self.getRecipesByFilter()
             } else {
                self.title = "IMMUNITY BOOSTER RECIPES"

                 self.backButton.isHidden = true
                 self.filterBarButton.isEnabled = false
                 self.filterBarButton.tintColor = .white
                 
                 self.textImageView.contentMode = .scaleToFill
                 self.textImageView.clipsToBounds = true
                 self.immunityBoosterRecipeView.isHidden = false
                 self.immBoosterInnerView.layer.cornerRadius = 5.0
                 self.textImageView.sd_setImage(with: URL(string: self.immBoosterTextImageUrl))
                 //self.navigationController?.navigationBar.isHidden = true
                 if self.immBoosterBtnUrlStrArray.count > 1 {
                     self.myTweakAndEatBtn.isHidden = false
                     self.myAiBPIndiaBtn.isHidden = false
                     self.myAiBPtn.isHidden = true
                     
                     DispatchQueue.global(qos: .background).async {
                         // Call your background task
                         let data = try? Data(contentsOf: URL(string: self.immBoosterBtnUrlStrArray.last!)!)
                         // UI Updates here for task complete.

                         if let imageData = data {
                             let image = UIImage(data: imageData)
                             DispatchQueue.main.async {
                                 
                                 self.myAiBPIndiaBtn.setBackgroundImage(image, for: .normal)
                                 
                             }
                     }
                     

                         
                     }
                     DispatchQueue.global(qos: .background).async {
                         // Call your background task
                         let data = try? Data(contentsOf: URL(string: self.immBoosterBtnUrlStrArray.first!)!)
                         // UI Updates here for task complete.

                         if let imageData = data {
                             let image = UIImage(data: imageData)
                             DispatchQueue.main.async {
                                 
                                 self.myTweakAndEatBtn.setBackgroundImage(image, for: .normal)
                                 
                             }
                     }
                     

                         
                     }
                 } else if self.immBoosterBtnUrlStrArray.count == 1 {
                     self.myAiBPtn.isHidden = false
                     self.myTweakAndEatBtn.isHidden = true
                     self.myAiBPIndiaBtn.isHidden = true
                     DispatchQueue.global(qos: .background).async {
                         // Call your background task
                         let data = try? Data(contentsOf: URL(string: self.immBoosterBtnUrlStrArray.first!)!)
                         // UI Updates here for task complete.

                         if let imageData = data {
                             let image = UIImage(data: imageData)
                             DispatchQueue.main.async {
                                 
                                 self.myAiBPtn.setBackgroundImage(image, for: .normal)
                                 
                             }
                     }
                     

                         
                     }
                 }
                 self.getSampleRecipes()
             }
    }
    @IBAction func immunityBoosterTapped(_ sender: Any) {
        self.immunityBoosterRecipes()
    }
    
    func getVegRecipes() {
        DispatchQueue.main.async {
              self.backButton.isHidden = false
                         self.filterBarButton.isEnabled = true
                         self.filterBarButton.tintColor = UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0);
              }
              if UserDefaults.standard.value(forKey: "TITLE") != nil {
                  self.title = (UserDefaults.standard.value(forKey: "TITLE") as! String)
              }
              
              self.immunityBoosterRecipeView.isHidden = true
              self.isVegOrNonVeg = true
              self.isVegetarian = true
              self.isImmunityBoosterSelected = false
              DispatchQueue.main.async {
               self.vegBtn.backgroundColor = UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1)
                  self.nonVegBtn.backgroundColor = UIColor.white
                  self.vegBtn.setTitleColor(.white, for: .normal)
                  self.immunityBoosterBtn.backgroundColor = .white
                  self.nonVegBtn.setTitleColor(.black, for: .normal)
                  self.immunityBoosterBtn.setTitleColor(.black, for: .normal)
              if self.showImmunityBoosterRecipes == true {
                               //self.title = "IMMUNITY BOOSTER RECIPES"
                         self.immunityBoosterBtn.backgroundColor = UIColor.orange
                         self.immunityBoosterBtn.setTitleColor(.white, for: .normal)
                         self.vegBtn.backgroundColor = UIColor.white
                         self.vegBtn.setTitleColor(.black, for: .normal)
                     }
              }
              self.getRecipesByFilter()
              
    }
    @IBAction func vegAction(_ sender: Any) {
        self.getVegRecipes()
    }
    func goToTAEClubMemPage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
       self.navigationController?.pushViewController(clickViewController!, animated: true)
         
      }
    
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
        self.navigationController?.pushViewController(clickViewController!, animated: true)

    }
    @IBAction func nonVegAction(_ sender: Any) {
         DispatchQueue.main.async {
        self.backButton.isHidden = false
                          self.filterBarButton.isEnabled = true
                          self.filterBarButton.tintColor = UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0);
        }
        if UserDefaults.standard.value(forKey: "TITLE") != nil {
            self.title = UserDefaults.standard.value(forKey: "TITLE") as! String
             }
        
        self.immunityBoosterRecipeView.isHidden = true
        self.isVegOrNonVeg = true
        self.isVegetarian = false
        self.immunityBoosterBtn.backgroundColor = .white
        self.isImmunityBoosterSelected = false
        //tweakRecipesInfo.removeAll(keepingCapacity: false)
        //        let tempArr = tweakRecipesInfo.filter({$0.isVeg == false})
        //        tweakRecipesInfo = tempArr
        //        self.recipeWallTableView.reloadData()
        DispatchQueue.main.async {
            //      self.resultSearchController.isActive = false
            self.nonVegBtn.backgroundColor = UIColor.red
            self.vegBtn.backgroundColor = UIColor.white
            //   vegBtn.titleLabel?.textColor = UIColor.black
            self.vegBtn.setTitleColor(.black, for: .normal)
            self.nonVegBtn.setTitleColor(.white, for: .normal)
            self.immunityBoosterBtn.setTitleColor(.black, for: .normal)
        }
        self.getRecipesByFilter()
        
    }
    
    
    
    
    
//    @objc func loadMoreData() {
//        DispatchQueue.global(qos: .background).async {
//            // this runs on the background queue
//            // here the query starts to add new 10 rows of data to arrays
//            DispatchQueue.main.async {
//                MBProgressHUD.hide(for: self.view, animated: true);
//                self.loadingData = false
//
//            }
//        }
//    }
    
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
       
        if cellDictionary.count > 0 {
            self.countryCode = "\(cellDictionary["ctr_phonecode"] as AnyObject as! Int)"
            self.recipeTitle = (cellDictionary["ctr_name"] as AnyObject as? String)!
                + " RECIPES";
        }
        
    }
    
    @objc func addBackButton() {
         backButton = UIButton(type: .custom);
        backButton.setImage(UIImage(named: "backIcon"), for: .normal);
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton);
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        resultSearchController.searchBar.isHidden = true
        resultSearchController.searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }
        resultSearchController.resignFirstResponder()
        
        let _ = self.navigationController?.popViewController(animated: true);
    }
    
    
    
    @IBAction func allRecipesTapped(_ sender: Any) {
        self.title = "ALL RECIPES"
        // self.delDB()
        UserDefaults.standard.setValue(self.title, forKey: "TITLE")
               UserDefaults.standard.synchronize()
        self.noRecipesView.isHidden = true

        self.countryCodesParentView.isHidden = true
        
        self.vegBtn.backgroundColor = .white
        self.immunityBoosterBtn.backgroundColor = .white
        self.nonVegBtn.backgroundColor = .white
        self.vegBtn.setTitleColor(.black, for: .normal)
        self.nonVegBtn.setTitleColor(.black, for: .normal)
        self.immunityBoosterBtn.setTitleColor(.black, for: .normal)
        self.isVegetarian = false
        self.isVegOrNonVeg = false
        self.isImmunityBoosterSelected = false
        self.getFirebaseData()
        
        
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
    //            //reach bottom
    //            self.foodTypeView.isHidden = true
    //        }
    //
    //        if (scrollView.contentOffset.y < 0){
    //            //reach top
    //            if self.foodTypeView.isHidden == true {
    //                self.foodTypeView.isHidden = false
    //            }
    //        }
    //
    //        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
    //            //not top and not bottom
    //            if self.foodTypeView.isHidden == true {
    //            self.foodTypeView.isHidden = false
    //            }
    //        }}
    //
    //
    @IBAction func pickerDoneAction(_ sender: Any) {
        self.countryCodesParentView.isHidden = true
        self.title = self.recipeTitle
        UserDefaults.standard.setValue(self.title, forKey: "TITLE")
        UserDefaults.standard.synchronize()
        if self.title == "ALL RECIPES" {
            
            return
        }
        if self.isVegOrNonVeg == false {
            //MBProgressHUD.showAdded(to: self.view, animated: true);
            self.getVegRecipes()
        } else {
            self.getRecipesByFilter()
        }
        
    }
    
    
    @IBAction func pickerCancelAction(_ sender: Any) {
        self.countryCodesParentView.isHidden = true
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        //        if self.noRecipesView.isHidden == false {
        //            //self.noRecipesView.isHidden = true
        //            return;
        //        }
        //self.countryCodePickerView.reloadAllComponents()
        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }
        self.allCountryArray = NSMutableArray()
        self.getAllCountryCodes()
        
    }
    
    func getTodayWeekDay()-> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let weekDay = dateFormatter.string(from: Date())
          return weekDay
    }
    
    func getTopBanners() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }//AiDPwdvop1HU7fj8vfL
     if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
        MBProgressHUD.hide(for: self.view, animated: true);

         self.getVegRecipes()
     }else {
         let weekday = getTodayWeekDay()
                   var weekNumber = 7
                   switch weekday {
                   case "Sunday":
                       weekNumber = 0
                       case "Monday":
                       weekNumber = 1
                       case "Tuesday":
                       weekNumber = 2
                       case "Wednesday":
                       weekNumber = 3
                       case "Thursday":
                       weekNumber = 4
                       case "Friday":
                       weekNumber = 5
                       case "Saturday":
                       weekNumber = 6
                   default:
                       weekNumber = 0
                   }
                   Database.database().reference().child("GlobalVariables").child("Pages").child("TopBanners").child("RecipeWall").child(self.countryCode).child("\(weekNumber)").observe(DataEventType.value, with: { (snapshot) in
                   
                    if snapshot.childrenCount > 0 {
                         self.topBannersDict = [String: AnyObject]()
                                let dispatch_group1 = DispatchGroup();
                                dispatch_group1.enter();
                                   for obj in snapshot.children.allObjects as! [DataSnapshot] {
                                   if obj.key == "iOS" {
                                        let topBannerObj = obj.value as AnyObject as! [String: AnyObject]
                                        self.topBannersDict = topBannerObj
                                    self.topBannerImage = self.topBannersDict["img"] as! String
                                    self.topBannerImageLink = self.topBannersDict["img_link"] as! String
                                    
                                    }
                                        
                                
                               
                        
                    }
                    
                        dispatch_group1.leave();

                        dispatch_group1.notify(queue: DispatchQueue.main) {
                            MBProgressHUD.hide(for: self.view, animated: true);
                            let url = URL(string: self.topBannerImage)
                                              DispatchQueue.global(qos: .background).async {
                                                  // Call your background task
                                                  let data = try? Data(contentsOf: url!)
                                                  // UI Updates here for task complete.
                                               //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");

                                                  if let imageData = data {
                                                      let image = UIImage(data: imageData)
                                                      DispatchQueue.main.async {
                                                          
                                                        self.topBannerBtn.setBackgroundImage(image, for: .normal)
                                                          
                                                      }
                                               }
                                       }
                            self.topBannerBtn.addTarget(self, action:#selector(self.bannerClicked), for: .touchUpInside)
                            self.topBannerHeightConstraint.constant = 80
                            self.getVegRecipes()
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true);

                            self.getVegRecipes()
                        }
            }
                   
                    
                   
                    
                })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.recipeWallTableView.contentInset = UIEdgeInsets(top: self.foodTypeView.frame.height, left: 0, bottom: 0, right: 0) // Where Y is your defined hidden view height.
        //   self.foodTypeView.isHidden = true
        
        // self.filteredTableData = [Recipes]()
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false;
            controller.searchBar.returnKeyType = .done
            
            recipeWallTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        
    }
    
    
    
    //     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        if(scrollView.contentOffset.y < -self.foodTypeView.frame.height){ // Where Y is your defined hidden view height.
    //            UIView.beginAnimations(nil, context: nil)
    //            UIView.setAnimationDuration(0.25)
    //           // self.recipeWallTableView.contentInset = UIEdgeInsets(top: self.foodTypeView.frame.height, left: 0, bottom: 0, right: 0) // Where Y is your defined hidden view height.
    //            self.foodTypeView.isHidden = false
    //            UIView.commitAnimations()
    //        }
    //        else{
    //            UIView.beginAnimations(nil, context: nil)
    //            UIView.setAnimationDuration(0.25)
    //           // self.recipeWallTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //            self.foodTypeView.isHidden = true
    //            UIView.commitAnimations()
    //        }
    //    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews();
        
     
       if IS_iPHONE678P {
            
            
        } else if IS_iPHONE678 {
        self.textImageViewHeightCOnstraint.constant = 250
        } else if IS_iPHONEXRXSMAX {
        self.textImageViewHeightCOnstraint.constant = 340
        }
//        else if IS_iPHONEXXS {
//            self.myNutritionTopConstraint.constant = 50
//            self.chatViewHeightConstraint.constant = 200
//            aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
//            self.monthBtnTrailingConstraint.constant = 30;
//
//        } else if IS_iPHONEXRXSMAX {
//            self.myNutritionTopConstraint.constant = 80
//            self.chatViewHeightConstraint.constant = 200
//            aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
//            self.monthBtnTrailingConstraint.constant = 50;
//
//        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad();
        CleverTap.sharedInstance()?.recordEvent("Recipe_wall_viewed")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.immunityBoosterBtn.setTitle("Immunity\nBooster", for: .normal)
        self.immunityBoosterBtn.titleLabel?.textAlignment = .center
       // recipeWallTableView.reloadData()
        //  self.title = "ALL RECIPES"
      
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                  self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
              }
        if self.countryCode == "91" {
                      self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
                  } else if self.countryCode == "1" {
                      self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
                  } else if self.countryCode == "65" {
                      self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
                  } else if self.countryCode == "62" {
                      self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
                  } else if self.countryCode == "60" {
                      self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
                  } else if self.countryCode == "63" {
                      self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
                  }
        if self.countryCode == "91" {
            // || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil
            if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil  {
                       self.isPremiumMember = true

                   }
        } else {
            if UserDefaults.standard.value(forKey: self.ptpPackage) != nil {
                      self.isPremiumMember = true

                  }
        }
      //self.isPremiumMember = false
        self.addBackButton();
        bundle = Bundle.init(path: path!)! as Bundle;
        self.countryCodesParentView.isHidden = true
        self.countryCodePickerView.delegate = self
        self.countryCodePickerView.dataSource = self
        
        vegBtn.setTitleColor(.black, for: .normal)
        nonVegBtn.setTitleColor(.black, for: .normal)
        
        
        
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
        if self.countryCode == "91" {
            self.title = "INDIA RECIPES"
        } else if self.countryCode == "1" {
            self.title = "UNITED STATES RECIPES"
        } else if self.countryCode == "65" {
            self.title = "SINGAPORE RECIPES"
        } else if self.countryCode == "62" {
            self.title = "INDONESIA RECIPES"
        } else if self.countryCode == "60" {
            self.title = "MALAYSIA RECIPES"
        } else if self.countryCode == "63" {
            self.title = "PHILIPPINES RECIPES"
        }
        UserDefaults.standard.setValue(self.title, forKey: "TITLE")
                      UserDefaults.standard.synchronize()
        if self.showImmunityBoosterRecipes == true {
                  //self.title = "IMMUNITY BOOSTER RECIPES"
            self.immunityBoosterBtn.backgroundColor = UIColor.orange
            self.immunityBoosterBtn.setTitleColor(.white, for: .normal)
            self.vegBtn.backgroundColor = UIColor.white
            self.vegBtn.setTitleColor(.black, for: .normal)
        } else {
        self.vegBtn.backgroundColor = UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1)

        }
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
        let dispatch_group1 = DispatchGroup();
                       dispatch_group1.enter();
        Database.database().reference().child("GlobalVariables").child("Pages").observe(DataEventType.value, with: { (snapshot) in
           
            if snapshot.childrenCount > 0 {
                        
                           for obj in snapshot.children.allObjects as! [DataSnapshot] {
                            if obj.key == "ImmBoosterPage" {
                                       let immBoosterObj = obj.value as AnyObject as! [String: AnyObject]
                                for (key, val) in immBoosterObj {
                                    if key == "iOS" {
                                     let iOS = val as AnyObject as! [String: AnyObject]
                                        if iOS.index(forKey:self.countryCode) != nil {
                                            let immBoosterPageObj = iOS[self.countryCode] as AnyObject as! [String: AnyObject]
                                            for (key,val) in immBoosterPageObj {
                                                if key == "btns" {
                                                    let btnsArray = val as AnyObject as! NSArray
                                                    self.immBoosterBtnUrlStrArray = btnsArray as! [String]
                                                    
                                                }
                                                if key == "text01" {
                                                    self.immBoosterTextImageUrl = val as AnyObject as! String
                                                }
                                            }
                                        }
                                    } else if key == "SampleRecipes" {
                                         let sampleRecArray = val as AnyObject as! NSArray
                                        self.sampleRecipesArray = sampleRecArray as! [String]
                                        
                                    }
                                }
//                                       let url = URL(string: imageUrl);
//                                       self.unsubScribeImageView.sd_setImage(with: url);
                            } else if obj.key == "RecipeWallPage" {
                                let recipeWallObj = obj.value as AnyObject as! [String: AnyObject]
                                for (key, val) in recipeWallObj {
                                    if key == "iOS" {
                                     let iOS = val as AnyObject as! [String: AnyObject]
                                        self.immunityStickerUrl = iOS["btn_sticker_imm"] as AnyObject as! String
                                        self.vegStickerUrl = iOS["btn_sticker_veg"] as AnyObject as! String
                                        self.nonVegStickerUrl = iOS["btn_sticker_nonveg"] as AnyObject as! String
                                    }
                                }

                            }
                
            }
            

                
            }
           
            
           
            
        })
        dispatch_group1.leave();

        dispatch_group1.notify(queue: DispatchQueue.main) {
           // MBProgressHUD.hide(for: self.view, animated: true);
            self.getTopBanners()
        }
        

    
        
//        vendorsRef.observe(DataEventType.value, with: { (snapshot) in
//            if snapshot.childrenCount > 0 {
//                let dispatch_group1 = DispatchGroup();
//                dispatch_group1.enter();
//
//                for vendors in snapshot.children.allObjects as! [DataSnapshot] {
//                    let vendorObj = vendors.value as? [String : AnyObject];
//                    let venObj = FulfillmentVendors();
//                    venObj.snapShot = vendors.key;
//                    venObj.canSellDiy = vendorObj?["canSellDiy"] as AnyObject as! Bool;
//                    venObj.canSellIngredients = vendorObj?["canSellIngredients"] as AnyObject as! Bool;
//                    venObj.fcmGroupName = vendorObj?["fcmGroupName"] as AnyObject as! String;
//                    venObj.logo = vendorObj?["logo"] as AnyObject as! String;
//                    venObj.name = vendorObj?["name"] as AnyObject as! String;
//                    if !(vendorObj?["warningMessage"] as AnyObject is NSNull) {
//                        venObj.warningMessage = vendorObj?["warningMessage"] as AnyObject as! String;
//                    }
//                    saveToRealmOverwrite(objType: FulfillmentVendors.self, objValues: venObj);
//                }
//
//                dispatch_group1.leave();
//
//                dispatch_group1.notify(queue: DispatchQueue.main) {
//
//                }
//            }
//        })
    }
    
    func foundSnapshot(_ snapshot: DataSnapshot) {
        let idChanged = snapshot.key
        var rowVal = 0
        if snapshot.childrenCount > 0 {
            let dispatch_group = DispatchGroup();
            dispatch_group.enter();
            
            
            let recipeObj = snapshot.value as? [String : AnyObject];
            
            let recipeItemObj = Recipes(snap: snapshot.key, bannerImage: self.getRecipeVal(recipeObj: recipeObj!, val: "bannerImg", type: String.self) as! String, cookTime: self.getRecipeVal(recipeObj: recipeObj!, val: "cookingTime", type: String.self) as! String, createdBy: self.getRecipeVal(recipeObj: recipeObj!, val: "crtBy", type: String.self) as! String, createdOn: "\(self.getRecipeVal(recipeObj: recipeObj!, val: "crtOn", type: NSNumber.self) as! NSNumber)", image: self.getRecipeVal(recipeObj: recipeObj!, val: "img", type: String.self) as! String, prepTime: self.getRecipeVal(recipeObj: recipeObj!, val: "preparationTime", type: String.self) as! String, servings: self.getRecipeVal(recipeObj: recipeObj!, val: "serving", type: Int.self) as! Int, recipeTitle: self.getRecipeVal(recipeObj: recipeObj!, val: "title", type: String.self) as! String, awesomeCnt: self.getRecipeVal(recipeObj: recipeObj!, val: "awesomeCount", type: Int.self) as! Int, isImmBooster: self.getRecipeVal(recipeObj: recipeObj!, val: "isImmBooster", type: Bool.self) as! Bool, hasVid: self.getRecipeVal(recipeObj: recipeObj!, val: "hasVideo", type: Bool.self) as! Bool, recipeVidUrl: self.getRecipeVal(recipeObj: recipeObj!, val: "videoPath", type: String.self) as! String, canBuyDIY: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyDiy", type: Bool.self) as! Bool, canBuyIngr: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyIngredients", type: Bool.self) as! Bool, isVeg: (recipeObj?.index(forKey: "isVeg") != nil) ? self.getRecipeVal(recipeObj: recipeObj!, val: "isVeg", type: Bool.self) as! Bool: false, canBuyDIYFrom: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyFrom", returningClass: CanBuyDIYFrom.self) as! [CanBuyDIYFrom], canBuyDIYVendor: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyVendor", returningClass: CanBuyDIYVendor.self) as! [CanBuyDIYVendor], awesomeMembers: self.getArrayValues(recipeObj: recipeObj!, val: "awesomeMembers", returningClass: AwesomeLikedMembers.self) as! [AwesomeLikedMembers], nutritionFacts: self.getArrayValues(recipeObj: recipeObj!, val: "nutrition", returningClass: NutritionFactsVal.self) as! [NutritionFactsVal], ingredients: self.getArrayValues(recipeObj: recipeObj!, val: "ingredients", returningClass: Ingredients.self) as! [Ingredients], benefits: self.getArrayValues(recipeObj: recipeObj!, val: "benefits", returningClass: StringValue.self) as! [StringValue], instructions: self.getArrayValues(recipeObj: recipeObj!, val: "instructions", returningClass: StringValue.self) as! [StringValue], canBuyIngredientsCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyIngredientsCountries", returningClass: StringValue.self) as! [StringValue], canBuyDIYCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyCountries", returningClass: StringValue.self) as! [StringValue], activeCountries: self.getArrayValues(recipeObj: recipeObj!, val: "activeCountries", returningClass: StringValue.self) as! [StringValue]);
            if self.resultSearchController.isActive {
                if let indexPathRow = self.filteredTableData.index(where: {$0.snapShot == idChanged}) {
                    self.filteredTableData[indexPathRow] = recipeItemObj
                    rowVal = indexPathRow
                }
            } else {
                if let indexPathRow = self.tweakRecipesInfo.index(where: {$0.snapShot == idChanged}) {
                    self.tweakRecipesInfo[indexPathRow] = recipeItemObj
                    rowVal = indexPathRow
                }
            }
            
            dispatch_group.leave()
            dispatch_group.notify(queue: DispatchQueue.main) {
                let indexPosition = IndexPath(row: rowVal, section: 0)
                UIView.setAnimationsEnabled(false)
                //self.recipeWallTableView.beginUpdates()
                self.recipeWallTableView.reloadRows(at: [indexPosition], with: .none)
               // self.recipeWallTableView.endUpdates()
//                UIView.performWithoutAnimation {
//                    self.recipeWallTableView.reloadRows(at: [indexPosition], with: .none)
//                }
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
    
    
    func getRecipeObj(tweakRecipes: String, recipeObj: [String : AnyObject]?) -> Recipes {
        let recipeItemObj = Recipes(snap: tweakRecipes, bannerImage: self.getRecipeVal(recipeObj: recipeObj!, val: "bannerImg", type: String.self) as! String, cookTime: self.getRecipeVal(recipeObj: recipeObj!, val: "cookingTime", type: String.self) as! String, createdBy: self.getRecipeVal(recipeObj: recipeObj!, val: "crtBy", type: String.self) as! String, createdOn: "\(self.getRecipeVal(recipeObj: recipeObj!, val: "crtOn", type: NSNumber.self) as! NSNumber)", image: self.getRecipeVal(recipeObj: recipeObj!, val: "img", type: String.self) as! String, prepTime: self.getRecipeVal(recipeObj: recipeObj!, val: "preparationTime", type: String.self) as! String, servings: self.getRecipeVal(recipeObj: recipeObj!, val: "serving", type: Int.self) as! Int, recipeTitle: self.getRecipeVal(recipeObj: recipeObj!, val: "title", type: String.self) as! String, awesomeCnt: self.getRecipeVal(recipeObj: recipeObj!, val: "awesomeCount", type: Int.self) as! Int, isImmBooster: self.getRecipeVal(recipeObj: recipeObj!, val: "isImmBooster", type: Bool.self) as! Bool, hasVid: self.getRecipeVal(recipeObj: recipeObj!, val: "hasVideo", type: Bool.self) as! Bool, recipeVidUrl: self.getRecipeVal(recipeObj: recipeObj!, val: "videoPath", type: String.self) as! String, canBuyDIY: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyDiy", type: Bool.self) as! Bool, canBuyIngr: self.getRecipeVal(recipeObj: recipeObj!, val: "canBuyIngredients", type: Bool.self) as! Bool, isVeg: (recipeObj?.index(forKey: "isVeg") != nil) ? self.getRecipeVal(recipeObj: recipeObj!, val: "isVeg", type: Bool.self) as! Bool: false, canBuyDIYFrom: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyFrom", returningClass: CanBuyDIYFrom.self) as! [CanBuyDIYFrom], canBuyDIYVendor: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyVendor", returningClass: CanBuyDIYVendor.self) as! [CanBuyDIYVendor], awesomeMembers: self.getArrayValues(recipeObj: recipeObj!, val: "awesomeMembers", returningClass: AwesomeLikedMembers.self) as! [AwesomeLikedMembers], nutritionFacts: self.getArrayValues(recipeObj: recipeObj!, val: "nutrition", returningClass: NutritionFactsVal.self) as! [NutritionFactsVal], ingredients: self.getArrayValues(recipeObj: recipeObj!, val: "ingredients", returningClass: Ingredients.self) as! [Ingredients], benefits: self.getArrayValues(recipeObj: recipeObj!, val: "benefits", returningClass: StringValue.self) as! [StringValue], instructions: self.getArrayValues(recipeObj: recipeObj!, val: "instructions", returningClass: StringValue.self) as! [StringValue], canBuyIngredientsCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyIngredientsCountries", returningClass: StringValue.self) as! [StringValue], canBuyDIYCountries: self.getArrayValues(recipeObj: recipeObj!, val: "canBuyDiyCountries", returningClass: StringValue.self) as! [StringValue], activeCountries: self.getArrayValues(recipeObj: recipeObj!, val: "activeCountries", returningClass: StringValue.self) as! [StringValue]);
        
        return recipeItemObj
    }
    
    @objc func getRecipesByFilter() {
        self.noRecipesView.isHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true);
        tweakRecipesRef.queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.tweakRecipesInfo = []
                self.tempRecipesArray = []
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject];
                    if !((recipeObj?["activeCountries"] as AnyObject) is NSNull) {
                        let activeCountriesArray = recipeObj!["activeCountries"] as AnyObject as! NSMutableArray;
                        //   activeCountriesArray = ["99"]
                        if (self.title != "ALL RECIPES" && self.title != "Recipe Wall") {
                            for activeCountries in activeCountriesArray {
                                //    let activeCountry = "99"
                                let activeCountry = "\(activeCountries)";
                                
                                if activeCountry == self.countryCode {
                                    
                                    let recipeItemObj = self.getRecipeObj(tweakRecipes: tweakRecipes.key, recipeObj: recipeObj)
                                    self.tweakRecipesInfo.append(recipeItemObj)
                                    self.tempRecipesArray.append(recipeItemObj)
                                    
                                    
                                }
                            }
                        } else {
                            let recipeItemObj = self.getRecipeObj(tweakRecipes: tweakRecipes.key, recipeObj: recipeObj)
                            self.tweakRecipesInfo.append(recipeItemObj)
                            self.tempRecipesArray.append(recipeItemObj)
                        }
                        
                        
                    }
                    
                }
                self.tweakRecipesInfo = self.tweakRecipesInfo.sorted(by: { $0.snapShot > $1.snapShot })
               
                if self.isVegOrNonVeg == true {
                    if self.isImmunityBoosterSelected == false {
                        if self.isPremiumMember == false {
                        let tempArr = self.tweakRecipesInfo.filter({$0.isImmBooster != true && $0.isVeg == self.isVegetarian})
                        self.tweakRecipesInfo = tempArr
                        } else {
                            let tempArr = self.tweakRecipesInfo.filter({$0.isVeg == self.isVegetarian})
                            self.tweakRecipesInfo = tempArr
                        }

                    } else {
                    let tempArr = self.tweakRecipesInfo.filter({$0.isImmBooster == true})
                    self.tweakRecipesInfo = tempArr
                        }
                }
                
            
                
                
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.resultSearchController.isActive = false
                    if self.tweakRecipesInfo.count == 0 {
                        self.noRecipesView.isHidden = false;
                        
                        self.noRecipesLbl.text = self.bundle.localizedString(forKey: "no_recipes_found", value: nil, table: nil);
                        
                    }
                 if self.recTitle != "" {
                    if let indexPathRow = self.tempRecipesArray.index(where: {$0.snapShot == self.recTitle}) {
                                                                        // self.cellTapped = false
                                                                        self.selectedIndex = indexPathRow
                        if self.tweakRecipesInfo.count > 0 {
                                                                        self.performSegue(withIdentifier: "detailedRecipe", sender: self)
                        } 
                                                                        self.recTitle = ""
                                                                        
                                            }
                                }
                    self.recipeWallTableView.reloadData();
                    if self.showImmunityBoosterRecipes == true {
                                self.showImmunityBoosterRecipes = false
                                self.immunityBoosterRecipes()
                            }
                   

                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.resultSearchController.searchBar.endEditing(true)
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "No recipes found!")
            }
            
        })
    }
    
    
    @objc func getRecipesByCountry() {
        self.noRecipesView.isHidden = true
       // MBProgressHUD.showAdded(to: self.view, animated: true);
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
                                
                                
                                let recipeItemObj = self.getRecipeObj(tweakRecipes: tweakRecipes.key, recipeObj: recipeObj)
                                self.tweakRecipesInfo.append(recipeItemObj)
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.resultSearchController.isActive = false
                    
                    self.tweakRecipesInfo = self.tweakRecipesInfo.sorted(by: { $0.snapShot > $1.snapShot })
                    if self.isImmunityBoosterSelected == false {
                        if self.isPremiumMember == false {
                        let tempArr = self.tweakRecipesInfo.filter({$0.isImmBooster != true && $0.isVeg == self.isVegetarian})
                        self.tweakRecipesInfo = tempArr
                        } else {
                            let tempArr = self.tweakRecipesInfo.filter({$0.isVeg == self.isVegetarian})
                            self.tweakRecipesInfo = tempArr
                        }

                    } else {
                    let tempArr = self.tweakRecipesInfo.filter({$0.isImmBooster == true && $0.isVeg == self.isVegetarian})
                    self.tweakRecipesInfo = tempArr
                        }

                    if self.tweakRecipesInfo.count == 0 {
                        self.noRecipesView.isHidden = false;
                        
                        self.noRecipesLbl.text = self.bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil);
                        
                    }
                    self.recipeWallTableView.reloadData();
                   

                    if self.recTitle == "" {
                        return
                    }
                    if let indexPathRow = self.tweakRecipesInfo.index(where: {$0.title == self.recTitle}) {
                        // self.cellTapped = false
                        self.selectedIndex = indexPathRow
                        self.performSegue(withIdentifier: "detailedRecipe", sender: self)
                        self.recTitle = ""
                        
                    }
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "No recipes found!")
            }
            
        })
    }
    
    @objc func getAllCountryCodes() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if self.allCountryArray.count > 0 {
                            let countryDict = self.allCountryArray[0] as! NSDictionary
                            self.countryCode = "\(countryDict["ctr_phonecode"] as AnyObject as! Int)"
                            self.recipeTitle = (countryDict["ctr_name"] as AnyObject as? String)!
                                + " RECIPES";
                            
                            //   let imageUrl = countryDict["ctr_flag_url"] as AnyObject as? String
                            
                            
                        }
                    }
                    self.countryCodePickerView.reloadAllComponents()
                    self.countryCodePickerView.selectRow(0, inComponent: 0, animated: true)
                    
                }
            } else {
                //error
                print("error")
                MBProgressHUD.hide(for: self.view, animated: true)
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            MBProgressHUD.hide(for: self.view, animated: true)
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        }
    }
    
    @objc func getSampleRecipes() {
        
        tweakRecipesRef.queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.sampleRecArray = []
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject];
                    if self.sampleRecipesArray.contains(tweakRecipes.key) {
                    let recipeItemObj = self.getRecipeObj(tweakRecipes: tweakRecipes.key, recipeObj: recipeObj)
                    self.sampleRecArray.append(recipeItemObj)
                    }
                }
                
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                   
                    self.sampleRecArray = self.sampleRecArray.sorted(by: { $0.snapShot > $1.snapShot })
                    self.sampleRecipeImageView1.sd_setImage(with: URL(string: self.sampleRecArray.first!.img))
                    self.sampleRecipeImageView2.sd_setImage(with: URL(string: self.sampleRecArray.last!.img))
                    self.sampleRecTitleLbl1.text = self.sampleRecArray.first!.title
                    self.sampleRecTitleLbl2.text = self.sampleRecArray.last!.title
                    self.awesomeCountLabel1.text = "\(self.sampleRecArray.first!.awesomeCount)" + " awesome"
                    self.awesomeCountLabel2.text = "\(self.sampleRecArray.last!.awesomeCount)" + " awesome"
                    self.recipeWallTableView.reloadData();
    
                }
                
            }
            
        })
    }
    
    
    @objc func getFirebaseData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        tweakRecipesRef.queryOrderedByKey().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.tweakRecipesInfo = []
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject];
                    
                    let recipeItemObj = self.getRecipeObj(tweakRecipes: tweakRecipes.key, recipeObj: recipeObj)
                    self.tweakRecipesInfo.append(recipeItemObj)
                }
                
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                   
                    self.tweakRecipesInfo = self.tweakRecipesInfo.sorted(by: { $0.snapShot > $1.snapShot })
                   
                        if self.isPremiumMember == false {
                        let tempArr = self.tweakRecipesInfo.filter({$0.isImmBooster != true})
                        self.tweakRecipesInfo = tempArr
                        }

                    

                    
                    if self.tweakRecipesInfo.count == 0 {
                        self.noRecipesView.isHidden = true
                    }
                    self.recipeWallTableView.reloadData();
    
                }
                
            }
            
        })
    }
    func goToBuyScreen(packageID: String, identifier: String) {
            UserDefaults.standard.set(identifier, forKey: "POP_UP_IDENTIFIERS")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                                  }
                                  self.moveToAnotherView(promoAppLink: packageID)

    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    //                       let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
    //        vc.packageID = packageID
    //        vc.identifierFromPopUp = identifier
    //         vc.fromHomePopups = true
    //                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    //                       navController?.pushViewController(vc, animated: true);
        }
    
    @objc func incrementID() -> Int {
        let realm = try! Realm();
        return (realm.objects(TweakRecipesInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1;
    }
    
    @objc func bannerClicked() {
        
        self.goToDesiredVC(promoAppLink: self.topBannerImageLink)
    }
   
    func goToTAEClub() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func goToDesiredVC(promoAppLink: String) {//IndWLIntusoe3uelxER
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if promoAppLink == "HOME" || promoAppLink == "" {
            self.goToHomePage()
            
        }
         if promoAppLink == "CLUB_PURCHASE" || promoAppLink == "CLUB_PUR_IND_OP_1M" {
             if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
               self.goToTAEClubMemPage()
             } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
         }
          if promoAppLink == "NCP_PUR_IND_OP" {
            if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
        self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: promoAppLink)
            }
        }
        if promoAppLink == "MYAIDP_PUR_IND_OP_3M" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);

            } else {
        self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: promoAppLink)
            }
        }
        if promoAppLink == "MYTAE_PUR_IND_OP_3M" || promoAppLink == "WLIF_PUR_IND_OP_3M" {
            if promoAppLink == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: promoAppLink)
                }
            } else if promoAppLink == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: promoAppLink)
                }
            }
        }
         if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == clubPackageSubscribed {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                         self.goToTAEClubMemPage()
                       } else {
                        DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self.view, animated: true);
                        }
                        self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
        }
        if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: promoAppLink) != nil {
                self.goToNutritonConsultantScreen(packageID: promoAppLink)
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }
        if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {
            
            
            if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-Qis3atRaproTlpr4zIs" || promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionLabels", sender: promoAppLink)

        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherVC(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherVC(promoAppLink: promoAppLink)
                       
                   }
               } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherVC(promoAppLink: promoAppLink)
                

            }
        }    }
    
    func moveToAnotherVC(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        
                    }
                    
                }
                
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
                }
            }
        })
    }
       
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if self.topBannersDict.count > 0 {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
//
//        let buttonImage = UIButton(type: .custom)
//        buttonImage.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80)
//        //        button2.backgroundColor = .blue
//       // buttonImage.setImage(UIImage.init(named: "ad-banner-1"), for: .normal)
//            //  let imageUrl = self.topBannersDict["img"] as! String
//            let url = URL(string: self.topBannerImage)
//                   DispatchQueue.global(qos: .background).async {
//                       // Call your background task
//                       let data = try? Data(contentsOf: url!)
//                       // UI Updates here for task complete.
//                    //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");
//
//                       if let imageData = data {
//                           let image = UIImage(data: imageData)
//                           DispatchQueue.main.async {
//
//                            buttonImage.setBackgroundImage(image, for: .normal)
//
//                           }
//                    }
//            }
//        buttonImage.addTarget(self, action:#selector(self.bannerClicked), for: .touchUpInside)
//        headerView.backgroundColor = UIColor.groupTableViewBackground
//        headerView.addSubview(buttonImage)
//
//        return headerView
//        }
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  (filteredTableData.count > 0) {
            return filteredTableData.count
        } else {
            return self.tweakRecipesInfo.count;
        }
        
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                    scrollingFinished()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //didEndDecelerating will be called for sure
            self.foodTypeView.isHidden = true

            return
        }
        else {
            scrollingFinished()
        }
    }
    
    func scrollingFinished() {
        // Your code
        self.foodTypeView.isHidden = false

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecipeWallTableViewCell;
        var cellDictionary = self.tweakRecipesInfo[indexPath.row];
        if (filteredTableData.count > 0) {
            cellDictionary = self.filteredTableData[indexPath.row];
        }
        if self.tweakRecipesInfo.count == 0 {
            self.noRecipesView.isHidden = false;
            
            self.noRecipesLbl.text = bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil);
            //            TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "check_out_recipes", value: nil, table: nil))
        }
        if cellDictionary.isImmBooster == true {
            cell.sticker2ImageView.isHidden = false
            cell.sticker2ImageView.sd_setImage(with: URL(string: self.immunityStickerUrl))
            if cellDictionary.isVeg == true {
                cell.sticker1ImageView.isHidden = false
            cell.sticker1ImageView.sd_setImage(with: URL(string: self.vegStickerUrl))
            } else {
                cell.sticker1ImageView.isHidden = false
                 cell.sticker1ImageView.sd_setImage(with: URL(string: self.nonVegStickerUrl))
            }
        } else if cellDictionary.isImmBooster == false {
            cell.sticker2ImageView.isHidden = true
           
            if cellDictionary.isVeg == true {
                cell.sticker1ImageView.isHidden = false
                       cell.sticker1ImageView.sd_setImage(with: URL(string: self.vegStickerUrl))
                       } else {
                cell.sticker1ImageView.isHidden = false
                            cell.sticker1ImageView.sd_setImage(with: URL(string: self.nonVegStickerUrl))
                       }
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
        
        let canBuyDIYCountries = cellDictionary.canBuyDIYCountries;
       // print(canBuyDIYCountries)
        
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 306
//    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myIndexPath = indexPath
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if !loadingData && indexPath.row == self.refreshPage - 1 {
//            loadingData = true
//            MBProgressHUD.showAdded(to: self.view, animated: true);
//            self.refreshPage += 10
//            loadMoreData()
//        }
//    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailedRecipe") {
            let benifitsArray = NSMutableArray();
            let nutritionFactsArray = NSMutableArray();
            let ingredientsArray = NSMutableArray();
            let instructionsArray = NSMutableArray();
            let awesomeArray = NSMutableArray();
            let destination = segue.destination as! RecipeDetailsViewController;
            
            var cellDict = self.tweakRecipesInfo[0]
            if self.recTitle != "" {
                cellDict = self.tempRecipesArray[self.selectedIndex];
            } else {
                let myIndexPath = self.recipeWallTableView.indexPathForSelectedRow;
                 cellDict = self.tweakRecipesInfo[(myIndexPath?.row)!];
            }
            if (filteredTableData.count > 0) {
                
                if self.recTitle != "" {
                    cellDict = self.filteredTableData[self.selectedIndex];
                } else {
                    cellDict = self.filteredTableData[myIndexPath.row];
                }
                //resultSearchController.searchBar.isHidden = true
                resultSearchController.searchBar.endEditing(true)
                
            }
            DispatchQueue.main.async {
                self.resultSearchController.isActive = false
            }
            if isPremiumMember == true {
                destination.immunityStickerUrl = self.immunityStickerUrl
                destination.vegStickerUrl = self.vegStickerUrl
                destination.nonVegStickerUrl = self.nonVegStickerUrl
            } else {
                destination.vegStickerUrl = self.vegStickerUrl
                destination.nonVegStickerUrl = self.nonVegStickerUrl
            }
           
            if cellDict.isVeg == true {
                destination.isVeg = true
            }
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
            
        } else if segue.identifier == "fromImmunityBoostToMore" {
            
            let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
            
            let cellDict = sender as AnyObject as! [String: AnyObject]
            popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
            popOverVC.fromHomePopups = true
        } else if segue.identifier == "sampleRecipes" {
            let benifitsArray = NSMutableArray();
                       let nutritionFactsArray = NSMutableArray();
                       let ingredientsArray = NSMutableArray();
                       let instructionsArray = NSMutableArray();
                       let awesomeArray = NSMutableArray();
                       let destination = segue.destination as! RecipeDetailsViewController;
                       let cellDict = sender as! Recipes

            destination.vegStickerUrl = self.vegStickerUrl
            destination.nonVegStickerUrl = self.nonVegStickerUrl
                       if cellDict.isVeg == true {
                           destination.isVeg = true
                       }
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
        } else if segue.identifier == "nutritionLabels" {
                             let pkgID = sender as! String
                             let popOverVC = segue.destination as! NutritionLabelViewController;
                             popOverVC.packageID = pkgID
                      popOverVC.fromWhichVC = "GamifyViewCOntroller"
                         
                         } else if segue.identifier == "moreInfo" {
                                    let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
                                    
                                    let cellDict = sender as AnyObject as! [String: AnyObject]
                                    popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
                                    popOverVC.fromHomePopups = true
                  } else if segue.identifier == "myTweakAndEat" {
                             let destination = segue.destination as! MyTweakAndEatVCViewController
                            // if self.countryCode == "91" {
                                 let pkgID = sender as! String
                                 destination.packageID = pkgID

                            // }
                         }
    }
    //Awesome Button delegate methods
    
    func likesAndNoLikes(_ cell: RecipeWallTableViewCell) {
        if (cell.awesomeBtn.currentImage?.isEqual(UIImage(named: "awesome_icon")) ?? true)  {
            self.myIndex = cell.cellIndexPath
            self.myIndexPath = cell.myIndexPath
            
            
            let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
            let currentTime = Int64(currentTimeStamp)
            var cellDict = self.tweakRecipesInfo[(myIndexPath.row)];
            
            if (filteredTableData.count > 0) {
                cellDict = self.filteredTableData[(myIndexPath.row)];
            }
            let snap = cellDict.snapShot
            var aweSomeCount = cellDict.awesomeMembers.count
            MBProgressHUD.showAdded(to: self.view, animated: true)
            cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover"), for: UIControl.State.normal)
            aweSomeCount += 1
            
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
            
            
        } else {
            self.updateAwesomeMembers(cell);
        }
    }
    
    @objc func cellTappedAwesome(_ cell: RecipeWallTableViewCell) {
        // if cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon"), for: .normal)
        likesAndNoLikes(cell)
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
        var cellDict = self.tweakRecipesInfo[(myIndexPath.row)];
        
        if (filteredTableData.count > 0) {
            cellDict = self.filteredTableData[(myIndexPath.row)];
        }
        let snap = cellDict.snapShot
        var aweSomeCount = cellDict.awesomeMembers.count
        let awesomeMem = cellDict.awesomeMembers
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //        if (awesomeMem.contains(where: {$0.aweSomeMsisdn == self.userMsisdn})) {
        //
        //        }
        for mem in awesomeMem {
            if mem.aweSomeMsisdn == self.userMsisdn {
                let awesomeSnap = mem.awesomeSnapShot
                //cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover"), for: UIControl.State.normal)
                aweSomeCount -= 1
                if aweSomeCount < 0 {
                    aweSomeCount = 0
                }
                DispatchQueue.global(qos: .background).async {
                    // Bounce back to the main thread to update the UI
                    
                    self.tweakRecipesRef.child(snap).child("awesomeMembers").child(awesomeSnap).removeValue()
                    
                    self.tweakRecipesRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon"), for: .normal)
                        
                    }
                }
                
            }
        }
        
        
        
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
        
        likesAndNoLikes(cell)
        
    }
    
    @objc func cellTappedShare(_ cell: RecipeWallTableViewCell){
        var cellDict = self.tweakRecipesInfo[(cell.myIndexPath?.row)!];
        if (filteredTableData.count > 0) {
            cellDict = self.filteredTableData[(cell.myIndexPath?.row)!];
            //resultSearchController.searchBar.isHidden = true
            
        }
        let snapshotKey = cellDict.snapShot;
        let items = [URL(string: "http://www.tweakandeat.com/recipes/recipedetails.html?rid=\(snapshotKey)")!]
        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }
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
        var cellDict = self.tweakRecipesInfo[(cell.myIndexPath?.row)!];
        if (filteredTableData.count > 0) {
            cellDict = self.filteredTableData[(cell.myIndexPath?.row)!];
            //resultSearchController.searchBar.isHidden = true
            
        }
        
        let snapshotKey = cellDict.snapShot;
        let items = [URL(string: "http://www.tweakandeat.com/recipes/recipedetails.html?rid=\(snapshotKey)")!]
       // print(items);
        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }
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
