//
//  MoreInfoPremiumPackagesViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 9/3/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import StoreKit
import Realm
import RealmSwift

enum MyTheme {
    case light
    case dark
}
class MoreInfoPremiumPackagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, UITextFieldDelegate, UserCallSchedule {
    func closeBtnTapped() {
        self.callSchedulePopup.removeFromSuperview()
         self.title = self.navTitle
               self.calendarOuterView.isHidden = true
        self.navigationItem.hidesBackButton = false
    }
    
    @objc var callSchedulePopup : UserCallSchedulePopUp! = nil;
    @objc var API_KEY = "rzp_live_dFMdQLcE5x9q86";
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var labelPriceDict = [String: AnyObject]();
    @objc var nutritionLabelPriceArray = NSMutableArray();
    let calenderView: CalenderView = {
          let v=CalenderView(theme: MyTheme.light)
          v.translatesAutoresizingMaskIntoConstraints=false
          return v
      }()
    
    var navTitle = ""
    var checkUserScheduleArray = [[String: AnyObject]]()
    @IBOutlet weak var calendarInnerView: UIView!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var calendarOuterView: UIView!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var moreInfoSelectPlanView: UIView!
    @IBOutlet weak var chooseSubScriptionPlanLbl: UILabel!
    @IBOutlet weak var userCallScheduleView1: UIView!
    @IBOutlet weak var captchViewInfoLbl: UILabel!
    @IBOutlet weak var userCallScheduleView2: UIView!
    @IBOutlet weak var buyNowMoreInfoBtn: UIButton!
    @IBOutlet weak var moreInfoSubscribeTextView: UITextView!
    @IBOutlet weak var featuresViewSubscribeTextView: UITextView!
    @IBOutlet weak var featuresView: UIView!
    @IBOutlet weak var callNutritionistTextLbl1: UILabel!
    @IBOutlet weak var callNutritionistTextLbl2: UILabel!
    @IBOutlet weak var unsubScribeImageView: UIImageView!
    @IBOutlet weak var priceTableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectPlanView: UIView!
    var timeSlotsArray = [[String: AnyObject]]()
    var productPrice: NSDecimalNumber = NSDecimalNumber()
    @IBOutlet weak var buyNowButton: UIButton!;
    @IBOutlet weak var infoView: UIView!;
    @IBOutlet weak var innerCalendarViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var timeSlotTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var packageDescTextView: UITextView!;
    @IBOutlet weak var areYouSureLbl: UILabel!
    @IBOutlet weak var unSubscribeImgViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var callNutritionistBtn2HeightContraint: NSLayoutConstraint!
    @IBOutlet weak var ourNutritionistLbl: UILabel!
    @IBOutlet weak var callNutritionistBtn2: UIButton!
    var myProfile : Results<MyProfileInfo>?;
    @IBOutlet weak  var paySucessView: UIView!
    @IBOutlet weak  var usdAmtLabel: UILabel!
    @IBOutlet weak  var nutritionstDescLbl: UILabel!
    var system = 0;
    var confirmationText = ""
    var cardImageString = "";
    var labelsPrice = "pkgPrice"
    var lables = "pkgDisplayDescription"
    var lableCount = "pkgDuration"
    @IBOutlet weak var captchaInnerView: UIView!
    var timerForShowScrollIndicator: Timer?
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var captchInputTF: UITextField!
    
    @IBOutlet weak var confirmCaptchaBtn: UIButton!
    
    @IBOutlet weak var captchaGeneratorTF: UITextField!
    
