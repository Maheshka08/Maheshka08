//
//  CaloriesLeftForTheDayController.swift
//  Tweak and Eat
//
//  Created by apple on 3/13/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Realm
import RealmSwift

class CaloriesLeftForTheDayController: UIViewController {
    @IBOutlet weak var caloriesLeftLabel: UILabel!
    var countryCode = ""
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    var premiumPackagesApiArray = [PremiumPackages]();
    let realm :Realm = try! Realm();
    var myProfile : Results<MyProfileInfo>?;
    @objc var name : String = "";
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
       var last10Data = [LastTenData]()
       var todayData = [TodayData]()
       var weekData = [WeekData]()
       var monthData = [MonthData]()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    
    func showProgress() {
        UIView.animate(withDuration: 1.5, animations: {
            if UserDefaults.standard.value(forKey: "TODAY_CALORIES") != nil {
                self.progressBar.value = CGFloat(UserDefaults.standard.value(forKey: "TODAY_CALORIES") as! Int)
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func getDataTrendsArray(dictionary: [String: AnyObject], tweakDictionary: [String: AnyObject]) {
                   
                    self.last10Data = [LastTenData]()
                    self.todayData = [TodayData]()
                    self.monthData = [MonthData]()
                    self.weekData = [WeekData]()
            var minCalories = 0
            var maxCalories = 0
            var todayCalories = 0
            UserDefaults.standard.set(0 , forKey: "TODAY_CALORIES")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(0, forKey: "MAX_CALORIES")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(0, forKey: "MIN_CALORIES")
            UserDefaults.standard.synchronize()
            minCalories = tweakDictionary["userMinCalsPerDay"] as AnyObject as! Int
            maxCalories = tweakDictionary["userMaxCalsPerDay"] as AnyObject as! Int
            UserDefaults.standard.set(maxCalories, forKey: "MAX_CALORIES")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(minCalories, forKey: "MIN_CALORIES")
            UserDefaults.standard.synchronize()
            if dictionary.index(forKey: "lastTenData") != nil {
            let last10DataArray = dictionary["lastTenData"] as AnyObject as! NSArray
            for data in last10DataArray {
                let dataDict = data as! [String: AnyObject]
                self.last10Data.append(LastTenData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.last10Data = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
            }
            if dictionary.index(forKey: "todaysData") != nil {
            let todayDataArray = dictionary["todaysData"] as AnyObject as! NSArray
            for data in todayDataArray {
                let dataDict = data as! [String: AnyObject]
                todayCalories += dataDict["total_calories"] as! Int
                self.todayData.append(TodayData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
                UserDefaults.standard.set(todayCalories, forKey: "TODAY_CALORIES")
                UserDefaults.standard.synchronize()

            self.todayData = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
            }
            let mean: CGFloat = CGFloat((minCalories + maxCalories) / 2)
            let approxCal = Int(mean) - todayCalories
            UserDefaults.standard.set(approxCal, forKey: "APPROX_CALORIES")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                self.caloriesLeftLabel.text = "Approximate calories left for the day - \(approxCal <= 0 ? 0: approxCal)"
                let main_string = self.caloriesLeftLabel.text
                let string_to_color = "Approximate calories left for the day -"
                
                let range = (main_string! as NSString).range(of: string_to_color)
                
                let attribute = NSMutableAttributedString.init(string: main_string!)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                self.caloriesLeftLabel.attributedText = attribute
            }
    if dictionary.index(forKey: "weeksData") != nil {
            let weeksDataArray = dictionary["weeksData"] as AnyObject as! NSArray
            for data in weeksDataArray {
                let dataDict = data as! [String: AnyObject]
                self.weekData.append(WeekData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.weekData = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
            }
            if dictionary.index(forKey: "monthsData") != nil {

            let monthDataArray = dictionary["monthsData"] as AnyObject as! NSArray
            for data in monthDataArray {
                let dataDict = data as! [String: AnyObject]
                self.monthData.append(MonthData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.monthData = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
            }
         self.showProgress()
        }
    
    func getPackageDetails<T>(packageObj: [String: AnyObject], val: String, type: T.Type) -> AnyObject {
        if (packageObj.index(forKey: val) != nil) {
            if !(packageObj[val] as AnyObject is NSNull) {
                return packageObj[val] as AnyObject
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
    
    @IBAction func tappedOnPackage(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        }
        if self.countryCode == "91" {
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
            } else {
                self.getPremiumPackagesApi2(packageID: "-IndIWj1mSzQ1GDlBpUt")
            }
        } else if self.countryCode == "1" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-MzqlVh6nXsZ2TCdAbOp");
            } else {
                self.getPremiumPackagesApi2(packageID: "-MzqlVh6nXsZ2TCdAbOp")
            }
        } else if self.countryCode == "65" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-SgnMyAiDPuD8WVCipga");
            } else {
                self.getPremiumPackagesApi2(packageID: "-SgnMyAiDPuD8WVCipga")
            }
        } else if self.countryCode == "62" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IdnMyAiDPoP9DFGkbas");
            } else {
                self.getPremiumPackagesApi2(packageID: "-IdnMyAiDPoP9DFGkbas")
            }
        } else if self.countryCode == "60" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-MalAXk7gLyR3BNMusfi");
            } else {
                self.getPremiumPackagesApi2(packageID: "-MalAXk7gLyR3BNMusfi")
            }
        }
    }
    
    @objc func getPremiumPackagesApi2(packageID: String) {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        APIWrapper.sharedInstance.getPremiumPackages2(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                print(response)
                let responseResult = response["callStatus"] as! String
                if  responseResult == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                 
                        let packs =  response["packs"] as AnyObject as! NSArray
                        for packsDict in packs {
                            let packsDict = packsDict as AnyObject as! [String: AnyObject]
                            if packsDict["mppc_fb_id"] as AnyObject as! String == packageID {
                            let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                            self.premiumPackagesApiArray.append(pkgObj)
                            }
                        }
                        
                    self.performSegue(withIdentifier: "moreInfo", sender: packageID)
                    
                        
                    }
                    
                    
                    
            }
        }) { (error : NSError!) -> (Void) in
            MBProgressHUD.hide(for: self.view, animated: true);
            if error?.code == -1011 {
                
            } else {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myTweakAndEat" {
            let destination = segue.destination as! MyTweakAndEatVCViewController;
            destination.packageID = sender as! String
            destination.fromWhichVC = "CaloriesLeftForTheDayController"
            
        }  else if segue.identifier == "moreInfo" {
            let popOverVC = segue.destination as! MoreInfoPremiumPackagesViewController;
            
            for dict in self.premiumPackagesApiArray {
                let cellD = dict;
                if cellD.mppc_fb_id == sender as! String {
            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
                if language == "BA" {
                    popOverVC.smallImage = cellD.pp_image_ba
                    
                } else {
                    popOverVC.smallImage = cellD.mppc_img_banner_ios
                }
            }
            let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
            popOverVC.msisdn = "+\(msisdn)";
            
            popOverVC.package = cellD.mppc_name;
            popOverVC.name = self.name;
            popOverVC.packageId = cellD.mppc_fb_id;
                }
            }
            
        }
    }
    
    @objc func getTrends() {
            //api call for labelperc
            if UserDefaults.standard.value(forKey: "userSession") == nil {
                
            } else {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            
                let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            APIWrapper.sharedInstance.getTweakLabels(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                print(responseDic);
                if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let tweakDict = responseDic as AnyObject as! [String: AnyObject]
                    let tweakLblDict = tweakDict["tweaks"] as! [String : AnyObject]
                    self.getDataTrendsArray(dictionary: tweakLblDict, tweakDictionary: tweakDict)
                    

                    
                }
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
                MBProgressHUD.hide(for: self.view, animated: true);
                if error?.code == -1011 {
                    
                  
                }
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            })
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myProfile = uiRealm.objects(MyProfileInfo.self);

        for myProfileObj in self.myProfile! {
            self.name = myProfileObj.name;
        }
        bundle = Bundle.init(path: path!)! as Bundle;
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
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        }
        self.navigationItem.hidesBackButton = true
        self.progressBar.maxValue = CGFloat(UserDefaults.standard.value(forKey: "MAX_CALORIES") as! Int)
        self.progressBar.value = 0
        self.getTrends()
       }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
