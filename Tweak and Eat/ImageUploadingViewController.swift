//
//  ImgUploadingViewController.swift
//  Tweak and Eat
//
//  Created by admin on 5/7/17.
//  Copyright © 2017 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import FirebaseAnalytics
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging

let IS_IPHONES4 = (UIScreen.main.bounds.size.height == 480) ? true : false

class ImageUploadingViewController: UIViewController {
    
    @IBOutlet weak var imageADView: UIImageView!
    @objc var pkgIdsArray = NSMutableArray()
    @objc var age = ""
    @objc var gender = ""
    @objc var weight = ""
    @objc var height = ""
    @objc var longitude = "0"
    @objc var latitude = "0"
    @objc let formatter = DateFormatter()
    @objc var promoAppLink = ""
    @objc var premiumPackagesArray = NSMutableArray()
    var ptpPackage = ""
    @IBOutlet var gotIt: UIButton!;
    @IBOutlet var tweakImage: UIImageView!;
    
    @IBOutlet weak var adImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shortTimeTweak: UILabel!
    @IBOutlet weak var hereTipLabel: UILabel!
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    
    
    let realm :Realm = try! Realm()
    var myProfile : Results<MyProfileInfo>?
    @objc var uploadedImage: UIImage!;
    @objc var mainViewController : WelcomeViewController? = nil;
    
    @objc var adId: Int = 0
    @objc var adLocalUrl: String = ""
    @objc var adType = "2"
    @objc let locationManager = CLLocationManager()
    
