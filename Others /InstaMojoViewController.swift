//
//  ViewController.swift
//  Sample
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit
//import Instamojo
import Firebase
import Razorpay

class InstaMojoViewController: UIViewController, UITextFieldDelegate, RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RAZORPAY_CANCELLED_BY_USER"), object: nil);
          TweakAndEatUtils.AlertView.showAlert(view: self, message: str);
      }
    
    typealias Razorpay = RazorpayCheckout
    @objc var razorpay: Razorpay!;
    // let API_KEY = "rzp_test_YVm7Z8EyoTlae5"
    @objc let API_KEY = "rzp_live_dFMdQLcE5x9q86";

    @IBOutlet var payButton: UIButton!;
    @IBOutlet var scrollView: UIScrollView!;
    @IBOutlet weak var selectedEnv: UILabel!;
    @IBOutlet weak var environmentSwitch: UISwitch!;
    @IBOutlet weak var nameTextField: UITextField!;
    @IBOutlet weak var emailTextField: UITextField!;
    @IBOutlet weak var phoneNumberTextfield: UITextField!;
    @IBOutlet weak var amountTextField: UITextField!;
    @IBOutlet weak var descriptionTextField: UITextField!;
    
    @objc var transactionID: String!;
    @objc var accessToken: String!;
    @objc var environment: [String : String]!;
    var keyboardHeight: Int!;
    @objc var textField : UITextField!;
    @objc var labelsCount = 0;
    
    @IBOutlet weak var detailsText: UILabel!;
    @objc var paymentType : String = "";
    @objc var displayAmount : String = "";
    @objc var displayCurrency : String = "";
    @objc var pkgDescription : String = "";
    @objc var pkgDuration : String = "";
    
    @objc var price : String = ""
    @objc var name : String = ""
    @objc var package : String = ""
    @objc var msisdn : String = ""
    @objc var packageId : String = ""
    @objc var currency : String = ""
    @objc var countryCode = ""
    @objc var email = ""
    
    
    @IBOutlet var nameDivider: UIView!
    @IBOutlet var nameErrorLable: UILabel!
    @IBOutlet var emailDivider: UIView!
    @IBOutlet var emailErrorLable: UILabel!
    @IBOutlet var phoneNumberDivider: UIView!
    @IBOutlet var phoneNumberErrorLable: UILabel!
    @IBOutlet var amountDivider: UIView!
    @IBOutlet var amountErrorLable: UILabel!
    @IBOutlet var descriptionDivider: UIView!
    @IBOutlet var descriptionErrorLable: UILabel!
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var twetoxStartDate = ""


    
    @objc func payNutritionLabels(_ payment_id: String, price: String) {
        let id:  String = payment_id
        let packageParams =
            ["labelsCount" : self.labelsCount, "amountPaid" : price, "amountCurrency" : self.currency, "paymentId" : id] as [String : Any];
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        
        APIWrapper.sharedInstance.purchaseLabels(sessionString: userSession, packageParams as NSDictionary, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic)
            if responseDic["CallStatus"] as AnyObject as! String == "GOOD" {
                UserDefaults.standard.setValue("YES" , forKey: "PURCHASED_LABELS")
                //TweakAndEatUtils.AlertView.showAlert(view: self, message: "You have sucessfully purchased the labels !!")
                let msg = self.bundle.localizedString(forKey: "sucessful_purchase", value: nil, table: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NUTRITION_LABELS_PURHASE_SUCCESSFUL"), object: nil);

                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "button_ok", value: nil, table: nil)
                , style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
            
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil)
            )
            
        })
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let id:  String = payment_id
        //self.showAlert(errorMessage: "Transaction Successful !!")
        if self.packageId == "-Qis3atRaproTlpr4zIs" {
            self.payNutritionLabels(id, price: self.price)
        } else {
            UserDefaults.standard.setValue("YES", forKey: "PREMIUM_MEMBER")
            
            let msg = "CONGRATULATIONS! on going Premium Member!";
            
            let alertController = UIAlertController(title : "", message: msg, preferredStyle: UIAlertController.Style.alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed");
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    //         if UserDefaults.standard.value(forKey: "NutritionistFirebaseId") == nil {
                    let packageParams =
                        ["packageId" : self.packageId, "amountPaid" : self.price, "amountCurrency" : self.currency, "paymentId" : id] as [String : Any];
                    
                    let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
                    
                    APIWrapper.sharedInstance.packageRegistration(sessionString: userSession, packageParams as NSDictionary, successBlock: {(responseDic : AnyObject!) -> (Void) in
                        print("Sucess");
                        print(responseDic)
                        if responseDic["CallStatus"] as AnyObject as! String == "GOOD" {
                            
                            
                            
                            let data = responseDic["Data"] as AnyObject as! [String: AnyObject]
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
                            self.getNutritionistFBID()
                            
                        }
                        
                    }, failureBlock: {(error : NSError!) -> (Void) in
                        print("Failure");
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                        
                    })
                    //         } else {
                    //            self.performSegue(withIdentifier: "questions", sender: self)
                    //            }
                }
                
            }
            // Add the actions
            alertController.addAction(okAction);
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil);
            
            // }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TWETOX_START_DATE
        if UserDefaults.standard.value(forKey: "TWETOX_START_DATE") != nil {
            twetoxStartDate = UserDefaults.standard.value(forKey: "TWETOX_START_DATE") as! String;
        }
        self.title = ""
        // price = "1.0"
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
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
        
        self.detailsText.text = self.bundle.localizedString(forKey: "details_text", value: nil, table: nil)
        self.payButton.setTitle(self.bundle.localizedString(forKey: "pay_btn", value: nil, table: nil), for: .normal);
        
        amountTextField.isUserInteractionEnabled = false
        descriptionTextField.isUserInteractionEnabled = false
        phoneNumberTextfield.isUserInteractionEnabled = false
        addNotificationToRecievePaymentCompletion()
        self.nameTextField.text = name
        self.emailTextField.text = email
        self.phoneNumberTextfield.text = msisdn
        if self.packageId == "-Qis3atRaproTlpr4zIs" {
          self.amountTextField.text = displayAmount.replacingOccurrences(of: ".0", with: "")
        } else {
        self.amountTextField.text = self.price
        }
       
        self.descriptionTextField.text = package
        
        razorpay = Razorpay.initWithKey(API_KEY, andDelegate: self)
        
        //Add Loader/Spinner To the current view
        
        
        //Set data mutable array to choose from prod and test environment
        environment = ["Production Environment": "production", "Test Environment": "test"]
        
        //Delegate texfield to handle next button click on keyboard
        self.amountTextField.delegate = self
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self
        self.phoneNumberTextfield.delegate = self
        
        //set nameTextField as inital Textfield to handle resigning the responder
        self.textField = self.nameTextField
        
        //Set observer to handle keybaord navigations
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //self.performSegue(withIdentifier: "questions", sender: self)
        
        
    }
    

    
    @objc func showRazorpayPaymentForm(){
        if self.packageId == "-Qis3atRaproTlpr4zIs" {
            let amount = self.price
            let priceValue = (amount as NSString).integerValue
            let razorpayPrice = priceValue * 100
            let params: [String:Any] = [
                "amount" : razorpayPrice,
                "description" : package,
                "image" : "",
                "name" : "Nutrition Labels",
                "display_amount": self.displayAmount.replacingOccurrences(of: ".0", with: ""),
                "display_currency": self.displayCurrency,
                "prefill" : [
                    "contact" : self.msisdn,
                    "email" : emailTextField.text!
                ],
                "theme" : [
                    "color" : "#800080"
                    //"#F37254"
                ]
            ]
            razorpay.open(params)

        }  else {
            let amount = self.price
            let priceValue = (amount as NSString).integerValue
            let razorpayPrice = priceValue * 100
            let params: [String:Any] = [
                "amount" : razorpayPrice,
                "image" : "",
                "name" : self.package,
                "currency" : self.currency,
                "prefill" : [
                    "contact" : self.msisdn,
                    "email" : emailTextField.text!
                ],
                "theme" : [
                    "color" : "#800080"
                    //"#F37254"
                ]
            ]
            razorpay.open(params)

        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    @objc func addNotificationToRecievePaymentCompletion(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentCompletionCallBack), name: NSNotification.Name("INSTAMOJO"), object: nil)
    }
    
    @objc func paymentCompletionCallBack() {
        if UserDefaults.standard.value(forKey: "USER-CANCELLED") != nil {
            self.showAlert(errorMessage: "Transaction cancelled by user, back button was pressed.")
        }
        
        if UserDefaults.standard.value(forKey: "ON-REDIRECT-URL") != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.checkPaymentStatus()
            }
        }
        
        if UserDefaults.standard.value(forKey: "USER-CANCELLED-ON-VERIFY") != nil {
            self.showAlert(errorMessage: "Transaction cancelled by user when trying to verify payment")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.checkPaymentStatus()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Int(keyboardSize.height) - 100
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func showPaymentView(_ sender: Any) {
        self.view.endEditing(true)
        if nameTextField.text?.count == 0 {
            self.nameTextField.becomeFirstResponder()
            return
        }
        
        if emailTextField.text?.count == 0 {
            emailTextField.becomeFirstResponder()
            return
        } else {
            if self.emailTextField.text!.isValidEmail() {
                self.invalidEmail(show: false, error: "")
            }  else {
                
                self.invalidEmail(show: true, error: "Invalid Email")
                return
            }
        }
        if phoneNumberTextfield.text?.count == 0 {
            self.phoneNumberTextfield.becomeFirstResponder()
            return
        }
        let amount = self.amountTextField.text
        if !(amount?.isEmpty)! && !(amount?.contains("."))!{
            self.amountTextField.text = self.amountTextField.text! + ".00"
        }
        payButton.isEnabled = false
        self.textField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        if self.paymentType == "instamojo" {
            fetchOrder()
        } else if self.paymentType == "razorPay" {
            showRazorpayPaymentForm()
        }
        
    }
    
    @objc func fetchOrder() {
        
    }
    
    @objc func createOrder(transactionID: String, accessToken: String) {
        
    }
    @objc func goToQuestionsViewController() {
        self.performSegue(withIdentifier: "questions", sender: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(InstaMojoViewController.goToQuestionsViewController), name: NSNotification.Name(rawValue: "GOTO_QUESTIONS"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(InstaMojoViewController.popBack), name: NSNotification.Name(rawValue: "DISMISS_QUESTIONS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InstaMojoViewController.popBack), name: NSNotification.Name(rawValue: "RAZORPAY_CANCELLED_BY_USER"), object: nil)
        
    }
    
    @objc func popBack() {
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MY_PACKAGES"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.payButton.isEnabled = true
    }

    @objc func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == descriptionTextField {
            self.view.endEditing(true)
        }
    }
    
    //To asssing next responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.nameTextField) {
            self.textField = self.emailTextField
            self.emailTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint.init(x: 0, y: keyboardHeight), animated: true)
            
        } else if (textField == self.emailTextField) {
            
            if self.emailTextField.text!.isValidEmail() {
                self.invalidEmail(show: false, error: "")
                self.textField = self.phoneNumberTextfield
                self.phoneNumberTextfield.becomeFirstResponder()
                scrollView.setContentOffset(CGPoint.init(x: 0, y: keyboardHeight), animated: true)
                
            } else {
                
                self.invalidEmail(show: true, error: "Invalid Email")
                return false
                
            }
            
            //        if emailTextField.text?.count == 0 || self.invalidEmail(show: !getEmailID.isValidEmail().validity, error: "") {
            //
            //                self.invalidEmail(show: true, error: "Invalid Email ")
            //                self.emailTextField.becomeFirstResponder()
            //                return true
            //            } else {
            //                self.invalidEmail(show: false, error: "")
            //
            //            }
            
        } else if(textField == self.phoneNumberTextfield) {
            self.textField = self.amountTextField
            self.amountTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint.init(x: 0, y: keyboardHeight), animated: true)
        } else if (textField == self.amountTextField) {
            let amount = self.amountTextField.text
            if !(amount?.isEmpty)! && !(amount?.contains("."))!{
                self.amountTextField.text = self.amountTextField.text! + ".00"
            }
            self.textField = self.descriptionTextField
            self.descriptionTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint.init(x: 0, y: keyboardHeight), animated: true)
        } else {
            textField.resignFirstResponder()
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.emailTextField) {
            
            if self.emailTextField.text!.isValidEmail() {
                self.invalidEmail(show: false, error: "")
                self.textField = self.phoneNumberTextfield
                self.phoneNumberTextfield.becomeFirstResponder()
            } else {
                
                self.invalidEmail(show: true, error: "Invalid Email")
                return
                
            }
        }
    }
    
    @objc func getNutritionistFBID() {
        let dictionary = ["key1":""]
        if UserDefaults.standard.string(forKey: "userSession") != nil{
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            APIWrapper.sharedInstance.userPremiumPackages(sessionString: userSession, dictionary as NSDictionary, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                print(responseDic)
                if responseDic["CallStatus"] as AnyObject as! String == "GOOD" {
                    
                    let dataDict = responseDic["Data"] as AnyObject as! NSDictionary
                    let dataElement = dataDict["UserPremiumPacks"] as AnyObject as! NSArray
                    var packageDictionary = [String: AnyObject]()
                    var pkgDetailsArray = NSMutableArray()
                    if dataElement.count > 0 {
                        for dict in dataElement {
                            let infoDict = dict as! [String: AnyObject]
                            let nutFBID = infoDict["nut_fb_uid"] as! String
                            let pkgID = infoDict["premium_pack_id"] as! String
                            let datePurchased = infoDict["premium_crt_dttm"] as! String
                            let amountPurchased = infoDict["premium_pay_amount"] as AnyObject
                            packageDictionary["datePurchased"] = datePurchased as AnyObject
                            packageDictionary["amountPurchased"] = amountPurchased as AnyObject
                            packageDictionary["premium_pack_id"] = pkgID as AnyObject
                            packageDictionary["nut_fb_uid"] = nutFBID as AnyObject
                            packageDictionary[pkgID] = nutFBID as AnyObject
                            pkgDetailsArray.add(packageDictionary)
                        }
                        UserDefaults.standard.setValue(pkgDetailsArray , forKey: "PREMIUM_PACKAGES")
                        
                    }
                    if self.packageId == "-SquhLfL5nAsrhdq7GCY" {
                        
                        if let currentUserID = Auth.auth().currentUser?.uid  {
                            let currentDate = Date();
                            let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                            let currentTime = Int64(currentTimeStamp); Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.packageId).setValue(["isChatOpen": true, "packagePublishedOn": currentTime!], withCompletionBlock: { (error, _) in
                                if error == nil {
                                    self.performSegue(withIdentifier: "questions", sender: self)
                                    
                                    
                                }
                            })
                        }
                    } else if self.packageId == "-TacvBsX4yDrtgbl6YOQ" {
                        
                        if let currentUserID = Auth.auth().currentUser?.uid  {
                            let currentDate = Date();
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy/MM/dd"
                            let pkgPurchaseDate = formatter.string(from: currentDate)
                            let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                            let currentTime = Int64(currentTimeStamp); Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.packageId).setValue(["packageStartDate": self.twetoxStartDate, "pkgPurchaseDate": pkgPurchaseDate, "packageDuration": self.labelsCount], withCompletionBlock: { (error, _) in
                                if error == nil {
                                    self.performSegue(withIdentifier: "questions", sender: self)
                                    
                                    
                                }
                            })
                        }
                    } else {
                        self.performSegue(withIdentifier: "questions", sender: self)
                        
                    }
                    
                }
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
            })
        }
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    @objc func checkPaymentStatus() {

    }
    
    @objc func open() {

    }
    
    @objc func fetchOrderFromInstamojo(orderID : String){
       
    }
    
    @objc func invalidName(show: Bool, error: String){
        if show {
            nameErrorLable.isHidden = false
            nameErrorLable.text = error
            nameDivider.backgroundColor = UIColor .red
            
        } else {
            nameErrorLable.isHidden = true
            nameDivider.backgroundColor = UIColor .groupTableViewBackground
        }
    }
    
    @objc func invalidEmail(show: Bool, error: String){
        if show {
            emailErrorLable.isHidden = false
            emailErrorLable.text = error
            emailDivider.backgroundColor = .red
            
        } else {
            emailErrorLable.isHidden = true
            emailDivider.backgroundColor = .groupTableViewBackground
        }
        
    }
    
    @objc func invalidPhoneNumber(show: Bool, error: String){
        if show {
            phoneNumberErrorLable.isHidden = false
            phoneNumberErrorLable.text = error
            phoneNumberDivider.backgroundColor = .red
            
        }else{
            phoneNumberErrorLable.isHidden = true
            phoneNumberDivider.backgroundColor = .groupTableViewBackground
        }
        
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    @objc func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @objc func invalidAmount(show: Bool, error: String){
        if show {
            amountErrorLable.isHidden = false
            amountErrorLable.text = error
            amountDivider.backgroundColor = .red
            
        }else{
            amountErrorLable.isHidden = true
            amountDivider.backgroundColor = .groupTableViewBackground
        }
    }
    
    @objc func invalidDescription(show: Bool, error: String){
        if show {
            descriptionErrorLable.isHidden = false
            descriptionErrorLable.text = error
            descriptionDivider.backgroundColor = .red
            
        }else{
            descriptionErrorLable.isHidden = true
            descriptionDivider.backgroundColor = .groupTableViewBackground
        }
    }
}

public extension NSMutableURLRequest {
    @objc func setBodyContent(parameters: [String : Any]) {
        let parameterArray = parameters.map { (key, value) -> String in
            return "\(key)=\((value as AnyObject))"
        }
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                                             options: [.caseInsensitive])
        
        return regex.firstMatch(in: self, options:[],
                                range: NSMakeRange(0, utf16.count)) != nil
    }
}
