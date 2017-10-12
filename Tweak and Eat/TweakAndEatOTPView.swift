//
//  TewakAndOTPView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 05/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData

class TweakAndEatOTPView: UIView {

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
    @IBOutlet var OTPTextField: AllowedCharsTextField!
    
    var delegate : WelcomeViewController! = nil;
    var tweakFinalView : TweakAndEatFinalIntroScreen! = nil;

    func beginning() {
      //  OTPTextField.delegate = self;
        if (UIScreen.main.bounds.size.height == 480 || UIScreen.main.bounds.size.height == 568) {
            self.frame = CGRect(x:0, y: -100, width: self.frame.size.width, height: self.frame.size.height)
        }
        OTPTextField.autocorrectionType = .no;
        OTPTextField.keyboardType = UIKeyboardType.numberPad;
        OTPTextField.becomeFirstResponder();
        logoBorderView.clipsToBounds = true;
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2;
        animationView.clipsToBounds = true;
        animationView.layer.cornerRadius = animationView.frame.size.width / 2;
        logoView.clipsToBounds = true;
        logoView.layer.cornerRadius = logoView.frame.size.width / 2;
        logoImageView.clipsToBounds = true;
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(sendANDVerifyButton.titleLabel?.text == "SEND CODE") {
            if(OTPTextField.text == "") {
                let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter valid phone", delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            } else {
                TweakAndEatUtils.showMBProgressHUD();
                delegate.msisdn = "91" + OTPTextField.text!;
                self.sendOTPForMSISDN();
            }
        } else {
            let code = UserDefaults.standard.value(forKey: TweakAndEatConstants.STORED_OTP_KEY);
            if(code != nil && OTPTextField.text != nil && OTPTextField.text != "") {
                if(Int32(OTPTextField.text!) == (code as! NSNumber).int32Value) {
                    delegate.switchToFourthScreen();
                } else {
                    let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter Valid OTP", delegate: nil, cancelButtonTitle: "OK");
                    alert.show();
                }
            } else {
                let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter OTP", delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            }
            textField.resignFirstResponder();
        }
        
        return true;
        
    }
    
    @IBAction func onClickOfResendButton(_ sender: AnyObject) {
        self.sendOTPForMSISDN();
        //self.delegate.switchToThirdScreen()
    }
    
    @IBAction func onClickOfVerifyAndSendButton(_ sender: AnyObject) {
        let button : UIButton = sender as! UIButton;
        
        if(button.titleLabel?.text == "SEND CODE") {
            if(OTPTextField.text == "") {
                let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter valid phone", delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            } else {
                TweakAndEatUtils.showMBProgressHUD();
                delegate.msisdn = "91" + OTPTextField.text!;
                //UserDefaults.standard.setValue(delegate.msisdn, forKey: "msisdn");
                self.sendOTPForMSISDN();
            }
        } else if(button.titleLabel?.text == "VERIFY") {
            OTPTextField.textAlignment = .center;
            OTPTextField.becomeFirstResponder();
            let code = UserDefaults.standard.value(forKey: TweakAndEatConstants.STORED_OTP_KEY);
            if(code != nil && OTPTextField.text != nil && OTPTextField.text != "" && OTPTextField.text?.characters.count == 5) {
                if(Int32(OTPTextField.text!) == (code as! NSNumber).int32Value) {
                    self.delegate.switchToFourthScreen();
    
                } else {
                    let alert : UIAlertView = UIAlertView(title: "Alert", message: "Invalid OTP", delegate: nil, cancelButtonTitle: "OK");
                    alert.show();
                }
            } else {
                
                if(OTPTextField.text == "") {
                    let alert : UIAlertView = UIAlertView(title: "Alert", message: "Please enter valid OTP", delegate: nil, cancelButtonTitle: "OK");
                    alert.show();
                } else {
                    
                    
                    let alert : UIAlertView = UIAlertView(title: "Alert", message: "You account is in 'Blocked' status\n\nAn account is usually blocked if a user violates our 'Terms of Use'.You can please contact us at appsmanager@purpleteal.com to request ‘Unblocking’ the account.", delegate: nil, cancelButtonTitle: "OK");
                    alert.show();
                }
            }
        }
    }
    
    func sendOTPForMSISDN() {
        
        TweakAndEatUtils.hideMBProgressHUD();
        let mobileNumber = delegate.msisdn
        let params : NSDictionary = NSDictionary(object: mobileNumber!, forKey: "msisdn" as NSCopying);
        APIWrapper.sharedInstance.getRegistrationCode(params, successBlock: { (response : AnyObject!) -> (Void) in
            TweakAndEatUtils.hideMBProgressHUD();
            if(TweakAndEatUtils.isValidResponse(response as? [String:AnyObject])) {
                self.sendANDVerifyButton.setTitle("VERIFY", for: UIControlState());
                self.resendButton.isHidden = false;
                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                print(responseDic)
                
                if(responseDic[TweakAndEatConstants.OTP_VALUE] != nil) {
                    UserDefaults.standard.set(responseDic[TweakAndEatConstants.OTP_VALUE], forKey: TweakAndEatConstants.STORED_OTP_KEY)
//                    let otpString: String = ((responseDic[TweakAndEatConstants.OTP_VALUE] as! NSNumber).int32Value) as AnyObject as! String
//                    if otpString.characters.count > 5 {
//                        let alert : UIAlertView = UIAlertView(title: "Alert", message: "You account is in 'Blocked' status\n\nAn account is usually blocked if a user violates our 'Terms of Use'.You can please contact us at appsmanager@purpleteal.com to request ‘Unblocking’ the account.", delegate: nil, cancelButtonTitle: "OK");
//                        alert.show();
//
//                        TweakAndEatUtils.hideMBProgressHUD();
//
//                    }
                    print("OTP number %@",responseDic[TweakAndEatConstants.OTP_VALUE] ?? "");
                    
                    self.OTPTextField.center = CGPoint(x: self.otpView.center.x, y: self.OTPTextField.center.y);
                    self.textLineBorder.center = CGPoint(x: self.otpView.center.x, y: self.textLineBorder.center.y);
                    
                    self.flagImage.isHidden = true;
                    self.countryCodeLabel.isHidden = true;
                    self.OTPTextField.text = "";
                }
            } else {
                TweakAndEatUtils.hideMBProgressHUD();
               
            }
        }) { (error : NSError!) -> (Void) in
            TweakAndEatUtils.hideMBProgressHUD();
            let alert : UIAlertView = UIAlertView(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", delegate: nil, cancelButtonTitle: "OK");
            alert.show();
            //error
        }
    }
}
