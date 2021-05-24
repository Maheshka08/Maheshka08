//
//  ViewController.swift
//  SampleStripePayment
//
//  Created by mac on 09/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import Realm
import RealmSwift
import Razorpay
//import StoreKit


class StripePaymentGateway: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RazorpayPaymentCompletionProtocol {
    
    //If an error occurs, the code will go to this function
//    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
//        // Show some alert
//    }
    
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
//        print(transactions)
//    }
    
//    func buyProduct(product: SKProduct) {
//       // MBProgressHUD.hide(for: self.view, animated: true);
//        print("Sending the Payment Request to Apple");
//        let payment = SKPayment(product: product)
//        self.productPrice = product.price
//        SKPaymentQueue.default().add(payment);
//
//
//    }
    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction:AnyObject in transactions {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//
//                // self.dismissPurchaseBtn.isEnabled = true
//                // self.restorePurchaseBtn.isEnabled = true
//                // self.buyNowButton.isEnabled = true
//
//                switch trans.transactionState {
//                case .purchased:
//                    print("Product Purchased")
//
//                    //Do unlocking etc stuff here in case of new purchase
//                    self.tableView.isHidden = true
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    //print(trans.transactionIdentifier!)
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    self.receiptValidation()
//                    SKPaymentQueue.default().remove(self)
//
//                    break;
//                case .failed:
//                    print("Purchased Failed");
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    self.tableView.isHidden = false;
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    SKPaymentQueue.default().remove(self)
//                    self.navigationController?.popViewController(animated: true)
//                    break;
//                case .restored:
//                    print("Already Purchased")
//                    //Do unlocking etc stuff here in case of restor
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    SKPaymentQueue.default().remove(self)
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//
//                default:
//                   // MBProgressHUD.hide(for: self.view, animated: true);
//
//                    break;
//                }
//            }
//        }
//    }
    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print(response.products)
//        let count : Int = response.products.count
//        if (count>0) {
//
//            let validProduct: SKProduct = response.products[0] as SKProduct
//            if (validProduct.productIdentifier == self.productIdentifier as String) {
//                print(validProduct.localizedTitle)
//                print(validProduct.localizedDescription)
//                print(validProduct.price)
//                self.buyProduct(product: validProduct)
//            } else {
//                print(validProduct.productIdentifier)
//            }
//        } else {
//            print("nothing")
//        }
//    }
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var productPrice: NSDecimalNumber = NSDecimalNumber()
    var productIdentifier = ""
    @IBOutlet weak var hiddenView: UIView!
    
    @IBOutlet weak var unSubscribeImageView: UIImageView!
    
    @objc var packageIDArray = NSMutableArray()
    func onPaymentError(_ code: Int32, description str: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RAZORPAY_CANCELLED_BY_USER"), object: nil);
        self.navigationController?.popViewController(animated: true)
        TweakAndEatUtils.AlertView.showAlert(view: self, message: str);
    }
    
    func twaekAndEatAndMyAiDPSub(paymentID: String) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let doubleVal = formatter.number(from: self.price.replacingOccurrences(of: ".0", with: ".00"))?.doubleValue
        //let newFloat =  formatter.string(from: NSNumber(value: Float(self.price.replacingOccurrences(of: ".0", with: ".00"))!))!
        print(doubleVal!)
        let paramsDictionary = ["packageId": self.packageID,
                                "amountPaid": doubleVal!,
                                "amountCurrency": self.currency,
                                "paymentId": paymentID,
                                "packageDuration": Int(self.pkgDuration)!,
                                "packageRecurring": 0
            
            ] as [String : AnyObject]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.MY_TANDE_SUB, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response!)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["CallStatus"] as! String;
            if  responseResult == "GOOD" {
                // MBProgressHUD.hide(for: self.view, animated: true)
                self.payBtn.isHidden = true;
                
                //self.view.window!.rootViewController?.dismiss(animated: true)
                //                    let country: String = UserDefaults.standard.value(forKey: "COUNTRY_NAME") as! String
                //                    let eventName = "premiumPackagesPayment_successful" + "_" + country
                //                    print(eventName)
                //                    Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "user bought premium package"])
                //
                var data = [String: AnyObject]()
                let response = responseDic ;
                if response.index(forKey: "data") != nil {
                    // contains key
                    data = responseDic["data"] as AnyObject as! [String: AnyObject]
                    
                } else if response.index(forKey: "Data") != nil {
                    // contains key
                    data = responseDic["Data"] as AnyObject as! [String: AnyObject]
                    
                }
                
                if data["NutritionistFirebaseId"] is NSNull {
                    UserDefaults.standard.setValue("", forKey: "NutritionistFirebaseId")
                } else {
                    UserDefaults.standard.setValue(data["NutritionistFirebaseId"] as AnyObject as! String, forKey: "NutritionistFirebaseId")
                }
                
                if data["NutritionistFirstName"] is NSNull {
                    UserDefaults.standard.setValue("", forKey: "NutritionistFirstName")
                } else {
                    UserDefaults.standard.setValue(data["NutritionistFirstName"] as AnyObject as! String, forKey: "NutritionistFirstName")
                }
                if data["NutritionistSignature"] is NSNull {
                    UserDefaults.standard.setValue("", forKey: "NutritionistSignature")
                } else {
                    UserDefaults.standard.setValue(data["NutritionistSignature"] as AnyObject as! String, forKey: "NutritionistSignature")
                }
                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).child("packages").observe(DataEventType.value, with: { (snapshot) in
                    if snapshot.childrenCount > 0 {
                        let dispatch_group = DispatchGroup();
                        dispatch_group.enter();
                        
                        for pkgs in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            let pkgID = pkgs.value as AnyObject
                            if pkgID as! String != self.packageID {
                                self.packageIDArray.add(pkgID);
                            }
                        }
                        dispatch_group.leave();
                        dispatch_group.notify(queue: DispatchQueue.main) {
                            // MBProgressHUD.hide(for: self.view, animated: true);
                            
                        }
                    }
                })
                let currentDate = Date();
                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                let currentTime = Int64(currentTimeStamp);
                for pkgID in self.packageIDArray {
                    if pkgID as! String == self.packageID {
                        self.packageIDArray.remove(self.packageID)
                    }
                }
                self.packageIDArray.add(self.packageID)
                var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfileInfo?.first?.msisdn as Any,"name": self.myProfileInfo?.first?.name as Any, "unread": false, "email": self.myProfileInfo?.first?.email as Any, "height": self.myProfileInfo?.first?.height as Any, "weight": self.myProfileInfo?.first?.weight as Any, "foodHabits": self.myProfileInfo?.first?.foodHabits as Any, "allergies": self.myProfileInfo?.first?.allergies as Any, "conditions": self.myProfileInfo?.first?.conditions as Any, "bodyShape": self.myProfileInfo?.first?.bodyShape as Any, "goals": self.myProfileInfo?.first?.goals as Any, "gender": self.myProfileInfo?.first?.gender as Any, "age": self.myProfileInfo?.first?.age as Any] as [String : Any]
                pkgsArray["packages"] = self.packageIDArray;
                
                Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
                })
                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                        if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                            self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
                            self.usdAmtLabel.text = "Thank you for subscribing to " + self.selectPlanLabel.text!;
                            
                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                            
                            let msg = signature.html2String;
                            self.nutritionstDescLbl.text =
                            msg;
                        } else if self.packageID == "-AiDPwdvop1HU7fj8vfL"{
                            APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(TweakAndEatURLConstants.IND_AiDP_CONTENT, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                                let responseResult = responseDic["CallStatus"] as! String
                                if  responseResult == "GOOD" {
                                    self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
                                    self.usdAmtLabel.text = "Thank you for subscribing to " + self.selectPlanLabel.text!;
                                    
                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                                    
                                    let msg = signature.html2String;
                                    self.nutritionstDescLbl.text =
                                    msg;
                                } else{
                                    
                                }
                            }, failure : { error in
                                //  print(error?.description)
                                //            self.getQuestionsFromFB()
                                MBProgressHUD.hide(for: self.view, animated: true);
                                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
                                
                            })
                        }
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                    }
                })
                
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            if error?.code == -1011 {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your payment was declined.");
                return
            }
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
        })
    }
    
    
    func onPaymentSuccess(_ payment_id: String) {
        let id:  String = payment_id
        // if self.packageID == "" {
        self.hiddenView.isHidden = true
        self.twaekAndEatAndMyAiDPSub(paymentID: id)
        //}
        //        let packageParams =
        //            ["packageId" : self.packageID, "amountPaid" : self.price, "amountCurrency" : self.currency, "paymentId" : id] as [String : Any];
        //        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        //
        //        APIWrapper.sharedInstance.packageRegistration(sessionString: userSession, packageParams as NSDictionary, successBlock: {(responseDic : AnyObject!) -> (Void) in
        //            print("Sucess");
        //            print(responseDic)
        //            if responseDic["CallStatus"] as AnyObject as! String == "GOOD"  {
        //                self.payBtn.isHidden = true;
        //                MBProgressHUD.hide(for: self.view, animated: true);
        //
        //                //self.view.window!.rootViewController?.dismiss(animated: true)
        //                let country: String = UserDefaults.standard.value(forKey: "COUNTRY_NAME") as! String
        //                let eventName = "premiumPackagesPayment_successful" + "_" + country
        //                print(eventName)
        //                Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "user bought premium package"])
        //
        //                var data = [String: AnyObject]()
        //                let response = responseDic as! [String: AnyObject];
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
        //                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).child("packages").observe(DataEventType.value, with: { (snapshot) in
        //                    if snapshot.childrenCount > 0 {
        //                        let dispatch_group = DispatchGroup();
        //                        dispatch_group.enter();
        //
        //                        for pkgs in snapshot.children.allObjects as! [DataSnapshot] {
        //
        //                            let pkgID = pkgs.value as AnyObject
        //                            if pkgID as! String != self.packageID {
        //                                self.packageIDArray.add(pkgID);
        //                            }
        //                        }
        //                        dispatch_group.leave();
        //                        dispatch_group.notify(queue: DispatchQueue.main) {
        //                            MBProgressHUD.hide(for: self.view, animated: true);
        //
        //                        }
        //                    }
        //                })
        //                let currentDate = Date();
        //                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
        //                let currentTime = Int64(currentTimeStamp);
        //                for pkgID in self.packageIDArray {
        //                    if pkgID as! String == self.packageID {
        //                        self.packageIDArray.remove(self.packageID)
        //                    }
        //                }
        //                self.packageIDArray.add(self.packageID)
        //                var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfileInfo?.first?.msisdn as Any,"name": self.myProfileInfo?.first?.name as Any, "unread": false, "email": self.myProfileInfo?.first?.email as Any, "height": self.myProfileInfo?.first?.height as Any, "weight": self.myProfileInfo?.first?.weight as Any, "foodHabits": self.myProfileInfo?.first?.foodHabits as Any, "allergies": self.myProfileInfo?.first?.allergies as Any, "conditions": self.myProfileInfo?.first?.conditions as Any, "bodyShape": self.myProfileInfo?.first?.bodyShape as Any, "goals": self.myProfileInfo?.first?.goals as Any] as [String : Any]
        //                    pkgsArray["packages"] = self.packageIDArray;
        //
        //                Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
        //                })
        //                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
        //                    if error == nil {
        //                        self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
        //                        self.usdAmtLabel.text = "Thank you for subscribing to " + self.selectPlanLabel.text!;
        //
        //                        let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
        //
        //                        let msg = signature.html2String;
        //                        self.nutritionstDescLbl.text =
        //                        msg;
        //
        //
        //                    } else {
        //                        MBProgressHUD.hide(for: self.view, animated: true);
        //
        //                    }
        //                })
        //            }
        //        }, failureBlock: {(error : NSError!) -> (Void) in
        //            MBProgressHUD.hide(for: self.view, animated: true);
        //
        //            print("failure")
        //            if error?.code == -1011 {
        //                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your card was declined.");
        //            }
        //        })
        
    }
    typealias Razorpay = RazorpayCheckout
    var subscriptionID = ""
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    let realm :Realm = try! Realm();
    var myProfileInfo : Results<MyProfileInfo>?;
    var system = 0
     var razorpay: Razorpay!;
    var cardImgStr = "";
    var razorPayAPIKEY = ""
    @objc var price : String = ""
    var callInAppUrlConstant = ""
    @objc var lables = "pkgDisplayDescription";
    @objc var selectedIndex: Int = 0;
    @objc var labelPriceDict = [String: AnyObject]();
    @objc var paymentType : String = "";
    @objc var displayAmount : String = "";
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    @objc var priceInDouble : Double = 0.0

    @objc var pkgDuration : String = "";
    @objc var package : String = "";
    @objc var currency : String = "";
    @objc var nutritionLabelPriceArray = NSMutableArray();
    @objc var stripepayment = ""
    @objc var countryCode = ""
    @objc var packageID = "";
    @objc var packageTitle = ""
    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var nutritionstDescLbl: UILabel!
    @IBOutlet weak var paySucessView: UIView!
    @IBOutlet weak var usdAmtLabel: UILabel!
    @IBOutlet weak var selectPlanLabel: UILabel!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yyTF: UITextField!
    @IBOutlet weak var mmTF: UITextField!
    @IBOutlet weak var cardNumberTf: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardDetailsView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionLabelPriceArray.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cellDict = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
        let labels = (cellDict[lables] as? String)! + " ("
        let amount = "\(cellDict["display_amount"] as AnyObject as! Double)" + " "
        let currency = (cellDict["display_currency"] as? String)! + ")"
        let totalDesc: String = labels + amount + currency;
        cell.textLabel?.text = totalDesc
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(16);
        cell.textLabel?.numberOfLines = 0
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row;
        self.labelPriceDict  = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
        self.pkgDescription = "\(labelPriceDict["pkgDescription"] as AnyObject as! String)";
        self.pkgDuration = labelPriceDict["pkgDuration"] as AnyObject as! String;
        self.price = "\(labelPriceDict["transPayment"] as AnyObject as! Double)";
        self.priceInDouble = labelPriceDict["transPayment"] as AnyObject as! Double;

        self.currency = "\(labelPriceDict["currency"] as AnyObject as! String)";
        let labels =  (self.labelPriceDict[lables] as? String)! + " ("
        let amount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
        
        let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
        let totalDesc: String = labels + amount + currency;
        self.selectPlanLabel.text = totalDesc
         self.productIdentifier = self.labelPriceDict["productIdentifier"] as AnyObject as! String
        //self.tableView.isHidden = true;
       // self.navigationItem.hidesBackButton = true
        MBProgressHUD.showAdded(to: self.view, animated: true);
        //SKPaymentQueue.default().add(self)
