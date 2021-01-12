//
//  TimelinesDetailsViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 03/10/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import CoreLocation
import RealmSwift
import Realm

class TimelinesDetailsViewController: UIViewController {
    var ptpPackage = ""
    @objc var adsImageViewTapped = UITapGestureRecognizer();
    @objc var imagesArray = [String]()
    @objc var tweaksList : [AnyObject]?;
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var selectedIndex = 0
    @objc var bundle = Bundle()
    @objc var tweakSuggestedText = ""
    let realm :Realm = try! Realm()
    var myProfile : Results<MyProfileInfo>?
    @objc var tweakUserComments = ""
    @objc var date : String!
    @objc var isFromOneSignal = false
    @IBOutlet weak var adImageViewHeightConstraint: NSLayoutConstraint!
    @objc var imageUrl : String!;
    @objc var age = ""
    @objc var gender = ""
    @objc var weight = ""
    @objc var height = ""
    @objc var longitude = "0"
    @objc var countryCode = ""
    @objc var latitude = "0"
    @objc var adId: Int = 0
    @objc var tweakId = 0
    @objc var adLocalUrl: String = ""
    @objc var adType = "2"
    @objc var promoAppLink = ""
    @objc var pkgIdsArray = NSMutableArray()
    @objc let locationManager = CLLocationManager()
    @objc var userID = UserDefaults.standard.value(forKey: "msisdn") as! String + "@taefb.com"
    @objc var deviceInfo = UIDevice.current.modelName
    @IBOutlet weak var imageADView: UIImageView!
    @objc let screenHeight: CGFloat = UIScreen.main.bounds.height;
    @objc var premiumPackagesArray = NSMutableArray()
    @objc var myMutableString = NSMutableAttributedString()
    

    @IBOutlet weak var tweakInfoTextView: UILabel!
    @IBOutlet weak var askAQuestionBtn: UIButton!
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var admobView: UIView!;
    @IBOutlet var timelineImageView: UIImageView!;
    @IBOutlet var okForRating: UIButton!;
    @IBOutlet var gotItButton: UIButton!;
    @IBOutlet var ratingView: HCSStarRatingView!;
    @IBOutlet var ratingNumberLabel: UILabel!;
    @objc var modifiedImgUrl : String!;
    @objc var timelineViewCell : TimelineTableViewCell! = nil;
    
    @objc var player = AVPlayer();
    
    @objc public var timelineDetails : TBL_Tweaks! = nil;
    
    var ratingChanged : Bool!;
    var ratings : CGFloat!;
    @objc var tweakStatus = 0
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        if self.isFromOneSignal == true {
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            let _ = self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
        self.navigationController?.pushViewController(clickViewController!, animated: true)

    }
    
    func goToHomePage() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
           let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.navigationController?.pushViewController(clickViewController!, animated: true)
          
       }
  
    
    func moveToAnotherView(promoAppLink: String) {
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
                    if packageObj.count == 0 {
                        self.goToHomePage()
                        return
                    }
                    self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
                }
            }
        })
    }
    @objc func tappedOnAdsImageView() {
    
        self.goToDesiredVC(promoAppLink: self.promoAppLink)
    }
    func goToTAEClubMemPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
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
                   
               } else if promoAppLink == "CLUB_PURCHASE" || promoAppLink == "CLUB_PUR_IND_OP_1M" {
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
               }else if promoAppLink == "NCP_PUR_IND_OP" {
                if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
                    self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: promoAppLink)
                }
            } else if promoAppLink == "MYAIDP_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                    self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);

                } else {
            self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: promoAppLink)
                }
            } else if promoAppLink == "MYTAE_PUR_IND_OP_3M" || promoAppLink == "WLIF_PUR_IND_OP_3M" {
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
            } else if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == clubPackageSubscribed {
                //MYTAE_PUR_IND_OP_3M
                          if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                             self.goToTAEClubMemPage()
                           } else {
                            DispatchQueue.main.async {
                                MBProgressHUD.showAdded(to: self.view, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
            } else if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
                
                
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
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }else if promoAppLink == "-IndWLIntusoe3uelxER" {
            
            
            if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
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
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.imageADView.isHidden = true
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
              }
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
        self.imageADView.isUserInteractionEnabled = true
        timelineImageView.contentMode = .scaleAspectFill
        timelineImageView.clipsToBounds = true
        self.adsImageViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnAdsImageView))
                            self.adsImageViewTapped.numberOfTapsRequired = 1
                            self.imageADView?.addGestureRecognizer(self.adsImageViewTapped)
      
        self.title = "Tweak Details"
        
