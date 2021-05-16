//
//  AvailablepremiumPackageObjViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 4/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase
import FlyshotSDK
//import StoreKit
import RNCryptor
import Branch
import FacebookCore
import CleverTapSDK


class PremiumPackages {
    @objc  var mppc_fb_id: String
    @objc  var pp_image_ba: String
    @objc  var mppc_img_banner_ios: String
    @objc  var mppc_name: String
    @objc  var isCellTapped: Bool
    @objc var isSelected = false
    
    init(mppc_fb_id: String, pp_image_ba: String, mppc_img_banner_ios: String, mppc_name: String, isCellTapped: Bool ) {
        self.mppc_fb_id = mppc_fb_id
        self.pp_image_ba = pp_image_ba
        self.mppc_img_banner_ios = mppc_img_banner_ios
        self.mppc_name = mppc_name
        self.isCellTapped = isCellTapped
    }
}
//extension AvailablePremiumPackagesViewController: FlyshotDelegate {
//   // This method will be invoked as a callback on In-App Purchase event made by Flyshot
//   // It will pass the same parameters as you would get from Apple StoreKit paymentQueue(_:updatedTransactions:) method
//   func flyshotPurchase(paymentQueue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//      // implement logic to process Flyshot IAP transactions
//      // normally you would check for transactionState and mark the product as purchased in your database store
//    for transaction:AnyObject in transactions {
//        if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//
//
//            switch trans.transactionState {
//            case .purchased:
//                print("Product Purchased")
//                //Do unlocking etc stuff here in case of new purchaseself.packageId == self.clubPackageSubscribed
//
//                let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
//                cellDictionary.isSelected = true
//                self.packageId = cellDictionary.mppc_fb_id
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    MBProgressHUD.showAdded(to: self.view, animated: true)
//
//
//                }
//                if self.packageId == self.clubPackageSubscribed {
//                    self.receiptValidation()
//                } else {
//                self.recptValidation()
//                }
//                print(trans.transactionIdentifier ?? "")
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//
//                 DispatchQueue.main.async {
//                MBProgressHUD.hide(for: self.view, animated: true);
//            }
//
//
//                SKPaymentQueue.default().remove(self)
//
//
//                break;
//            case .failed:
//
//                print("Purchased Failed");
//               // print(transaction)
//               // print(trans.error?.localizedDescription as Any)
//                DispatchQueue.main.async {
//
//
//                    MBProgressHUD.hide(for: self.view, animated: true);
//
//                }
//                let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
//                cellDictionary.isSelected = false
//                self.tableView.reloadData()
//                //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Purchase failed! Please try again!")
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                SKPaymentQueue.default().remove(self)
//
//                break;
//            case .restored:
//                print("Already Purchased")
//                //Do unlocking etc stuff here in case of restor
//                DispatchQueue.main.async {
//
//                MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                SKPaymentQueue.default().remove(self)
//
//            default:
//                // MBProgressHUD.hide(for: self.view, animated: true);
//
//                break;
//            }
//        }
//    }
//   }
//
//   // Flyshot will rely on this method before invoking any in-app purchase
//   func allowFlyshotPurchase(productIdentifier: String) -> Bool {
//      // implement logic to check if Flyshot should be allowed to show In-App Purchase alert for particular Product Identifier
//       return true
//   }
//
//   // This method will be invoked as a callback when Flyshot campaign was detected
//   func flyshotCampaignDetected(productId: String?) {
//      // Optional: implement custom logic here with productId related to current campaign
//   }
//}
class AvailablePremiumPackagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AvailablePackagesCellDelegate {
    
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
    
//    func buyProduct(product: SKProduct) {
//        if SKPaymentQueue.canMakePayments() {
//
//            print("Sending the Payment Request to Apple");
//            let payment = SKPayment(product: product)
//            self.productPrice = product.price
//            //   SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment);
//        }
//    }
    

    
//    func receiptValidation() {
//         DispatchQueue.main.async {
//        MBProgressHUD.showAdded(to: self.view, animated: true);
//        }
//
//        let receiptFileURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptFileURL!)
//        var jsonDict = [String: AnyObject]()
//
//        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.packageId
//            , "amountPaid": self.priceInDouble, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
//        //91e841953e9f4d19976283cd2ee78992
//
//        print(recieptString!)
//
//
//        APIWrapper.sharedInstance.postReceiptData(TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: jsonDict, success: { response in
//            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
//            var responseResult = ""
//            if responseDic.index(forKey: "callStatus") != nil {
//                responseResult = responseDic["callStatus"] as! String
//            } else if responseDic.index(forKey: "CallStatus") != nil {
//                responseResult = responseDic["CallStatus"] as! String
//            }
//            if  responseResult == "GOOD" {
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                print("in-app done")
//                      //AppsFlyerLib.shared().logEvent("af_purchase", withValues: [AFEventParamContentType: "CLUB Subscription", AFEventParamContentId: self.packageID, AFEventParamCurrency: self.currency])
////                if UserDefaults.standard.value(forKey: "msisdn") != nil {
////                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
////                    Branch.getInstance().setIdentity(msisdn)
////
////                }
//                if UserDefaults.standard.value(forKey: "msisdn") != nil {
//                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
//                    let data: NSData = msisdn.data(using: .utf8)! as NSData
//                    let password = "sFdebvQawU9uZJ"
//                    let cipherData = RNCryptor.encrypt(data: data as Data, withPassword: password)
//                    Branch.getInstance().setIdentity(cipherData.base64EncodedString())
//
//                }
//                AppEvents.logEvent(.purchased, parameters: ["packageID": self.packageId, "curency": self.currency])
//                let event = BranchEvent.customEvent(withName: "purchase")
//                event.eventDescription = "User completed payment."
//                event.customData["packageID"] = self.packageId
//                event.customData["currency"] = self.currency
//                event.logEvent()
//          self.clubPaymentSuccessView.isHidden = false
//                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TAECLUB-IN-APP-SUCCESSFUL"), object: responseDic);
//
//            }
//        }, failure : { error in
//            self.navigationItem.hidesBackButton = false
//             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//
//            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
//        })
//
//
//
//    }
    
//    func recptValidation() {
//        DispatchQueue.main.async {
//            MBProgressHUD.showAdded(to: self.view, animated: true);
//
//        }
//
//       var url = ""
//        var jsonDict = [String: AnyObject]()
//        if self.packageId == self.ptpPackage || self.packageId == "-MysRamadanwgtLoss99" {
//            let currentDate = Date();
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "YYYMMddHHmmss"
//            let strDate = dateFormatter.string(from: currentDate)
//            let msisdn = self.myProfile?.first?.msisdn as AnyObject as! String
//            let paymentID = "\(msisdn)_" + strDate
//          url = TweakAndEatURLConstants.AIBP_REGISTRATION
//            jsonDict = ["paymentId" : paymentID as AnyObject, "packageId":  self.packageId, "amountPaid": self.price, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration, "packageRecurring": 0 as AnyObject] as [String : AnyObject]
//        } else {
//
//            url = TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE
//            let receiptFileURL = Bundle.main.appStoreReceiptURL
//            let receiptData = try? Data(contentsOf: receiptFileURL!)
//            let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//             jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.packageId, "amountPaid": self.price, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
//        }
//
//
//        print(jsonDict)
//
//        //91e841953e9f4d19976283cd2ee78992
//
//        //print(recieptString!)
//        //        UserDefaults.standard.set(receiptData, forKey: "RECEIPT")
//        //        UserDefaults.standard.synchronize()
//        //
//
//      //  MBProgressHUD.showAdded(to: self.view, animated: true);
//        APIWrapper.sharedInstance.postReceiptData(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: jsonDict, success: { response in
//            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
//            var responseResult = ""
//
//            if responseDic.index(forKey: "callStatus") != nil {
//                responseResult = responseDic["callStatus"] as! String
//            } else if responseDic.index(forKey: "CallStatus") != nil {
//                responseResult = responseDic["CallStatus"] as! String
//            }
//            if  responseResult == "GOOD" {
//                //IndIWj1mSzQ1GDlBpUt
//                 //AppsFlyerLib.shared().logEvent("af_purchase", withValues: [AFEventParamContentType: self.packageName, AFEventParamContentId: self.packageId, AFEventParamCurrency: self.currency])
////                if UserDefaults.standard.value(forKey: "msisdn") != nil {
////                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
////                    Branch.getInstance().setIdentity(msisdn)
////
////                }
//                if UserDefaults.standard.value(forKey: "msisdn") != nil {
//                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
//                    let data: NSData = msisdn.data(using: .utf8)! as NSData
//                    let password = "sFdebvQawU9uZJ"
//                    let cipherData = RNCryptor.encrypt(data: data as Data, withPassword: password)
//                    Branch.getInstance().setIdentity(cipherData.base64EncodedString())
//
//                }
//                AppEvents.logEvent(.purchased, parameters: ["packageID": self.packageId, "curency": self.currency])
//
//                let event = BranchEvent.customEvent(withName: "purchase")
//                event.eventDescription = "User completed payment."
//                event.customData["packageID"] = self.packageId
//                event.customData["currency"] = self.currency
//                event.logEvent()
//                 DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                print("in-app done")
//                let labels =  (self.labelPriceDict[self.lables] as? String)! + " ("
//                let amount = "\(self.labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
//
//                let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
//                let totalDesc: String = labels + amount + currency;
//                var data = [String: AnyObject]()
//
//                let priceDesc = totalDesc
//                if responseDic.index(forKey: "data") != nil {
//                    // contains key
//                    data = responseDic["data"] as AnyObject as! [String: AnyObject]
//
//                } else if responseDic.index(forKey: "Data") != nil {
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
//                var pkgesArr = NSMutableArray()
//
//                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                    if snapshot.childrenCount > 0 {
//                        let dispatch_group = DispatchGroup();
//                        dispatch_group.enter();
//
//                        let snpShotDict = snapshot.value as AnyObject as! [String: AnyObject]
//                        if snpShotDict.index(forKey: "packages") != nil {
//                            pkgesArr = snpShotDict["packages"] as AnyObject as! NSMutableArray
//
//                        }
//                        let currentDate = Date();
//                        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
//                        let currentTime = Int64(currentTimeStamp);
//
//                        var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfile?.first?.msisdn as Any,"name": self.myProfile?.first?.name as Any, "unread": false, "email": self.myProfile?.first?.email as Any, "height": self.myProfile?.first?.height as Any, "weight": self.myProfile?.first?.weight as Any, "foodHabits": self.myProfile?.first?.foodHabits as Any, "allergies": self.myProfile?.first?.allergies as Any, "conditions": self.myProfile?.first?.conditions as Any, "bodyShape": self.myProfile?.first?.bodyShape as Any, "goals": self.myProfile?.first?.goals as Any, "gender": self.myProfile?.first?.gender as Any, "age": self.myProfile?.first?.age as Any] as [String : Any]
//                        if pkgesArr.count > 0 {
//                            pkgesArr.remove(self.packageId)
//                            pkgesArr.add(self.packageId)
//                            pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
//
//                        } else {
//                            pkgsArray["packages"] = [self.packageId];
//                        }
//
//                        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
//
//                        })
//                        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
//                            if error == nil {
//                                //      if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
//                                if self.packageId == self.ptpPackage || self.packageId == "-AiDPwdvop1HU7fj8vfL" {
//                                    var url = ""
//                                    if self.packageId == self.ptpPackage {
//                                        url = TweakAndEatURLConstants.ALL_AiBP_CONTENT
//                                    } else if self.packageId == "-AiDPwdvop1HU7fj8vfL" {
//                                        url = TweakAndEatURLConstants.IND_AiDP_CONTENT
//                                    }
//                                        APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
//                                        let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//                                            var responseResult = ""
//
//                                            if responseDic.index(forKey: "callStatus") != nil {
//                                                responseResult = responseDic["callStatus"] as! String
//                                            } else if responseDic.index(forKey: "CallStatus") != nil {
//                                                responseResult = responseDic["CallStatus"] as! String
//                                            }
//                                        if  responseResult == "GOOD" {
//                                             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                       //     self.navigationItem.hidesBackButton = true;
//                                            //self.backBtn.isHidden = true
//                                            self.paySucessView.isHidden = false
//                                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                            let msg = signature.html2String;
//                                            self.nutritionstDescLbl.text =
//                                            msg;
//
//                                        } else{
//                                             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                        }
//                                    }, failure : { error in
//                                        //  print(error?.description)
//                                        //            self.getQuestionsFromFB()
//                                         DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
//
//                                    })
//
//                                } else {
//                                   // self.navigationItem.hidesBackButton = true;
//                                  //  self.backBtn.isHidden = true
//                                    self.paySucessView.isHidden = false
//                                    self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                    let msg = signature.html2String;
//                                    self.nutritionstDescLbl.text =
//                                    msg;
//                                }
//                                 DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//
//
//                            } else {
//                                 DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//
//                            }
//                        })
//                        dispatch_group.leave();
//                        dispatch_group.notify(queue: DispatchQueue.main) {
//                            // MBProgressHUD.hide(for: self.view, animated: true);
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PREMIUM_PACK_IN-APP-SUCCESSFUL"), object: nil);
//                        }
//                    } else {
//                        let dispatch_group = DispatchGroup();
//                        dispatch_group.enter();
//                        let currentDate = Date();
//                        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
//                        let currentTime = Int64(currentTimeStamp);
//
//                        var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfile?.first?.msisdn as Any,"name": self.myProfile?.first?.name as Any, "unread": false, "email": self.myProfile?.first?.email as Any, "height": self.myProfile?.first?.height as Any, "weight": self.myProfile?.first?.weight as Any, "foodHabits": self.myProfile?.first?.foodHabits as Any, "allergies": self.myProfile?.first?.allergies as Any, "conditions": self.myProfile?.first?.conditions as Any, "bodyShape": self.myProfile?.first?.bodyShape as Any, "goals": self.myProfile?.first?.goals as Any, "gender": self.myProfile?.first?.gender as Any, "age": self.myProfile?.first?.age as Any] as [String : Any]
//                        if pkgesArr.count > 0 {
//                            pkgesArr.remove(self.packageId)
//                            pkgesArr.add(self.packageId)
//                            pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
//
//                        } else {
//                            pkgsArray["packages"] = [self.packageId];
//                        }
//
//                        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
//
//                        })
//                        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
//                            if error == nil {
//                                //      if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
//                                if self.packageId == self.ptpPackage || self.packageId == "-AiDPwdvop1HU7fj8vfL" {
//                                    var url = ""
//                                    if self.packageId == self.ptpPackage {
//                                        url = TweakAndEatURLConstants.ALL_AiBP_CONTENT
//                                    } else if self.packageId == "-AiDPwdvop1HU7fj8vfL" {
//                                        url = TweakAndEatURLConstants.IND_AiDP_CONTENT
//                                    }
//                                    APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
//                                        let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//                                        var responseResult = ""
//
//                                        if responseDic.index(forKey: "callStatus") != nil {
//                                            responseResult = responseDic["callStatus"] as! String
//                                        } else if responseDic.index(forKey: "CallStatus") != nil {
//                                            responseResult = responseDic["CallStatus"] as! String
//                                        }
//                                        if  responseResult == "GOOD" {
//                                             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                        //    self.navigationItem.hidesBackButton = true;
//                                           // self.backBtn.isHidden = true
//                                            self.paySucessView.isHidden = false
//                                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                            let msg = signature.html2String;
//                                            self.nutritionstDescLbl.text =
//                                            msg;
//
//                                        } else{
//                                             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                        }
//                                    }, failure : { error in
//                                        //  print(error?.description)
//                                        //            self.getQuestionsFromFB()
//                                         DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
//
//                                    })
//
//                                } else {
//                                //self.navigationItem.hidesBackButton = true;
//                                   // self.backBtn.isHidden = true
//                                self.paySucessView.isHidden = false
//                                self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                let msg = signature.html2String;
//                                self.nutritionstDescLbl.text =
//                                msg;
//                                }
//                                 DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//
//
//                            } else {
//                                 DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//
//                            }
//                        })
//                        dispatch_group.leave();
//                        dispatch_group.notify(queue: DispatchQueue.main) {
//                            // MBProgressHUD.hide(for: self.view, animated: true);
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PREMIUM_PACK_IN-APP-SUCCESSFUL"), object: nil);
//                        }
//                    }
//                })
//
//
//            }
//        }, failure : { error in
//             DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//            if error!.code == -1011 {
//                self.navigationController?.popViewController(animated: true)
//                return
//            }
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
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        for transaction:AnyObject in transactions {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//
//
//                switch trans.transactionState {
//                case .purchased:
//                    print("Product Purchased")
//                    //Do unlocking etc stuff here in case of new purchaseself.packageId == self.clubPackageSubscribed
//                    if self.packageId == self.clubPackageSubscribed {
//                        self.receiptValidation()
//                    } else {
//                    self.recptValidation()
//                    }
//                    print(trans.transactionIdentifier ?? "")
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//
//                     DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                }
//                    let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
//                    cellDictionary.isSelected = false
//                    self.tableView.reloadData()
//
//
//                    SKPaymentQueue.default().remove(self)
//
//
//                    break;
//                case .failed:
//
//                    print("Purchased Failed");
//                   // print(transaction)
//                   // print(trans.error?.localizedDescription as Any)
//                    DispatchQueue.main.async {
//
//
//                        MBProgressHUD.hide(for: self.view, animated: true);
//
//                    }
//                    let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
//                    cellDictionary.isSelected = false
//                    self.tableView.reloadData()
//                    //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Purchase failed! Please try again!")
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    SKPaymentQueue.default().remove(self)
//
//                    break;
//                case .restored:
//                    print("Already Purchased")
//                    //Do unlocking etc stuff here in case of restor
//                    DispatchQueue.main.async {
//
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    }
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    SKPaymentQueue.default().remove(self)
//
//                default:
//                    // MBProgressHUD.hide(for: self.view, animated: true);
//
//                    break;
//                }
//            }
//        }
//    }
    
