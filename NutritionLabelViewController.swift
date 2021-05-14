//
//  NutritionLabelViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 11/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift


class NutritionLabelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @objc var packageObj = NSDictionary();
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var packageID = "";
    
    var labelsPrice = "";
    var lableCount = "";
    var lables = "";
    var fromWhichVC = ""
    @IBOutlet weak var pkgDescTitle: UILabel!;
    @IBOutlet weak var packageSelectionViewTopConstraint: NSLayoutConstraint!;
    @IBOutlet weak var okBtn: UIButton!;
    
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var nutritionLabelImage: UIImageView!;
    @IBOutlet weak var packSelectionLabel: UILabel!;
    @IBOutlet weak var paymentHistoryBtn: UIBarButtonItem!;
    @IBOutlet weak var buyNowBtn: UIButton!;
    @IBOutlet weak var labelInfoView: UIView!;
    @IBOutlet weak var labelInfoTextLabel: UITextView!;
    @IBOutlet weak var nutritionLabelCountProgressBar: UIProgressView!;
    @IBOutlet weak var labelCountView: UIView!;
    @IBOutlet weak var remainingLabels: UILabel!;
    @IBOutlet weak var totalLabels: UILabel!;
    @IBOutlet weak var nutritionLabelPacksTableView: UITableView!;
    @IBOutlet weak var packageDescriptionLbl: UITextView!;
    @IBOutlet weak var packageCountLabel: UILabel!;
    @IBOutlet weak var packageCountHeightConstraint: NSLayoutConstraint!;
    
    @IBOutlet weak var trendFriendLbl: UILabel!
    @objc var nutritionLabelPackageRef : DatabaseReference!;
    @objc var nutritionLabelPackagesArray = NSMutableArray();
    @objc var countryCode = "";
    @objc var nutritionLabelPriceArray = NSMutableArray();
    @IBOutlet weak var packageSelectionView: UIView!;
    
    @objc var packageDescription: String  = "";
    var fromCrown : Bool?;
    @objc var selectedIndex: Int = 0;
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    let realm :Realm = try! Realm();
    var myProfile : Results<MyProfileInfo>?;
    @objc var name : String = "";
    @objc var labelPriceDict = [String: AnyObject]();
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        DispatchQueue.main.async {
            self.labelCountView.layer.cornerRadius = 10

        }
//        if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
//            labelsPrice = "pkgPrice";
//            lables = "pkgDisplayDescription";
//            lableCount = "pkgDuration";
//            self.nutritionLabelImage.image = UIImage.init(named: "my_tweakandeat_banner.png");
//
//        } else {
//            labelsPrice = "labelsPrice";
//            lables = "lables";
//            lableCount = "lableCount";
//        }
        labelsPrice = "labelsPrice";
        lables = "lables";
        lableCount = "lableCount";
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path : path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }
        self.view.bringSubviewToFront(labelInfoView);
        self.view.bringSubviewToFront(nutritionLabelPacksTableView);
        
        self.buyNowBtn.setTitle(self.bundle.localizedString(forKey: "buy_now", value: nil, table: nil), for: .normal);
        self.okBtn.setTitle(self.bundle.localizedString(forKey: "button_ok", value: nil, table: nil), for: .normal);
        self.title = self.bundle.localizedString(forKey: "nutrition_label_title", value: nil, table: nil);
        
        self.packSelectionLabel.text = self.bundle.localizedString(forKey: "select_your_pack_lbl", value: nil, table: nil);
        
        self.nutritionLabelPacksTableView.dataSource = self;
        self.nutritionLabelPacksTableView.delegate = self;

        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        }
         self.myProfile = uiRealm.objects(MyProfileInfo.self);
        if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
//            self.paymentHistoryBtn.tintColor = UIColor.white
//            self.paymentHistoryBtn.isEnabled = false
//            getTwetoxDetails()
        } else if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