    @IBOutlet weak var captchaView: UIView!
    @objc var ptpPackage = ""
    @IBOutlet weak var packageTitle: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var callNutritionistBtn1: UIButton!
    @IBOutlet weak var packageDescription: UITextView!
    var pickerView: UIPickerView {
      get {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        return pickerView
      }
    }
    var accessoryToolbar: UIToolbar {
      get {
        let toolbarFrame = CGRect(x: 0, y: 0,
          width: view.frame.width, height: 44)
        let accessoryToolbar = UIToolbar(frame: toolbarFrame)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
          target: self,
          action: #selector(onDoneButtonTapped(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
          target: nil,
          action: nil)
        accessoryToolbar.items = [flexibleSpace, doneButton]
        accessoryToolbar.barTintColor = UIColor.white
        return accessoryToolbar
      }
    }
    @objc var smallImage : String = ""
    @objc var price : String = ""
    @objc var name : String = ""
    @objc var package : String = ""
    @objc var msisdn : String = ""
    @objc var packageId : String = ""
    @objc var packageFullDesc : String = ""
    @objc var paymentType : String = ""
    @objc var currency : String = ""
    @objc var countryCode = ""
    @objc var priceInDouble : Double = 0.0
    var productIdentifier = ""
    @objc var selectedIndex: Int = 0;
    var products: [SKProduct] = []
    @objc var languagesArray = [[String: AnyObject]]()
    @objc var displayAmount : String = "";
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    
    @objc var pkgDuration : String = "";
    @objc var nutritionLabelPackagesArray = NSMutableArray();
    @objc var moreInfoPremiumPackagesArray = NSMutableArray()
    @objc var moreInfoPremiumPackagesRef : DatabaseReference!
    func showCalendarView() {
        self.calendarOuterView.isHidden = false
        self.title = "SCHEDULE YOUR CALL"
        self.areYouSureLbl.layer.cornerRadius = 10
        self.calendarInnerView.layer.cornerRadius = 10
        self.calView.layer.cornerRadius = 10
      
        self.areYouSureLbl.isHidden = true
        self.calendarOuterView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.calView.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: self.calView.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: self.calView.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: self.calView.leftAnchor, constant: 12).isActive=true
        calenderView.bottomAnchor.constraint(equalTo: self.calView.bottomAnchor, constant: 10).isActive=true
        let userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
                       
                       let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn
                   
                                             let msisdnRange = certNutText.range(of: userMsisdn)
                                             let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                                             certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                                             certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                                             self.ourNutritionistLbl.attributedText = certAttrStr
        if IS_iPHONE678 {
            //.self.innerCalendarViewHeightConstant.isActive = false
        calenderView.heightAnchor.constraint(equalToConstant: 250).isActive=true
        }else if IS_iPHONE678P {
            //.self.innerCalendarViewHeightConstant.isActive = false
        calenderView.heightAnchor.constraint(equalToConstant: 310).isActive=true
        }  else {
            //self.innerCalendarViewHeightConstant.isActive = false
            calenderView.heightAnchor.constraint(equalToConstant: 340).isActive=true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if self.timeSlotsArray.count > 0 {
//            self.pickerView.reloadAllComponents()
//            return
//        }
         
                      
                   
    }
    func gettimeSlots() {
        self.timeSlotsArray = []
        MBProgressHUD.showAdded(to: self.view, animated: true);
                           
                                      APIWrapper.sharedInstance.getTimeSlots({ (responceDic : AnyObject!) -> (Void) in
                               if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                                   let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                                   
                                   if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                       MBProgressHUD.hide(for: self.view, animated: true)
                                       self.timeSlotsArray = (response["data"] as AnyObject) as! [[String : AnyObject]]
                                   self.navigationItem.hidesBackButton = true
                                    self.showCalendarView()
                                   } else {
                                           MBProgressHUD.hide(for: self.view, animated: true)
                                       }
                                   }
                                else {
                                   //error
                                   MBProgressHUD.hide(for: self.view, animated: true)
                               }
                           }) { (error : NSError!) -> (Void) in
                               //error
                               if error?.code == -1011 {
                                              
                                          } else {
                                              TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                                          }
                                      }
    }
    @IBAction func getTimeSlotsBtnTapped(_ sender: Any) {
        self.timeSlotTextField.becomeFirstResponder()
           if self.timeSlotsArray.count > 0 {
           let dict = self.timeSlotsArray[0]
            //self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
            self.pickerView.reloadAllComponents()

           }
           
    }
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if self.timeSlotTextField.isFirstResponder {
        self.timeSlotTextField.resignFirstResponder()
            if self.timeSlotsArray.count > 0 && self.timeSlotTextField.text?.count == 0 {
            let dict = self.timeSlotsArray[0]
             self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
                
            }
           
            self.updateAreYouSureLbl()
      }
    }
    
    @IBAction func callNutritionistBtn2Tapped(_ sender: Any) {
        self.gettimeSlots()
        
    }
    @IBAction func callNutritionistBtn1Tapped(_ sender: Any) {
        self.navigationItem.hidesBackButton = true
        self.showCalendarView()
    }
    @IBAction func paymentSuccessOKTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myTweakandEatViewController : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        myTweakandEatViewController.fromWhichVC = "MoreInfoPremiumPackagesViewController"
        myTweakandEatViewController.packageID = self.packageId; self.navigationController?.pushViewController(myTweakandEatViewController, animated: true);
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // Show some alert
    }
    
    func buyProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            
            print("Sending the Payment Request to Apple");
            let payment = SKPayment(product: product)
            self.productPrice = product.price
            //   SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment);
        }
    }
    @IBAction func confirmCaptchaScheduleCall(_ sender: Any) {
        if self.captchaGeneratorTF.text != self.captchInputTF.text {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please enter a valid 4 digit number!")
            self.captchInputTF.text = ""
            
            return
        }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let date = (self.calenderView.selectedDate < 10) ? "0\(self.calenderView.selectedDate)" : "\(self.calenderView.selectedDate)"
                let month = (self.calenderView.currentMonthIndex < 10) ? "0\(self.calenderView.currentMonthIndex)" : "\(self.calenderView.currentMonthIndex)"
                let year = "\(self.calenderView.currentYear)"
                let time = "\(self.timeSlotTextField.text?.replacingOccurrences(of: " AM", with: ":00").replacingOccurrences(of: " PM", with: ":00") ?? "")"
                let timeSlot: String = year + "-" + month + "-" + date + " " + self.timeSlotTextField.text!
        let paramsDictionary = ["callDateTime": timeSlot, "lang": self.languageTextField.text!] as [String : AnyObject]
                APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.SCHEDULE_USER_CALL, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: paramsDictionary , success: { response in
                    print(response!)
                    
                    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                    let responseResult = responseDic["callStatus"] as! String;
                    if  responseResult == "GOOD" {
                       
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.captchaView.isHidden = true
                        self.view.endEditing(true)
                        self.callSchedulePopup = (Bundle.main.loadNibNamed("UserCallSchedulePopUp", owner: self, options: nil)! as NSArray).firstObject as? UserCallSchedulePopUp;
                                                     self.callSchedulePopup.frame = CGRect(0, 0, self.view.frame.width, self.view.frame.height);
                                                            self.callSchedulePopup.userCallScheduleDelegate = self;
                                                            self.callSchedulePopup.beginning();
                        self.view.addSubview(self.callSchedulePopup)
                        self.callSchedulePopup.yourCallLabel.text = "Your CALL has been scheduled !"
                         let data = responseDic["data"] as! [String: AnyObject]
                        let callDateTime: String = data["callDateTime"] as! String
                        let stringValue = "When: " + callDateTime
                                              let whenRange = stringValue.range(of: "When: ")
                                              
                                              let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                                              attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(whenRange!, in: stringValue))
                                              attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(whenRange!, in: stringValue))
                                              

                                             
                                              self.callSchedulePopup.whenLbl.attributedText = attributedString
                        let userMsisdn = data["userMsisdn"] as! String
                        
                        let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn
                        let scheduleDetails = ["callDateTime": callDateTime, "certNutText":certNutText, "userMsisdn": userMsisdn] as [String: AnyObject];
                        UserDefaults.standard.set(scheduleDetails, forKey: "CALL_SCHEDULED");
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil);
                                              let msisdnRange = certNutText.range(of: userMsisdn)
                                              let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                                              certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                                              certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                                              self.callSchedulePopup.ourCerifiedNutritionistLbl.attributedText = certAttrStr
        //                let callDateTime = daIndWLIntusoe3uelxER
                        if self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-IndWLIntusoe3uelxER" {
                                self.callNutritionistBtn2HeightContraint.isActive = false
                            self.userCallScheduleView2.isHidden = false
                                self.userCallScheduleView2.layer.cornerRadius = 15
                        self.userCallScheduleView2.layer.borderColor = UIColor.purple.cgColor
                            self.userCallScheduleView2.layer.borderWidth = 3
                           let yourCallStr: String = "Your CALL has been already scheduled !\n\n"
                            let certNutText = yourCallStr + "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn + " on " + callDateTime;
                            
                            let msisdnRange = certNutText.range(of: userMsisdn)
                            let callDateTimeRange =  certNutText.range(of: callDateTime)
                            let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                            let yourCallRange = certNutText.range(of: "Your CALL has been already scheduled !")
                                           certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(yourCallRange!, in: certNutText))
                                           certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(yourCallRange!, in: certNutText))
                            certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                            certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                            certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0), range: NSRange(callDateTimeRange!, in: certNutText))
                            self.callNutritionistTextLbl2.attributedText = certAttrStr
                        }
        //                } else {
        //                    self.userCallScheduleView1.isHidden = false
        //                self.unSubscribeImgViewHeightContraint.isActive = false
        //                self.userCallScheduleView1.layer.cornerRadius = 15
        //                self.userCallScheduleView1.layer.borderColor = UIColor.purple.cgColor
        //                self.userCallScheduleView1.layer.borderWidth = 3
        //
        //                        let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn + " on" + callDateTime;
        //                                           let msisdnRange = certNutText.range(of: userMsisdn)
        //                                           let callDateTimeRange =  certNutText.range(of: callDateTime)
        //                                           let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
        //                                           certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
        //                                           certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
        //                                           certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0), range: NSRange(callDateTimeRange!, in: certNutText))
        //                                           self.callNutritionistTextLbl1.attributedText = certAttrStr
        //                }
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
    @IBAction func refreshCaptcha(_ sender: Any) {
        self.captchaGeneratorTF.text = fourDigitNumber
        self.captchInputTF.text = ""

    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                
                // self.dismissPurchaseBtn.isEnabled = true
                // self.restorePurchaseBtn.isEnabled = true
                self.buyNowButton.isEnabled = true
                
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    //Do unlocking etc stuff here in case of new purchase
                    self.recptValidation()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    MBProgressHUD.hide(for: self.view, animated: true);
                    SKPaymentQueue.default().remove(self)
                    
                    
                    break;
                case .failed:
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SKPaymentQueue.default().remove(self)
                    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startTimerForShowScrollIndicator()
    }
    
    
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        if self.languageTableView.isHidden == true {
            MBProgressHUD.showAdded(to: self.view, animated: true)
                    APIWrapper.sharedInstance.getJSON(url: TweakAndEatURLConstants.CALL_SCHEDULE_LANGUAGES , { (responceDic : AnyObject!) -> (Void) in
                        if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                            let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                            
                            if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.languagesArray = response["data"] as! [[String: AnyObject]]
                                self.languageTableView.isHidden = false
                                self.languageTableView.reloadData()

                            } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                            }
                         else {
                            //error
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }) { (error : NSError!) -> (Void) in
                        //error
                        if error?.code == -1011 {
                                       
                                   } else {
                                       TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                                   }
                               }
                    }

        }
        
    
    @IBAction func dropDownTapped(_ sender: Any) {
        if self.priceTableView.isHidden == true {
            self.buyNowButton.isEnabled = false
            self.priceTableView.isHidden = false
            self.priceTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == moreInfoTableView {
            return self.moreInfoPremiumPackagesArray.count;
        } else if tableView == languageTableView {
            return self.languagesArray.count;
        } else {
            return self.nutritionLabelPriceArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//var cell :UITableViewCell!
        if tableView == moreInfoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MoreInfoPackageTableViewCell;
            let cellDict = self.moreInfoPremiumPackagesArray[indexPath.row] as! [String : AnyObject];
            if countryCode == "1" || countryCode == "60" || countryCode == "91" || countryCode == "62" || countryCode == "65" {
                let cellStr = cellDict["text"] as? String
                cell.featuresLabel.text = "\n" + cellStr! + "\n"
                if cellDict["free"] as! Bool == true {
                    cell.freeImage.image = UIImage.init(named: "tick_icon");
                    
                } else {
                    cell.freeImage.image = UIImage.init(named: "x-icon.png");
                    
                    // cell.freeImage.isHidden = true;
                }
                if cellDict["paid"] as! Bool == true {
                    //cell.premiumImage.isHidden = false;
                    cell.premiumImage.image = UIImage.init(named: "tick_icon");
                    
                } else {
                    cell.premiumImage.image = UIImage.init(named: "x-icon.png");
                    
                    
                    //cell.premiumImage.isHidden = true;
                }
            } else  {
                var cellStr = ""
                if  cellDict["name"] as? String != nil {
                    cellStr = (cellDict["name"] as? String)!
                }
                
                cell.featuresLabel.text =  "\n" + cellStr + "\n"
                if cellDict["isFree"] as! Bool == true {
                    cell.freeImage.isHidden = false;
                } else {
                    cell.freeImage.isHidden = true;
                }
                if cellDict["isPremium"] as! Bool == true {
                    cell.premiumImage.isHidden = false;
                } else {
                    cell.premiumImage.isHidden = true;
                }
            }
            return cell
            
        } else if tableView == languageTableView {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.contentView.backgroundColor = .groupTableViewBackground
            let cellDict = self.languagesArray[indexPath.row] ;
            cell.textLabel?.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = cellDict["mcl_name"] as? String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pricesCell", for: indexPath)
            let cellDict = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
            let labels = (cellDict[lables] as? String)! + " ("
            let amount = "\(cellDict["display_amount"] as AnyObject as! Double)" + " "
            let currency = (cellDict["display_currency"] as? String)! + ")"
            let totalDesc: String = labels + amount + currency;
            cell.textLabel?.text = totalDesc
            
            cell.textLabel?.font = cell.textLabel?.font.withSize(16);
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        // return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.priceTableView {
            return "Please choose a subscription plan"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == priceTableView {
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
            if self.featuresView.isHidden == false {
            self.priceLabel.text = " " + totalDesc
            } else {
                self.chooseSubScriptionPlanLbl.text = " " + totalDesc

            }
            
            self.buyNowButton.isEnabled = true
            self.priceTableView.isHidden = true
            self.productIdentifier = self.labelPriceDict["productIdentifier"] as AnyObject as! String
        } else if tableView == languageTableView {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            let cellDict = self.languagesArray[indexPath.row] ;
            
            self.languageTextField.text = cellDict["mcl_name"] as? String
            self.languageTableView.isHidden = true
            self.updateAreYouSureLbl()
        }
    }
    
    @IBAction func closCaptchaView(_ sender: Any) {
        self.captchaView.isHidden = true
        self.view.endEditing(true)
    }
    
    func getMyTweakAndEatDetails() {
       // MBProgressHUD.showAdded(to: self.view, animated: true);
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.nutritionLabelPackagesArray = NSMutableArray();

            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {

                    if premiumPackages.key == self.packageId  {
                        let packageObj = premiumPackages.value as? [String : AnyObject];
                        if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                          
                        self.nutritionLabelPackagesArray.add(packageObj!);
                            DispatchQueue.global(qos: .userInitiated).async {
                                self.packagLabelSelections();
                            }
                            
                        } else {
                            TweakAndEatUtils.AlertView.showAlert(view: self, message: "There is no package available. Please try again later!!");
                        }
                        
                    }
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                   
                    for dict in self.nutritionLabelPackagesArray {
                        let tempDict = dict as! [String: AnyObject];
                        if tempDict["systemFlag"] as! Bool == false {
                            self.system = 0;
                            if self.countryCode == "91" {
                                self.API_KEY = "rzp_test_YVm7Z8EyoTlae5";
                            } else {
                           // STPPaymentConfiguration.shared().publishableKey = "pk_test_uSKEX7kh67ftcHeVV5zRdIzr"
                            }

                        } else {
                            self.system = 1;
                            if self.countryCode == "91" {
                                self.API_KEY = "rzp_live_dFMdQLcE5x9q86";
                            } else {
                              //  STPPaymentConfiguration.shared().publishableKey = "pk_live_QljdHScPsqQ2yJAGcjYqk39i"
                            }

                        }
                        if tempDict["isActive"] as! Bool == false {
                            self.buyNowButton.setTitle("COMING SOON..", for: .normal)
                            self.buyNowButton.isUserInteractionEnabled = false
                        } else {
                            self.buyNowButton.setTitle("BUY NOW", for: .normal)
                            self.buyNowButton.isUserInteractionEnabled = true

                        }
                       // self.smallImageView.sd_setImage(with: URL(string:tempDict["imgSmall"] as! String));

                    }
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        })
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    func recptValidation() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
       var url = ""
        var jsonDict = [String: AnyObject]()
        if self.packageId == self.ptpPackage || self.packageId == "-MysRamadanwgtLoss99" {
            let currentDate = Date();
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYMMddHHmmss"
            let strDate = dateFormatter.string(from: currentDate)
            let msisdn = self.myProfile?.first?.msisdn as AnyObject as! String
            let paymentID = "\(msisdn)_" + strDate
          url = TweakAndEatURLConstants.AIBP_REGISTRATION
            jsonDict = ["paymentId" : paymentID as AnyObject, "packageId":  self.packageId, "amountPaid": self.price, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration, "packageRecurring": 0 as AnyObject] as [String : AnyObject]
        } else {
            
            url = TweakAndEatURLConstants.IAP_INDIA_SUBSCRIBE
            let receiptFileURL = Bundle.main.appStoreReceiptURL
            let receiptData = try? Data(contentsOf: receiptFileURL!)
            let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
             jsonDict = ["receiptData" : recieptString as AnyObject, "environment" : "Production" as AnyObject, "packageId":  self.packageId, "amountPaid": self.price, "amountCurrency" : self.currency, "packageDuration": self.pkgDuration] as [String : AnyObject]
        }
       
      
        print(jsonDict)
        //91e841953e9f4d19976283cd2ee78992
        
        //print(recieptString!)
        //        UserDefaults.standard.set(receiptData, forKey: "RECEIPT")
        //        UserDefaults.standard.synchronize()
        //
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postReceiptData(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: jsonDict, success: { response in
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
                let labels =  (self.labelPriceDict[self.lables] as? String)! + " ("
                let amount = "\(self.labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
                
                let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
                let totalDesc: String = labels + amount + currency;
                var data = [String: AnyObject]()

                let priceDesc = totalDesc
                if responseDic.index(forKey: "data") != nil {
                    // contains key
                    data = responseDic["data"] as AnyObject as! [String: AnyObject]
                    
                } else if responseDic.index(forKey: "Data") != nil {
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
                var pkgesArr = NSMutableArray()
                
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
                            pkgesArr.remove(self.packageId)
                            pkgesArr.add(self.packageId)
                            pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
                            
                        } else {
                            pkgsArray["packages"] = [self.packageId];
                        }
                        
                        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
                            
                        })
                        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                            if error == nil {
                                //      if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                                if self.packageId == self.ptpPackage || self.packageId == "-AiDPwdvop1HU7fj8vfL" {
                                    var url = ""
                                    if self.packageId == self.ptpPackage {
                                        url = TweakAndEatURLConstants.ALL_AiBP_CONTENT
                                    } else if self.packageId == "-AiDPwdvop1HU7fj8vfL" {
                                        url = TweakAndEatURLConstants.IND_AiDP_CONTENT
                                    }
                                        APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                                        let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                                            var responseResult = ""
                                            
                                            if responseDic.index(forKey: "callStatus") != nil {
                                                responseResult = responseDic["callStatus"] as! String
                                            } else if responseDic.index(forKey: "CallStatus") != nil {
                                                responseResult = responseDic["CallStatus"] as! String
                                            }
                                        if  responseResult == "GOOD" {
                                            MBProgressHUD.hide(for: self.view, animated: true);
                                            self.navigationItem.hidesBackButton = true;
                                            self.paySucessView.isHidden = false
                                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                                            
                                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                                            
                                            let msg = signature.html2String;
                                            self.nutritionstDescLbl.text =
                                            msg;
                                            
                                        } else{
                                            MBProgressHUD.hide(for: self.view, animated: true);
                                        }
                                    }, failure : { error in
                                        //  print(error?.description)
                                        //            self.getQuestionsFromFB()
                                        MBProgressHUD.hide(for: self.view, animated: true);
                                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
                                        
                                    })
                                    
                                } else {
                                    self.navigationItem.hidesBackButton = true;
                                    self.paySucessView.isHidden = false
                                    self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                                    
                                    let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                                    
                                    let msg = signature.html2String;
                                    self.nutritionstDescLbl.text =
                                    msg;
                                }
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
                            pkgesArr.remove(self.packageId)
                            pkgesArr.add(self.packageId)
                            pkgsArray["packages"] = pkgesArr as AnyObject as! [String]
                            
                        } else {
                            pkgsArray["packages"] = [self.packageId];
                        }
                        
                        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).setValue(["userFbToken":InstanceID.instanceID().token()!, "dietPlan": ["isPublished": false, "status": 0], "purchasedOn": Int64(currentTimeStamp)!], withCompletionBlock: { (error, _) in
                            
                        })
                        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                            if error == nil {
                                //      if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                                if self.packageId == self.ptpPackage || self.packageId == "-AiDPwdvop1HU7fj8vfL" {
                                    var url = ""
                                    if self.packageId == self.ptpPackage {
                                        url = TweakAndEatURLConstants.ALL_AiBP_CONTENT
                                    } else if self.packageId == "-AiDPwdvop1HU7fj8vfL" {
                                        url = TweakAndEatURLConstants.IND_AiDP_CONTENT
                                    }
                                    APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(url, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                                        let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                                        var responseResult = ""
                                        
                                        if responseDic.index(forKey: "callStatus") != nil {
                                            responseResult = responseDic["callStatus"] as! String
                                        } else if responseDic.index(forKey: "CallStatus") != nil {
                                            responseResult = responseDic["CallStatus"] as! String
                                        }
                                        if  responseResult == "GOOD" {
                                            MBProgressHUD.hide(for: self.view, animated: true);
                                            self.navigationItem.hidesBackButton = true;
                                            self.paySucessView.isHidden = false
                                            self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                                            
                                            let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                                            
                                            let msg = signature.html2String;
                                            self.nutritionstDescLbl.text =
                                            msg;
                                            
                                        } else{
                                            MBProgressHUD.hide(for: self.view, animated: true);
                                        }
                                    }, failure : { error in
                                        //  print(error?.description)
                                        //            self.getQuestionsFromFB()
                                        MBProgressHUD.hide(for: self.view, animated: true);
                                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
                                        
                                    })

                                } else {
                                self.navigationItem.hidesBackButton = true;
                                self.paySucessView.isHidden = false
                                self.usdAmtLabel.text = "Thank you for subscribing to " + priceDesc;
                                
                                let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
                                
                                let msg = signature.html2String;
                                self.nutritionstDescLbl.text =
                                msg;
                                }
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

                
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            if error!.code == -1011 {
                self.navigationController?.popViewController(animated: true)
                return
            }
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
    
    @objc func packagLabelSelections() {
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
            print(self.nutritionLabelPackagesArray);
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cellDict = self.moreInfoPremiumPackagesArray[indexPath.row] as! [String : AnyObject];
//        let cellStr = cellDict["text"] as? String
//        if (cellStr?.count)! < 50 {
//            return 60
//        }
//    }

    @IBOutlet weak var moreInfoTableView: UITableView!
    @IBOutlet weak var smallImageView: UIImageView!
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.moreInfoTableView.flashScrollIndicators()
            self.moreInfoSubscribeTextView.flashScrollIndicators()
            self.featuresViewSubscribeTextView.flashScrollIndicators()
            self.packageDescription.flashScrollIndicators()
        }
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    func getAttributedTextForTextView(fullString str: String) -> NSMutableAttributedString {
        let attributedOriginalText = NSMutableAttributedString(string: str)
        let linkRange1 = attributedOriginalText.mutableString.range(of: "http://www.tweakandeat.com/privacy.html")
        let linkRange2 = attributedOriginalText.mutableString.range(of: "http://www.tweakandeat.com/terms-of-use.html")
        attributedOriginalText.addAttribute(.link, value: "http://www.tweakandeat.com/privacy.html", range: linkRange1)
        attributedOriginalText.addAttribute(.link, value: "http://www.tweakandeat.com/terms-of-use.html", range: linkRange2)
       
        return attributedOriginalText
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if textView == self.featuresViewSubscribeTextView || textView == self.moreInfoSubscribeTextView {
            UIApplication.shared.open(URL)
        }
           return false
       }
    @IBAction func scheduleCallTapped(_ sender: Any) {
        
      
        if self.calenderView.selectedDate == 0 || self.timeSlotTextField.text?.count == 0 || self.languageTextField.text?.count == 0{
            if self.calenderView.selectedDate == 0 && self.timeSlotTextField.text?.count != 0 && self.languageTextField.text?.count != 0 {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose a date from calendar !")
            } else if self.timeSlotTextField.text?.count == 0 && self.calenderView.selectedDate != 0 && self.languageTextField.text?.count != 0 {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose time !")
            } else if self.timeSlotTextField.text?.count != 0 && self.calenderView.selectedDate != 0 && self.languageTextField.text?.count == 0 {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose the language !")
            } else {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose date, time and language to schedule a call from our Certified Nutritionists !")
            }
            return
        }
        self.captchaView.isHidden = false
        self.captchInputTF.becomeFirstResponder()
        self.captchViewInfoLbl.text = self.confirmationText
        

        
       }
       @IBAction func cancelCalenderViewTapped(_ sender: Any) {
        self.title = self.navTitle
        self.timeSlotTextField.text = ""
        self.calendarOuterView.isHidden = true
        self.navigationItem.hidesBackButton = false
       }
    
    func getUserCallScheduleDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CHECK_USER_SCHEDULE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      self.checkUserScheduleArray = []
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                      if data.count == 0 {
                          
                      } else {
                          self.checkUserScheduleArray = data
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil);
                      }
                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                      TweakAndEatUtils.AlertView.showAlert(view: self, message: "Could not schedule the call. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
       override func viewWillLayoutSubviews() {
             super.viewWillLayoutSubviews()
             calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
         }

    @objc func updateAreYouSureLbl() {
        if self.calenderView.selectedDate != 0 && self.timeSlotTextField.text!.count > 0 {
            self.areYouSureLbl.isHidden = false
            let date = (self.calenderView.selectedDate < 10) ? "0\(self.calenderView.selectedDate)" : "\(self.calenderView.selectedDate)"
                       let month = (self.calenderView.currentMonthIndex < 10) ? "0\(self.calenderView.currentMonthIndex)" : "\(self.calenderView.currentMonthIndex)"
                       let year = "\(self.calenderView.currentYear)"
            let time = self.timeSlotTextField.text!
            let lang = self.languageTextField.text!
            self.areYouSureLbl.text = "Are you sure you want to fix a call on " + date + "/" + month + "/" + year + " at " + time + "?"
            self.confirmationText = "on " + date + "/" + month + "/" + year + " at " + time + " in " + lang
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        view.endEditing(true);

    }
    
    var fourDigitNumber: String {
     var result = ""
     repeat {
         // Create a string with a random number 0...9999
         result = String(format:"%04d", arc4random_uniform(10000) )
     } while Set<Character>(result.characters).count < 4
     return result
    }

    // USAGE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captchaInnerView.layer.cornerRadius = 10
        self.refreshBtn.layer.cornerRadius = 10
        self.confirmCaptchaBtn.layer.cornerRadius = 10
        
        self.captchaGeneratorTF.text = fourDigitNumber
        self.languageTableView.backgroundColor = UIColor.groupTableViewBackground
         NotificationCenter.default.addObserver(self, selector: #selector(MoreInfoPremiumPackagesViewController.updateAreYouSureLbl), name: NSNotification.Name(rawValue: "DATE_SELECTED"), object: nil)
        self.scheduleBtn.layer.cornerRadius = 15
        self.cancelBtn.layer.cornerRadius = 15
        self.timeSlotTextField.delegate = self
        self.timeSlotTextField.inputView = self.pickerView
        self.timeSlotTextField.inputAccessoryView = self.accessoryToolbar

        self.buyNowButton.alpha = 0.8
        self.buyNowButton.layer.cornerRadius = 10
        self.buyNowMoreInfoBtn.alpha = 0.8
               self.buyNowMoreInfoBtn.layer.cornerRadius = 10
//        self.featuresViewSubscribeTextView.textAlignment = .justified
//        self.moreInfoSubscribeTextView.textAlignment = .justified
        self.moreInfoSubscribeTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.featuresViewSubscribeTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        
        self.featuresViewSubscribeTextView.textColor = UIColor.gray
        self.moreInfoSubscribeTextView.textColor = UIColor.gray
        self.moreInfoSubscribeTextView.layer.cornerRadius = 10;
        self.featuresViewSubscribeTextView.layer.cornerRadius = 10;
//        self.featuresViewSubscribeTextView.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.6)
//        self.moreInfoSubscribeTextView.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.6)
        self.myProfile = uiRealm.objects(MyProfileInfo.self);
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
        if  self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-IndWLIntusoe3uelxER" {
            if UserDefaults.standard.value(forKey: "CALL_SCHEDULED") != nil {
                self.callNutritionistBtn2HeightContraint.isActive = false
                           self.userCallScheduleView2.isHidden = false
                                    self.userCallScheduleView2.layer.cornerRadius = 15
                            self.userCallScheduleView2.layer.borderColor = UIColor.purple.cgColor
                                self.userCallScheduleView2.layer.borderWidth = 3
                
            } else {
                self.userCallScheduleView2.isHidden = true
                self.callNutritionistBtn2HeightContraint.isActive = true
                
                self.callNutritionistBtn2.isHidden = false
            }
            
        } else {
             self.userCallScheduleView2.isHidden = true
            self.userCallScheduleView1.isHidden = true
            self.callNutritionistBtn2.isHidden = true
            self.callNutritionistBtn1.isHidden = true

        }
        if UserDefaults.standard.value(forKey: "CALL_SCHEDULED") != nil {
            let dict = UserDefaults.standard.value(forKey: "CALL_SCHEDULED") as! [String: AnyObject]
            let callDateTime = dict["callDateTime"] as! String
            let userMsisdn = dict["userMsisdn"] as! String
            let yourCallStr: String = "Your CALL has been already scheduled !\n\n"
            let certStr = dict["certNutText"] as AnyObject as! String
            let certNutText = yourCallStr + certStr + " on " + callDateTime
             if self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-IndWLIntusoe3uelxER" {
                    

                // let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn + " on" + callDateTime;
                 let msisdnRange = certNutText.range(of: userMsisdn)
                 let callDateTimeRange =  certNutText.range(of: callDateTime)
                 let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                 certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                 certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                 certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0), range: NSRange(callDateTimeRange!, in: certNutText))
                
                let yourCallRange = certNutText.range(of: "Your CALL has been already scheduled !")
                certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(yourCallRange!, in: certNutText))
                certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(yourCallRange!, in: certNutText))
                 self.callNutritionistTextLbl2.attributedText = certAttrStr
             }