    func infoBtnTapped(_ cell: AvailablePackagesCell2) {
        
    }
    
    func uploadReferralCodeBtnTapped(_ cell: AvailablePackagesCell2) {
       

        Flyshot.shared.upload(onSuccess: { (status) in
            print(status)
            if status == .found {
                print("yes")
                self.myIndex = cell.cellIndexPath
                self.selectedIndex = self.myIndex

            } else if status == .notFound {
                print("not found")
                DispatchQueue.main.async {
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose the right image and try again!")

                }
            } else if status == .redeemed {
                print("redeemed")
                DispatchQueue.main.async {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "The referral code is already redeemed!")
                }
            } else {

            }
           // status enum:
           //   notFound (notify the user that no active promos were found)
           //   found (close the Promo Banner if "status == .found")
           //   redeemed (notify the user that campaign was already redeemed)
        }, onFailure: { (error) in
           // Handle error
            DispatchQueue.main.async {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection and try again later!")
            }

        })
    }
    
    func selectBtnTapped(_ cell: AvailablePackagesCell2) {
        self.myIndex = cell.cellIndexPath
        self.selectedIndex = self.myIndex
        let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
        self.packageId = cellDictionary.mppc_fb_id
        cellDictionary.isSelected = true
        self.tableView.reloadData()

        if  countryCode == "91" {
           // labelsPrice = "pkgRecurPrice"
         
            if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                //self.imgPopup = "imgClubPopup"
                self.labelsPrice = "pkgRecurClubPrice"
            } else {
                labelsPrice = "pkgRecurPrice"

            }
           // self.featuresView.isHidden = false
            //self.getPackageDetails()
            
        } else {
            if self.packageId == self.clubPackageSubscribed {
                labelsPrice = "pkgRecurPrice"

            } else {
            labelsPrice = "pkgPrice"
            }
        }
        self.moveToAnotherView(link: cellDictionary.mppc_fb_id)
    }
    
    @objc func packagLabelSelections(pkg: String) {
        if self.nutritionLabelPackagesArray.count > 0 {
            
            let nutritionLabelDict = nutritionLabelPackagesArray[0] as! [String : AnyObject];
            print(nutritionLabelDict);
            let packagePriceArray = nutritionLabelDict["packagePrice"] as! NSMutableArray;
            for pckgPrice in packagePriceArray {
                let packagePriceDict = pckgPrice as! [String : AnyObject];
                if packagePriceDict["countryCode"] as AnyObject as! String == self.countryCode {
                    if (packagePriceDict.index(forKey: labelsPrice) != nil) {
                        self.nutritionLabelPriceArray = NSMutableArray()
                        for dict  in packagePriceDict[labelsPrice] as! NSMutableArray {
                            let priceDict = dict as! [String : AnyObject];
                            if priceDict["isActive"] as! Bool == true {
                            self.nutritionLabelPriceArray.add(priceDict);
                            }
                        }
                    }
                }
                
            }
          


            DispatchQueue.main.async {
                
                if self.nutritionLabelPriceArray.count > 0 {
                    for dict in self.nutritionLabelPriceArray {
                        let recurPriceDict = dict as! [String: AnyObject]
                        self.startPurchase(identifier: recurPriceDict["productIdentifier"] as! String, dict: recurPriceDict)
                    }
                }
                


        }
            
        }
    }
    
    func startPurchase(identifier: String, dict: [String : AnyObject]) {

        DispatchQueue.global().async() { [self] in

        self.labelPriceDict  = dict;
            self.pkgDescription = "\(self.labelPriceDict["pkgDescription"] as AnyObject as! String)";
            self.pkgDuration = self.labelPriceDict["pkgDuration"] as AnyObject as! String;
            self.price = "\(self.labelPriceDict["transPayment"] as AnyObject as! Double)";
            self.priceInDouble = self.labelPriceDict["transPayment"] as AnyObject as! Double;
            self.currency = "\(self.labelPriceDict["currency"] as AnyObject as! String)";
            let labels =  (self.labelPriceDict[self.lables] as? String)! + " ("
            let amount = "\(self.labelPriceDict["display_amount"] as AnyObject as! Double)" + " "

                           let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
                           let totalDesc: String = labels + amount + currency;

            self.packageName = (self.labelPriceDict[self.lables] as? String)!

                           self.productIdentifier = identifier


//                                  if (SKPaymentQueue.canMakePayments()) {
//                                     // self.buyNowButton.isEnabled = false
//                                      let productID:NSSet = NSSet(array: [self.productIdentifier as String]);
//                                      let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
//                                      productsRequest.delegate = self;
//                                      productsRequest.start();
//                                      print("Fetching Products");
//                                  } else {
//                                      print("can't make purchases");
//                                  }
            DispatchQueue.main.async {
              //  MBProgressHUD.showAdded(to: self.view, animated: true);

            }

        }
    }
    
    func moveToAnotherView(link: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var packageObj = [String : AnyObject]();
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {

                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == link {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        self.nutritionLabelPackagesArray.add(packageObj);

                        self.packagLabelSelections(pkg: link);

                    }

                }

                dispatch_group.leave();

                dispatch_group.notify(queue: DispatchQueue.main) {
                    //MBProgressHUD.hide(for: self.view, animated: true);
                    
                    //self.performSegue(withIdentifier: "fromAdsToMore", sender: packageObj)
                }
            }
        })
    }
    var productPrice: NSDecimalNumber = NSDecimalNumber()

    @objc var nutritionLabelPriceArray = NSMutableArray();
    @objc var nutritionLabelPackagesArray = NSMutableArray();
    var labelsPrice = "pkgPrice"
    @IBOutlet weak  var paySucessView: UIView!
    @IBOutlet weak  var usdAmtLabel: UILabel!
    @IBOutlet weak  var nutritionstDescLbl: UILabel!
    @IBOutlet weak var askSiaButton: UIButton!
    var identifierFromPopUp = ""
    var clubPackageSubscribed = ""
    var packageId = ""
    @IBOutlet weak var clubPaymentSuccessView: UIView!

    func cellTappedOnHowToSubscribeVideo(_ cell: AvailablePremiumPackagesTableViewCell) {
        
        self.myIndex = cell.cellIndexPath
        let cellDictionary = self.premiumPackagesApiArray[self.myIndex]
       
        Database.database().reference().child("GlobalVariables").child("subVideos").child(cellDictionary.mppc_fb_id).observe(DataEventType.value, with: { (snapshot) in
            let videoUrl = snapshot.value as AnyObject as! String
            if  let url = URL(string: videoUrl) {
            UIApplication.shared.open(url)
            }

        })
        
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        var data = [String: AnyObject]()
        
        let response = notification.object as! [String: AnyObject];
        let priceDesc = response["priceDesc"] as AnyObject as! String
        if response.index(forKey: "data") != nil {
            // contains key
            data = response["data"] as AnyObject as! [String: AnyObject]
            
        } else if response.index(forKey: "Data") != nil {
            // contains key
            data = response["Data"] as AnyObject as! [String: AnyObject]
            
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
        var pkgesArr = NSMutableArray()
        self.packageID = UserDefaults.standard.value(forKey: "SELECTED_PACKAGE") as! String

        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();

                let snpShotDict = snapshot.value as AnyObject as! [String: AnyObject]
                if snpShotDict.index(forKey: "packages") != nil {
                    pkgesArr = snpShotDict["packages"] as AnyObject as! NSMutableArray
                    
                }
                let currentDate = Date();
                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                let currentTime = Int64(currentTimeStamp);
                
                var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfile?.first?.msisdn as Any,"name": self.myProfile?.first?.name as Any, "unread": false, "email": self.myProfile?.first?.email as Any, "height": self.myProfile?.first?.height as Any, "weight": self.myProfile?.first?.weight as Any, "foodHabits": self.myProfile?.first?.foodHabits as Any, "allergies": self.myProfile?.first?.allergies as Any, "conditions": self.myProfile?.first?.conditions as Any, "bodyShape": self.myProfile?.first?.bodyShape as Any, "goals": self.myProfile?.first?.goals as Any, "gender": self.myProfile?.first?.gender as Any, "age": self.myProfile?.first?.age as Any] as [String : Any]
                if pkgesArr.count > 0 {
                    pkgesArr.remove(self.packageID)
                    pkgesArr.add(self.packageID)
                    pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
                    
                } else {
                    pkgsArray["packages"] = [self.packageID];
                }
                
                Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
                    
                })
                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                     //   if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                            self.navigationItem.hidesBackButton = true;
                            self.paySucessView.isHidden = false
                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                            
                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                            
                            let msg = signature.html2String;
                            self.nutritionstDescLbl.text =
                            msg;
                     //   }