//        NotificationCenter.default.addObserver(self, selector: #selector(TimelinesDetailsViewController.fromOneSignal), name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
        let homeBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-1"), style: .plain, target: self, action: #selector(TimelinesDetailsViewController.clickButton))
        homeBarButtonItem.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem  = homeBarButtonItem

        self.getPremiumPackagesArray()
        self.addBackButton()
       
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                myMutableString = NSMutableAttributedString(string: self.bundle.localizedString(forKey: "edr_trend_msg", value: nil, table: nil), attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont(name: "Trebuchet MS", size: 18.0)!]))
                
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 184/255, green: 21/255, blue: 131/255, alpha: 1).cgColor, range: NSRange(location:0,length:14))
                
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 184/255, green: 21/255, blue: 131/255, alpha: 1).cgColor, range: NSRange(location:1,length:12))
                
                // set label Attribute
                myNutritionLbl.attributedText = myMutableString

            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle

                
                myMutableString = NSMutableAttributedString(string: self.bundle.localizedString(forKey: "edr_trend_msg", value: nil, table: nil), attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont(name: "Trebuchet MS", size: 18.0)!]))
                
               myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 184/255, green: 21/255, blue: 131/255, alpha: 1).cgColor, range: NSRange(location:0,length:2))
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 184/255, green: 21/255, blue: 131/255, alpha: 1).cgColor, range: NSRange(location:1,length:12))
                myNutritionLbl.attributedText = myMutableString
            
            }
        }
   
        self.myProfile = self.realm.objects(MyProfileInfo.self)
        for myProfileObj in self.myProfile! {
            self.age = myProfileObj.age
            self.height = myProfileObj.height
            self.weight = myProfileObj.weight
            self.gender = myProfileObj.gender
        }
        
    
        ratingChanged = false;
        
        
        if timelineDetails.tweakModifiedImageURL == ""{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakOriginalImageURL ?? ""));
            self.ratingView.isHidden = true
            self.ratingNumberLabel.isHidden = true
        }
        else{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakModifiedImageURL ?? ""));
            self.ratingView.isHidden = false
            self.ratingNumberLabel.isHidden = false
        }
        
        self.tweakInfoTextView.text = self.tweakSuggestedText.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: " .", with: ".")
        
        ratingNumberLabel.text = "\(timelineDetails.tweakRating)";
        ratingView.value = CGFloat(timelineDetails.tweakRating);
        okForRating.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0);
        if timelineDetails.tweakModifiedImageURL == ""{
            
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : timelineDetails.tweakOriginalImageURL)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)

                    self.shareBtn?.setImage(UIImage(named: "SharedBtn.png"), for: .normal)
                    
                }
            })

        }
        else{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakModifiedImageURL ?? ""));
            
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : timelineDetails.tweakModifiedImageURL)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)
                   // TweakAndEatUtils.AlertView.showAlert(view: self, message: "This image has been already shared to tweak wall!")
                    self.shareBtn?.setImage(UIImage(named: "SharedBtn.png"), for: .normal)
                    
                }
            })

        }
    }
    
    @objc func clickButton(){
        print("button click")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
//    func fromOneSignal() {
//        self.isFromOneSignal = true
//    }
    
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
                        if((activeCountriesArray.contains(Int(self.countryCode)!)) || (activeCountriesArray.contains(self.countryCode))) {
                            self.premiumPackagesArray.add(packageObj!)
                            
                        }
                        self.didYouKnowStaticText()
                        
                    } else {
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "There are no available Premium Packages. Please come later!")
                    }
                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    
                    
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
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
        } else if promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionPack", sender: self)
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
        }
        
    }
    
    @objc func moveToWall() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myWall : MyWallViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as! MyWallViewController;
       
        self.navigationController?.pushViewController(myWall, animated: true);
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);

        //self.serveAD()
