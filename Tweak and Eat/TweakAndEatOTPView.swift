//
//  TewakAndOTPView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 05/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData

class TweakAndEatOTPView: UIView, UITextFieldDelegate {
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var emailTextLineBorder: UILabel!
    @objc var bundle = Bundle()
    var phoneNumber = ""
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailHintView: UIView!
    @IBOutlet weak var emailHintLabel: UILabel!
    @IBOutlet weak var phoneNumberHintView: UIView!
    @IBOutlet weak var otpLangDescLabel: UILabel!
    
    @IBOutlet var textLineBorder: UILabel!;
    @IBOutlet var otpView: UIView!;
    @IBOutlet var flagImage: UIImageView!;
    @IBOutlet var countryCodeLabel: UILabel!;
    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var logoBorderView: UIView!;
    @IBOutlet var resendButton: UIButton!;
    @IBOutlet var sendANDVerifyButton: UIButton!;
    @IBOutlet var OTPTextField: UITextField!;
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var numberHintLabel: UILabel!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var otpLanguageView: UIView!
    @objc var bmi : String = ""
    @objc var minMobileNumberLength = 12
    @objc var countryCode = ""
    @objc var ctrPhoneMax = 0
    @objc var ctrPhoneMin = 0
    @objc var resendTapped = false
    
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var countryCodesParentView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodePickerView: UIPickerView!
    
    @objc var delegate : WelcomeViewController! = nil;
    @objc var tweakFinalView : TweakAndEatFinalIntroScreen! = nil;