//                        else if self.packageID == "-AiDPwdvop1HU7fj8vfL"{
//                            APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(TweakAndEatURLConstants.IND_AiDP_CONTENT, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
//                                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//                                let responseResult = responseDic["CallStatus"] as! String
//                                if  responseResult == "GOOD" {
//                                    self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
//                                    self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                    let msg = signature.html2String;
//                                    self.nutritionstDescLbl.text =
//                                    msg;
//                                } else{
//
//                                }
//                            }, failure : { error in
//                                //  print(error?.description)
//                                //            self.getQuestionsFromFB()
//                                MBProgressHUD.hide(for: self.view, animated: true);
//                                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
//
//                            })
//                        }
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                    }
                })
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    // MBProgressHUD.hide(for: self.view, animated: true);
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PREMIUM_PACK_IN-APP-SUCCESSFUL"), object: nil);
                }
            } else {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                let currentDate = Date();
                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                let currentTime = Int64(currentTimeStamp);
                
                var pkgsArray = [ "lastUpdatedOn": currentTime!, "msisdn": self.myProfile?.first?.msisdn as Any,"name": self.myProfile?.first?.name as Any, "unread": false, "email": self.myProfile?.first?.email as Any, "height": self.myProfile?.first?.height as Any, "weight": self.myProfile?.first?.weight as Any, "foodHabits": self.myProfile?.first?.foodHabits as Any, "allergies": self.myProfile?.first?.allergies as Any, "conditions": self.myProfile?.first?.conditions as Any, "bodyShape": self.myProfile?.first?.bodyShape as Any, "goals": self.myProfile?.first?.goals as Any, "gender": self.myProfile?.first?.gender as Any, "age": self.myProfile?.first?.age as Any] as [String : Any]
                if pkgesArr.count > 0 {
                    pkgesArr.remove(self.packageID)
                    pkgesArr.add(self.packageID)
                    pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
                    
                } else {
                    pkgsArray["packages"] = [self.packageID];
                }
                
                Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageID).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
                    
                })
                Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                  //      if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                            self.navigationItem.hidesBackButton = true;
                            self.paySucessView.isHidden = false
                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                            
                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                            
                            let msg = signature.html2String;
                            self.nutritionstDescLbl.text =
                            msg;
                    //    }
