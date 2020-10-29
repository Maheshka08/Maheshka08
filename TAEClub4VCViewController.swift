//
//  TAEClub4VCViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 08/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import StoreKit
import Branch
import RNCryptor
import FacebookCore

class TAEClub4VCViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UITextFieldDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
     if textView == self.featuresViewSubscribeTextView  {
         UIApplication.shared.open(URL)
     }
        return false
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
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
                    self.navigationItem.hidesBackButton = false

                    print("Purchased Failed");
                    MBProgressHUD.hide(for: self.view, animated: true);
                  //  self.tableView.isHidden = false;
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SKPaymentQueue.default().remove(self)
                   // self.navigationController?.popViewController(animated: true)
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
    
    func buyProduct(product: SKProduct) {
           // MBProgressHUD.hide(for: self.view, animated: true);
           print("Sending the Payment Request to Apple");
           let payment = SKPayment(product: product)
           self.productPrice = product.price
           SKPaymentQueue.default().add(payment);
           
           
       }
    @IBOutlet weak var featuresViewSubscribeTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var club4ImageView: UIImageView!
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
    @IBOutlet weak var showPurchasedView: UIView!
    @IBOutlet weak var paymentSuccessView: UIView!
    var cardImageString = "";
    var fromPopUpScreen = false
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    var labelsPrice = "pkgRecurPrice"
    var lables = "pkgDisplayDescription"
    var lableCount = "pkgDuration"
    @objc var displayAmount : String = "";
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    @objc var pkgDuration : String = "";
    var packageName = ""
    var packageID = ""
    @IBAction func club4DoneTapped(_ sender: Any) {
         self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func club4SubmitTapped(_ sender: Any) {
       // self.navigationController?.popToRootViewController(animated: true)
        purchaseIAP()
    }
    
    func purchaseIAP() {
        self.navigationItem.hidesBackButton = true
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
                    self.navigationItem.hidesBackButton = false
                 }
    }
    
    func receiptValidation() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        var jsonDict = [String: AnyObject]()
        
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.packageID
            , "amountPaid": self.priceInDouble, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
        //91e841953e9f4d19976283cd2ee78992
        
        print(recieptString!)

        
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
                      //AppsFlyerLib.shared().logEvent("af_purchase", withValues: [AFEventParamContentType: "CLUB Subscription", AFEventParamContentId: self.packageID, AFEventParamCurrency: self.currency])