NotificationCenter.default.addObserver(self, selector: #selector(TimelinesDetailsViewController.moveToWall), name: NSNotification.Name(rawValue: "TWEAK_SHARED"), object: nil)
        let cornerRadius = (screenHeight * 0.105) / 2;
        shareBtn.layer.cornerRadius = 20;
        okForRating.layer.cornerRadius = 20;
        if tweakStatus == 4{
            self.shareBtn.isHidden = false
            self.askAQuestionBtn.isHidden = false
        }else{
            self.shareBtn.isHidden = true
            self.askAQuestionBtn.isHidden = true
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(TimelinesDetailsViewController.pushToChat), name: NSNotification.Name(rawValue: "CHAT_NOTIFICATION"), object: nil)
        if UserDefaults.standard.value(forKey: "CHAT_NOTIFICATION") != nil {
            self.pushToChat()
        }
    }
    
    @objc func pushToChat() {
        UserDefaults.standard.removeObject(forKey: "CHAT_NOTIFICATION");
        self.performSegue(withIdentifier: "nutritionChat", sender: self)

    }
    
    @IBOutlet weak var myNutritionLbl: UILabel!
    @IBAction func askAQuestionTapped(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "ASK_A_QUESTION") == nil {
        UserDefaults.standard.set("YES", forKey: "ASK_A_QUESTION")
            UserDefaults.standard.synchronize()
        if UserDefaults.standard.value(forKey: "COUNTRY_ISO") != nil {
            let eventName = TweakAndEatUtils.getEventNames(countryISO: UserDefaults.standard.value(forKey: "COUNTRY_ISO") as AnyObject as! String, eventName: "ask_a_question")
            print(eventName)
            Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "Ask a question"])
        }
        }
        self.performSegue(withIdentifier: "nutritionChat", sender: self)
    }
    @IBAction func fullSizeImage(_ sender: AnyObject) {
        self.imagesArray = [String]()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//        let fullImageView : FullImageViewController = storyBoard.instantiateViewController(withIdentifier: "fullImageView") as! FullImageViewController;
//        fullImageView.shareAction = true
//        if timelineDetails.tweakModifiedImageURL == "" {
//            fullImageView.imageUrl =  timelineDetails.tweakOriginalImageURL! as String;
//        }
//        else{
//            fullImageView.imageUrl =  timelineDetails.tweakModifiedImageURL! as String;
//        }
//       
//        self.navigationController?.present(fullImageView, animated: true, completion: nil);
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            for tweakObjs in self.tweaksList! {
                self.timelineDetails = tweakObjs as! TBL_Tweaks
                
                if self.timelineDetails.tweakModifiedImageURL == ""{
                    self.imagesArray.append(self.timelineDetails.tweakOriginalImageURL ?? "")
                }
                else{
                    self.imagesArray.append(self.timelineDetails.tweakModifiedImageURL ?? "")
                    
                }
                
                
            }
            group.leave()
        }
        
        // does not wait. But the code in notify() gets run
        // after enter() and leave() calls are balanced
        
        group.notify(queue: .main) {
            self.performSegue(withIdentifier: "imageSlide", sender: self)
            
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
        if (self.shareBtn.currentImage?.isEqual(UIImage(named: "SharedBtn.png")))!{
            //do something here
            TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "share_alert", value: nil, table: nil))
        }else{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let fullImageView : FullImageViewController = storyBoard.instantiateViewController(withIdentifier: "fullImageView") as! FullImageViewController;
        fullImageView.shareAction = false
//            if (timelineDetails.tweakUserComments == nil || timelineDetails.tweakUserComments == "") {
//                fullImageView.tweakUserComments = ""
//            } else {
//                fullImageView.tweakUserComments = timelineDetails.tweakUserComments ?? ""
//            }
            fullImageView.tweakUserComments = self.tweakUserComments 
            fullImageView.fullImage = timelineImageView.image;
            fullImageView.imageUrl = imageUrl;

     
        
        self.navigationController?.present(fullImageView, animated: true, completion: nil);
        
       }
    }
    
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfChatMessage(_ sender: AnyObject) {
        let alert = UIAlertController(title: self.bundle.localizedString(forKey: "alert", value: nil, table: nil), message: "Chatting with  Nutritionist is coming soon", preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
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
                    //self.promoAppLink = "PP_LABELS"
                 //   self.imageADView.isHidden = false
                    // let promoImgUrl = "https://s3.ap-south-1.amazonaws.com/ptadworks/homepromos/home_promo_labels_v2.png"
                    // self.imageADView.sd_setImage(with: URL(string: promoImgUrl))
                    
                    self.promoAppLink = response["promoAppLink"] as! String
                    
                    self.imageADView.isUserInteractionEnabled = true;
                    if response.index(forKey: "promoImgUrl") != nil && response.index(forKey: "promoAppLink") != nil {
                        let promoImgUrl = response["promoImgUrl"] as! String
                        print(promoImgUrl)
                        let promoAppLink = response["promoAppLink"] as! String
                        if promoImgUrl == "" || promoAppLink == "" {
                            self.imageADView.isHidden = true
                           
                        } else {
                            self.imageADView.isHidden = false
                            
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
    
    func sendTweakRating() {
        if("\(timelineDetails.tweakRating)" != "\(ratingView.value)") {
            let ratingParams : [String : String] = ["tid" : "\(tweakId)", "rate" : "\(ratingView.value)"];
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            
            APIWrapper.sharedInstance.updateRatingForTweak(ratingParams as NSDictionary,userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEWREMINDER"), object: nil)
                self.ratingNumberLabel!.updateConstraints();
                
                //Update the floating value to Label
                self.ratingNumberLabel.text = "\(self.ratingView.value)";
                
                let alert = UIAlertController(title: "", message: self.bundle.localizedString(forKey: "rating_alert", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: UIAlertAction.Style.default, handler: nil));
                self.present(alert, animated: true, completion: nil);
                self.timelineDetails.tweakRating = Float(self.ratingView.value);
                self.okForRating.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0);
                self.ratingChanged = false;
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
//                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//                let defaultAction = UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
            })
            
        }
    }
    
    @IBAction func onClickOfDone(_ sender: AnyObject) {
      

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutritionChat" {
            let destination = segue.destination as! ChatVC
            destination.tweakID = String(tweakId)
            destination.imageUrl = imageUrl
            
        } else  if segue.identifier == "imageSlide" {
            let destinationVC = segue.destination as! PageViewImageSlider
            destinationVC.itemIndex = selectedIndex
            destinationVC.imagesArray = self.imagesArray
        } else if segue.identifier == "nutritionLabels" {
                          let pkgID = sender as! String
                          let popOverVC = segue.destination as! NutritionLabelViewController;
                          popOverVC.packageID = pkgID
                      
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
    
    @IBAction func onChangeOfRatingViewValue(_ sender: AnyObject) {
        if self.tweakInfoTextView.text == self.bundle.localizedString(forKey: "no_tweak_yet", value: nil, table: nil) {
            return
        }
        if(ratingChanged == false) {
            ratingChanged = true;
            okForRating.backgroundColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
            
        }
        let ratingNumber = sender as! HCSStarRatingView;
        ratingNumberLabel.text = "\(ratingNumber.value)";
        sendTweakRating()
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