//                        else if self.packageID == "-AiDPwdvop1HU7fj8vfL"{
//                            APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(TweakAndEatURLConstants.IND_AiDP_CONTENT, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
//                                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//                                let responseResult = responseDic["CallStatus"] as! String
//                                if  responseResult == "GOOD" {
//                                    self.navigationItem.hidesBackButton = true; self.paySucessView.isHidden = false
//                                    self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
//
//                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
//
//                                    let msg = signature.html2String;
//                                    self.nutritionstDescLbl.text =
//                                    msg;
//                                } else{
//
//                                }
//                            }, failure : { error in
//                                //  print(error?.description)
//                                //            self.getQuestionsFromFB()
//                                MBProgressHUD.hide(for: self.view, animated: true);
//                                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
//
//                            })
//                        }
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                    }
                })
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    // MBProgressHUD.hide(for: self.view, animated: true);
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PREMIUM_PACK_IN-APP-SUCCESSFUL"), object: nil);
                }
            }
        })

      //  self.receiptValidation()
    }
    
    func goToTAEClubMemPage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
       self.navigationController?.pushViewController(clickViewController!, animated: true)
         
      }
    
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
     self.navigationController?.pushViewController(clickViewController!, animated: true)
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    func goToTAEClub() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    func cellTappedOnImage(_ cell: AvailablePremiumPackagesTableViewCell, sender: UITapGestureRecognizer) {
        self.myIndexPath = cell.myIndexPath;
        var selectedRowIndex = cell.myIndexPath
        currentRow = selectedRowIndex!.row
//        if self.premiumPackagesApiArray[currentRow].mppc_fb_id == self.ptpPackage {
//            if UserDefaults.standard.value(forKey: self.ptpPackage) != nil {
//                self.performSegue(withIdentifier: "nutritionAnalytics", sender: self)
//            } else {
//                self.performSegue(withIdentifier: "premiumTweakPack", sender: self)
//            }
//            return
//        }

//        var count = 0
//        if self.premiumPackagesApiArray[currentRow].mppc_fb_id != "-Qis3atRaproTlpr4zIs"  && self.premiumPackagesApiArray[currentRow].mppc_fb_id != self.ptpPackage {
//
//        for cellDict in self.premiumPackagesApiArray {
//
//            if count != self.currentRow {
//                cellDict.isCellTapped = false
//            self.premiumPackagesApiArray[count] = cellDict
//            }
//            count += 1
//        }
//        }
        let cellDictionary = self.premiumPackagesApiArray[currentRow]

//        if cellDictionary.isCellTapped == false {
//        cellDictionary.isCellTapped = true
//        } else {
//             cellDictionary.isCellTapped = false
//        }
//        self.premiumPackagesApiArray[self.currentRow] = cellDictionary
        let packageID = cellDictionary.mppc_fb_id;
        self.packageID = cellDictionary.mppc_fb_id;
        print(packageID);


        UserDefaults.standard.set(packageID, forKey: "SELECTED_PACKAGE");
//        if cellDictionary.mppc_name.contains("Tweak & Eat Club") {
//            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
//               self.goToTAEClubMemPage()
//             } else {
//                 self.goToTAEClub()
//             }
//        } else {
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            self.premiumPackagesArray = NSMutableArray()
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {

                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    let packageObj = premiumPackages.value as? [String : AnyObject];
                    if premiumPackages.key == packageID {
                        self.premiumPackagesArray.add(packageObj!);
                    }

                }

                dispatch_group.leave();

                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if self.premiumPackagesArray.count > 0 {
                        if self.fromCrown == true {
                            if (cellDictionary.mppc_fb_id == "-TacvBsX4yDrtgbl6YOQ") {
                                self.performSegue(withIdentifier: "purchasedPackages", sender: self);
                            } else if (cellDictionary.mppc_fb_id == "-KyotHu4rPoL3YOsVxUu"){
                                self.performSegue(withIdentifier: "purchasedPackages", sender: self);

                            } else if (cellDictionary.mppc_fb_id == "-SquhLfL5nAsrhdq7GCY") {
                                self.performSegue(withIdentifier: "AiDP", sender: self);

                            } else  if (cellDictionary.mppc_fb_id == "-IndIWj1mSzQ1GDlBpUt") {
                                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }


                            } else  if (cellDictionary.mppc_fb_id == "-ClubInd4tUPXHgVj9w3") {
                                if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }


                            } else  if (cellDictionary.mppc_fb_id == "-ClubUsa5nDa1M8WcRA6") {
                                if UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubUsa5nDa1M8WcRA6");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }


                            } else  if (cellDictionary.mppc_fb_id == "-IndWLIntusoe3uelxER") {
                                                            if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                                                                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");

                                                            } else  {
                                                                self.performSegue(withIdentifier: "moreInfo", sender: self);
                                                            }


                        } else  if (cellDictionary.mppc_fb_id == "-AiDPwdvop1HU7fj8vfL") {
                                if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);

                                }
                            }

                        } else {
                            if self.pkgIdsArray.count > 0 {
                                let pkgsID = cellDictionary.mppc_fb_id
                                if self.pkgIdsArray.contains(pkgsID) {
                                    if pkgsID == "-KyotHu4rPoL3YOsVxUu" {
                                        self.performSegue(withIdentifier: "purchasedPackages", sender: self);
                                        return
                                    }
                                    if pkgsID == "-SquhLfL5nAsrhdq7GCY" {
                                        self.performSegue(withIdentifier: "AiDP", sender: self);
                                        return
                                    }
                                    if pkgsID == "-TacvBsX4yDrtgbl6YOQ" {
                                        self.performSegue(withIdentifier: "purchasedPackages", sender: self);
                                        return
                                    }
                                    if pkgsID == "-IndIWj1mSzQ1GDlBpUt" {
                                        if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                                            self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");

                                        } else  {
                                            self.performSegue(withIdentifier: "moreInfo", sender: self);

                                        }
                                        return
                                    }//IndWLIntusoe3uelxER
                                    if pkgsID == "-IndWLIntusoe3uelxER" {
                                        if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                                            self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");

                                        } else  {
                                            self.performSegue(withIdentifier: "moreInfo", sender: self);

                                        }
                                        return
                                    }
                                    if pkgsID == "-AiDPwdvop1HU7fj8vfL" {
                                        if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                                            self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");

                                        } else  {
                                            self.performSegue(withIdentifier: "moreInfo", sender: self);

                                        }
                                        return
                                    }
                                    if (pkgsID == "-Qis3atRaproTlpr4zIs") {
                                        self.performSegue(withIdentifier: "nutritionPack", sender: self);

                                    }
                                }
                            }
