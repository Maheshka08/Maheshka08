//
//  TweakAndEatOptionsView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 06/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatOptionsView: UIView, UITextFieldDelegate {
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet var nickNameField: AllowedCharsTextField!
    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var logoBorderView: UIView!;
    @IBOutlet var optionsView: UIView!;
    @IBOutlet var nextButton: UIButton!;
    @IBOutlet var prevButton: UIButton!;
   
    @IBOutlet var genderView: UIView!;
    var genderSelectionSize : CGFloat!;
    @objc let borderLabel : UILabel = UILabel();
    @objc var bmi : String = ""
    
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var bmiPickerView: UIPickerView!
    
    @IBOutlet weak var pickerViewDone: UIBarButtonItem!
    @IBOutlet weak var pickerViewCancel: UIBarButtonItem!
    
    @IBOutlet weak var selectBodyShapeLbl: UILabel!
    @IBOutlet weak var genderOkBtn: UIButton!
    @IBOutlet weak var genderPrevBtn: UIButton!
    
    @objc var bodyshapenumber : String!;
    @objc var allergies : NSArray! = nil;
    
    @IBOutlet var option1: UIImageView!;
    @IBOutlet var option2: UIImageView!;
    @IBOutlet var option3: UIImageView!;
    @IBOutlet var option4: UIImageView!;
    @IBOutlet var option5: UIImageView!;
    @IBOutlet var option6: UIImageView!;
    
    @IBOutlet var mlabel1: UILabel!;
    @IBOutlet var label2: UILabel!;
    @IBOutlet var mlabel3: UILabel!;
    @IBOutlet var mlabel4: UILabel!;
    @IBOutlet var mlabel5: UILabel!;
    @IBOutlet var flabel6: UILabel!;
    
    @IBOutlet weak var maleLabel: UILabel!;
    @IBOutlet var tweakGenderView: UIView!;
    
    @IBOutlet weak var femaleLabel: UILabel!;
    @IBOutlet weak var ageTextField: AllowedCharsTextField!;
    @IBOutlet weak var heightTextField: AllowedCharsTextField!;
    @IBOutlet weak var weightTextField: AllowedCharsTextField!;
    
    @objc var bodyShapesToBeShown : NSMutableArray! = nil;
    
    @objc var optionsList : NSArray! = nil;
    @objc var bodyShapes : NSArray! = nil;
    @objc var delegate : WelcomeViewController! = nil;
    
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!;
    @IBOutlet var genderLabel: UILabel!;
    
    @objc func showFootAndInchesFromCm(_ cms: Double) -> String {
        
        let feet = cms * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetShow)'\(inches)"
    }
    
    @objc func setAgeOptions() {
        
        delegate.selectedAge = self.ageTextField.text as NSString?;
        delegate.weight = self.weightTextField.text as NSString?;
        delegate.height = self.heightTextField.text as NSString?;
        
    }
    
 
    
    @IBAction func pickerViewDoneAct(_ sender: Any) {
        if self.bmi == "weight"{
            if self.weightTextField.text == "" {
                self.weightTextField.text = "140"
            }
        } else if self.bmi == "height"{
            if self.heightTextField.text == "" {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                    if countryCode == "1" {
                        self.heightTextField.text = "4'0''"
                        delegate.totalCMS = "121"
                    } else {
                        self.heightTextField.text = "121"
                    }
                }
                
            }
        }
          self.pickerParentView.isHidden = true
    }
    
    @IBAction func pickerViewCancelAct(_ sender: Any) {
        self.pickerParentView.isHidden = true
    }
    
    @IBAction func weightFieldTapped(_ sender: Any) {
        self.endEditing(true)
        self.bmi = "weight"
        self.pickerParentView.isHidden = false
        self.bmiPickerView.reloadAllComponents()
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//            if countryCode == "1" {
                if weightTextField.text?.count == 0 {
                    self.bmiPickerView.selectRow(120, inComponent: 0, animated: true)
                    self.weightTextField.text = "140"

                } else {
                let wgt = Int(weightTextField.text!)
                
                self.bmiPickerView.selectRow(wgt! - 20, inComponent: 0, animated: true)
            }
           // }
        //}
        
    }
    
    @IBAction func heightFieldTapped(_ sender: Any) {
        self.endEditing(true)
        self.bmi = "height"
        self.pickerParentView.isHidden = false
        self.bmiPickerView.reloadAllComponents()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "1" {
                if heightTextField.text?.count == 0 {
                    self.bmiPickerView.selectRow(2, inComponent: 0, animated: true)
                    self.bmiPickerView.selectRow(0, inComponent: 1, animated: true)

                } else {
                let height = heightTextField.text!
                let feetArray = height.components(separatedBy: "'")
                let feetInInt = Int(feetArray[0])
                let inchInInt = Int(feetArray[1])
                
                self.bmiPickerView.selectRow(feetInInt! - 2, inComponent: 0, animated: true)
                self.bmiPickerView.selectRow(inchInInt!, inComponent: 1, animated: true)
                }
            } else if countryCode == "91"  {
                var heightInDouble: Double = 0.0
                if heightTextField.text?.count == 0 {
                    self.bmiPickerView.selectRow(2, inComponent: 0, animated: true)
                    self.bmiPickerView.selectRow(0, inComponent: 1, animated: true)
                    
                } else {
                    heightInDouble = Double(heightTextField.text!)!
                    let hgtInString = showFootAndInchesFromCm(heightInDouble)
                let feetArray = hgtInString.components(separatedBy: "'")
                let feetInInt = Int(feetArray[0])
                let inchInInt = Int(feetArray[1])
                self.bmiPickerView.selectRow(feetInInt! - 2, inComponent: 0, animated: true)
                self.bmiPickerView.selectRow(inchInInt!, inComponent: 1, animated: true)
//                self.bmiPickerView(self.bmiPickerView, didSelectRow: feetInInt! - 2, inComponent: 0)
//                self.bmiPickerView(self.bmiPickerView, didSelectRow: inchInInt!, inComponent: 1)
            }
            } else {
                if heightTextField.text?.count == 0 {
                    self.bmiPickerView.selectRow(120, inComponent: 0, animated: true)
                    self.heightTextField.text = "140"
                    
                } else {
                    let wgt = Int(heightTextField.text!)
                    
                    self.bmiPickerView.selectRow(wgt! - 20, inComponent: 0, animated: true)
                }

            }
        }
        
    }
    
    @objc func setGenderOptions() {
      
        maleLabel.text = self.bundle.localizedString(forKey: "male", value: nil, table: nil);
        maleLabel.tag = 100;
        self.selectLabel(maleLabel);
        femaleLabel.text = self.bundle.localizedString(forKey: "female", value: nil, table: nil);
        femaleLabel.tag = 101;
        self.deselectLabel(femaleLabel);
        maleLabel.isUserInteractionEnabled = true;
        femaleLabel.isUserInteractionEnabled = true;
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelGenderOptionTapped(_:)));
        tapGesture.numberOfTapsRequired = 1;
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelGenderOptionTapped(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        maleLabel.addGestureRecognizer(tapGesture);
        femaleLabel.addGestureRecognizer(tapGesture1);
        
        self.optionsView.addSubview(maleLabel);
        self.optionsView.addSubview(femaleLabel);
        
    }
    
    @objc func setImageViewsOfGender() {
        genderSelectionSize = self.option1.frame.size.width ;
        borderLabel.backgroundColor = UIColor.green;
        borderLabel.layer.cornerRadius = genderSelectionSize / 2;
        borderLabel.layer.masksToBounds = true;
        borderLabel.tag = 199;
        
        self.tweakGenderView.addSubview(borderLabel);
        
        
        borderLabel.frame = CGRect(x: option1.frame.minX, y: option1.frame.minY, width: genderSelectionSize, height: genderSelectionSize);
        
        option1.tag = 200;
        option1.layer.cornerRadius = genderSelectionSize / 2;
        option1.layer.borderWidth = 1;
        option1.layer.borderColor = UIColor.white.cgColor;
        option1.layer.masksToBounds = true;
        option1.contentMode = UIView.ContentMode.scaleAspectFit;
        
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        option1.addGestureRecognizer(tapGesture1);
        option1.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option1);
        
        option2.tag = 201;
        option2.layer.cornerRadius = genderSelectionSize / 2;
        option2.layer.borderWidth = 1;
        option2.layer.borderColor = UIColor.white.cgColor;
        option2.layer.masksToBounds = true;
        
        let tapGesture2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture2.numberOfTapsRequired = 1;
        option2.addGestureRecognizer(tapGesture2);
        option2.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option2);
        
        option3.tag = 202;
        option3.layer.cornerRadius = genderSelectionSize / 2;
        option3.layer.borderWidth = 1;
        option3.layer.borderColor = UIColor.white.cgColor;
        option3.layer.masksToBounds = true;
        
        let tapGesture3 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture3.numberOfTapsRequired = 1;
        option3.addGestureRecognizer(tapGesture3);
        option3.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option3);
       
        option4.tag = 203;
        option4.layer.cornerRadius = genderSelectionSize / 2;
        option4.layer.borderWidth = 1;
        option4.layer.borderColor = UIColor.white.cgColor;
        option4.layer.masksToBounds = true;
        
        let tapGesture4 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture4.numberOfTapsRequired = 1;
        option4.addGestureRecognizer(tapGesture4);
        option4.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option4);
      
        option5.tag = 204;
        option5.layer.cornerRadius = genderSelectionSize / 2;
        option5.layer.borderWidth = 1;
        option5.layer.borderColor = UIColor.white.cgColor;
        option5.layer.masksToBounds = true;
        let tapGesture5 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture5.numberOfTapsRequired = 1;
        option5.addGestureRecognizer(tapGesture5);
        option5.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option5);
        
        
        option6.tag = 205;
        option6.layer.cornerRadius = genderSelectionSize / 2;
        option6.layer.borderWidth = 1;
        option6.layer.borderColor = UIColor.white.cgColor;
        option6.layer.masksToBounds = true;
        
        let tapGesture6 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelSizeOptionTapped(_:)));
        tapGesture6.numberOfTapsRequired = 1;
        option6.addGestureRecognizer(tapGesture6);
        option6.isUserInteractionEnabled = true;
        
        self.tweakGenderView.addSubview(option6);
        
    }
    
    @IBAction func tweakGenderImagePrevTapped(_ sender: Any) {
        
        let age = self.ageTextField;
        let weight = self.weightTextField;
        let height = self.heightTextField;
        let nickName = self.nickNameField;
        self.prevButton.isHidden = true;
        
        self.optionsView.isHidden = false;
        self.tweakGenderView.isHidden = true;
        if((age?.text?.isEmpty)! || (weight?.text?.isEmpty)! || (height?.text?.isEmpty)! || (nickName?.text?.isEmpty)!) {
            self.optionsView.isHidden = false;
            self.tweakGenderView.isHidden = true;
            self.delegate.ageAlert();
        }
        self.nextButton.setTitle(self.bundle.localizedString(forKey: "next", value: nil, table: nil), for: UIControl.State());
//        self.tweakOptionView.nextButton.setTitle(self.bundle.localizedString(forKey: "next>", value: nil, table: nil), for: .normal)
//        self.tweakOptionView.prevButton.setTitle(self.bundle.localizedString(forKey: "prev<", value: nil, table: nil), for: .normal)
    }
    
    @IBAction func onClickOfPrevButton(_ sender: AnyObject) {
        let age = self.ageTextField;
        let weight = self.weightTextField;
        let height = self.heightTextField;
        let nickName = self.nickNameField;
        let button : UIButton = sender as! UIButton;
        button.isHidden = true;
        self.optionsView.isHidden = false

        if((age?.text?.isEmpty)! || (weight?.text?.isEmpty)! || (height?.text?.isEmpty)! || (nickName?.text?.isEmpty)!) {
            self.optionsView.isHidden = false
            self.delegate.ageAlert()
        }
        self.nextButton.setTitle(self.bundle.localizedString(forKey: "next", value: nil, table: nil), for: UIControl.State())
    }
    
    @IBAction func onClickOfOkButton(_ sender: Any) {
        
        TweakAndEatUtils.showMBProgressHUD()
        APIWrapper.sharedInstance.getAllergies({(responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    let allergiesKinds = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                    var countryCodes = ""
                    if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                        countryCodes = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                    }
                    if allergiesKinds.count > 0 {
                        var countryCode = ""
                        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                        }
                        UserDefaults.standard.set(allergiesKinds, forKey: "ALLERGIES")
                        APIWrapper.sharedInstance.getFoodHabits(countryCode: countryCodes, {(responceDic : AnyObject!) -> (Void) in
                            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                                
                                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                    let foodHabits = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                                    
                                    if foodHabits.count > 0 {
                                        
                                        UserDefaults.standard.set(foodHabits, forKey: "FOODHABITS")
                                        APIWrapper.sharedInstance.getConditions({(responceDic : AnyObject!) -> (Void) in
                                            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                                                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                                                
                                                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                                    let conditions = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                                                    
                                                    if conditions.count > 0 {
                                                        
                                                        UserDefaults.standard.set(conditions, forKey: "CONDITIONS")
                                                        
                                                        APIWrapper.sharedInstance.getGoals({(responceDic : AnyObject!) -> (Void) in
                                                            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                                                                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                                                                
                                                                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                                                    let goals = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                                                                    
                                                                    if goals.count > 0 {
                                                                        TweakAndEatUtils.hideMBProgressHUD()
                                                                        
                                                                        UserDefaults.standard.set(goals, forKey: "GOALS")
                                                                        self.delegate.switchToFifthScreen()
                                                                    }
                                                                }
                                                            } else {
                                                                //error
                                                                print("error")
                                                                TweakAndEatUtils.hideMBProgressHUD()
                                                            }
                                                        }) { (error : NSError!) -> (Void) in
                                                            //error
                                                            print("error")
                                                            TweakAndEatUtils.hideMBProgressHUD()
                                                            
                                                            let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                                                            alert.show();
                                                        }
                                                    }
                                                }
                                            } else {
                                                //error
                                                print("error")
                                                TweakAndEatUtils.hideMBProgressHUD()
                                            }
                                        }) { (error : NSError!) -> (Void) in
                                            //error
                                            print("error")
                                            TweakAndEatUtils.hideMBProgressHUD()
                                            
                                            let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                                            alert.show();
                                        }
                                    } else {
                                        TweakAndEatUtils.hideMBProgressHUD()
                                        
                                    }
                                }
                            } else {
                                //error
                                print("error")
                                TweakAndEatUtils.hideMBProgressHUD()
                            }
                        }) { (error : NSError!) -> (Void) in
                            //error
                            print("error")
                            TweakAndEatUtils.hideMBProgressHUD()
                            let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                            alert.show();
                        }
                        
                        
                    }
                    
                }
            } else {
                //error
                print("error")
                TweakAndEatUtils.hideMBProgressHUD()
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            TweakAndEatUtils.hideMBProgressHUD()
            let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
            alert.show();
        }
    }
    

    
    @objc func emailValidation() {
        if !((self.emailTF.text?.isValidEmail())!) {
            let title = ""
            let message = "Please enter a valid email address !"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(action);
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
            
            return
            
        }
    }
    
    @IBAction func onClickOfNextButton(_ sender: AnyObject) {
        if !((self.emailTF.text?.isValidEmail())!) {
            let title = ""
            let message = "Please enter a valid email address !"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(action);
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
            
            return
            
        }
        self.pickerParentView.isHidden = true
        let age = self.ageTextField;
        let weight = self.weightTextField;
        let height = self.heightTextField;
        let nickName = self.nickNameField;
        let button : UIButton = sender as! UIButton
        if(button.titleLabel?.text == self.bundle.localizedString(forKey: "next", value: nil, table: nil)) {
            
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            borderLabel.frame = CGRect(x: option1.frame.minX, y: option1.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
            if((age?.text?.isEmpty)! || (weight?.text?.isEmpty)! || (height?.text?.isEmpty)! || (nickName?.text?.isEmpty)!) {
                self.optionsView.isHidden = false
                self.nextButton.setTitle(self.bundle.localizedString(forKey: "next", value: nil, table: nil), for: UIControl.State())
                self.prevButton.isHidden = true
                self.delegate.ageAlert()
            }
            else{
//                if (UIScreen.main.bounds.size.height == 480 || UIScreen.main.bounds.size.height == 568) {
//                    self.frame = CGRect(x:0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//                }
                self.endEditing(true)
                self.optionsView.isHidden = true
                self.nextButton.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: UIControl.State())
               
                
                self.prevButton.isHidden = false
                
                self.tweakGenderView.isHidden = false
                 self.prevButton.setTitle(bundle.localizedString(forKey: "prev", value: nil, table: nil), for: .normal)
            }
            if(self.bodyShapes == nil) {
                TweakAndEatUtils.showMBProgressHUD()
                
                APIWrapper.sharedInstance.getBodyShapes({ (responceDic : AnyObject!) -> (Void) in
                    if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                        let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                        
                        if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                            let sizeGroups : [AnyObject]? = response[TweakAndEatConstants.DATA] as? [AnyObject]
                            
                            if(sizeGroups != nil && (sizeGroups?.count)! > 0) {
                                self.bodyShapes = sizeGroups as NSArray!
                                if(self.delegate.selectedGender == "M" ) {
                                    self.setBodySizes(self.bundle.localizedString(forKey: "male", value: nil, table: nil) as NSString)
                                } else {
                                    self.setBodySizes(self.bundle.localizedString(forKey: "female", value: nil, table: nil) as NSString)
                                }
                            }
                            TweakAndEatUtils.hideMBProgressHUD()
                        }
                    } else {
                        //error
                        print("error")
                        TweakAndEatUtils.hideMBProgressHUD()
                    }
                }) { (error : NSError!) -> (Void) in
                    //error
                    print("error")
                    TweakAndEatUtils.hideMBProgressHUD()
            let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                    alert.show();
                }
            } else {
                if(delegate.selectedGender == self.bundle.localizedString(forKey: "male", value: nil, table: nil)) {
                    self.setBodySizes(self.bundle.localizedString(forKey: "male", value: nil, table: nil) as NSString)
                } else {
                    self.setBodySizes(self.bundle.localizedString(forKey: "female", value: nil, table: nil) as NSString)
                }
            }
        } else {
            delegate.switchToFifthScreen()
        }
    }
    
    @objc func setBodySizes(_ gender: NSString) {
       
        if(gender as String == self.bundle.localizedString(forKey: "male", value: nil, table: nil)) {
            
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"men_1.png")
            self.mlabel1.text = bundle.localizedString(forKey: "body_shapes_male1", value: nil, table: nil)
            mlabel1.textAlignment = .center
            
            option2 = self.tweakGenderView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"men_2.png")
            self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
            label2.textAlignment = .center
            
            option3  = self.tweakGenderView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"men_3.png")
            self.mlabel3.text = bundle.localizedString(forKey: "body_shapes_male3", value: nil, table: nil)
            mlabel3.textAlignment = .center
            
            option4 = self.tweakGenderView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"men_4.png")
            self.mlabel4.text = bundle.localizedString(forKey: "body_shapes_male4", value: nil, table: nil)
            mlabel4.textAlignment = .center
            
            option5 = self.tweakGenderView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"men_5.png")
            self.mlabel5.text = bundle.localizedString(forKey: "body_shapes_male5", value: nil, table: nil)
            mlabel5.textAlignment = .center
            
            option6  = self.tweakGenderView.viewWithTag(205) as! UIImageView
            self.flabel6.isHidden = true
            option6.isHidden = true
            option6.isUserInteractionEnabled = false
            flabel6.isHidden = true
            
            
        } else {
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"women_1.png")
            self.mlabel1.text = bundle.localizedString(forKey: "body_shapes_female1", value: nil, table: nil)
            
            option2  = self.tweakGenderView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"women_2.png")
            self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
            
            option3 = self.tweakGenderView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"women_3.png")
            self.mlabel3.text = bundle.localizedString(forKey: "body_shapes_female3", value: nil, table: nil)
            
            option4  = self.tweakGenderView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"women_4.png")
            self.mlabel4.text = bundle.localizedString(forKey: "body_shapes_female4", value: nil, table: nil)
            
            
            option5 = self.tweakGenderView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"women_5.png")
            self.mlabel5.text = bundle.localizedString(forKey: "body_shapes_female5", value: nil, table: nil)
            
            option6 = self.tweakGenderView.viewWithTag(205) as! UIImageView
            option6.image = UIImage(named: "women_6.png")
            flabel6.isHidden = false
            self.flabel6.text = bundle.localizedString(forKey: "body_shapes_female6", value: nil, table: nil)
            option6.isHidden = false
            option6.isUserInteractionEnabled = true
            
        }
        
    }
    
    @objc func labelSizeOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        let borderLabel : UILabel = self.tweakGenderView.viewWithTag(199) as! UILabel
        
        let option : UIImageView
        
        if(tappedImageView.tag == 200) {
            option = self.tweakGenderView.viewWithTag(200) as! UIImageView
            if maleLabel.textColor == UIColor.white {
                bodyshapenumber = "1"
            } else if femaleLabel.textColor == UIColor.white {
                bodyshapenumber = "6"
            }
            
        } else if(tappedImageView.tag == 201) {
            option = self.tweakGenderView.viewWithTag(201) as! UIImageView
            if maleLabel.textColor == UIColor.white {
                bodyshapenumber = "2"
            } else if femaleLabel.textColor == UIColor.white{
                bodyshapenumber = "7"
            }
            
        }else if(tappedImageView.tag == 202) {
            option = self.tweakGenderView.viewWithTag(202) as! UIImageView
            
            if maleLabel.textColor == UIColor.white {
                bodyshapenumber = "3"
            } else if femaleLabel.textColor == UIColor.white {
                bodyshapenumber = "8"
            }
            
        }else if(tappedImageView.tag == 203) {
            option = self.tweakGenderView.viewWithTag(203) as! UIImageView
            if maleLabel.textColor == UIColor.white{
                bodyshapenumber = "4"
            } else if femaleLabel.textColor == UIColor.white {
                bodyshapenumber = "9"
            }
            
        }else if(tappedImageView.tag == 204) {
            option = self.tweakGenderView.viewWithTag(204) as! UIImageView
            if maleLabel.textColor == UIColor.white{
                bodyshapenumber = "5"
            } else if femaleLabel.textColor == UIColor.white {
                bodyshapenumber = "10"
            }
        }else if(tappedImageView.tag == 205) {
            option = self.tweakGenderView.viewWithTag(205) as! UIImageView
            if femaleLabel.textColor == UIColor.white {
                bodyshapenumber = "11"
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            borderLabel.frame = CGRect(x: tappedImageView.frame.minX, y: tappedImageView.frame.minY, width: self.genderSelectionSize, height: self.genderSelectionSize)
        })
    }
    
    @objc func labelGenderOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        let tappedLabel : UILabel = tapGesture.view as! UILabel
        if(tappedLabel.tag == 100) {
            delegate.selectedGender = self.bundle.localizedString(forKey: "male", value: nil, table: nil)
            let femaleLabel = optionsView.viewWithTag(101) as! UILabel
            self.selectLabel(tappedLabel)
            self.deselectLabel(femaleLabel)
            self.pickerParentView.isHidden = true
        } else {
            delegate.selectedGender = self.bundle.localizedString(forKey: "female", value: nil, table: nil)
            let maleLabel = optionsView.viewWithTag(100) as! UILabel
            self.selectLabel(tappedLabel)
            self.deselectLabel(maleLabel)
            self.pickerParentView.isHidden = true
        }
    }
    
    @objc func selectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.backgroundColor = TweakAndEatColorConstants.AppDefaultColor
    }
    
    @objc func deselectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.textColor = TweakAndEatColorConstants.AppDefaultColor
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3
        label.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTF {
            emailValidation()
        }
    }
 

    
    @objc func beginning() {
        
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
       self.prevButton.setTitle(self.bundle.localizedString(forKey: "prev", value: nil, table: nil), for: .normal)
//        if (UIScreen.main.bounds.size.height == 480 || UIScreen.main.bounds.size.height == 568) {
//            self.frame = CGRect(x:0, y: -160, width: self.frame.size.width, height: self.frame.size.height + 160)
//            self.nickNameField.becomeFirstResponder()
//        }
        self.nickNameField.tintColor = .black
        self.emailTF.tintColor = .black
        self.emailTF.delegate = self;
        self.emailTF.isUserInteractionEnabled = true
        
        self.ageTextField.placeholder = self.bundle.localizedString(forKey: "years_hint", value: nil, table: nil)
       
        self.weightTextField.placeholder = self.bundle.localizedString(forKey: "kgs_hint", value: nil, table: nil)
        self.heightTextField.placeholder = self.bundle.localizedString(forKey: "cms_hint", value: nil, table: nil)

        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
          let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "1" {
                self.weightTextField.placeholder = "In lbs"
                self.heightTextField.placeholder = "In Inches"
            }
        }
        
//        self.maleLabel.text = self.bundle.localizedString(forKey: "male", value: nil, table: nil)
//        self.femaleLabel.text = self.bundle.localizedString(forKey: "female", value: nil, table: nil)

        logoBorderView.clipsToBounds = true
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2
        animationView.clipsToBounds = true
        animationView.layer.cornerRadius = animationView.frame.size.width / 2
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = logoView.frame.size.width / 2
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
    }
    
}