    @objc var userID = UserDefaults.standard.value(forKey: "msisdn") as! String + "@taefb.com"
    @objc var deviceInfo = UIDevice.current.modelName
    @IBOutlet var didYouKnowText: UILabel!;
    @objc var parameterDict : [String : AnyObject]!;
    @objc var refillComments : String?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if IS_IPHONES4 {
          
            self.imageADView.isHidden = true
        } else {
            self.imageADView.isHidden = false
        }
    }
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true);

    }
    
    @objc func iOSVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    @objc func getPremiumPackagesArray() {
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.premiumPackagesArray = NSMutableArray()
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let packageObj = premiumPackages.value as? [String : AnyObject];
                    if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                        let activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray
                            if ((activeCountriesArray.contains(Int(self.countryCode)!)) || (activeCountriesArray.contains(self.countryCode))) {
                                self.premiumPackagesArray.add(packageObj!)
                                
                            }
                        
                    } else {
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "There are no available Premium Packages. Please come later!")
                    }
                }
                self.didYouKnowStaticText()
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {

                    
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
//    func serveAD() {
//        let locationManager : CLLocationManager = CLLocationManager();
//        if  UserDefaults.standard.value(forKey: "LATITUDE") as? String
//            == nil || UserDefaults.standard.value(forKey: "LATITUDE") as? String == "0.0" {
//           
//            locationManager.requestAlwaysAuthorization();
//            let lat = "\(locationManager.location?.coordinate.latitude ?? 0.0)";
//            UserDefaults.standard.set(lat, forKey: "LATITUDE")
//            
//        } else {
//            latitude = (UserDefaults.standard.value(forKey: "LATITUDE") as? String)!
//        }
//        if  UserDefaults.standard.value(forKey: "LONGITUDE") as? String
//            == nil || UserDefaults.standard.value(forKey: "LONGITUDE") as? String == "0.0" {
//            locationManager.requestAlwaysAuthorization();
//            let long = "\(locationManager.location?.coordinate.longitude ?? 0.0)";
//            UserDefaults.standard.set(long, forKey: "LONGITUDE")
//            
//        } else {
//            longitude = (UserDefaults.standard.value(forKey: "LONGITUDE") as? String)!
//        }
//        let version = self.iOSVersion()
//        var postDictionary = NSDictionary()
//        postDictionary = ["requestAd": [
//            "appCode": TweakAndEatConstants.TAE_APP_ID_FOR_ADS,
//            "appOs": "IOS",
//            "appOsVersion": version,
//            "deviceInfo": deviceInfo,
//            "adType": self.adType,
//            "userId": self.userID,
//            "userAge": self.age,
//            "userGender": self.gender,
//            "userHeight": self.height,
//            "userWeight": self.weight,
//            "lat": self.latitude,
//            "long": self.longitude,
//            "serveLocal": true,
//            "countryCode": "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)",
//            ]]
//        APIWrapper.sharedInstance.postRequest(TweakAndEatURLConstants.ENDPOINT_SERVE_AD, parametersDic: postDictionary, success: { (response: AnyObject!) in
//            if response["CallStatus"] as AnyObject as! String == "GOOD" {
//                self.adId = response["adId"] as AnyObject as! Int
//                if response["adLocalUrl"] as AnyObject is NSNull || response["adLocalUrl"] as AnyObject as! String == "" {
//                    self.adLocalUrl = ""
//                } else {
//                    self.adLocalUrl = response["adLocalUrl"] as AnyObject as! String
//                }
//                let imageUrl = response["adImgUrl"] as AnyObject as! String
//                self.imageADView.sd_setImage(with: URL(string: imageUrl));
//                
//            }
//        }, failure : { error in
//            TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
//        })
//    }
    
    @objc func clickOnAD() {
        self.pkgIdsArray = NSMutableArray()
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                for pkgID in pkgsArray {
                    let pkgDict = pkgID as! [String: AnyObject];
                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                    self.pkgIdsArray.add(pkgIDs)
                }
                
                
            }
        }
        if promoAppLink == "HOME" || promoAppLink == "" {
            self.goToHomePage()
        } else if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == "-ClubInd3gu7tfwko6Zx" {
                  if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil {
                    self.goToTAEClubMemPage()
                  } else {
                      self.goToTAEClub()
                  }
              } else if promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionPack", sender: promoAppLink)
        } else  if promoAppLink == "PP_PACKAGES" {
                   //self.performSegue(withIdentifier: "buyPackages", sender: self);
        } else if promoAppLink == "-KyotHu4rPoL3YOsVxUu" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-SquhLfL5nAsrhdq7GCY" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {
                   
                   
                   if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)

                       
                       
                   }
                   
               } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
            if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                              
            self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                              DispatchQueue.main.async {
                                  MBProgressHUD.showAdded(to: self.view, animated: true);
                              }
                              self.moveToAnotherView(promoAppLink: promoAppLink)
                              
                          }
            } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                

            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "myTweakAndEat" {
                   let destination = segue.destination as! MyTweakAndEatVCViewController
                  // if self.countryCode == "91" {
            destination.fromWhichVC = "MyTweakAndEatVCViewController"
                       let pkgID = sender as! String
                       destination.packageID = pkgID

                  // }
               }  else if segue.identifier == "premiumPackagesToMore" {
                           let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
                           
                           let cellDict = sender as AnyObject as! [String: AnyObject]
                           popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
                           popOverVC.fromHomePopups = true
             
         } else if segue.identifier == "nutritionPack" {
            let pkgID = sender as! String
            let popOverVC = segue.destination as! NutritionLabelViewController;
            popOverVC.packageID = pkgID
        }
    }
    func goToHomePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
    }
    func goToTAEClubMemPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
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
                    self.performSegue(withIdentifier: "premiumPackagesToMore", sender: packageObj)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        if IS_iPHONE678 || IS_iPHONE678P {
        self.tweakImage.contentMode = .scaleAspectFit
        }
        self.addBackButton()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
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
        }
        
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }
        
        self.shortTimeTweak.text = bundle.localizedString(forKey: "post_upload_status", value: nil, table: nil)
        self.hereTipLabel.text =  bundle.localizedString(forKey: "post_upload_did_you_know", value: nil, table: nil)
        self.gotIt.setTitle(bundle.localizedString(forKey: "button_got_it", value: nil, table: nil), for: .normal)
        
        self.imageADView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageUploadingViewController.clickOnAD))
        self.imageADView.addGestureRecognizer(tapGestureRecognizer)
        self.myProfile = self.realm.objects(MyProfileInfo.self)
        for myProfileObj in self.myProfile! {
            self.age = myProfileObj.age
            self.height = myProfileObj.height
            self.weight = myProfileObj.weight
            self.gender = myProfileObj.gender
        }
        
        tweakImage.image = uploadedImage;
        getPremiumPackagesArray()
        self.tabBarController?.tabBar.isHidden = true
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.tweakImage(parameterDict as NSDictionary, userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            
            if UserDefaults.standard.value(forKey: "FIRST_TWEAK") == nil {
            UserDefaults.standard.setValue("YES", forKey: "FIRST_TWEAK")
                if UserDefaults.standard.value(forKey: "COUNTRY_ISO") != nil {
                    let eventName = TweakAndEatUtils.getEventNames(countryISO: UserDefaults.standard.value(forKey: "COUNTRY_ISO") as AnyObject as! String, eventName: "first_tweak")
                    print(eventName)
                    Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "First tweak"])
                }
                
            }
            MBProgressHUD.hide(for: self.view, animated: true);

        }, failureBlock: {(error : NSError!) -> (Void) in
            MBProgressHUD.hide(for: self.view, animated: true);

            print("Failure");
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //serveAD()
    }
    
    @objc func getActivities(selectedDate: String) {
        FitbitAPI.sharedInstance.authorize(with: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
        let datePath = "https://api.fitbit.com/1/user/-/activities/date/\(selectedDate).json"
      
        guard let session = FitbitAPI.sharedInstance.session,
            let stepURL = URL(string: datePath) else {
                return
        }
        let dataTask = session.dataTask(with: stepURL) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                
                
                return
            }
            
            guard let data = data,
                let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                     TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                    return
            }
            print(dictionary["summary"] as AnyObject as! NSDictionary)
            self.sendFitBitData(dateString: selectedDate, fitBitDictionary: dictionary as NSDictionary)

            DispatchQueue.main.async {

            }
        
        }
        dataTask.resume()
    }
    
    @objc func sendFitBitData(dateString: String, fitBitDictionary: NSDictionary) {
        let activities = fitBitDictionary["summary"] as AnyObject as! NSDictionary
        var floors = ""
        if let floorsVal = activities["floors"]  {
            floors = "\(floorsVal as! Int64)"
        } else {
            floors = "0"
        }
        var km = ""
        let distanceArray = activities["distances"] as! NSArray
        let distanceDict = distanceArray[0] as! NSDictionary
        km = "\(distanceDict["distance"] as! Double)"
        let paramsDictionary = ["date": dateString,
                                "steps": "\(activities["steps"] as! Int64)",
            "floors": floors,
            "distance": km,
            "activeMins": "\(activities["veryActiveMinutes"] as! Int64)",
            "calories": "\(activities["caloriesOut"] as! Int64)",
            "deviceType": "1"]
       
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD"  {
                MBProgressHUD.hide(for: self.view, animated: true);

            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);

            print("failure")
            TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        })
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true);
    }
    func goToTAEClub() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                   let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                   let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                   navController?.pushViewController(vc, animated: true);
       }

    @objc func didYouKnowStaticText(){
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getRequest(TweakAndEatURLConstants.DAILYTIPS, sessionString: userSession, success:
            { (responseDic : AnyObject!) -> (Void) in
                
                if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responseDic as! [String:AnyObject];
                    let reminders : [String:AnyObject]? = response["tweaks"]  as? [String:AnyObject];
                    print(reminders!);
                    self.imageADView.isHidden = false

                    self.promoAppLink = response["promoAppLink"] as! String
                    self.didYouKnowText.text = reminders?["pkg_evt_message"] as? String;
                    self.imageADView.isUserInteractionEnabled = true;
                    if response.index(forKey: "promoImgUrl") != nil && response.index(forKey: "promoAppLink") != nil {
                        let promoImgUrl = response["promoImgUrl"] as! String
                        let promoAppLink = response["promoAppLink"] as! String
                        if promoImgUrl == "" || promoAppLink == "" {
                            self.imageADView.isHidden = true
                            self.didYouKnowText.isHidden = true
                            self.hereTipLabel.isHidden = true
                        } else {
                            self.imageADView.isHidden = false
                            self.didYouKnowText.isHidden = true
                            self.hereTipLabel.isHidden = true
                           
                            self.imageADView.sd_setImage(with: URL(string: promoImgUrl)) { (image, error, cache, url) in
                                // Your code inside completion block
                                let ratio = image!.size.width / image!.size.height
                                let newHeight = self.imageADView.frame.width / ratio
                                self.adImageViewHeightConstraint.constant = newHeight
                                self.view.layoutIfNeeded()
                            }
                        }
                    }

                }
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
        }
    }
    
    @IBAction func gotItAction(_ sender: Any) {
        self.gotIt.isHidden = true;
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
        clickViewController.fromGotIt = true; self.navigationController?.pushViewController(clickViewController, animated: true);
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