//IndWLIntusoe3uelxER
                            if (cellDictionary.mppc_fb_id == "-IndIWj1mSzQ1GDlBpUt") {

                                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);

                                }
                                return

                            } else  if (cellDictionary.mppc_fb_id == "-ClubInd4tUPXHgVj9w3") {
                                if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else  if (cellDictionary.mppc_fb_id == "-ClubUsa5nDa1M8WcRA6") {
                                if UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubUsa5nDa1M8WcRA6");

                                } else  {
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == self.clubPackageSubscribed) {
                                if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil  {
                                   self.goToTAEClubMemPage()
                                    return
                                 } else {
                                    // self.goToTAEClub()
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
return
                                 }
                            } else if (cellDictionary.mppc_fb_id == "-NcInd5BosUcUeeQ9Q32") {
                                if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil  {
                                    self.goToNutritonConsultantScreen(packageID: cellDictionary.mppc_fb_id)
                                    return
                                 } else {
                                    // self.goToTAEClub()
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
return
                                 }
                            } else  if (cellDictionary.mppc_fb_id == "-IndWLIntusoe3uelxER") {

                                                           if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                                                               self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");

                                                           } else  {
                                                               self.performSegue(withIdentifier: "moreInfo", sender: self);

                                                           }
                                                           return

                            } else if (cellDictionary.mppc_fb_id == "-AiDPwdvop1HU7fj8vfL") {

                                if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == "-IdnMyAiDPoP9DFGkbas") {

                                if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IdnMyAiDPoP9DFGkbas");

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == "-MysRamadanwgtLoss99") {

                                if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                                self.performSegue(withIdentifier: "myTweakAndEat", sender: "-MysRamadanwgtLoss99");

                                } else  {

                              self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                            return


                            } else if (cellDictionary.mppc_fb_id == "-SgnMyAiDPuD8WVCipga") {

                                if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-SgnMyAiDPuD8WVCipga");

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == "-MalAXk7gLyR3BNMusfi") {
                                
                                if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-MalAXk7gLyR3BNMusfi");

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == "-MzqlVh6nXsZ2TCdAbOp") {

                                if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-MzqlVh6nXsZ2TCdAbOp");

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return


                            } else if (cellDictionary.mppc_fb_id == self.ptpPackage) {
                                
                                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: self.ptpPackage);
                                    
                                } else  {
                                    
                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                                return
                                
                                
                            } else if ((cellDictionary.mppc_fb_id == "-TacvBsX4yDrtgbl6YOQ") || (cellDictionary.mppc_fb_id == "-Qis3atRaproTlpr4zIs")) {

                                self.performSegue(withIdentifier: "nutritionPack", sender: self);
                                return

                            }
                            self.performSegue(withIdentifier: "moreInfo", sender: self);

                        }
                    }
                }
            }
        })
        
    }
    

    var selectedIndex = 0
    @objc var labelPriceDict = [String: AnyObject]();
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    @objc var currency : String = ""
    @objc var priceInDouble : Double = 0.0
    var productIdentifier = ""
    var myProfile : Results<MyProfileInfo>?;
    @objc var myIndex : Int = 0;
    @objc var packageID = ""
    @objc var fromHomePopups = false
    @objc var packageIDArray = NSMutableArray();
    @objc var myIndexPath : IndexPath = [];
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    var ptpPackage = ""
    var indTAE = 0
    var indMyAidp = 0
    @objc var price : String = ""
    var lables = "pkgDisplayDescription"
    var packageName = ""
    @IBOutlet weak var headerView: UIView!;
    @objc var pkgDuration : String = "";
    @objc var premiumPackagesRef : DatabaseReference!;
    @objc var nonPremiumPackagesRef : DatabaseReference!;
    var premiumPackageResults : Results<PremiumPackageDetails>?;
    var premiumPackagesApiArray = [PremiumPackages]();
    @objc var premiumPackagesArray = NSMutableArray();
    
    let realm :Realm = try! Realm();
    @objc var expandedRows = Set<Int>();
    @objc var fromCrown = false;
    @objc var selectedRowIndex = -1;
    @IBOutlet weak var tableView: UITableView!;
    @objc var pkgIdsArray = NSMutableArray()
    @objc var name : String = "";
    @objc var countryCode = "";
    @IBOutlet weak var nextArrow: UILabel!;
    @IBOutlet weak var wantHelpLabel: UILabel!;
    @IBOutlet weak var askSiaButtonHeightConstraint: NSLayoutConstraint!
    var cellTapped:Bool = true
    var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
    var currentRow = 0;
    func goToHomePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
    }

  
    @objc func action() {
                   self.navigationController?.popToRootViewController(animated: true)

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad();
        //UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
        CleverTap.sharedInstance()?.recordEvent("Packages_viewed")

        //SKPaymentQueue.default().add(self)
       // Flyshot.shared.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        Flyshot.test.clearUserData()
//        Flyshot.test.campaignRedeemTest = true
//        Flyshot.test.clearCampaignData()
        
//         DispatchQueue.main.async {
//        self.tableView.reloadData()
//        }
        self.navigationItem.hidesBackButton = true
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "backIcon"), for: .normal)
        btn1.frame = CGRect(0, 0, 30, 30)
        btn1.addTarget(self, action: #selector(AvailablePremiumPackagesViewController.action), for: .touchUpInside);        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
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
        if self.countryCode == "91" || self.countryCode == "1" {
            dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
        }
//        if self.countryCode == "91" {
//            self.askSiaButton.isHidden = false
//            self.wantHelpLabel.isHidden = false
//            self.askSiaButtonHeightConstraint.constant = 34
//        } else {
//            self.askSiaButton.isHidden = true
//            self.wantHelpLabel.isHidden = true
//            self.askSiaButtonHeightConstraint.constant = 0
//
//        }
        self.askSiaButton.isHidden = true
        self.wantHelpLabel.isHidden = true
        self.askSiaButtonHeightConstraint.constant = 0
        if self.countryCode == "91" {
            self.clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
            
        } else if self.countryCode == "62" {
            self.clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            self.clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
            //self.referralCodeBtn.isHidden = false
        } else if self.countryCode == "65" {
            self.clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            self.clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
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
        
//        if self.countryCode == "91" {
//            self.clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
//        } else if self.countryCode == "62" {
//            self.clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
//        } else if self.countryCode == "1" {
//            self.clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
//        } else if self.countryCode == "65" {
//            self.clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
//        } else if self.countryCode == "60" {
//            self.clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
//        }
//        if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
//            self.imgPopup = "imgClubPopup"
//        }
        //self.premiumPackagesApiArray.removeAll()
        self.navigationController?.isNavigationBarHidden = true
        if self.fromCrown == false {
            if self.countryCode == "91" {
                self.clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
            } else if self.countryCode == "62" {
                self.clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
            } else if self.countryCode == "1" {
                self.clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
            } else if self.countryCode == "65" {
                self.clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
            } else if self.countryCode == "60" {
                self.clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
            }
            if self.countryCode == "91" {
            if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                getPremiumPackagesApi5()
            } else {
                getPremiumPackagesApi2();

            }
            } else {
                getPremiumPackagesApi2();
            }
        } else {
        self.getPremiumPackagesApi();
        }
       
        self.myProfile = uiRealm.objects(MyProfileInfo.self);

       
        UserDefaults.standard.removeObject(forKey: "RECEIPT")
        //self.receiptValidation()
      //  NotificationCenter.default.addObserver(self, selector: #selector(AvailablePremiumPackagesViewController.handlePurchaseNotification(_:)), name: NSNotification.Name(rawValue: "IN-APP-PURCHASE-SUCCESSFUL"),
                                               //object: nil)
        
      
        //self.countryCode = "33"
        nonPremiumPackagesRef =  Database.database().reference().child("NonPremiumPackages").child("-Qis3atRaproTlpr4zIs").child("imgLarge")
        
        print(nonPremiumPackagesRef)
      
        self.headerView = UIView();
        premiumPackagesRef = Database.database().reference().child("PremiumPackageDetailsiOS");
        self.tableView.register(UINib.init(nibName: "SavedPackagesTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedPackagesTableViewCell");
        
        

        for myProfileObj in self.myProfile! {
            self.name = myProfileObj.name;
        }
        self.title = "Premium Packs";
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "instamojo" {
            let popOverVC = segue.destination as! InstaMojoViewController;
            let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
            popOverVC.msisdn = "+\(msisdn)";

            let cellDict = self.premiumPackagesArray[0] as AnyObject as! NSDictionary;
            let packagePrice = cellDict["packagePrice"] as! NSMutableArray;
            for pkgPrice in packagePrice {
                var pkg =  pkgPrice as! NSDictionary;
                if pkg["countryCode"] as AnyObject as! String == self.countryCode {
                    popOverVC.price = "\(pkg["transPayment"] as AnyObject as! Double)";
                    popOverVC.paymentType = "\(pkg["paymentType"] as AnyObject as! String)";
                    popOverVC.currency = "\(pkg["currency"] as AnyObject as! String)";

                }
            }

            popOverVC.package = (cellDict["packageTitle"] as AnyObject as? String)!;
            popOverVC.name = self.name;
            popOverVC.packageId = (cellDict["packageId"] as AnyObject as? String)!;
        } else if segue.identifier == "dietplan" {
            let popOverVC = segue.destination as! DietPlanViewController;
            

        } else if segue.identifier == "moreInfo" {
            
//            DispatchQueue.main.async {
//           self.tableView.reloadData()
//           }
            let popOverVC = segue.destination as! MoreInfoPremiumPackagesViewController;
            if UserDefaults.standard.value(forKey: "POP_UP_IDENTIFIERS") != nil {
                self.identifierFromPopUp = UserDefaults.standard.value(forKey: "POP_UP_IDENTIFIERS") as! String
            }
            popOverVC.identifierFromPopUp = self.identifierFromPopUp
            let image: UIImage = self.view.snapshot
            popOverVC.snapShotImage = image
            let cellD =  self.premiumPackagesApiArray[currentRow]
            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
                if language == "BA" {
                    popOverVC.smallImage = cellD.mppc_img_banner_ios

                } else {
            popOverVC.smallImage = cellD.mppc_img_banner_ios
                }
            }
            let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
            popOverVC.msisdn = "+\(msisdn)";

            popOverVC.package = cellD.mppc_name;
            popOverVC.name = self.name;
            popOverVC.packageId = cellD.mppc_fb_id;
            let transition: CATransition = CATransition()
            transition.duration = 0.8
              transition.type = CATransitionType.fade
            transition.subtype = .fromLeft
              navigationController?.view.layer.add(transition, forKey: nil)

        } else if segue.identifier == "AiDP" {
            let popOverVC = segue.destination as! AiDPViewController;
            let cellDict = self.premiumPackagesArray[0] as AnyObject as! NSDictionary;
            popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!;

            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgID = (cellDict["packageId"] as AnyObject as? String)!;
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                for dict in pkgsArray {
                    let pkgDict = dict as! [String: AnyObject];
                    if pkgDict["premium_pack_id"] as! String == pkgID {
                        let fbNutID = pkgDict[pkgID] as! String;
                        UserDefaults.standard.setValue(fbNutID, forKey: "NutritionistFirebaseId");
                    }
                }
            }
            popOverVC.smallImage = (cellDict["imgSmallPremium"] as AnyObject as? String)!;

        } else if segue.identifier == "purchasedPackages" {
            let popOverVC = segue.destination as! PurchasedPackagesViewController;
            popOverVC.packageIDArray = self.packageIDArray;
            let cellDict = self.premiumPackagesArray[0] as AnyObject as! NSDictionary;

            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgID = (cellDict["packageId"] as AnyObject as? String)!;
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;

                for dict in pkgsArray {
                    let pkgDict = dict as! [String: AnyObject];
                    if pkgDict["premium_pack_id"] as! String == pkgID {
                        let fbNutID = pkgDict[pkgID] as! String;
                        UserDefaults.standard.setValue(fbNutID, forKey: "NutritionistFirebaseId");
                    }
                }
            }
            //imgSmallPremium
            popOverVC.smallImage = (cellDict["imgSmallPremium"] as AnyObject as? String)!;
            popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!

        } else if segue.identifier == "nutritionPack" {
            let popOverVC = segue.destination as! NutritionLabelViewController;
             let cellDict = self.premiumPackagesArray[0] as AnyObject as! NSDictionary;
            popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!;
            popOverVC.packageObj = cellDict
            popOverVC.fromCrown = self.fromCrown
        } else if segue.identifier == "myTweakAndEat" {
           // if self.countryCode == "91" {
            let destination = segue.destination as! MyTweakAndEatVCViewController;
            destination.packageID = sender as! String
        //    }

        }
    }
    
    @IBAction func dietPlanTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "dietplan", sender: self);
    }
    
    @IBAction func savedPackagesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "packages", sender: self);
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let cellDictionary = self.premiumPackagesApiArray[indexPath.row]
//        if cellDictionary.mppc_fb_id != "-Qis3atRaproTlpr4zIs" && cellDictionary.mppc_fb_id != "-KyotHu4rPoL3YOsVxUu" && cellDictionary.mppc_fb_id != "-SquhLfL5nAsrhdq7GCY" &&  cellDictionary.mppc_fb_id != self.ptpPackage  && cellDictionary.mppc_fb_id != "-IndAiBPtmMrS4VPnwmD" && cellDictionary.mppc_fb_id != "-IdnAiBPLKMO5ePamQle" && cellDictionary.mppc_fb_id != "-SgnAiBPJlXfM3KzDWR8" && cellDictionary.mppc_fb_id != "-MysAiBPyaX9TgFT1YOp" && cellDictionary.mppc_fb_id != "-PhyAiBPcYLiSYlqhjbI" && cellDictionary.mppc_fb_id != "-UsaAiBPxnaopT55GJxl" && cellDictionary.mppc_fb_id != "-MysRamadanwgtLoss99" && cellDictionary.mppc_fb_id != "-IndWLIntusoe3uelxER" && cellDictionary.mppc_fb_id != "-AiDPwdvop1HU7fj8vfL" && cellDictionary.mppc_fb_id != "-IndIWj1mSzQ1GDlBpUt" && self.fromCrown == false {//
//            if indexPath.row == self.currentRow {
//
//                return 216
//            } else {
//                return 216
//
//            }
//          
//        } else {
//
//            if self.fromCrown == false {
//                return 176
//
//            }
//            return 156
//
//        }
//         // return 176
//    }
    
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
    
    @objc func getPremiumPackagesApi5() {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        APIWrapper.sharedInstance.getPremiumPackages5(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                print(response)
                let responseResult = response["callStatus"] as! String
                if  responseResult == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    self.pkgIdsArray = NSMutableArray()
                    //packs
                    if self.fromCrown == true {
                        self.title = "My Premium Packages";
                        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                                for pkgID in pkgsArray {
                                    let pkgDict = pkgID as! [String: AnyObject];
                                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                                    self.pkgIdsArray.add(pkgIDs)
                                }
                                let packs =  response["packs"] as AnyObject as! NSArray

                                for pkgs in packs {
                                    let packsDict = pkgs as! [String: AnyObject]
                                    let packageID =  packsDict["mppc_fb_id"] as AnyObject as! String
                                    if (self.pkgIdsArray.contains(packageID)){
                                        let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                                        self.premiumPackagesApiArray.append(pkgObj)
                                        
                                    }
                                }
                                self.tableView.reloadData()
                                
                            }
                        }
                        
                    } else {
                        
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
                        let packs =  response["packs"] as AnyObject as! NSArray
                        for packsDict in packs {
                            let packsDict = packsDict as AnyObject as! [String: AnyObject]
                            let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                            self.premiumPackagesApiArray.append(pkgObj)
                        }
                        //let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
//                        if msisdn == "6010000001" {
//                        let hardCodedPkg = PremiumPackages(mppc_fb_id: "-IndWLIntusoe3uelxER", pp_image_ba: "https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/wlint/wlint_ind_002.png", mppc_img_banner_ios: "https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/wlint/wlint_ind_002.png", mppc_name: "Intermittent Fasting Weight Loss", isCellTapped: false)
//                        self.premiumPackagesApiArray.insert(hardCodedPkg, at: 0)
                       // }
                         DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                        if self.fromHomePopups == true {
                            if let indexPathRow = self.premiumPackagesApiArray.index(where: {$0.mppc_fb_id == self.packageID}) {
                                self.currentRow = indexPathRow
                               // self.cellTapped = false
                                if (self.packageID == self.clubPackageSubscribed) {
                                    if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil  {
                                       self.goToTAEClubMemPage()
                                        return
                                     } else {
                                        // self.goToTAEClub()
                                        self.performSegue(withIdentifier: "moreInfo", sender: self);
    return
                                     }
                                } else if (self.packageID == "-NcInd5BosUcUeeQ9Q32") {
                                    if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil  {
                                        self.goToNutritonConsultantScreen(packageID: "-NcInd5BosUcUeeQ9Q32")
                                        return
                                     } else {
                                        // self.goToTAEClub()
                                        self.performSegue(withIdentifier: "moreInfo", sender: self);
    return
                                     }
                                } else {
                                if UserDefaults.standard.value(forKey: self.packageID) != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: self.packageID);

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                            }
                            }
                            

                        

                        }
                        
                        

                        
                    }
                    
                    
                    
                    print(self.premiumPackagesApiArray)
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
    
   
    
    @objc func getPremiumPackagesApi2() {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        APIWrapper.sharedInstance.getPremiumPackages2(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                print(response)
                let responseResult = response["callStatus"] as! String
                if  responseResult == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    self.pkgIdsArray = NSMutableArray()
                    //packs
                    if self.fromCrown == true {
                        self.title = "My Premium Packages";
                        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                                for pkgID in pkgsArray {
                                    let pkgDict = pkgID as! [String: AnyObject];
                                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                                    self.pkgIdsArray.add(pkgIDs)
                                }
                                let packs =  response["packs"] as AnyObject as! NSArray

                                for pkgs in packs {
                                    let packsDict = pkgs as! [String: AnyObject]
                                    let packageID =  packsDict["mppc_fb_id"] as AnyObject as! String
                                    if (self.pkgIdsArray.contains(packageID)){
                                        let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                                        self.premiumPackagesApiArray.append(pkgObj)
                                        
                                    }
                                }
                                self.tableView.reloadData()
                                
                            }
                        }
                        
                    } else {
                        
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
                        let packs =  response["packs"] as AnyObject as! NSArray
                        for packsDict in packs {
                            let packsDict = packsDict as AnyObject as! [String: AnyObject]
                            let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                            self.premiumPackagesApiArray.append(pkgObj)
                        }
                        //let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
//                        if msisdn == "6010000001" {
//                        let hardCodedPkg = PremiumPackages(mppc_fb_id: "-NcInd5BosUcUeeQ9Q32", pp_image_ba: "https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/wlint/wlint_ind_002.png", mppc_img_banner_ios: "https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/wlint/wlint_ind_002.png", mppc_name: "NCP", isCellTapped: false)
//                        self.premiumPackagesApiArray.insert(hardCodedPkg, at: 0)
                       // }
                         DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                        if self.fromHomePopups == true {
                            if let indexPathRow = self.premiumPackagesApiArray.index(where: {$0.mppc_fb_id == self.packageID}) {
                                self.currentRow = indexPathRow
                               // self.cellTapped = false
                                if (self.packageID == self.clubPackageSubscribed) {
                                    if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil  {
                                       self.goToTAEClubMemPage()
                                        return
                                     } else {
                                        // self.goToTAEClub()
                                        self.performSegue(withIdentifier: "moreInfo", sender: self);
    return
                                     }
                                } else if (self.packageID == "-NcInd5BosUcUeeQ9Q32") {
                                    if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil  {
                                        self.goToNutritonConsultantScreen(packageID: "-NcInd5BosUcUeeQ9Q32")
                                        return
                                     } else {
                                        // self.goToTAEClub()
                                        self.performSegue(withIdentifier: "moreInfo", sender: self);
    return
                                     }
                                } else {
                                if UserDefaults.standard.value(forKey: self.packageID) != nil {
                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: self.packageID);

                                } else  {

                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
                                }
                            }
                            }
                            

                        

                        }
                        
                        

                        
                    }
                    
                    
                    
                    print(self.premiumPackagesApiArray)
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
    
    @objc func getPremiumPackagesApi() {
          let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);

        APIWrapper.sharedInstance.getPremiumPackages(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
               print(response)
                let responseResult = response["callStatus"] as! String
                if  responseResult == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);

                    self.pkgIdsArray = NSMutableArray()

                    //packs
                    if self.fromCrown == true {
                       self.title = "My Premium Packages";
                        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                                for pkgID in pkgsArray {
                                    let pkgDict = pkgID as! [String: AnyObject];
                                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                                    self.pkgIdsArray.add(pkgIDs)
                                }
                                let packs =  response["packs"] as AnyObject as! NSArray

                                for pkgs in packs {
                                    let packsDict = pkgs as! [String: AnyObject]
                                    let packageID =  packsDict["mppc_fb_id"] as AnyObject as! String
                               if (self.pkgIdsArray.contains(packageID)){
                                let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                                self.premiumPackagesApiArray.append(pkgObj)
                                
                                    }
                                }

                                self.tableView.reloadData()

                            }
                        }
                        
                    } else {

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
                        let packs =  response["packs"] as AnyObject as! NSArray
                        for packsDict in packs {
                            let packsDict = packsDict as AnyObject as! [String: AnyObject]
                            let pkgObj = PremiumPackages(mppc_fb_id: self.getPackageDetails(packageObj: packsDict, val: "mppc_fb_id", type: String.self) as! String, pp_image_ba: self.getPackageDetails(packageObj: packsDict, val: "pp_image_ba", type: String.self) as! String, mppc_img_banner_ios: self.getPackageDetails(packageObj: packsDict, val: "mppc_img_banner_ios", type: String.self) as! String, mppc_name: self.getPackageDetails(packageObj: packsDict, val: "mppc_name", type: String.self) as! String, isCellTapped: false)
                            self.premiumPackagesApiArray.append(pkgObj)
                        }
                            self.tableView.reloadData()

                        }