//             else {
//                self.userCallScheduleView1.isHidden = false
//             self.unSubscribeImgViewHeightContraint.isActive = false
//             self.userCallScheduleView1.layer.cornerRadius = 15
//             self.userCallScheduleView1.layer.borderColor = UIColor.purple.cgColor
//             self.userCallScheduleView1.layer.borderWidth = 3
//
//                    // let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn + " on" + callDateTime;
//                                        let msisdnRange = certNutText.range(of: userMsisdn)
//                                        let callDateTimeRange =  certNutText.range(of: callDateTime)
//                                        let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
//                                        certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
//                                        certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
//                                        certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0), range: NSRange(callDateTimeRange!, in: certNutText))
//                                        self.callNutritionistTextLbl1.attributedText = certAttrStr
//             }
        }
      
       self.packageDescription.text = ""
        self.priceLabel.text = " Please choose a subscription plan"
        self.chooseSubScriptionPlanLbl.text = " Please choose a subscription plan"
        SKPaymentQueue.default().add(self)
        
        for myProfileObj in self.myProfile! {
            self.name = myProfileObj.name;
        }
        self.priceLabel.textColor = UIColor.black
        self.chooseSubScriptionPlanLbl.textColor = UIColor.black
        self.moreInfoSelectPlanView.layer.cornerRadius = 10
        self.moreInfoSelectPlanView.layer.borderWidth = 2
        self.moreInfoSelectPlanView.layer.borderColor = UIColor.darkGray.cgColor
        self.selectPlanView.layer.cornerRadius = 10
        self.selectPlanView.layer.borderWidth = 2
        self.selectPlanView.layer.borderColor = UIColor.darkGray.cgColor
        //self.priceLabel.backgroundColor = UIColor.white
        self.moreInfoSubscribeTextView.textContainer.lineBreakMode = .byWordWrapping
        Database.database().reference().child("GlobalVariables").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                        
                           for obj in snapshot.children.allObjects as! [DataSnapshot] {
                            if obj.key == "txt_unsub_message" {
                                       let imageUrl = obj.value as AnyObject as! String
                                       let url = URL(string: imageUrl);
                                       self.unsubScribeImageView.sd_setImage(with: url);
                            } else if obj.key == "ios_terms_pp_buy" {
                                let terms = obj.value as AnyObject as! [String: AnyObject]
                                if  self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == "-IndAiBPtmMrS4VPnwmD" || self.packageId == "-UsaAiBPxnaopT55GJxl" || self.packageId == "-SgnAiBPJlXfM3KzDWR8" || self.packageId == "-IdnAiBPLKMO5ePamQle" || self.packageId == "-MysAiBPyaX9TgFT1YOp" || self.packageId == "-PhyAiBPcYLiSYlqhjbI" || self.packageId == "-MysRamadanwgtLoss99" || self.packageId == "-IndWLIntusoe3uelxER" {
                                    var subscriptionDetailsText = ""
                                    if  self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == "-IndWLIntusoe3uelxER" {
                                        subscriptionDetailsText = terms["auorenewal"] as! String
                                    } else {
                                         subscriptionDetailsText = terms["onetime"] as! String

                                    }
                                                                       self.featuresViewSubscribeTextView.linkTextAttributes = [
                                                                           NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                                           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                                       ]
                                    self.featuresViewSubscribeTextView.text = subscriptionDetailsText.replacingOccurrences(of: "\\n", with: "\n")
                                                                    } else {
                                                                       let subscriptionDetailsText = terms["auorenewal"] as! String
                                                                       self.moreInfoSubscribeTextView.linkTextAttributes = [
                                                                           NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                                           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                                       ]
                                                                       self.moreInfoSubscribeTextView.text = subscriptionDetailsText.replacingOccurrences(of: "\\n", with: "\n")
                                                                   }
                            }

                }
                
            }
           
            
            
        })
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
        self.smallImageView.sd_setImage(with: URL(string: self.smallImage));

        self.infoView.isHidden = true;
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            
            if  self.packageId == "-IndIWj1mSzQ1GDlBpUt" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == "-IndAiBPtmMrS4VPnwmD" || self.packageId == "-UsaAiBPxnaopT55GJxl" || self.packageId == "-SgnAiBPJlXfM3KzDWR8" || self.packageId == "-IdnAiBPLKMO5ePamQle" || self.packageId == "-MysAiBPyaX9TgFT1YOp" || self.packageId == "-PhyAiBPcYLiSYlqhjbI" || self.packageId == "-MysRamadanwgtLoss99" || self.packageId == "-IndWLIntusoe3uelxER" {
                labelsPrice = "pkgRecurPrice"
                self.featuresView.isHidden = false
                self.getPackageDetails()
            } else  {
                self.featuresView.isHidden = true
                MBProgressHUD.showAdded(to: self.view, animated: true)

                APIWrapper.sharedInstance.getDifferencesForUSA(type: self.packageId, { (responceDic : AnyObject!) -> (Void) in
                    if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                        let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                        
                        if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                            let responseArray  = response[TweakAndEatConstants.DATA] as! NSArray;
                            print(responseArray)
                            self.moreInfoPremiumPackagesArray = responseArray.mutableCopy() as! NSMutableArray
                            
                            self.moreInfoTableView.reloadData();
              //TweakAndEatUtils.hideMBProgressHUD();
                            
                            self.getMyTweakAndEatDetails()
                        }
                    } else {
                        //error
                        TweakAndEatUtils.hideMBProgressHUD();
                    }
                }) { (error : NSError!) -> (Void) in
                    //error
                    TweakAndEatUtils.hideMBProgressHUD();
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection and try again..")
                 
                }
            }