//                if UserDefaults.standard.value(forKey: "msisdn") != nil {
//                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
//                    Branch.getInstance().setIdentity(msisdn)
//
//                }
                if UserDefaults.standard.value(forKey: "msisdn") != nil {
                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
                    let data: NSData = msisdn.data(using: .utf8)! as NSData
                    let password = "sFdebvQawU9uZJ"
                    let cipherData = RNCryptor.encrypt(data: data as Data, withPassword: password)
                    Branch.getInstance().setIdentity(cipherData.base64EncodedString())

                }
                AppEvents.logEvent(.purchased, parameters: ["packageID": self.packageId, "curency": self.currency])
                let event = BranchEvent.customEvent(withName: "purchase")
                event.eventDescription = "User completed payment."
                event.customData["packageID"] = self.packageId
                event.customData["currency"] = self.currency
                event.logEvent()
          self.paymentSuccessView.isHidden = false
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TAECLUB-IN-APP-SUCCESSFUL"), object: responseDic);

            }
        }, failure : { error in
            self.navigationItem.hidesBackButton = false
            MBProgressHUD.hide(for: self.view, animated: true);
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
        
  
    }
    
    func getSubscriptionText() {
        Database.database().reference().child("GlobalVariables").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                        
                           for obj in snapshot.children.allObjects as! [DataSnapshot] {
                         if obj.key == "ios_terms_pp_buy" {
                            let terms = obj.value as AnyObject as! [String: AnyObject]

                           let subscriptionDetailsText = terms["auorenewal"] as! String
                            self.featuresViewSubscribeTextView.linkTextAttributes = [
                            NSAttributedString.Key.foregroundColor: UIColor.blue,
                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                                                                  ]
                            self.featuresViewSubscribeTextView.text = subscriptionDetailsText.replacingOccurrences(of: "\\n", with: "\n")
                              
                            }

                }
                
            }
           
            
            
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.featuresViewSubscribeTextView.flashScrollIndicators()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuresViewSubscribeTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.featuresViewSubscribeTextView.flashScrollIndicators()

        
        self.featuresViewSubscribeTextView.textColor = UIColor.gray
      
        self.featuresViewSubscribeTextView.layer.cornerRadius = 10;
        self.featuresViewSubscribeTextView.layer.borderWidth = 2
        self.featuresViewSubscribeTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
              }

            if self.countryCode == "91" {
                self.packageID = "-ClubInd3gu7tfwko6Zx"
            } else if self.countryCode == "62" {
                self.packageID = "-ClubIdn4hd8flchs9Vy"

            }
        self.submitBtn.isEnabled = false
        // Do any additional setup after loading the view.
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
        self.getClub4Info()

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
                if self.packagesPriceArray.count == 1 {
                let ptpPriceDict  = self.packagesPriceArray[0] as! [String : AnyObject];
                self.productIdentifier = ptpPriceDict["productIdentifier"] as AnyObject as! String
                    self.pkgDescription = "\(ptpPriceDict["pkgDescription"] as AnyObject as! String)";
                           //self.pkgDuration = "\(labelPriceDict["pkgDuration"] as AnyObject as! String)";
                           self.pkgDuration = ptpPriceDict["pkgDuration"] as AnyObject as! String;
                           
                           self.price = "\(ptpPriceDict["transPayment"] as AnyObject as! Double)";
                           self.priceInDouble = ptpPriceDict["transPayment"] as AnyObject as! Double;
                           self.currency = "\(ptpPriceDict["currency"] as AnyObject as! String)";
                }
                self.submitBtn.isEnabled = true
                if self.fromPopUpScreen == true {
                    self.purchaseIAP()
                }

            }
            
           
        }
    }
    
    func getPTPDetails() {
        // MBProgressHUD.showAdded(to: self.view, animated: true);
        
        
        Database.database().reference().child("PremiumPackageDetailsiOS").child(self.packageID).observe(DataEventType.value, with: { (snapshot) in
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

                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.getSubscriptionText()
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
    func updateUI(data: [[String: AnyObject]] ) {
        if data.count == 0 {
            
        } else {
          for dict in data {
              if dict["name"] as! String == "submit_btn_title" {
                  let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                  let encodedData = htmlText.data(using: String.Encoding.utf8)!
                    var attributedString: NSAttributedString

                    do {
                        attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
                    
                      let textAttribute: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: UIFont(name:"QUESTRIAL-REGULAR", size: 24.0)!]

                      self.submitBtn.setAttributedTitle(NSAttributedString(string: attributedString.string, attributes: textAttribute), for: .normal)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    } catch {
                        print("error")
                    }
              }
                  if dict["name"] as! String == "body_img" {
                      let urlString = dict["value"] as! String

                    self.club4ImageView.sd_setImage(with: URL(string: urlString.replacingOccurrences(of: "tae_club_sub4_bg", with: "tae_club_sub4_bg_ios"))) { (image, error, cache, url) in
                                                                       // Your code inside completion block
                        if image != nil {
                      let ratio = image!.size.width / image!.size.height
                      let newHeight = self.club4ImageView.frame.width / ratio
                     
                          UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                animations: {
                                                 self.imageViewHeightConstraint.constant = newHeight
                                                  self.view.layoutIfNeeded()
                                 }, completion: nil)


                      }
                    }
              }
              if dict["name"] as! String == "title" {
                  self.title = (dict["value"] as! String)
              }

          }
        }
    }
    
    func getClub4Info() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_SUB4, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                     // MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                  
                    self.updateUI(data: data)
                    self.getPTPDetails()

                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