//                }
                   print(self.premiumPackagesApiArray)
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

    // MARK: GET FIREBASE DATA
    @objc func getFirebaseData() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
            premiumPackagesRef.queryOrdered(byChild: "createdOn").observe(DataEventType.value, with: { (snapshot) in
                // this runs on the background queue
                // here the query starts to add new 10 rows of data to arrays
                self.premiumPackagesArray = NSMutableArray();

                if snapshot.childrenCount > 0 {
                    let dispatch_group = DispatchGroup();
                    dispatch_group.enter();
                    
                    for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let packageObj = premiumPackages.value as? [String : AnyObject];
                        if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                            let activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray;
                         
                            if (activeCountriesArray.contains(Int(self.countryCode)!)) {
                                    if self.fromCrown == true {
                                        
                                    if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                                        if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                                            if (self.pkgIdsArray.contains(premiumPackages.key)) {
                                                self.premiumPackagesArray.add(packageObj!);
                                                
                                            }
                                        }
                                    } else {
                                        
                                        }
                                    } else {
                                        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                                            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                                                
                                                if !(self.pkgIdsArray.contains(premiumPackages.key)) {
                                                    self.premiumPackagesArray.add(packageObj!);

                                                }
                                            }
                                        } else {
                                            self.premiumPackagesArray.add(packageObj!);
                                        }
                                    }
                                
                                }
                            
                        } else {
                            TweakAndEatUtils.AlertView.showAlert(view: self, message: "There are no available Premium Packages. Please come later!");
                        }
                    }
                    print(self.premiumPackagesArray)
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData();
                        
                    }
                    
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true);

                }
            })
        }
    
    func isPackagePurchased(pkgID: String) -> Bool {
        if UserDefaults.standard.value(forKey: pkgID) != nil {
            return true
        }
        return false
    }
    
    // MARK: TABLEVIEW DELEGATE AND DATASOURCE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.premiumPackagesApiArray.count > 0 {
            return self.premiumPackagesApiArray.count
        }
        return 0;
    }
  
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.premiumPackagesApiArray.count > 0 {
//            let indexPath = IndexPath(row: indexPath.row, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! AvailablePremiumPackagesTableViewCell
//
//        return CGFloat(cell.packageImageViewHeightConstraint.constant)
//        }
//        return 0
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footeriew = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
//        let imgv = UIImageView(frame: CGRect(x: 10, y: 10, width: self.tableView.frame.size.width - 20, height: 60))
//        imgv.image = UIImage.init(named: "nutrition_labels_Included_for_all")
//        imgv.contentMode = .scaleAspectFit
//        footeriew.addSubview(imgv)
//        return footeriew
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//
//          return 80
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellDictionary = self.premiumPackagesApiArray[indexPath.row];
//        
//
//        if (self.countryCode == "-1" && UserDefaults.standard.value(forKey: cellDictionary.mppc_fb_id) == nil) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as! AvailablePackagesCell2;
//            cell.cellDelegate = self
//            cell.cellIndexPath = indexPath.row;
//            cell.myIndexPath = indexPath;
//
//            let cellDictionary = self.premiumPackagesApiArray[indexPath.row];
//            if cellDictionary.isSelected == true {
//                cell.packagesView.layer.borderWidth = 3
//                cell.packagesView.layer.borderColor = UIColor.purple.cgColor
//            } else {
//                cell.packagesView.layer.borderWidth = 1
//                cell.packagesView.layer.borderColor = UIColor.clear.cgColor
//            }
//            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
//                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
//                if language == "BA" {
//                    let imageUrlBA = cellDictionary.mppc_img_banner_ios;
//                    cell.packageImageView.sd_setImage(with: URL(string: imageUrlBA)) { (image, error, cache, url) in
//                                                                       // Your code inside completion block
//                        if image != nil {
//                      let ratio = image!.size.width / image!.size.height
//                            let newHeight = cell.packageImageView.frame.width / ratio
//                            cell.packageImageViewHeightConstraint.constant = newHeight
//                            cell.layoutIfNeeded()
//                            UIView.performWithoutAnimation {
//                                tableView.beginUpdates()
//                                tableView.endUpdates()
//                            }
//
//
//                      }
//                    }
//
//                } else {
//                    let imageUrlEN = cellDictionary.mppc_img_banner_ios;
//                    cell.packageImageView.sd_setImage(with: URL(string: imageUrlEN)) { (image, error, cache, url) in
//                                                                       // Your code inside completion block
//                        if image != nil {
//                      let ratio = image!.size.width / image!.size.height
//                            let newHeight = cell.packageImageView.frame.width / ratio
//                            cell.packageImageViewHeightConstraint.constant = newHeight
//                            cell.layoutIfNeeded()
//                            UIView.performWithoutAnimation {
//                                tableView.beginUpdates()
//                                tableView.endUpdates()
//                            }
//
//
//                      }
//                    }
//                }
//            }
//            if  cellDictionary.mppc_fb_id != "-Qis3atRaproTlpr4zIs" && cellDictionary.mppc_fb_id != "-KyotHu4rPoL3YOsVxUu" && cellDictionary.mppc_fb_id != "-SquhLfL5nAsrhdq7GCY" {
//            let isPckgPurchased = self.isPackagePurchased(pkgID: cellDictionary.mppc_fb_id)
//            if isPckgPurchased == true {
//                cell.tickMarkImageView.isHidden = false
//            } else {
//                cell.tickMarkImageView.isHidden = true
//            }
//        }
//            return cell
//        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AvailablePremiumPackagesTableViewCell;
        cell.cellDelegate = self
        cell.cellIndexPath = indexPath.row;
        cell.myIndexPath = indexPath;
        
        let cellDictionary = self.premiumPackagesApiArray[indexPath.row];
       
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                let imageUrlBA = cellDictionary.mppc_img_banner_ios;
                cell.packageImageView.sd_setImage(with: URL(string: imageUrlBA)) { (image, error, cache, url) in
                                                                   // Your code inside completion block
                    if image != nil {
                  let ratio = image!.size.width / image!.size.height
                        let newHeight = cell.packageImageView.frame.width / ratio
                        cell.packageImageViewHeightConstraint.constant = newHeight
                        cell.layoutIfNeeded()
                        UIView.performWithoutAnimation {
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }


                  }
                }
                
            } else {
                let imageUrlEN = cellDictionary.mppc_img_banner_ios;
                cell.packageImageView.sd_setImage(with: URL(string: imageUrlEN)) { (image, error, cache, url) in
                                                                   // Your code inside completion block
                    if image != nil {
                  let ratio = image!.size.width / image!.size.height
                        let newHeight = cell.packageImageView.frame.width / ratio
                        cell.packageImageViewHeightConstraint.constant = newHeight
                        cell.layoutIfNeeded()
                        UIView.performWithoutAnimation {
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }


                  }
                }
            }
        }
        if  cellDictionary.mppc_fb_id != "-Qis3atRaproTlpr4zIs" && cellDictionary.mppc_fb_id != "-KyotHu4rPoL3YOsVxUu" && cellDictionary.mppc_fb_id != "-SquhLfL5nAsrhdq7GCY" {
        let isPckgPurchased = self.isPackagePurchased(pkgID: cellDictionary.mppc_fb_id)
        if isPckgPurchased == true {
            cell.tickMarkImageView.isHidden = false
        } else {
            cell.tickMarkImageView.isHidden = true
        }
    }
    
        return cell;
       // }
        //return UITableViewCell()
        
    }
    