//            else {
//                // packageId = "-KyotHu4rPoL3YOsVxUu"
//                if packageId == "-KyotHu4rPoL3YOsVxUu" {
//                    self.infoView.isHidden = true;
//                } else {
//                    self.infoView.isHidden = false;
//
//                }
//                self.packageDescTextView.text = "";
//                self.packageDescTextView.text = self.packageFullDesc;
//                moreInfoPremiumPackagesRef = Database.database().reference().child("PremiumPackageDetailsiOS").child(self.packageId).child("differences");
//                self.getFirebaseData();
//            }
            
        }
    }
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//        print(token.tokenId)
//
//    }
    
    func getPackageDetails() {
        APIWrapper.sharedInstance.getPackageDetails(packageId: self.packageId, { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    TweakAndEatUtils.hideMBProgressHUD();
                    self.getMyTweakAndEatDetails()
                    let  data = response["data"] as AnyObject as! [String: AnyObject]
                    let html = (data["mp_description_ios"] as AnyObject as! String)
                    let htmlData = Data(html.utf8)
                    if let attributedString = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        self.packageDescription.attributedText = attributedString
                    }
                    self.packageDescription.font = UIFont(name: "QUESTRIAL-REGULAR", size: 17)


                   // self.packageDescription.text = (data["mp_description"] as AnyObject as! String).html2String
                    self.packageTitle.text = (data["mp_pkg_title"] as AnyObject as! String)
                    self.title = (data["mp_pg_title"] as AnyObject as! String)
                    self.navTitle = self.title!
                    if (data["mp_id"] as AnyObject as! String) == "-IndIWj1mSzQ1GDlBpUt" || (data["mp_id"] as AnyObject as! String) == "-IndWLIntusoe3uelxER" {

                        
                        self.packagePrice.textColor = UIColor.init(red: 184.0/255.0, green: 35.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                        self.packageTitle.textColor = UIColor.init(red: 110.0/255.0, green: 25.0/255.0, blue: 139.0/255.0, alpha: 1.0)
                        let main_string = (data["mp_pkg_sub_title_ios"] as AnyObject as! String)
                        let string_to_color = "Starts at just ~"
                        
                        let range = (main_string as NSString).range(of: string_to_color)
                        
                        let attribute = NSMutableAttributedString.init(string: main_string)
                        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                        self.packagePrice.attributedText = attribute
                    } else if (data["mp_id"] as AnyObject as! String) == "-AiDPwdvop1HU7fj8vfL" || (data["mp_id"] as AnyObject as! String) == self.ptpPackage {
                        self.packagePrice.textColor = UIColor.init(red: 58.0/255.0, green: 156.0/255.0, blue: 149.0/255.0, alpha: 1.0)
                        self.packageTitle.textColor = UIColor.init(red: 110.0/255.0, green: 25.0/255.0, blue: 139.0/255.0, alpha: 1.0)
                        let main_string = (data["mp_pkg_sub_title_ios"] as AnyObject as! String)
                        let string_to_color = "Starts at just "
                        
                        let range = (main_string as NSString).range(of: string_to_color)
                        
                        let attribute = NSMutableAttributedString.init(string: main_string)
                        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                        self.packagePrice.attributedText = attribute
                    }
                }
            } else {
                //error
                print("error")
                TweakAndEatUtils.hideMBProgressHUD()
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            TweakAndEatUtils.hideMBProgressHUD();
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            //error
        }
    }
    

    @IBAction func buyTapped(_ sender: Any) {
        


         if self.featuresView.isHidden == false {
            if self.priceLabel.text == " Please choose a subscription plan" {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose a subscription plan!");
                return
            }
         } else {
            if self.chooseSubScriptionPlanLbl.text == " Please choose a subscription plan" {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose a subscription plan!");
                return
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true);
        if (SKPaymentQueue.canMakePayments()) {
            self.buyNowButton.isEnabled = false
            let productID:NSSet = NSSet(array: [self.productIdentifier as String]);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        } else {
            print("can't make purchases");
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getFirebaseData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        moreInfoPremiumPackagesRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.moreInfoPremiumPackagesArray = NSMutableArray()
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();

                for moreInfoPremiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let moreInfoPackageObj = moreInfoPremiumPackages.value as? [String : AnyObject];
                    self.moreInfoPremiumPackagesArray.add(moreInfoPackageObj!);
                }
                dispatch_group.leave();

                    dispatch_group.notify(queue: DispatchQueue.main) {
                        print(self.moreInfoPremiumPackagesArray);

                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        self.moreInfoTableView.reloadData();
                        
                    }
                  } else {
                     MBProgressHUD.hide(for: self.view, animated: true);
              }
        })
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "instamojo" {
        let popOverVC = segue.destination as! InstaMojoViewController;
        
        let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        popOverVC.msisdn = "+\(msisdn)";
   
        popOverVC.price = self.price;
        popOverVC.package = self.package;
        popOverVC.name = self.name;
        popOverVC.packageId = self.packageId;
        popOverVC.paymentType = self.paymentType;
        popOverVC.currency = self.currency;
        
    } else if segue.identifier == "stripe" {
            let popOverVC = segue.destination as! StripePaymentGateway;
        if countryCode == "1" {
            popOverVC.packageID = "-MzqlVh6nXsZ2TCdAbOp"
        } else if countryCode == "60" {
            popOverVC.packageID = "-MalAXk7gLyR3BNMusfi"
        } else if countryCode == "65" {
            popOverVC.packageID = "-SgnMyAiDPuD8WVCipga"
        } else if countryCode == "62" {
            popOverVC.packageID = "-IdnMyAiDPoP9DFGkbas"
        } else if countryCode == "91" {
            popOverVC.packageID = self.packageId
            popOverVC.razorPayAPIKEY = self.API_KEY

        }
        var tempDict = [String: AnyObject]();
        if  self.nutritionLabelPackagesArray.count > 0 {
        for dict in self.nutritionLabelPackagesArray {
            let tempDict = dict as! [String: AnyObject]
            self.cardImageString = tempDict["paymentImgStripe"] as AnyObject as! String;
            popOverVC.packageTitle = tempDict["packageTitle"] as AnyObject as! String

        }
        popOverVC.cardImgStr = self.cardImageString
//        for dict in self.nutritionLabelPriceArray {
//            tempDict = dict as! [String : AnyObject];
//            if tempDict[lableCount] as! Int == 12 {
//                self.labelPriceDict  = tempDict
//
//            }
//            }
//            if self.labelPriceDict.count == 0 {
//                tempDict = self.nutritionLabelPriceArray[0] as! [String: AnyObject];
//                self.labelPriceDict  = self.nutritionLabelPriceArray[0] as! [String: AnyObject];
//            }
            self.labelPriceDict  = self.nutritionLabelPriceArray[0] as! [String: AnyObject];

        }
        popOverVC.labelPriceDict = self.labelPriceDict;
        popOverVC.nutritionLabelPriceArray = self.nutritionLabelPriceArray
//let cellDict  = self.labelPriceDict
        popOverVC.pkgDescription = "\(labelPriceDict["pkgDescription"] as AnyObject as! String)";
        popOverVC.pkgDuration = labelPriceDict["pkgDuration"] as AnyObject as! String;
        popOverVC.productIdentifier =  labelPriceDict["productIdentifier"] as AnyObject as! String
        popOverVC.price = "\(labelPriceDict["transPayment"] as AnyObject as! Double)";
        popOverVC.currency = "\(labelPriceDict["currency"] as AnyObject as! String)";
        
        popOverVC.package = (labelPriceDict[lables] as AnyObject as? String)!;
        popOverVC.displayAmount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)";
        popOverVC.displayCurrency = "\(labelPriceDict["display_currency"] as AnyObject as! String)";
        popOverVC.system = system

        
    } else if segue.identifier == "razorpay" {
        let popOverVC = segue.destination as! StripePaymentGateway;
//        if countryCode == "91" {
//            popOverVC.packageID = "-IndIWj1mSzQ1GDlBpUt"
//        }
//        popOverVC.razorPayAPIKEY = self.API_KEY
        var tempDict = [String: AnyObject]();
        if  self.nutritionLabelPackagesArray.count > 0 {
            for dict in self.nutritionLabelPackagesArray {
                let tempDict = dict as! [String: AnyObject]
                self.cardImageString = tempDict["paymentImgStripe"] as AnyObject as! String;
            }
            popOverVC.cardImgStr = self.cardImageString
//            for dict in self.nutritionLabelPriceArray {
//                tempDict = dict as! [String : AnyObject];
//                if tempDict[lableCount] as! Int == 12 {
//                    self.labelPriceDict  = tempDict
//                    
//                }
//            }
//            if self.labelPriceDict.count == 0 {
//                tempDict = self.nutritionLabelPriceArray[0] as! [String: AnyObject];
//                self.labelPriceDict  = tempDict
//            }
            self.labelPriceDict  = self.nutritionLabelPriceArray[0] as! [String: AnyObject];

        }
        popOverVC.labelPriceDict = self.labelPriceDict
        popOverVC.nutritionLabelPriceArray = self.nutritionLabelPriceArray
        //let cellDict  = self.labelPriceDict
        popOverVC.pkgDescription = "\(labelPriceDict["pkgDescription"] as AnyObject as! String)";
        popOverVC.pkgDuration = "\(labelPriceDict["pkgDuration"] as AnyObject as! Int)";
        popOverVC.price = "\(labelPriceDict["amount"] as AnyObject as! Double)";
        popOverVC.currency = "\(labelPriceDict["currency"] as AnyObject as! String)";
        
        popOverVC.package = (labelPriceDict[lables] as AnyObject as? String)!;
        popOverVC.displayAmount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)";
        popOverVC.displayCurrency = "\(labelPriceDict["display_currency"] as AnyObject as! String)";
        popOverVC.system = system;
        
      }
    }
}
// MARK: - UIPickerViewDataSource

extension MoreInfoPremiumPackagesViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int {
    return self.timeSlotsArray.count
  }
}

// MARK: - UIPickerViewDelegate

extension MoreInfoPremiumPackagesViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String? {
    let dict = self.timeSlotsArray[row];
    return (dict["ncts_timeslot"] as! String)
  }

  // Called when the scrolling stops and the row
  // in the center is set as selected.
  func pickerView(_ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int) {
    let dict = self.timeSlotsArray[row];
    self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
  }
}
 