    @objc func beginning() {
        path = Bundle.main.path(forResource: "en", ofType: "lproj")
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
        if IS_iPHONE5 {
            self.numberHintLabel.font = UIFont(name: "QUESTRIAL-REGULAR", size: 11)
            self.OTPTextField.font = UIFont(name: "QUESTRIAL-REGULAR", size: 16)
        } else if IS_iPHONE678 {
            self.numberHintLabel.font = UIFont(name: "QUESTRIAL-REGULAR", size: 13)
            self.OTPTextField.font = UIFont(name: "QUESTRIAL-REGULAR", size: 18)
        }
        self.flagImage.isUserInteractionEnabled = true
        self.flagImage.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.flagImage.layer.borderWidth = 2
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage));
        tapped.numberOfTapsRequired = 1;
        self.flagImage?.addGestureRecognizer(tapped);
        OTPTextField.autocorrectionType = .no;
        OTPTextField.tintColor = .black
        OTPTextField.keyboardType = UIKeyboardType.numberPad;
        
        logoBorderView.clipsToBounds = true;
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2;
        animationView.clipsToBounds = true;
        animationView.layer.cornerRadius = animationView.frame.size.width / 2;
        logoView.clipsToBounds = true;
        logoView.layer.cornerRadius = logoView.frame.size.width / 2;
        logoImageView.clipsToBounds = true;
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2;
        
        self.phoneNumberHintView.layer.borderColor = UIColor.darkGray.cgColor;
        self.phoneNumberHintView.layer.borderWidth = 1.0;
        self.phoneNumberHintView.layer.cornerRadius = 5
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        self.countryCodesParentView.isHidden = true
//        if  ((self.OTPTextField.text?.count)! > self.ctrPhoneMax)  {
//            let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter a valid phone number!", delegate: nil, cancelButtonTitle: "OK");
//            alert.show();
//            return
//
//        }
        
    }

    @IBAction func pickerViewDoneBtnTapped(_ sender: Any) {
        self.countryCodesParentView.isHidden = true
        if self.countryCode == "" {
            self.OTPTextField.resignFirstResponder()
            if self.countryCodesParentView.isHidden == true {
                self.bmi = "countryCodes"
                self.countryCodesParentView.isHidden = false
                self.delegate.getAllCountryCodes()
               
            }
        }
    }
    
    @IBAction func pickerViewCancelBtnTapped(_ sender: Any) {
        self.countryCodesParentView.isHidden = true
        if self.countryCode == "" {
            self.OTPTextField.resignFirstResponder()
            if self.countryCodesParentView.isHidden == true {
                self.bmi = "countryCodes"
                self.countryCodesParentView.isHidden = false
                
                self.delegate.getAllCountryCodes()
    
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
         let maxLength = self.ctrPhoneMax
         let currentString: NSString = textField.text! as NSString
         let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
         return newString.length <= maxLength

    }
    
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(sendANDVerifyButton.titleLabel?.text == bundle.localizedString(forKey: "button_send_code", value: nil, table: nil)) {
                    if  ((self.OTPTextField.text?.count)! > self.ctrPhoneMax)  {
                        let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "enter_validnum_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                        alert.show();
                        return true
            
                    }
            
           
            if(OTPTextField.text == "") {
                let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "enter_validnum_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                alert.show();
            } else {
                TweakAndEatUtils.showMBProgressHUD();
                delegate.msisdn = (self.countryCodeTextField.text?.replacingOccurrences(of: "+", with: ""))! + OTPTextField.text!;
                self.phoneNumber = self.OTPTextField.text!

                self.sendOTPForMSISDN();
            }
        } else {
            let code = UserDefaults.standard.value(forKey: TweakAndEatConstants.STORED_OTP_KEY);
            if(code != nil && OTPTextField.text != nil && OTPTextField.text != "") {
                if(Int32(OTPTextField.text!) == (code as! NSNumber).int32Value) {
                    delegate.switchToFourthScreen();
                } else {
                    let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "valid_otp", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                    alert.show();
                }
            } else {
                let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "enter_otp_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                alert.show();
            }
            textField.resignFirstResponder();
        }
        
        return true;
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print(OTPTextField.text!.prefix(1))
//        if  (OTPTextField.text!.prefix(1)) == "0" {
//            self.OTPTextField.text = ""
//        }
//        return true
//    }

    
    
    @IBAction func onClickOfResendButton(_ sender: AnyObject) {
        self.resendTapped = true
        self.sendOTPForMSISDN();
    }
    
    @IBAction func onClickOfVerifyAndSendButton(_ sender: AnyObject) {
            let button : UIButton = sender as! UIButton;
            
            if(button.titleLabel?.text == bundle.localizedString(forKey: "button_send_code", value: nil, table: nil)) {
                
                if  ((self.OTPTextField.text?.count)! > self.ctrPhoneMax)  {
                    let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "enter_validnum_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                    alert.show();
                    return
                    
                }
                
                print(OTPTextField.text!.prefix(1))
                if  (OTPTextField.text!.prefix(1)) == "0" {
                     //self.OTPTextField.text = ""
                    let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "no_zero_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                    alert.show();
                    return
                }
                
                if(OTPTextField.text == "") {
                    let alert : UIAlertView = UIAlertView(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "enter_validnum_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: bundle.localizedString(forKey: "ok", value: nil, table: nil));
                    alert.show();
                   
                } else {
                    if self.countryCodeTextField.text == self.countryCode {
                        
    //                    if (self.OTPTextField.text?.count)! < self.minMobileNumberLength {
    //                    let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter a valid phone number!", delegate: nil, cancelButtonTitle: "OK");
    //                    alert.show();
    //                    return
    //                    }
                    }
                    
                    if ((self.OTPTextField.text?.count)! < self.ctrPhoneMin || (self.OTPTextField.text?.count)! > self.ctrPhoneMax) {
                        let alert : UIAlertView = UIAlertView(title:  bundle.localizedString(forKey: "alert", value: nil, table: nil), message:  bundle.localizedString(forKey: "enter_validnum_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle:  bundle.localizedString(forKey: "ok", value: nil, table: nil));
                        alert.show();
                        return
                        
                    }
                    TweakAndEatUtils.showMBProgressHUD();
                    delegate.msisdn = (self.countryCodeTextField.text?.replacingOccurrences(of: "+", with: ""))! + OTPTextField.text!;
                    self.countryCodeTextField.isHidden = true
                    self.phoneNumberHintView.isHidden = true
                    self.flagImage.isHidden = true
                    self.OTPTextField.placeholder = "Please enter OTP"
                    self.OTPTextField.becomeFirstResponder()
                    self.countryCodePickerView.isHidden = true
                    self.countryCodesParentView.isHidden = true
                    self.phoneNumber = self.OTPTextField.text!
                    self.sendOTPForMSISDN();
                }
            } else if(button.titleLabel?.text == bundle.localizedString(forKey: "button_verify", value: nil, table: nil)) {
                OTPTextField.textAlignment = .center;
                OTPTextField.becomeFirstResponder();
                let code = UserDefaults.standard.value(forKey: TweakAndEatConstants.STORED_OTP_KEY);
                if(code != nil && OTPTextField.text != nil && OTPTextField.text != "" && OTPTextField.text?.characters.count == 5) {
                    if(Int32(OTPTextField.text!) == (code as! NSNumber).int32Value) {
                        self.getISOCountryCode()
        
                    } else {
                        let alert : UIAlertView = UIAlertView(title:  bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "invalid_otp", value: nil, table: nil), delegate: nil, cancelButtonTitle:  bundle.localizedString(forKey: "ok", value: nil, table: nil));
                        alert.show();
                    }
                } else {
                    
                        let alert : UIAlertView = UIAlertView(title:  bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "valid_otp", value: nil, table: nil), delegate: nil, cancelButtonTitle:  bundle.localizedString(forKey: "ok", value: nil, table: nil));
                        alert.show();
                    
                }
            }
        }
    
    @objc func getISOCountryCode() {
        
        APIWrapper.sharedInstance.getAllOtherCountryCodes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    for dict in response[TweakAndEatConstants.DATA] as AnyObject as! NSArray {
                        let dictionary = dict as! NSDictionary
                        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                            if "\(dictionary["ctr_phonecode"] as AnyObject)"  == "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)" {
                                let isoCountryCode: String = "\(dictionary["ctr_iso"] as AnyObject)"
                                UserDefaults.standard.setValue(isoCountryCode, forKey: "COUNTRY_ISO")
                                self.delegate.switchToFourthScreen();
                                
                            }
                        }
                        
                        //                        if (dictionary["ctr_active"] as AnyObject) as! Bool == true {
                        //
                        //                        }
                    }
                    
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        // self.allCountryArray = response[TweakAndEatConstants.DATA] as AnyObject as! NSArray
                        
                    }
                }
            } else {
                //error
                print("error")
                // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            TweakAndEatUtils.hideMBProgressHUD()
            // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        }
    }
    
    @objc func tappedOnImage(sender:UITapGestureRecognizer) {
        
        self.OTPTextField.resignFirstResponder()
        if self.countryCodesParentView.isHidden == true {
            self.bmi = "countryCodes"
            self.countryCodesParentView.isHidden = false
            
            self.countryCodeTextField.inputView = self.countryCodePickerView
            self.countryCodePickerView.reloadAllComponents()
            
        }
        if self.countryCode == "" {
            self.delegate.getAllCountryCodes()
        }
        
    }
    
    @IBAction func countryCodeBtnTapped(_ sender: Any) {
     
        self.OTPTextField.resignFirstResponder()
        if self.countryCodesParentView.isHidden == true {
        self.bmi = "countryCodes"
        self.countryCodesParentView.isHidden = false
           
        self.countryCodeTextField.inputView = self.countryCodePickerView
        self.countryCodePickerView.reloadAllComponents()

        }
        if self.countryCode == "" {
            self.delegate.getAllCountryCodes()
        }
    }
    
    @objc func sendOTPForMSISDN() {
            
            TweakAndEatUtils.hideMBProgressHUD();
            
            var params : NSDictionary = ["ccode": self.countryCodeTextField.text?.replacingOccurrences(of: "+", with: ""), "msisdn":                 self.phoneNumber];
            APIWrapper.sharedInstance.getRegistrationCode(params, successBlock: { (response : AnyObject!) -> (Void) in
                TweakAndEatUtils.hideMBProgressHUD();
                if(TweakAndEatUtils.isValidResponse(response as? [String:AnyObject])) {
            self.sendANDVerifyButton.setTitle(self.bundle.localizedString(forKey: "button_verify", value: nil, table: nil), for: UIControl.State());
                    self.resendButton.isHidden = false;
                    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                    print(responseDic)
                    
                    if(responseDic[TweakAndEatConstants.OTP_VALUE] != nil) {
                        UserDefaults.standard.set(responseDic[TweakAndEatConstants.OTP_VALUE], forKey: TweakAndEatConstants.STORED_OTP_KEY)
                        if self.resendTapped == true {
                            self.resendTapped = false
                            let alert : UIAlertView = UIAlertView(title: self.bundle.localizedString(forKey: "sucess_alert", value: nil, table: nil), message: self.bundle.localizedString(forKey: "sucess_otp_alert", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                            alert.show();
                        }
                        print("OTP number %@",responseDic[TweakAndEatConstants.OTP_VALUE] ?? "");
                        
                        self.OTPTextField.center = CGPoint(x: self.otpView.center.x, y: self.OTPTextField.center.y);
                        self.textLineBorder.center = CGPoint(x: self.otpView.center.x, y: self.textLineBorder.center.y);
                        
                        self.flagImage.isHidden = true;
                        self.countryCodeLabel.isHidden = true;
                        self.numberHintLabel.isHidden = true;
                        
                        self.OTPTextField.text = "";
                    }
                        
                } else {
                    TweakAndEatUtils.hideMBProgressHUD();
                   
                }
            }) { (error : NSError!) -> (Void) in

                TweakAndEatUtils.hideMBProgressHUD();
    //            let alert : UIAlertView = UIAlertView(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: "OK");
    //            alert.show();
                //error
            }
        }
    
    @IBAction func bahasaTapped(_ sender: Any) {
        delegate.languageSelectedAgain(lang: "BA")
    }
    @IBAction func englishTapped(_ sender: Any) {
        delegate.languageSelectedAgain(lang: "EN")
    }
    
}