//            self.paymentHistoryBtn.tintColor = UIColor.white
//            self.paymentHistoryBtn.isEnabled = false
//            getMyTweakAndEatDetails()
        } else  {
            
        self.paymentHistoryBtn.isEnabled = false;
        self.labelInfoView.layer.cornerRadius = 5;
        self.labelInfoView.layer.borderWidth = 2;
        self.labelInfoView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.packageDescriptionLbl.isHidden = true;
            self.pkgDescTitle.isHidden = false;
        //self.labelCountView.isHidden = true;
       // self.nutritionLabelCountProgressBar.layer.cornerRadius = 5.0;
       // self.nutritionLabelCountProgressBar.transform = nutritionLabelCountProgressBar.transform.scaledBy(x: 1, y: 10);
       
       // nutritionLabelPackageRef = Database.database().reference().child("NonPremiumPackages");
        self.getFirebaseData();
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(priceLabelOptionTapped(_:)));
        self.packageSelectionView.addGestureRecognizer(tapGesture);
        tapGesture.numberOfTapsRequired = 1;
        }
        for myProfileObj in self.myProfile! {
            self.name = myProfileObj.name;
        }
    }
    
    
    func getMyTweakAndEatDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.nutritionLabelPackagesArray = NSMutableArray();
            
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if premiumPackages.key == self.packageID {
                        let packageObj = premiumPackages.value as? [String : AnyObject];
                        if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                            let activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray;
                            if ((activeCountriesArray.contains(Int(self.countryCode)!)) || (activeCountriesArray.contains(self.countryCode))) {
                                self.nutritionLabelPackagesArray.add(packageObj!);
                            }
                            
                            self.packagLabelSelections();
                            
                        } else {
                            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_nutrition_alert", value: nil, table: nil));
                        }
                        
                    }
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    let nutritionLabelDict = self.nutritionLabelPackagesArray[0] as! [String : AnyObject];
                    
                    
                 //   let packageDesc = "Package Description:" + "\n" + "\n";
                    
                    if self.countryCode == "91" || self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "63" {
//                        if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
//                            self.nutritionLabelImage.image = UIImage.init(named: "my_tweakandeat_banner.png");
//                        } else {
//                            self.nutritionLabelImage.sd_setImage(with: URL(string: nutritionLabelDict["imgSmallPremium"] as! String));
//                        }
                        self.nutritionLabelImage.sd_setImage(with: URL(string: nutritionLabelDict["imgSmallPremium"] as! String));

                    } else if self.countryCode == "62" {
                        self.nutritionLabelImage.sd_setImage(with: URL(string: nutritionLabelDict["imgSmall_BA"] as! String));
                    }
                    
                    if self.countryCode == "91" || self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "63" {
                        self.packageDescription = nutritionLabelDict["packageDesc"] as! String;
                    } else if self.countryCode == "62" {
                        self.packageDescription = nutritionLabelDict["packageDesc_BA"] as! String;
                    }
                    if self.countryCode == "91" || self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "63" {
                        let packageFullDescription = nutritionLabelDict["packageFullDesc"] as! String;
                        self.packageDescriptionLbl.text =
                            self.packageDescription.html2String;
                        self.labelInfoTextLabel.text = packageFullDescription.html2String;
                    } else if self.countryCode == "62" {
                        let packageFullDescription = nutritionLabelDict["packageFullDesc_BA"] as! String;
                        self.packageDescriptionLbl.text =
                            self.packageDescription.html2String;
                        self.labelInfoTextLabel.text = packageFullDescription.html2String;
                    }
                    
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.nutritionLabelPacksTableView.reloadData();
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
    @objc func getLabelDetails() {
        
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.labelDetails(sessionString: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic);
            if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                if responseDic["totalTransactions"] as AnyObject as! Int == 0 {
                    self.packageDescriptionLbl.isHidden = false;
                   // self.packageDescriptionLbl.isHidden = true;
                    //self.pkgDescTitle.isHidden = true;
                    self.trendFriendLbl.isHidden = true;
                    self.labelCountView.isHidden = false;
                    //self.packageSelectionViewTopConstraint.constant = 118;
                    //self.packageSelectionViewTopConstraint.constant = 10;
                    self.paymentHistoryBtn.isEnabled = false;
                  //  if UserDefaults.standard.value(forKey: "USER_LABELS_COUNT") != nil {
                        let balanceLabels = responseDic["balanceLabels"] as AnyObject as! Int;
                        if balanceLabels < 0 {
                            self.remainingLabels.text = "\(0)";
                        } else {
                            self.remainingLabels.text = "\(balanceLabels)";
                        }
                 //   }
                } else {
                    self.buyNowBtn.setTitle(self.bundle.localizedString(forKey: "top_up", value: nil, table: nil), for: .normal);
                    
                    self.paymentHistoryBtn.isEnabled = true;
                   // self.packageSelectionViewTopConstraint.constant = 10;
                    self.packageDescriptionLbl.isHidden = true;
                    self.pkgDescTitle.isHidden = true;
                    self.trendFriendLbl.isHidden = false;
                    self.labelCountView.isHidden = false;
                  
                  //  let totalLabels = responseDic["totalLabels"] as AnyObject as! Int;
                    let balanceLabels = responseDic["balanceLabels"] as AnyObject as! Int;
                    if balanceLabels < 0 {
                        self.remainingLabels.text = "\(0)";
                    } else {
                        self.remainingLabels.text = "\(balanceLabels)";
                    }
                }
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    @objc func getTwetoxDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let dispatch_group = DispatchGroup();
        dispatch_group.enter();
        
        if !((packageObj["activeCountries"] as AnyObject) is NSNull) {
            print((packageObj["activeCountries"] as AnyObject));
            var activeCountriesArray = packageObj["activeCountries"] as AnyObject as! NSMutableArray;
            
            for activeCountries in activeCountriesArray {
                let activeCountry = "\(activeCountries)";
                if activeCountry == self.countryCode {
                    
                    self.nutritionLabelPackagesArray.add(packageObj);
                    
                } else if activeCountry == "99" {
                    
                    self.nutritionLabelPackagesArray.add(packageObj);
                    
                }
            }
           // twetoxLabelsSelections();
            packagLabelSelections();
            
        } else {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "There are no available Twetox Packages. Please come later!");
        }
        
        dispatch_group.leave();
        dispatch_group.notify(queue: DispatchQueue.main) {
            let nutritionLabelDict = self.nutritionLabelPackagesArray[0] as! [String : AnyObject];
            
           
          //  let packageDesc = "Package Description:" + "\n" + "\n";
            
            if self.countryCode == "91" {
                self.nutritionLabelImage.sd_setImage(with: URL(string: nutritionLabelDict["imgSmall"] as! String));
            } else if self.countryCode == "62" {
                self.nutritionLabelImage.sd_setImage(with: URL(string: nutritionLabelDict["imgSmall_BA"] as! String));
            }
            if self.countryCode == "91" {
                self.packageDescription = nutritionLabelDict["packageDesc"] as! String;
            } else if self.countryCode == "62" {
                self.packageDescription = nutritionLabelDict["packageDesc_BA"] as! String;
            }
            if self.countryCode == "91" {
                let packageFullDescription = nutritionLabelDict["packageFullDesc"] as! String;
                self.packageDescriptionLbl.text =
                    self.packageDescription.html2String;
                self.labelInfoTextLabel.text = packageFullDescription.html2String;
            } else if self.countryCode == "62" {
                let packageFullDescription = nutritionLabelDict["packageFullDesc_BA"] as! String;
                self.packageDescriptionLbl.text =
                    self.packageDescription.html2String;
                self.labelInfoTextLabel.text = packageFullDescription.html2String;
                self.labelInfoTextLabel.text = packageFullDescription.html2String;
            }
            
            MBProgressHUD.hide(for: self.view, animated: true);
            self.nutritionLabelPacksTableView.reloadData();
        }
    }
    
      @IBAction func okAction(_ sender: Any) {
        self.labelInfoView.isHidden = true;
    }
    
    @objc func priceLabelOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        if self.nutritionLabelPacksTableView.isHidden == true {
            self.nutritionLabelPacksTableView.isHidden = false;
        } else {
            self.nutritionLabelPacksTableView.isHidden = true;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
//        if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
//           // self.title = "Twetox"
//        } else if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
////            self.title = "My Tweak & Eat";
////            self.nutritionLabelImage.image = UIImage.init(named: "my_tweakandeat_banner.png")
//
//        } else {
//        self.getLabelDetails();
//        }
        self.getLabelDetails();
    }
    
    @IBAction func labelInfoAction(_ sender: Any) {
        self.nutritionLabelPacksTableView.isHidden = true;
        if self.labelInfoView.isHidden == true{
            self.labelInfoView.isHidden = false;

        }else{
            self.labelInfoView.isHidden = true;
        }
    }
    
    @objc func packagLabelSelections() {
        if self.nutritionLabelPackagesArray.count > 0 {
            if packageID == "-TacvBsX4yDrtgbl6YOQ" {
                self.buyNowBtn.setTitle(self.bundle.localizedString(forKey: "buy_now", value: nil, table: nil), for: .normal);
                
            }
             
            let nutritionLabelDict = nutritionLabelPackagesArray[0] as! [String : AnyObject];
            print(nutritionLabelDict);
            let packagePriceArray = nutritionLabelDict["packagePrice"] as! NSMutableArray;
            for pckgPrice in packagePriceArray {
                let packagePriceDict = pckgPrice as! [String : AnyObject];
                if packagePriceDict["countryCode"] as AnyObject as! String == self.countryCode {
                    if (packagePriceDict.index(forKey: labelsPrice) != nil) {
                        for dict  in packagePriceDict[labelsPrice] as! NSMutableArray {
                            let priceDict = dict as! [String : AnyObject];
                            self.nutritionLabelPriceArray.add(priceDict);
                        }
                    }
                }
                
            }
            print(self.nutritionLabelPackagesArray);
        }
    }
    
    @objc func twetoxLabelsSelections() {
        if self.nutritionLabelPackagesArray.count > 0 {
            
            let nutritionLabelDict = nutritionLabelPackagesArray[0] as! [String : AnyObject];
            print(nutritionLabelDict);
            let packagePriceArray = nutritionLabelDict["packagePrice"] as! NSMutableArray;
            for pckgPrice in packagePriceArray {
                let packagePriceDict = pckgPrice as! [String : AnyObject];
                if packagePriceDict["countryCode"] as AnyObject as! String == self.countryCode {
                    if (packagePriceDict.index(forKey: "bundles") != nil) {
                        for dict  in packagePriceDict["bundles"] as! NSMutableArray {
                            let priceDict = dict as! [String : AnyObject];
                            self.nutritionLabelPriceArray.add(priceDict);
                        }
                    }
                }
            }
            
            print(self.nutritionLabelPackagesArray);
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        if self.fromWhichVC == "" {
        navigationController?.popViewController(animated: true);
        dismiss(animated: true, completion: nil);
        } else {
            navigationController?.popToRootViewController(animated: true);
        }
    }
    
    func goToHomePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instamojoPayment" {
            let popOverVC = segue.destination as! InstaMojoViewController;
            let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
            popOverVC.msisdn = "+\(msisdn)";
            
            let cellDict  = nutritionLabelPackagesArray[0] as! [String : AnyObject];
            let packagePrice = cellDict["packagePrice"] as! NSMutableArray;
            for pkgPrice in packagePrice {
                var pkg =  pkgPrice as! NSDictionary;
                if pkg["countryCode"] as AnyObject as! String == self.countryCode {
                    popOverVC.currency = "\(pkg["currency"] as AnyObject as! String)";
                    popOverVC.paymentType = "\(pkg["paymentType"] as AnyObject as! String)";

                }
            }
            if self.labelPriceDict.count == 0 {
                self.labelPriceDict  = self.nutritionLabelPriceArray[0] as! [String : AnyObject];
            } else {
            self.labelPriceDict  = self.nutritionLabelPriceArray[selectedIndex] as! [String : AnyObject];
            }
            if self.packageID ==  "-MzqlVh6nXsZ2TCdAbOp" {
                popOverVC.pkgDescription = "\(labelPriceDict["pkgDescription"] as AnyObject as! String)";
                popOverVC.pkgDuration = "\(labelPriceDict["pkgDuration"] as AnyObject as! Int)";

            }
            
             if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
//                popOverVC.labelsCount = labelPriceDict["amount"] as AnyObject as! Int;
//                popOverVC.package = (labelPriceDict["name"] as AnyObject as? String)!;
//                popOverVC.price = "\(labelPriceDict["transPayment"] as AnyObject as! Double)";
                popOverVC.labelsCount = labelPriceDict[lableCount] as AnyObject as! Int;
                popOverVC.package = (labelPriceDict[lables] as AnyObject as? String)!;
                popOverVC.price = "\(labelPriceDict["amount"] as AnyObject as! Double)";


             } else {
                popOverVC.price = "\(labelPriceDict["amount"] as AnyObject as! Double)";
                popOverVC.currency = "\(labelPriceDict["currency"] as AnyObject as! String)";

            popOverVC.labelsCount = labelPriceDict[lableCount] as AnyObject as! Int;
            popOverVC.package = (labelPriceDict[lables] as AnyObject as? String)!;
                popOverVC.displayAmount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)";
                popOverVC.displayCurrency = "\(labelPriceDict["display_currency"] as AnyObject as! String)";

            }
            popOverVC.name = self.name;
            popOverVC.packageId = (cellDict["packageId"] as AnyObject as? String)!;
        }
    }
    
    @objc func getFirebaseData() {

        MBProgressHUD.showAdded(to: self.view, animated: true);
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.nutritionLabelPackagesArray = NSMutableArray();
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let packageObj = premiumPackages.value as? [String : AnyObject];
                    if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                       // let activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray;
                        //if activeCountriesArray.contains(self.countryCode) {
                        if premiumPackages.key == "-Qis3atRaproTlpr4zIs" {
                            self.nutritionLabelPackagesArray.add(packageObj!);
                            self.packagLabelSelections();

                        }
                       // }
                        

                    } else {
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_nutrition_alert", value: nil, table: nil));
                    }
                    
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    let nutritionLabelDict = self.nutritionLabelPackagesArray[0] as! [String : AnyObject];
                  //  let packageDesc = "Package Description:" + "\n" + "\n";
                    
                        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                            if language == "BA" {
                                 let premiumImgs = nutritionLabelDict["premiumImgs"] as! [String: AnyObject]
                                for (key,val) in premiumImgs {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                        self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                    }
                                }
                                
                            
                                let bottomDescription = nutritionLabelDict["bottomDescription_BA"] as! String;
                                self.trendFriendLbl.text = bottomDescription.html2String
                                let packageDescription1 = nutritionLabelDict["packageDescription"] as! [String: AnyObject]
                                for (key,val) in packageDescription1 {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                        //  self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                        self.packageDescription = dict[language] as! String;
                                        self.packageDescriptionLbl.text =
                                            self.packageDescription.html2String;
                                        
                                    }
                                }
                               // let packageFullDescription = nutritionLabelDict["packageFullDesc_BA"] as! String;
                                
                                let packageFullDescription = nutritionLabelDict["packageFullDescription"] as! [String: AnyObject]
                                for (key,val) in packageFullDescription {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                        //  self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                        let packageFullDescription = dict[language] as! String;
                                        self.labelInfoTextLabel.text = packageFullDescription.html2String;
                                        
                                    }
                                }
                            } else {
                                let premiumImgs = nutritionLabelDict["premiumImgs"] as! [String: AnyObject]
                                for (key,val) in premiumImgs {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                        self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                    }
                                }
                                let bottomDescription = nutritionLabelDict["bottomDescription"] as! String;
                                self.trendFriendLbl.text = bottomDescription.html2String
                                let packageDescription1 = nutritionLabelDict["packageDescription"] as! [String: AnyObject]
                                for (key,val) in packageDescription1 {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                        //  self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                        self.packageDescription = dict[language] as! String;
                                        self.packageDescriptionLbl.text =  self.packageDescription.html2String;
                                    }
                                }
                               // let packageFullDescription = nutritionLabelDict["packageFullDesc"] as! String;
                                let packageFullDescription = nutritionLabelDict["packageFullDescription"] as! [String: AnyObject]
                                for (key,val) in packageFullDescription {
                                    if key == self.countryCode {
                                        let dict = val as! [String: AnyObject]
                                      //  self.nutritionLabelImage.sd_setImage(with: URL(string: dict[language] as! String));
                                        let packageFullDescription = dict[language] as! String;
                                        self.labelInfoTextLabel.text = packageFullDescription.html2String;

                                    }
                                }
                                self.packageDescriptionLbl.text =
                                    self.packageDescription.html2String;
                            }
                        }
                    
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.nutritionLabelPacksTableView.isHidden = true;
                    self.nutritionLabelPacksTableView.reloadData();
                    
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionLabelPriceArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! NutritionLabelTableViewCell;
        let cellDict = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
        if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
           // cell.textLabel?.text = cellDict["name"] as? String;
            cell.textLabel?.text = cellDict[lables] as? String;


        } else {
        cell.textLabel?.text = cellDict[lables] as? String;
        }
        cell.textLabel?.font = cell.textLabel?.font.withSize(16);

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        selectedIndex = indexPath.row;
        self.labelPriceDict  = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
        if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
           // self.packSelectionLabel.text = self.labelPriceDict["name"] as? String;
            self.packSelectionLabel.text = self.labelPriceDict[lables] as? String;

            
        } else {
           self.packSelectionLabel.text = self.labelPriceDict[lables] as? String;
        }
        
        self.nutritionLabelPacksTableView.isHidden = true;
        
    }
    
    @IBAction func nutritionLblPacksTapped(_ sender: Any) {
        if self.nutritionLabelPacksTableView.isHidden == true {
            self.nutritionLabelPacksTableView.isHidden = false;
        } else {
            self.nutritionLabelPacksTableView.isHidden = true;
        }
    }
    
    @IBAction func buyNowTapped(_ sender: Any) {
        if self.packSelectionLabel.text == "Select your pack" {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "select_your_pack_alert", value: nil, table: nil));
        } else {
            
            Analytics.logEvent("TAE_LBLS_BUYNOW_CLICKED_IND", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing labels"])
        self.nutritionLabelPacksTableView.isHidden = true
        self.performSegue(withIdentifier: "instamojoPayment", sender: self);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
