//
//  TweakAndEatOptionsView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 06/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatOptionsView: UIView, UITextFieldDelegate {
    
    
    @IBOutlet var nickNameField: AllowedCharsTextField!
    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var logoBorderView: UIView!;
    @IBOutlet var optionsView: UIView!;
    @IBOutlet var nextButton: UIButton!;
    @IBOutlet var prevButton: UIButton!;
    @IBOutlet var ageLabel: UILabel!;
    @IBOutlet var genderLabel: UILabel!;
    @IBOutlet var genderView: UIView!;
    var genderSelectionSize : CGFloat!;
    let borderLabel : UILabel = UILabel();
    
    var bodyshapenumber : String!;
    var allergies : NSArray! = nil;
    
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
    
    var bodyShapesToBeShown : NSMutableArray! = nil;
    
    var optionsList : NSArray! = nil;
    var bodyShapes : NSArray! = nil;
    var delegate : WelcomeViewController! = nil;
    
    func setAgeOptions() {
        
        delegate.selectedAge = self.ageTextField.text as NSString?;
        delegate.weight = self.weightTextField.text as NSString?;
        delegate.height = self.heightTextField.text as NSString?;
        
    }
    
    func setGenderOptions() {
        maleLabel.text = "M";
        maleLabel.tag = 100;
        self.selectLabel(maleLabel);
        femaleLabel.text = "F";
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
    
    func setImageViewsOfGender() {
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
        option1.contentMode = UIViewContentMode.scaleAspectFit;
        
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
        self.nextButton.setTitle("NEXT >", for: UIControlState());
    }
    
    @IBAction func onClickOfPrevButton(_ sender: AnyObject) {
        let age = self.ageTextField;
        let weight = self.weightTextField;
        let height = self.heightTextField;
        let nickName = self.nickNameField;
        let button : UIButton = sender as! UIButton;
        button.isHidden = true;
        self.optionsView.isHidden = false
        // self.genderView.isHidden = true
        if((age?.text?.isEmpty)! || (weight?.text?.isEmpty)! || (height?.text?.isEmpty)! || (nickName?.text?.isEmpty)!) {
            self.optionsView.isHidden = false
            // self.genderView.isHidden = true
            self.delegate.ageAlert()
        }
        self.nextButton.setTitle("NEXT >", for: UIControlState())
    }
    
    @IBAction func onClickOfOkButton(_ sender: Any) {
        
        TweakAndEatUtils.showMBProgressHUD()
        APIWrapper.sharedInstance.getAllergies({(responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    let allergiesKinds = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                    
                    if allergiesKinds.count > 0 {
                        UserDefaults.standard.set(allergiesKinds, forKey: "ALLERGIES")
                        APIWrapper.sharedInstance.getFoodHabits({(responceDic : AnyObject!) -> (Void) in
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
                                                        self.delegate.switchToFifthScreen()
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
                                        }
                                    }
                                    //TweakAndEatUtils.hideMBProgressHUD()
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
                        }
                        
                        
                    }
                    //TweakAndEatUtils.hideMBProgressHUD()
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
        }
    }
    
    
    
    @IBAction func onClickOfNextButton(_ sender: AnyObject) {
        let age = self.ageTextField;
        let weight = self.weightTextField;
        let height = self.heightTextField;
        let nickName = self.nickNameField;
        let button : UIButton = sender as! UIButton
        if(button.titleLabel?.text == "NEXT >") {
            
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            borderLabel.frame = CGRect(x: option1.frame.minX, y: option1.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
            if((age?.text?.isEmpty)! || (weight?.text?.isEmpty)! || (height?.text?.isEmpty)! || (nickName?.text?.isEmpty)!) {
                self.optionsView.isHidden = false
                //self.genderView.isHidden = true
                self.nextButton.setTitle("NEXT >", for: UIControlState())
                self.prevButton.isHidden = true
                self.delegate.ageAlert()
            }
            else{
                if (UIScreen.main.bounds.size.height == 480 || UIScreen.main.bounds.size.height == 568) {
                    self.frame = CGRect(x:0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                }
                self.endEditing(true)
                self.optionsView.isHidden = true
                //self.genderView.isHidden = false
                self.nextButton.setTitle("OK", for: UIControlState())
                self.prevButton.isHidden = false
                self.tweakGenderView.isHidden = false
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
                                if(self.delegate.selectedGender == "M") {
                                    self.setBodySizes("M")
                                } else {
                                    self.setBodySizes("F")
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
                }
            } else {
                if(delegate.selectedGender == "M") {
                    self.setBodySizes("M")
                } else {
                    self.setBodySizes("F")
                }
            }
        } else {
            delegate.switchToFifthScreen()
        }
    }
    
    func setBodySizes(_ gender: NSString) {
        
        
        if(gender == "M") {
            
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"men_1.png")
            self.mlabel1.text = "SUPER FIT"
            mlabel1.textAlignment = .center
            
            option2 = self.tweakGenderView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"men_2.png")
            self.label2.text = "FIT"
            label2.textAlignment = .center
            
            option3  = self.tweakGenderView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"men_3.png")
            self.mlabel3.text = "AVERAGE"
            mlabel3.textAlignment = .center
            
            option4 = self.tweakGenderView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"men_4.png")
            self.mlabel4.text = "BOTTOM"
            mlabel4.textAlignment = .center
            
            option5 = self.tweakGenderView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"men_5.png")
            self.mlabel5.text = "CENTRAL"
            mlabel5.textAlignment = .center
            
            option6  = self.tweakGenderView.viewWithTag(205) as! UIImageView
            self.flabel6.isHidden = true
            option6.isHidden = true
            option6.isUserInteractionEnabled = false
            flabel6.isHidden = true
            
            
        } else {
            option1 = self.tweakGenderView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"women_1.png")
            self.mlabel1.text = "HOUR GLASS"
            //mlabel1.textAlignment = .center
            
            option2  = self.tweakGenderView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"women_2.png")
            self.label2.text = "FIT"
            // label2.textAlignment = .center
            
            option3 = self.tweakGenderView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"women_3.png")
            self.mlabel3.text = "SLENDAR"
            // mlabel3.textAlignment = .center
            
            option4  = self.tweakGenderView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"women_4.png")
            self.mlabel4.text = "PEAR"
            // mlabel4.textAlignment = .center
            
            option5 = self.tweakGenderView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"women_5.png")
            self.mlabel5.text = "APPLE"
            // mlabel5.textAlignment = .center
            
            option6 = self.tweakGenderView.viewWithTag(205) as! UIImageView
            option6.image = UIImage(named: "women_6.png")
            flabel6.isHidden = false
            self.flabel6.text = "HEAVY"
            // flabel6.textAlignment = .center
            option6.isHidden = false
            option6.isUserInteractionEnabled = true
            
            
            
        }
        
    }
    
    func labelSizeOptionTapped(_ tapGesture: UITapGestureRecognizer) {
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
    
    func labelGenderOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        let tappedLabel : UILabel = tapGesture.view as! UILabel
        if(tappedLabel.tag == 100) {
            delegate.selectedGender = "M"
            let femaleLabel = optionsView.viewWithTag(101) as! UILabel
            self.selectLabel(tappedLabel)
            self.deselectLabel(femaleLabel)
        } else {
            delegate.selectedGender = "F"
            let maleLabel = optionsView.viewWithTag(100) as! UILabel
            self.selectLabel(tappedLabel)
            self.deselectLabel(maleLabel)
        }
    }
    
    func selectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.backgroundColor = TweakAndEatColorConstants.AppDefaultColor
    }
    
    func deselectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.textColor = TweakAndEatColorConstants.AppDefaultColor
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3
        label.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
    }
    
    func beginning() {
        if (UIScreen.main.bounds.size.height == 480 || UIScreen.main.bounds.size.height == 568) {
            self.frame = CGRect(x:0, y: -160, width: self.frame.size.width, height: self.frame.size.height + 160)
            self.nickNameField.becomeFirstResponder()
        }
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
