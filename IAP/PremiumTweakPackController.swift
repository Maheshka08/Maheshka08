//
//  ViewController.swift
//  AutoScroll
//
//  Created by apple on 10/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Firebase
import StoreKit

class PremiumTweakPackController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
   
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.productIdentifier as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                self.buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func buyProduct(product: SKProduct) {
        // MBProgressHUD.hide(for: self.view, animated: true);
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        self.productPrice = product.price
        SKPaymentQueue.default().add(payment);
        
        
    }
    func receiptValidation() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        var jsonDict = [String: AnyObject]()
        
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.ptpPackage
            , "amountPaid": self.priceInDouble, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
        //91e841953e9f4d19976283cd2ee78992
        
        print(recieptString!)
        //        UserDefaults.standard.set(receiptData, forKey: "RECEIPT")
        //        UserDefaults.standard.synchronize()
        //
        
        // MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postReceiptData(TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: jsonDict, success: { response in
            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
            var responseResult = ""
            if responseDic.index(forKey: "callStatus") != nil {
                responseResult = responseDic["callStatus"] as! String
            } else if responseDic.index(forKey: "CallStatus") != nil {
                responseResult = responseDic["CallStatus"] as! String
            }
            if  responseResult == "GOOD" {
                MBProgressHUD.hide(for: self.view, animated: true);
                print("in-app done")
          self.paymentSuccessView.isHidden = false
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PTP-IN-APP-SUCCESSFUL"), object: responseDic);
//                var data = [String: AnyObject]()
//                let response = responseDic ;
//                if response.index(forKey: "data") != nil {
//                    // contains key
//                    data = responseDic["data"] as AnyObject as! [String: AnyObject]
//
//                } else if response.index(forKey: "Data") != nil {
//                    // contains key
//                    data = responseDic["Data"] as AnyObject as! [String: AnyObject]
//
//                }
//
//                //   let data = responseDic["data"] as AnyObject as! [String: AnyObject]
//                if data["NutritionistFirebaseId"] is NSNull {
//                    UserDefaults.standard.setValue("", forKey: "NutritionistFirebaseId")
//                } else {
//                    UserDefaults.standard.setValue(data["NutritionistFirebaseId"] as AnyObject as! String, forKey: "NutritionistFirebaseId")
//                }
//
//                if data["NutritionistFirstName"] is NSNull {
//                    UserDefaults.standard.setValue("", forKey: "NutritionistFirstName")
//                } else {
//                    UserDefaults.standard.setValue(data["NutritionistFirstName"] as AnyObject as! String, forKey: "NutritionistFirstName")
//                }
//                if data["NutritionistSignature"] is NSNull {
//                    UserDefaults.standard.setValue("", forKey: "NutritionistSignature")
//                } else {
//                    UserDefaults.standard.setValue(data["NutritionistSignature"] as AnyObject as! String, forKey: "NutritionistSignature")
//                }
                

            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
        
        //        do {
        //            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        //            let storeURL = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        //            var storeRequest = URLRequest(url: storeURL)
        //            storeRequest.httpMethod = "POST"
        //            storeRequest.httpBody = requestData
        //
        //            let session = URLSession(configuration: URLSessionConfiguration.default)
        //            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
        //
        //                do {
        //                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        //                    print("=======>",jsonResponse)
        //                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
        //                        print(date)
        //                    }
        //                } catch let parseError {
        //                    print(parseError)
        //                }
        //            })
        //            task.resume()
        //        } catch let parseError {
        //            print(parseError)
        //        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                
                // self.dismissPurchaseBtn.isEnabled = true
                // self.restorePurchaseBtn.isEnabled = true
                // self.buyNowButton.isEnabled = true
                
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    
                    //Do unlocking etc stuff here in case of new purchase
                    //self.tableView.isHidden = true
                    MBProgressHUD.hide(for: self.view, animated: true);
                    //print(trans.transactionIdentifier!)
                    self.receiptValidation()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SKPaymentQueue.default().remove(self)
                    

                    
                    break;
                case .failed:
                    print("Purchased Failed");
                    MBProgressHUD.hide(for: self.view, animated: true);
                  //  self.tableView.isHidden = false;
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SKPaymentQueue.default().remove(self)
                    self.navigationController?.popViewController(animated: true)
                    break;
                case .restored:
                    print("Already Purchased")
                    //Do unlocking etc stuff here in case of restor
                    MBProgressHUD.hide(for: self.view, animated: true);
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SKPaymentQueue.default().remove(self)
                    
                default:
                    // MBProgressHUD.hide(for: self.view, animated: true);
                    
                    break;
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.packagesPriceArray.count > 0 {
            return self.packagesPriceArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ptpTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cellDict = self.packagesPriceArray[indexPath.row] as! [String : AnyObject];
        let labels = (cellDict[lables] as? String)! + " ("
        let amount = "\(cellDict["display_amount"] as AnyObject as! Double)" + " "
        let currency = (cellDict["display_currency"] as? String)! + ")"
        let totalDesc: String = labels + amount + currency;
        cell.textLabel?.text = totalDesc
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(16);
        cell.textLabel?.numberOfLines = 0
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please select your subscription"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.ptpPriceDict  = self.packagesPriceArray[indexPath.row] as! [String : AnyObject];
        self.pkgDescription = "\(ptpPriceDict["pkgDescription"] as AnyObject as! String)";
        //self.pkgDuration = "\(labelPriceDict["pkgDuration"] as AnyObject as! String)";
        self.pkgDuration = ptpPriceDict["pkgDuration"] as AnyObject as! String;
        
        self.price = "\(ptpPriceDict["transPayment"] as AnyObject as! Double)";
        self.priceInDouble = ptpPriceDict["transPayment"] as AnyObject as! Double;
        self.currency = "\(ptpPriceDict["currency"] as AnyObject as! String)";
        let labels =  (self.ptpPriceDict[lables] as? String)! + " ("
        let amount = "\(ptpPriceDict["display_amount"] as AnyObject as! Double)" + " "
        
        let currency = (self.ptpPriceDict["display_currency"] as? String)! + ")"
        let totalDesc: String = labels + amount + currency;
        self.productIdentifier = self.ptpPriceDict["productIdentifier"] as AnyObject as! String
        
      self.selectYourPackLabel.text = totalDesc
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        
                       // self.ptpTableView.isHidden = true
                        self.ptpTableViewHeightConstraint.constant = 0
                        //self.bottomButtonsView.backgroundColor = UIColor.groupTableViewBackground
                        self.view.layoutIfNeeded()
                        
                        
        },  completion: {(_ completed: Bool) -> Void in
          
        })
   
    }
    var productPrice: NSDecimalNumber = NSDecimalNumber()
    var imgArray = [UIImage]()
    var descArray = [String]()
    var countryCode = ""
    var ptpPackagesArray = NSMutableArray()
    var packagesPriceArray = NSMutableArray()
    var system = 0
    var productIdentifier = ""
    var ptpPackage = ""
    @objc var smallImage : String = ""
    @objc var price : String = ""
    @objc var priceInDouble : Double = 0.0
    @objc var name : String = ""
    @objc var package : String = ""
    @objc var msisdn : String = ""
    @objc var packageId : String = ""
    @objc var packageFullDesc : String = ""
    @objc var paymentType : String = ""
    @objc var currency : String = ""
    @objc var ptpPriceDict = [String: AnyObject]();
    @objc var selectedIndex: Int = 0;
    
    var cardImageString = "";
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    var labelsPrice = "pkgRecurPrice"
    var lables = "pkgDisplayDescription"
    var lableCount = "pkgDuration"
    @objc var displayAmount : String = "";
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    @objc var pkgDuration : String = "";
    @IBOutlet weak var showPurchasedView: UIView!
    @IBOutlet weak var paymentSuccessView: UIView!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var ptpTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ptpTableView: UITableView!
    @IBOutlet weak var selectYourPackLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var congratulationsTextLbl: UILabel!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArray.count
    }
    
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buyNowTapped(_ sender: Any) {
        if self.selectYourPackLabel.text == "Please select your pack" {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please select your pack")
        } else {
            if self.countryCode == "91" {
                Analytics.logEvent("TAE_PTP_BUYNOW_IND", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            } else if self.countryCode == "1" {
                 Analytics.logEvent("TAE_PTP_BUYNOW_USA", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            } else if self.countryCode == "65" {
                 Analytics.logEvent("TAE_PTP_BUYNOW_SGP", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            } else if self.countryCode == "62" {
                 Analytics.logEvent("TAE_PTP_BUYNOW_INDO", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            } else if self.countryCode == "60" {
                 Analytics.logEvent("TAE_PTP_BUYNOW_MYS", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            } else if self.countryCode == "63" {
                 Analytics.logEvent("TAE_PTP_BUYNOW_PHL", parameters: [AnalyticsParameterItemName: "Buy Now tapped for purchasing Premium Tweak Pack"])
            }
          
            MBProgressHUD.showAdded(to: self.view, animated: true);
            SKPaymentQueue.default().add(self)
            if (SKPaymentQueue.canMakePayments()) {
                let productID:NSSet = NSSet(array: [self.productIdentifier as String]);
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start();
                print("Fetching Products");
            } else {
                print("can't make purchases");
            }
        }
    }
    @IBAction func dropDownbtnTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        
                        self.ptpTableView.isHidden = false
                        self.ptpTableViewHeightConstraint.constant = 280
                        //self.bottomButtonsView.backgroundColor = UIColor.groupTableViewBackground
                        self.view.layoutIfNeeded()
                        
                        
        },  completion: {(_ completed: Bool) -> Void in
          //  self.getPTPDetails()
        })
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! ScrollCell
        
        item.imgView.image = self.imgArray[indexPath.item]
        //item.descLbl.adjustsFontForContentSizeCategory = true
        item.descLbl.text = self.descArray[indexPath.row]
        
        
        return item
    }
    
    @objc func packagSelections() {
        let dispatch_group = DispatchGroup();
        dispatch_group.enter();
        
        if self.ptpPackagesArray.count > 0 {
            
            let nutritionLabelDict = ptpPackagesArray[0] as! [String : AnyObject];
            print(nutritionLabelDict);
            let packagePriceArray = nutritionLabelDict["packagePrice"] as! NSMutableArray;
            for pckgPrice in packagePriceArray {
                let packagePriceDict = pckgPrice as! [String : AnyObject];
                if packagePriceDict["countryCode"] as AnyObject as! String == self.countryCode {
                    if (packagePriceDict.index(forKey: labelsPrice) != nil) {
                        self.packagesPriceArray = NSMutableArray()
                        for dict  in packagePriceDict[labelsPrice] as! NSMutableArray {
                            let priceDict = dict as! [String : AnyObject];
                            if priceDict["isActive"] as! Bool == true {
                                self.packagesPriceArray.add(priceDict);
                            }
                        }
                    }
                }
                
            }
            dispatch_group.leave();
            dispatch_group.notify(queue: DispatchQueue.main) {
                
                self.buyNowBtn.isEnabled = true

            }
            
           
        }
    }
    
    func getPTPDetails() {
         MBProgressHUD.showAdded(to: self.ptpTableView, animated: true);
        
        
        Database.database().reference().child("PremiumPackageDetailsiOS").child(ptpPackage).observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.ptpPackagesArray = NSMutableArray();
            
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                

                        let packageObj = snapshot.value as? [String : AnyObject];
                        if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                            
                            self.ptpPackagesArray.add(packageObj!);
                            //DispatchQueue.global(qos: .userInitiated).async {
                                self.packagSelections();
                            //}
                            
                        } else {
                            TweakAndEatUtils.AlertView.showAlert(view: self, message: "There is no package available. Please try again later!!");
                        }
                        
                    
                
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {

                    MBProgressHUD.hide(for: self.ptpTableView, animated: true);
                    self.ptpTableView.reloadData()
                }
                
            } else {
                MBProgressHUD.hide(for: self.ptpTableView, animated: true);
                
            }
        })
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = self.collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < self.imgArray.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    self.pageControl.currentPage = indexPath1!.row ;
                    
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    self.pageControl.currentPage = indexPath1!.row ;
                    
                }
                
                
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
       
        if self.countryCode == "91" {
            ptpPackage = "-PtpIndu4fke3hfj8skf"
        } else if self.countryCode == "1" {
            ptpPackage = "-PtpUsa9aqws5fcb7mkG"
        } else if self.countryCode == "65" {
            ptpPackage = "-PtpSgn5Kavqo3cakpqh"
        } else if self.countryCode == "62" {
            ptpPackage = "-PtpIdno8kwg2npl5vna"
        } else if self.countryCode == "60" {
            ptpPackage = "-PtpMys1ogs7bwt3malu"
        } else if self.countryCode == "63" {
            ptpPackage = "-PtpPhy3mskop9Avqj5L"
        }
        if (UserDefaults.standard.value(forKey: ptpPackage) != nil) {
            self.showPurchasedView.isHidden = false
        } else {
             self.showPurchasedView.isHidden = true
        }
        self.congratulationsTextLbl.text = "Congratulations!\n\nStart Tweaking now. Our Nutritionists will ensure your Nutrition 'Trends' right, and hand-hold until your health goals fall in line. Simple!"
        self.buyNowBtn.isEnabled = false
        self.ptpTableView.layer.cornerRadius = 10
        self.ptpTableView.backgroundColor = UIColor.groupTableViewBackground
        path = Bundle.main.path(forResource: "en", ofType: "lproj");
        bundle = Bundle.init(path: path!)! as Bundle;
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "AR" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
                
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
            
            
        }
        SKPaymentQueue.default().add(self)
        self.getPTPDetails()

        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"stamp-bg")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        self.collectionView.backgroundView = imageView
        self.pageControl.isUserInteractionEnabled = false
        //  edgesForExtendedLayout = []
        //self.collectionView.isUserInteractionEnabled = false
        self.pageControl.currentPage = 0;
        
        // Do any additional setup after loading the view, typically from a nib.
        self.imgArray = [UIImage.init(named: "Slide 1"),UIImage.init(named: "Slide 2"),UIImage.init(named: "Slide 3"),UIImage.init(named: "Slide 4"),UIImage.init(named: "Slide 5")] as! [UIImage]
        let slideDesc1 = "Get Visual, Graphical Tweaks (your plate of food visually and graphically marked up) from your certified nutritionist"
        let slideDesc2 = "Get Specific inputs on what to consume, what to replace next time, what to eat first, second etc., to show the order in which to consume the different items in your plate, all by a certified nutritionist"
        let slideDesc3 = "“Ask a Question“- you can chat with the nutritionist that sent you the tweak anytime, if any clarification is needed or you have any question on the tweaked plate. The concerned nutritionist will respond to you within the day. You will be notified when you receive the response.\nGet Nutrition Labels with every plate you tweak - there is no limit on Nutrition Labels - it’s unlimited!"
        let slideDesc4 = "Each Nutrition Label with every plate will include the following:\n%Calories\n%Carbs\n% Protein\n% Fat\n% Others"
        let slideDesc5 = "Get Nutritional Analysis that includes the following:\nCalorie Trends for the last 10 Tweaks (Plates)\nCarb Trends for the last 10 Tweaks\nProtein Trends for the last 10 Tweaks\nFat Trends for the last 10 Tweaks\nTotal Trend Analysis to help you make the ‘Trend your Friend’"
        self.descArray = [slideDesc1,slideDesc2,slideDesc3,slideDesc4,slideDesc5]
        self.collectionView.reloadData()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
        
        
    }
    
    
    
}
extension PremiumTweakPackController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