//      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var selectedRowIndex = indexPath
//        currentRow = selectedRowIndex.row
//        self.myIndexPath = indexPath;
//        let cellDictionary = self.premiumPackagesApiArray[indexPath.row] as AnyObject as! NSDictionary;
//        if self.countryCode == "91" &&  cellDictionary.mppc_fb_id != "-Qis3atRaproTlpr4zIs"{
//        let indexPath = IndexPath(row: currentRow, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! AvailablePremiumPackagesTableViewCell
//        if cell.howToSubVideoHeightConstraint.constant == 0 {
//             cell.howToSubVideoHeightConstraint.constant = 46
//        } else {
//           cell.howToSubVideoHeightConstraint.constant = 0
//        }
//        }
//        tableView.beginUpdates()
//        tableView.endUpdates()
////        self.myIndexPath = indexPath;
////        let cellDictionary = self.premiumPackagesApiArray[indexPath.row] as AnyObject as! NSDictionary;
//        let packageID = cellDictionary["mppc_fb_id"] as AnyObject as! String;
//        print(packageID); Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
//            self.premiumPackagesArray = NSMutableArray()
//            // this runs on the background queue
//            // here the query starts to add new 10 rows of data to arrays
//            if snapshot.childrenCount > 0 {
//
//                let dispatch_group = DispatchGroup();
//                dispatch_group.enter();
//                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
//                    let packageObj = premiumPackages.value as? [String : AnyObject];
//                    if premiumPackages.key == packageID {
//                    self.premiumPackagesArray.add(packageObj!);
//                    }
//
//                }
//
//                dispatch_group.leave();
//
//                dispatch_group.notify(queue: DispatchQueue.main) {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    if self.premiumPackagesArray.count > 0 {
//                        if self.fromCrown == true {
//                            if (cellDictionary.mppc_fb_id == "-TacvBsX4yDrtgbl6YOQ") {
//                               self.performSegue(withIdentifier: "purchasedPackages", sender: self);
//                            } else if (cellDictionary.mppc_fb_id == "-KyotHu4rPoL3YOsVxUu"){
//                                self.performSegue(withIdentifier: "purchasedPackages", sender: self);
//
//                            } else if (cellDictionary.mppc_fb_id == "-SquhLfL5nAsrhdq7GCY") {
//                                self.performSegue(withIdentifier: "AiDP", sender: self);
//
//                            } else  if (cellDictionary.mppc_fb_id == "-IndIWj1mSzQ1GDlBpUt") {
//                                  if self.indTAE == 1 {
//                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
//
//                                } else  {
//                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                }
//
//
//                            } else  if (cellDictionary.mppc_fb_id == "-AiDPwdvop1HU7fj8vfL") {
//                                if self.indMyAidp == 1 {
//                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");
//
//                                } else  {
//                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                }
//                            }
//
//                        } else {
//                            if self.pkgIdsArray.count > 0 {
//                                let pkgsID = cellDictionary.mppc_fb_id
//                                if self.pkgIdsArray.contains(pkgsID) {
//                                    if pkgsID == "-KyotHu4rPoL3YOsVxUu" {
//                                        self.performSegue(withIdentifier: "purchasedPackages", sender: self);
//                                        return
//                                    }
//                                    if pkgsID == "-SquhLfL5nAsrhdq7GCY" {
//                                        self.performSegue(withIdentifier: "AiDP", sender: self);
//                                        return
//                                    }
//                                    if pkgsID == "-TacvBsX4yDrtgbl6YOQ" {
//                                        self.performSegue(withIdentifier: "purchasedPackages", sender: self);
//                                        return
//                                    }
//                                    if pkgsID == "-IndIWj1mSzQ1GDlBpUt" {
//                                        if self.indTAE == 1 {
//                                            self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
//
//                                        } else  {
//                                            self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                        }
//                                        return
//                                    }
//                                    if pkgsID == "-AiDPwdvop1HU7fj8vfL" {
//                                        if self.indMyAidp == 1 {
//                                            self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");
//
//                                        } else  {
//                                            self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                        }
//                                        return
//                                    }
//                                    if (pkgsID == "-Qis3atRaproTlpr4zIs") {
//                                        self.performSegue(withIdentifier: "nutritionPack", sender: self);
//
//                                    }
//                                }
//                            }
//                            if (cellDictionary.mppc_fb_id == "-IndIWj1mSzQ1GDlBpUt") {
//
//                                if self.indTAE == 1 {
//                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
//
//                                } else  {
//                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                }
//                                return
//
//                            }
//                            if (cellDictionary.mppc_fb_id == "-AiDPwdvop1HU7fj8vfL") {
//
//                                if self.indMyAidp == 1 {
//                                    self.performSegue(withIdentifier: "myTweakAndEat", sender: "-AiDPwdvop1HU7fj8vfL");
//
//                                } else  {
//                                    self.performSegue(withIdentifier: "moreInfo", sender: self);
//
//                                }
//                                return
//
//                            }
//                    if ((cellDictionary.mppc_fb_id == "-TacvBsX4yDrtgbl6YOQ") || (cellDictionary.mppc_fb_id == "-Qis3atRaproTlpr4zIs")) {
//
//                        self.performSegue(withIdentifier: "nutritionPack", sender: self);
//                        return
//
//                    }
//                    self.performSegue(withIdentifier: "moreInfo", sender: self);
//                }
//                }
//                }
//            }
//        })
//}
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.view.endEditing(true);
//    }
    
    @IBAction func paymentSuccessOKTapped(_ sender: Any) {
        self.paySucessView.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myTweakandEatViewController : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        myTweakandEatViewController.packageID = self.packageId; self.navigationController?.pushViewController(myTweakandEatViewController, animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