//        if (SKPaymentQueue.canMakePayments()) {
//            let productID:NSSet = NSSet(array: [self.productIdentifier as String]);
//            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
//            productsRequest.delegate = self;
//            productsRequest.start();
//            print("Fetching Products");
//        } else {
//            print("can't make purchases");
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Please choose a subscription:"
        }
        return ""
    }
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
//    func receiptValidation() {
//        MBProgressHUD.showAdded(to: self.view, animated: true);
//
//        let receiptFileURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptFileURL!)
//        var jsonDict = [String: AnyObject]()
//        
//        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.packageID
//            , "amountPaid": self.priceInDouble, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
//        //91e841953e9f4d19976283cd2ee78992
//        
//        print(recieptString!)
//        //        UserDefaults.standard.set(receiptData, forKey: "RECEIPT")
//        //        UserDefaults.standard.synchronize()
//        //
//        
//       // MBProgressHUD.showAdded(to: self.view, animated: true);
//        APIWrapper.sharedInstance.postReceiptData(TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: jsonDict, success: { response in
//            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//            let responseResult = responseDic["callStatus"] as! String
//            if  responseResult == "GOOD" {
//                MBProgressHUD.hide(for: self.view, animated: true);
//                print("in-app done")
//                let labels =  (self.labelPriceDict[self.lables] as? String)! + " ("
//                let amount = "\(self.labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
//                
//                let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
//                let totalDesc: String = labels + amount + currency;
////                responseDic["priceDesc"] = totalDesc as AnyObject
////                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IN-APP-PURCHASE-SUCCESSFUL"), object: responseDic);
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
//                
//                let currentDate = Date();
//                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
//                let currentTime = Int64(currentTimeStamp);
//                var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfileInfo?.first?.msisdn as Any,"name": self.myProfileInfo?.first?.name as Any, "unread": false, "email": self.myProfileInfo?.first?.email as Any, "height": self.myProfileInfo?.first?.height as Any, "weight": self.myProfileInfo?.first?.weight as Any, "foodHabits": self.myProfileInfo?.first?.foodHabits as Any, "allergies": self.myProfileInfo?.first?.allergies as Any, "conditions": self.myProfileInfo?.first?.conditions as Any, "bodyShape": self.myProfileInfo?.first?.bodyShape as Any, "goals": self.myProfileInfo?.first?.goals as Any, "gender": self.myProfileInfo?.first?.gender as Any, "age": self.myProfileInfo?.first?.age as Any] as [String : Any]
//                pkgsArray["packages"] = [self.packageID];
//                
//                Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
//                })
//                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
//                    if error == nil {
//                        self.navigationItem.hidesBackButton = true;
//                        self.paySucessView.isHidden = false
//                        self.usdAmtLabel.text = "Thank you for subscribing to " + totalDesc;
//                        
//                        let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//                        
//                        let msg = signature.html2String;
//                        self.nutritionstDescLbl.text =
//                        msg;
//                        
//                        
//                    } else {
//                        MBProgressHUD.hide(for: self.view, animated: true);
//                        
//                    }
//                })
//            }
//        }, failure : { error in
//            MBProgressHUD.hide(for: self.view, animated: true);
//            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//            
//            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
//        })
//        
//        
//        //        do {
//        //            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//        //            let storeURL = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
//        //            var storeRequest = URLRequest(url: storeURL)
//        //            storeRequest.httpMethod = "POST"
//        //            storeRequest.httpBody = requestData
//        //
//        //            let session = URLSession(configuration: URLSessionConfiguration.default)
//        //            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
//        //
//        //                do {
//        //                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//        //                    print("=======>",jsonResponse)
//        //                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
//        //                        print(date)
//        //                    }
//        //                } catch let parseError {
//        //                    print(parseError)
//        //                }
//        //            })
//        //            task.resume()
//        //        } catch let parseError {
//        //            print(parseError)
//        //        }
//    }
    
    @IBAction func payTapped(_ sender: Any) {
//        if self.razorPayAPIKEY == "" {
//            if (self.cardNumberTf.text?.count == 0 || self.mmTF.text?.count == 0 || self.yyTF.text?.count == 0 || self.cvvTF.text?.count == 0) {
//                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please enter all the card details for payment.")
//                return
//            }
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            // Initiate the card
//            let stripCard = STPCardParams()
//            // Split the expiration date to extract Month & Year
//            if self.mmTF.text?.isEmpty == false && self.yyTF.text?.isEmpty == false {
//                //            let expirationDate = self.expireDateTextField.text.componentsSeparatedByString("/")
//                //            let expMonth = UInt(expirationDate[0].toInt()!)
//                //            let expYear = UInt(expirationDate[1].toInt()!)
//                
//                // Send the card info to Strip to get the token
//                stripCard.number = self.cardNumberTf.text
//                stripCard.cvc = self.cvvTF.text
//                stripCard.expMonth = UInt(mmTF.text!)!
//                stripCard.expYear = UInt(yyTF.text!)!
//                let validateStpCard = STPCardValidator.validationState(forCard: stripCard)
//                print(validateStpCard)
//                STPAPIClient.shared().createToken(withCard: stripCard, completion:  { (token, error) -> Void in
//                    
//                    if error != nil {
//                        MBProgressHUD.hide(for: self.view, animated: true);
//                        
//                        TweakAndEatUtils.AlertView.showAlert(view: self, message: (error?.localizedDescription)!)
//                        return
//                    }
//                    print(token!)
//                    //self.postStripeToken(token!)
//                    
//                    _ = "CONGRATULATIONS! on going Premium Member!";
//                    
//                    let dict: NSDictionary = [ "tokenId":
//                        token?.tokenId as AnyObject as! String,
//                                               "currency": self.currency  as AnyObject as! String,
//                                               "amountPaid": Double(self.price)!,
//                                               //Double.init(self.price as AnyObject as! String)!,
//                        "desc": self.pkgDescription  as AnyObject as! String,
//                        "pkgDuration": Int(self.pkgDuration)!, "system": self.system];
//                    
//                    APIWrapper.sharedInstance.postRequestWithHeaderMethod(self.stripepayment, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: dict as! [String : AnyObject], success: { response in
//                        print(response!)
//                        
//                        let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//                        let responseResult = responseDic["callStatus"] as! String;
//                        if  responseResult == "GOOD" {
//                            self.payBtn.isHidden = true; MBProgressHUD.hide(for: self.view, animated: true);
//                            
//                            //self.view.window!.rootViewController?.dismiss(animated: true)
//                            var data = [String: AnyObject]()
//                            let response = responseDic ;
//                            if response.index(forKey: "data") != nil {
//                                // contains key
//                                data = responseDic["data"] as AnyObject as! [String: AnyObject]
//                                
//                            } else if response.index(forKey: "Data") != nil {
//                                // contains key
//                                data = responseDic["Data"] as AnyObject as! [String: AnyObject]
//                                
//                            }
//                            
//                         //   let data = responseDic["data"] as AnyObject as! [String: AnyObject]
//                            if data["NutritionistFirebaseId"] is NSNull {
//                                UserDefaults.standard.setValue("", forKey: "NutritionistFirebaseId")
//                            } else {
//                                UserDefaults.standard.setValue(data["NutritionistFirebaseId"] as AnyObject as! String, forKey: "NutritionistFirebaseId")
//                            }
//                            
//                            if data["NutritionistFirstName"] is NSNull {
//                                UserDefaults.standard.setValue("", forKey: "NutritionistFirstName")
//                            } else {
//                                UserDefaults.standard.setValue(data["NutritionistFirstName"] as AnyObject as! String, forKey: "NutritionistFirstName")
//                            }
//                            if data["NutritionistSignature"] is NSNull {
//                                UserDefaults.standard.setValue("", forKey: "NutritionistSignature")
//                            } else {
//                                UserDefaults.standard.setValue(data["NutritionistSignature"] as AnyObject as! String, forKey: "NutritionistSignature")
//                            }
//                            
//                            let currentDate = Date();
//                            let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
//                            let currentTime = Int64(currentTimeStamp);
//                            var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfileInfo?.first?.msisdn as Any,"name": self.myProfileInfo?.first?.name as Any, "unread": false, "email": self.myProfileInfo?.first?.email as Any, "height": self.myProfileInfo?.first?.height as Any, "weight": self.myProfileInfo?.first?.weight as Any, "foodHabits": self.myProfileInfo?.first?.foodHabits as Any, "allergies": self.myProfileInfo?.first?.allergies as Any, "conditions": self.myProfileInfo?.first?.conditions as Any, "bodyShape": self.myProfileInfo?.first?.bodyShape as Any, "goals": self.myProfileInfo?.first?.goals as Any, "gender": self.myProfileInfo?.first?.gender as Any, "age": self.myProfileInfo?.first?.age as Any] as [String : Any]
//                            pkgsArray["packages"] = [self.packageID];
//                            
//                            Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
//                            })
//                            Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
//                                if error == nil {
//                                    self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
//                                    self.usdAmtLabel.text = "Thank you for subscribing to " + self.selectPlanLabel.text!;
//                                    
//                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//                                    
//                                    let msg = signature.html2String;
//                                    self.nutritionstDescLbl.text =
//                                    msg;
//                                    
//                                    
//                                } else {
//                                    MBProgressHUD.hide(for: self.view, animated: true);
//                                    
//                                }
//                            })
//                        }
//                    }, failure : { error in
//                        MBProgressHUD.hide(for: self.view, animated: true);
//                        
//                        print("failure")
//                        if error?.code == -1011 {
//                            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your card was declined.");
//                        }
//                    })
//                    
//                    //         } else {
//                    //            self.performSegue(withIdentifier: "questions", sender: self)
//                    //            }
//                    
//                })
//            }
//        } else {
//            self.razorpayStartSubInd()
//            //            self.razorpay = Razorpay.initWithKey(self.razorPayAPIKEY, andDelegate: self)
//            //            let amount = String(self.labelPriceDict["transPayment"] as AnyObject as! Int)
//            //          //  self.subscriptionID = dataDict["id"] as AnyObject as! String
//            //            let priceValue = (amount as NSString).integerValue
//            //            let razorpayPrice = priceValue * 100
//            //            let params: [String:Any] = [
//            //                "amount" : razorpayPrice,
//            //                /*"subscription_id": self.subscriptionID,*/
//            //                "description" : self.labelPriceDict["pkgDisplayDescription"] as AnyObject as! String,
//            //                "image" : "",
//            //                "name" : self.packageTitle,
//            //                "display_amount": String(self.labelPriceDict["display_amount"] as AnyObject as! Int).replacingOccurrences(of: ".0", with: ""),
//            //                "display_currency": self.displayCurrency,
//            //                "prefill" : [
//            //                    "name": self.myProfileInfo?.first?.name as AnyObject as! String,
//            //                    "contact" : self.myProfileInfo?.first?.msisdn as AnyObject as! String,
//            //                    "email" : self.myProfileInfo?.first?.email as AnyObject as! String
//            //                ],
//            //                "theme" : [
//            //                    "color" : "#800080"
//            //                    //"#F37254"
//            //                ]
//            //            ]
//            //            self.razorpay.open(params)
//        }
    }
    func razorpayStartSubInd(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let paramsDictionary = ["planId": (self.system == 0) ? self.labelPriceDict["plan_id_test"] as AnyObject as! String : self.labelPriceDict["plan_id_prod"] as AnyObject as! String,
                                "pkgId": self.packageID,
                                "totalCount": self.labelPriceDict["billing_cycles"] as AnyObject as! Int,
                                "pkgDesc": self.pkgDescription  as AnyObject as! String,
                                "pkgDuration": self.pkgDuration,
                                "system": self.system] as [String : Any]
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.RAZORPAY_START_SUB_IND, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response!)
            MBProgressHUD.hide(for: self.view, animated: true);
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                let dataDict = responseDic["data"] as! [String: AnyObject]
                self.razorpay = Razorpay.initWithKey(self.razorPayAPIKEY, andDelegate: self)
                let amount = String(self.labelPriceDict["transPayment"] as AnyObject as! Int)
                self.subscriptionID = dataDict["id"] as AnyObject as! String
                let priceValue = (amount as NSString).integerValue
                let razorpayPrice = priceValue * 100
                let params: [String:Any] = [
                    "amount" : razorpayPrice,
                    "subscription_id": self.subscriptionID,
                    "description" : self.labelPriceDict["pkgDisplayDescription"] as AnyObject as! String,
                    "image" : "",
                    "name" : self.packageTitle,
                    "display_amount": String(self.labelPriceDict["display_amount"] as AnyObject as! Int).replacingOccurrences(of: ".0", with: ""),
                    "display_currency": self.displayCurrency,
                    "prefill" : [
                        "name": self.myProfileInfo?.first?.name as AnyObject as! String,
                        "contact" : self.myProfileInfo?.first?.msisdn as AnyObject as! String,
                        "email" : self.myProfileInfo?.first?.email as AnyObject as! String
                    ],
                    "theme" : [
                        "color" : "#800080"
                        //"#F37254"
                    ]
                ]
                self.razorpay.open(params)
                
                
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    @IBAction func okAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myTweakandEatViewController : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        myTweakandEatViewController.packageID = self.packageID; self.navigationController?.pushViewController(myTweakandEatViewController, animated: true);
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if textField == cardNumberTf {
            return newLength <= 16
        } else if textField == mmTF {
            return newLength <= 2
        } else if textField == yyTF {
            return newLength <= 2
        } else if textField == cvvTF {
            return newLength <= 3
        }
        
        return newLength <= 0
    }
    
    
    @IBAction func dropDownTapped(_ sender: Any) {
        if self.tableView.isHidden == true {
            self.tableView.isHidden = false
        } else {
            self.tableView.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        self.title = "Purchase"
        self.payBtn.isHidden = true;
        //SKPaymentQueue.default().add(self)
   //     SKPaymentQueue.default().restoreCompletedTransactions();

        // postAction()
        // Do any additional setup after loading the view, typically from a nib.
        //        Database.database().reference().child("GlobalVariables").child("txt_unsub_message").observe(DataEventType.value, with: { (snapshot) in
        //            let imageUrl = snapshot.value as AnyObject as! String
        //            let url = URL(string: imageUrl);
        //            self.unSubscribeImageView.sd_setImage(with: url);
        //
        //
        //        })
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self);
        
        if self.razorPayAPIKEY != "" {
            self.hiddenView.isHidden = false
            //            //self.razorpayStartSubInd()
            //            self.razorpay = Razorpay.initWithKey(self.razorPayAPIKEY, andDelegate: self)
            //            let amount = String(self.labelPriceDict["transPayment"] as AnyObject as! Int)
            //            //  self.subscriptionID = dataDict["id"] as AnyObject as! String
            //            let priceValue = (amount as NSString).integerValue
            //            let razorpayPrice = priceValue * 100
            //            let params: [String:Any] = [
            //                "amount" : razorpayPrice,
            //                /*"subscription_id": self.subscriptionID,*/
            //                "description" : self.labelPriceDict["pkgDisplayDescription"] as AnyObject as! String,
            //                "image" : "",
            //                "name" : self.packageTitle,
            //                "display_amount": String(self.labelPriceDict["display_amount"] as AnyObject as! Int).replacingOccurrences(of: ".0", with: ""),
            //                "display_currency": self.displayCurrency,
            //                "prefill" : [
            //                    "name": self.myProfileInfo?.first?.name as AnyObject as! String,
            //                    "contact" : self.myProfileInfo?.first?.msisdn as AnyObject as! String,
            //                    "email" : self.myProfileInfo?.first?.email as AnyObject as! String
            //                ],
            //                "theme" : [
            //                    "color" : "#800080"
            //                    //"#F37254"
            //                ]
            //            ]
            //            self.razorpay.open(params)
            self.razorpayStartSubInd()
        } else {
            self.hiddenView.isHidden = true
        }
        self.selectPlanLabel.font = self.selectPlanLabel.font.withSize(14);
        self.selectPlanLabel.numberOfLines = 0
        
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
        if self.razorPayAPIKEY != "" {
            self.cardLbl.isHidden = true
            self.cardDetailsView.isHidden = true
        }
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        if countryCode == "1" || countryCode == "60" || countryCode == "65" || countryCode == "62" || countryCode == "91" {
            self.callInAppUrlConstant = TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE
        } 
        if countryCode == "1" {
            self.stripepayment = TweakAndEatURLConstants.STRIPE_PAYMENT_FOR_USA
        } else if countryCode == "60" {
            self.stripepayment = TweakAndEatURLConstants.STRIPE_PAYMENT_FOR_MYS
        }
        self.imageView.sd_setImage(with: URL(string: self.cardImgStr));
        self.cardNumberTf.delegate = self
        self.mmTF.delegate = self
        self.yyTF.delegate = self
        self.cvvTF.delegate = self
        self.paySucessView.isHidden = true
        
        //self.tableView.isHidden = true
        
        let labels =  (self.labelPriceDict[lables] as? String)! + " ("
        let amount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
        
        let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
        let totalDesc: String = labels + amount + currency;
        self.selectPlanLabel.text = totalDesc
        self.tableView.reloadData()
        
        
        
    }
    
}

