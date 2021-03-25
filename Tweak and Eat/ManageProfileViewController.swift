//
//  ManageProfileViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import CleverTapSDK
import FirebaseInstanceID

class ManageProfileViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var goalsContentView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    var myProfile : Results<MyProfileInfo>?
    var pieChartInfo : Results<TweakPieChartValues>?
    
    @objc var selectGender : String = " "
    @objc var foodhabit : String!
    @objc var bmi : String!
    
    @objc var deviceInfo = UIDevice.current.modelName
    @objc var fooddHabitName = "fh_name"
    @objc var conditionName = "cond_name"
    @objc var allergiesName = "alg_name"
    @objc var goalsName = "goal_name"
    
    @objc var selectedHeightValue :Int = 0
    @objc var selectedWeightValue :Int = 0
    @objc var column : Int = 0
    
    @IBOutlet var registeredMobile: UILabel!
    @IBOutlet weak var dummy: UITextField!
    
    @objc var pickerView = UIPickerView()
    @objc var allergies = [[String : AnyObject]]()
    @objc var foodHabitsArray = [[String : AnyObject]]()
    @objc var conditionsArray = [[String : AnyObject]]()
    @objc var goalsArray = [[String : AnyObject]]()
    @objc var selectedAllergies = [String]()
    @objc var selectedConditions = [String]()
    @objc var selectedGoalsArray = [String]()
    @objc var weightFieldArray = [String]()
    @objc var heightFieldArray = [String]()
    var genderSelectionSize : CGFloat!;
    @objc let borderLabel : UILabel = UILabel();
    @objc var food = [String]()
    @objc var allergy = [String]()
    @objc var conditions = [String]()
    @objc var goals = [String]()
    
    @objc var eggs : String = ""
    @objc var Milk : String = ""
    @objc var Nuts : String = ""
    
    @IBOutlet weak var heightPickerView: UIPickerView!
    
    @objc var Shellfish : String = ""
    @objc var Soy : String = ""
    @objc var Wheat : String = ""
    @objc var BloodPressure : String = ""
    @objc var Cholesterol : String = ""
    @objc var Diabetes : String = ""
    @objc var y: CGFloat = 5
    @objc var x: CGFloat = 10
    @objc var y1: CGFloat = 5
    @objc var y11: CGFloat = 5
    @objc var x1: CGFloat = 10
    @objc var food1 : String = ""
    @objc var allergy1 : String = ""
    @objc var conditions1 : String = ""
    
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
    @objc var totalCMS : String = ""
    
    @IBOutlet weak var bodyShapesContentView: UIView!
    @IBOutlet var conditionsContentView: UIView!
    @IBOutlet var allergiesContentView: UIView!
    @IBOutlet weak var weightTextField: AllowedCharsTextField!
    @IBOutlet var heightTextField: AllowedCharsTextField!
    @IBOutlet weak var nickNameTextField: AllowedCharsTextField!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet var ageTextField: AllowedCharsTextField!
    
    @IBOutlet var vegLabel: UILabel!
    @IBOutlet var vegAndEggLabel: UILabel!
    @IBOutlet var nonVegLabel: UILabel!
    
    @IBOutlet weak var updateProfileBtn: UIButton!
    @IBOutlet weak var allergiesBox1: UIButton!
    @IBOutlet weak var allergiesBox2: UIButton!
    @IBOutlet weak var allergiesBox3: UIButton!
    @IBOutlet weak var allergiesBox4: UIButton!
    @IBOutlet weak var allergiesBox5: UIButton!
    @IBOutlet weak var allergiesBox6: UIButton!
    
    @IBOutlet weak var conditionBox1: UIButton!
    @IBOutlet weak var conditionBox2: UIButton!
    @IBOutlet weak var conditionBox3: UIButton!
    @IBOutlet var foodHabitContentView: UIView!
    
    @objc var foodHabitsString: String = ""
    @objc var allergiesString: String = ""
    @objc var conditionsString: String = ""
    @objc var goalsString: String = ""
    @objc var bodyShapesString: String = ""
    @objc var gender: String = ""
    @objc var option : UIImageView!
    @objc var countryName : String = ""
    
    @objc var pickOption = [["2 feet", "3 feet", "4 feet","5 feet", "6 feet", "7 feet","8 feet"], ["0 inch","1 inch", "2 inches", "3 inches", "4 inches","5 inches", "6 inches", "7 inches","8 inches","9 inches", "10 inches", "11 inches"]];
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    
    func getAllDetails() {
        
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
                                                                        
self.setUpUI()                                                                    }
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
    
    func setUpUI() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        self.emailTF.isUserInteractionEnabled = true
        self.emailTF.keyboardType = .emailAddress
        
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "AR" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                fooddHabitName = "fh_ba_name"
                conditionName = "cond_ba_name"
                allergiesName = "alg_ba_name"
                
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }
        self.nickNameLabel.text = bundle.localizedString(forKey: "nick_name", value: nil, table: nil)
        self.ageLabel.text = bundle.localizedString(forKey: "register_age", value: nil, table: nil)
        self.genderLabel.text = bundle.localizedString(forKey: "register_sex", value: nil, table: nil)
        self.weightLabel.text = bundle.localizedString(forKey: "register_weight", value: nil, table: nil)
        self.heightLabel.text = bundle.localizedString(forKey: "register_height", value: nil, table: nil)
        self.updateProfileBtn.setTitle(bundle.localizedString(forKey: "update_profile", value: nil, table: nil), for: .normal)
        self.maleLabel.text = self.bundle.localizedString(forKey: "male", value: nil, table: nil)
        self.femaleLabel.text = self.bundle.localizedString(forKey: "female", value: nil, table: nil)
        
        let country: String = UserDefaults.standard.value(forKey: "COUNTRY_NAME") as! String
        print(country)
        self.countryName = country
        doneButton();
        // self.title = "Update Profile"
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)]);
        self.emailTF.delegate = self;
        ageTextField.delegate = self;
        pickerView.delegate = self;
        heightTextField.delegate = self;
        weightTextField.delegate = self;
        heightTextField.inputView = pickerView;
        weightTextField.inputView = pickerView;
        if self.countryCode == "1" {
            self.weightFieldArray = [String]()
            for i in 20...550 {
                let str1 = String(i)
                let str2 = "lbs"
                let str3 = "\(str1) \(str2)"
                self.weightFieldArray.append(str3)
                
                
            }
            
            
        } else {
            self.weightFieldArray = [String]()
            for i in 20...350{
                let str1 = String(i);
                let str2 = "kgs";
                
                let str3 = "\(str1) \(str2)";
                self.weightFieldArray.append(str3);
            }
            
            
        }
        for i in 20...250{
            let str1 = String(i);
            let str2 = "Cms";
            let str3 = "\(str1) \(str2)";
            self.heightFieldArray.append(str3);
        }
        
        let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        // "Registered Mobile: +\(msisdn)";
        self.registeredMobile.text = bundle.localizedString(forKey: "registered_mobile", value: nil, table: nil) + "+\(msisdn)"
        self.myProfile = uiRealm.objects(MyProfileInfo.self);
        self.pieChartInfo = uiRealm.objects(TweakPieChartValues.self);
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        for dataStr in self.myProfile! {
            foodHabitsString = dataStr.foodHabits;
            allergiesString = dataStr.allergies;
            conditionsString = dataStr.conditions;
            bodyShapesString = dataStr.bodyShape;
            goalsString = dataStr.goals
            self.emailTF.text = dataStr.email
            gender = dataStr.gender;
            
        }
        
        self.updateProfileBtn.layer.backgroundColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.updateProfileBtn.layer.cornerRadius = 5;
        foodHabitsArray = UserDefaults.standard.value(forKey: "FOODHABITS") as! [[String : AnyObject]];
        allergies = UserDefaults.standard.value(forKey: "ALLERGIES") as! [[String : AnyObject]];
        conditionsArray = UserDefaults.standard.value(forKey: "CONDITIONS") as! [[String : AnyObject]];
        goalsArray = UserDefaults.standard.value(forKey: "GOALS") as! [[String : AnyObject]]
        print(goalsArray)
        var count = 0;
        var tagBtn = 0;
        var tagLbl = 100;
        
        var buttonCheckedOrNot: Bool = false;
        
        for foodHabit in foodHabitsArray {
            food1 = (foodHabit[fooddHabitName] as AnyObject as? String)!;
            if foodHabitsString.components(separatedBy: (",")).count > 1 {
                let foodArray1 = foodHabitsString.components(separatedBy: (","));
                if foodArray1 .contains(food1) {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            } else {
                if foodHabitsString == food1 {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            }
            count += 1;
            
            if count % 2 != 0 {
                tagBtn += 1;
                tagLbl += 1;
                x = 10;
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 0, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: food1, type: 0, tag: tagLbl, isChecked: buttonCheckedOrNot);
                
            } else {
                tagBtn += 1;
                tagLbl += 1;
                
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 0, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: food1, type: 0, tag: tagLbl, isChecked: buttonCheckedOrNot);
                y = CGFloat(5 + y1);
                
            }
        }
        
        y = 5;
        count = 0;
        for allergy in allergies {
            allergy1 = (allergy[allergiesName] as AnyObject as? String)!;
            if allergiesString.components(separatedBy: (",")).count > 1 {
                let allergyArray1 = allergiesString.components(separatedBy: (","));
                if allergyArray1 .contains(allergy1) {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            } else {
                if allergiesString == allergy1 {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            }
            
            count += 1;
            
            if count % 2 != 0 {
                tagBtn += 1;
                tagLbl += 1;
                x = 10;
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 1, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: allergy1, type: 1, tag: tagLbl, isChecked: buttonCheckedOrNot);
                
            } else {
                tagBtn += 1;
                tagLbl += 1;
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 1, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: allergy1, type: 1, tag: tagLbl, isChecked: buttonCheckedOrNot);
                y = CGFloat(5 + y11);
                
            }
        }
        
        y = 5;
        count = 0;
        for cond in conditionsArray {
            conditions1 = (cond[conditionName] as AnyObject as? String)!;
            if conditionsString.components(separatedBy: (",")).count > 1 {
                let conditionsArray1 = conditionsString.components(separatedBy: (","));
                if conditionsArray1 .contains(conditions1) {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            } else {
                if conditionsString == conditions1 {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            }
            count += 1;
            
            if count % 2 != 0 {
                tagBtn += 1;
                tagLbl += 1;
                x = 10;
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 2, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: conditions1, type: 2, tag: tagLbl, isChecked: buttonCheckedOrNot);
                
            } else {
                tagBtn += 1;
                tagLbl += 1;
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 2, isChecked: buttonCheckedOrNot);
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: conditions1, type: 2, tag: tagLbl, isChecked: buttonCheckedOrNot);
                y = CGFloat(5 + y11);
                
            }
        }
        y = 5;
        count = 0;
        
        for foodHabit in goalsArray {
            let goal = (foodHabit[goalsName] as AnyObject as? String)!;
            if goalsString.components(separatedBy: (",")).count > 1 {
                let foodArray1 = goalsString.components(separatedBy: (","));
                if foodArray1 .contains(goal) {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            } else {
                if goalsString == goal {
                    buttonCheckedOrNot = true;
                } else {
                    buttonCheckedOrNot = false;
                }
            }
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: 2, yAxis: y, tag: tagBtn, type: 3, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: goal, type: 3, tag: tagLbl, isChecked: buttonCheckedOrNot)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                
                self.createButton(xAxis: 175, yAxis: y, tag: tagBtn, type: 3, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: 175 + 52, yAxis: y, foodhabit: goal, type: 3, tag: tagLbl, isChecked: buttonCheckedOrNot)
                y = CGFloat(5 + y1)
                
            }
            
        }
        
        setImageViewsOfGender();
        
        setborderLabels();
        setBodySizes();
        if gender == "M" {
            if bodyShapesString == "1"{
                bodyShapesString = "1";
                self.setSelectedBodyShape(tagVal: 200);
            } else if bodyShapesString == "2" {
                bodyShapesString = "2";
                self.setSelectedBodyShape(tagVal: 201);
            } else if bodyShapesString == "3" {
                bodyShapesString = "3";
                self.setSelectedBodyShape(tagVal: 202);
            } else if bodyShapesString == "4" {
                bodyShapesString = "4";
                self.setSelectedBodyShape(tagVal: 203);
            } else if bodyShapesString == "5" {
                self.setSelectedBodyShape(tagVal: 204);
                bodyShapesString = "5";
            }
            
        } else {
            if bodyShapesString == "6"{
                bodyShapesString = "6";
                self.setSelectedBodyShape(tagVal: 200);
            } else if bodyShapesString == "7" {
                bodyShapesString = "7";
                self.setSelectedBodyShape(tagVal: 201);
            } else if bodyShapesString == "8" {
                bodyShapesString = "8";
                self.setSelectedBodyShape(tagVal: 202);
            } else if bodyShapesString == "9" {
                bodyShapesString = "9";
                self.setSelectedBodyShape(tagVal: 203);
            } else if bodyShapesString == "10" {
                bodyShapesString = "10";
                self.setSelectedBodyShape(tagVal: 204);
            } else if bodyShapesString == "11" {
                bodyShapesString = "11";
                self.setSelectedBodyShape(tagVal: 205);
            }
        }
        
        maleLabel.text = self.bundle.localizedString(forKey: "male", value: nil, table: nil);
        maleLabel.tag = 2000;
        self.selectLabel(maleLabel);
        maleLabel.isUserInteractionEnabled = true;
        self.maleLabel.backgroundColor = UIColor.clear;
        
        femaleLabel.text = self.bundle.localizedString(forKey: "female", value: nil, table: nil);
        femaleLabel.tag = 2001;
        self.deselectLabel(femaleLabel);
        femaleLabel.isUserInteractionEnabled = true;
        self.femaleLabel.backgroundColor = UIColor.clear;
        self.femaleLabel.textColor = UIColor.white;
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelGenderOptionTapped(_:)));
        tapGesture.numberOfTapsRequired = 1;
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatOptionsView.labelGenderOptionTapped(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        maleLabel.addGestureRecognizer(tapGesture);
        femaleLabel.addGestureRecognizer(tapGesture1);
        
        for myProfileObj in self.myProfile! {
            
            self.ageTextField.text = myProfileObj.age;
            
            if countryCode == "1" {
                let height = myProfileObj.height
                let feetArray = height.components(separatedBy: "'")
                let feet = "\(feetArray[0])";
                let inches = "\(feetArray[1])";
                
                let totalCM: Int = Int((Float(Double(feet)! * 30.48) + Float(Double(inches)! * 2.54)));
                self.totalCMS = "\(totalCM)"
                self.heightTextField.text = myProfileObj.height;
            } else {
                self.heightTextField.text = myProfileObj.height;
            }
            self.weightTextField.text = myProfileObj.weight;
            self.nickNameTextField.text = myProfileObj.name;
            
            if myProfileObj.gender == "M" {
                maleLabel.layer.backgroundColor = UIColor.white.cgColor;
                maleLabel.textColor = TweakAndEatColorConstants.AppDefaultColor;
                self.selectLabel(maleLabel);
                self.deselectLabel(femaleLabel);
            } else {
                femaleLabel.layer.backgroundColor = UIColor.white.cgColor;
                femaleLabel.textColor = TweakAndEatColorConstants.AppDefaultColor;
                self.selectLabel(femaleLabel);
                self.deselectLabel(maleLabel);
            }
            
        }
    }
    
    
    
    @objc func createButton(xAxis: CGFloat, yAxis: CGFloat, tag: Int, type: Int, isChecked: Bool) {
        let checkBoxBtn = UIButton();
        if type == 3 {
            checkBoxBtn.frame = CGRect(x:xAxis, y:yAxis, width:50, height: 50);
        } else {
            checkBoxBtn.frame = CGRect(x:xAxis, y:yAxis, width:30, height: 30);
        }
        checkBoxBtn.addTarget(self, action: #selector(ManageProfileViewController.btnPressed(_:)), for: .touchUpInside);
        checkBoxBtn.tag = tag;
        if isChecked == false {
            self.clickedOff(checkBoxBtn);
        } else {
            self.clickedon(checkBoxBtn);
        }
        x = checkBoxBtn.frame.maxX;
        y1 = checkBoxBtn.frame.maxY;
        y11 = checkBoxBtn.frame.maxY;
        if type == 0 {
            self.foodHabitContentView.addSubview(checkBoxBtn);
        } else if type == 1 {
            self.allergiesContentView.addSubview(checkBoxBtn);
        } else if type == 2 {
            self.conditionsContentView.addSubview(checkBoxBtn);
        } else if type == 3 {
            self.goalsContentView.addSubview(checkBoxBtn);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

       self.getAllDetails()
        
    }
    
    @objc func btnPressed(_ sender: UIButton!) {
        print(sender.tag);
        let labelTag = sender.tag + 100;
        let label = self.view.viewWithTag(labelTag) as! UILabel;
        print(label.text!);
        if label.isDescendant(of: self.foodHabitContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender);
                if food.contains(label.text!) {
                    food.remove(at: food.index(of: label.text!)!);
                }
            } else {
                self.clickedon(sender);
                food.append(label.text!);
            }
            
        } else if label.isDescendant(of: self.allergiesContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender);
                if allergy.contains(label.text!) {
                    allergy.remove(at: allergy.index(of: label.text!)!);
                }
            } else {
                self.clickedon(sender);
                allergy.append(label.text!);
            }
            
        } else if label.isDescendant(of: self.conditionsContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender);
                if conditions.contains(label.text!) {
                    conditions.remove(at: conditions.index(of: label.text!)!);
                }
            } else {
                self.clickedon(sender);
                conditions.append(label.text!);
            }
            
        } else if label.isDescendant(of: self.goalsContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender);
                if goals.contains(label.text!) {
                    goals.remove(at: goals.index(of: label.text!)!);
                }
            } else {
                self.clickedon(sender);
                goals.append(label.text!);
            }
            
        }
    }
    
    @objc func createFoodHabitLabel(xAxis: CGFloat, yAxis: CGFloat, foodhabit: String, type: Int, tag: Int, isChecked: Bool) {
        let foodHabitLabel = UILabel();
        if type == 3 {
            foodHabitLabel.frame = CGRect(x:xAxis, y:yAxis, width:140, height: 50);
        } else {
            foodHabitLabel.frame = CGRect(x:xAxis, y:yAxis, width:140, height: 30);
        }
        foodHabitLabel.font = UIFont.systemFont(ofSize: 13.0);
        foodHabitLabel.numberOfLines = 0
        foodHabitLabel.text = foodhabit;
        if isChecked == true {
            if type == 0 {
                food.append(foodhabit);
            } else if type == 1 {
                allergy.append(foodhabit);
            } else if type == 2 {
                conditions.append(foodhabit);
            } else if type == 3 {
                goals.append(foodhabit);
            }
        }
        foodHabitLabel.tag = tag;
        x1 = foodHabitLabel.frame.maxX;
        if type == 0 {
            self.foodHabitContentView.addSubview(foodHabitLabel);
        } else if type == 1 {
            self.allergiesContentView.addSubview(foodHabitLabel);
        } else if type == 2 {
            self.conditionsContentView.addSubview(foodHabitLabel);
        } else if type == 3 {
            self.goalsContentView.addSubview(foodHabitLabel);
        }
    }
    
    @objc func doneButton(){
        
        let pickerView = UIPickerView();
        pickerView.backgroundColor = .white;
        pickerView.showsSelectionIndicator = true;
        
        let toolBar = UIToolbar();
        toolBar.barStyle = UIBarStyle.default;
        toolBar.isTranslucent = true;
        toolBar.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
        toolBar.sizeToFit();
        
        let doneButton = UIBarButtonItem(title:  bundle.localizedString(forKey: "action_done", value: nil, table: nil), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ManageProfileViewController.donePicker));
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil);
        //   let cancelButton = UIBarButtonItem(title: bundle.localizedString(forKey: "action_cancel", value: nil, table: nil), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManageProfileViewController.canclePicker));
        
        toolBar.setItems([doneButton, spaceButton], animated: false);
        toolBar.isUserInteractionEnabled = true;
        
        heightTextField.inputView = pickerView;
        heightTextField.inputAccessoryView = toolBar;
        
        weightTextField.inputView = pickerView;
        weightTextField.inputAccessoryView = toolBar;
    }
    
    @objc func donePicker() {
        heightTextField.resignFirstResponder();
        weightTextField.resignFirstResponder();
    }
    
    @objc func canclePicker() {
        heightTextField.resignFirstResponder();
        weightTextField.resignFirstResponder();
    }
    
    @objc func labelGenderOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        let tappedLabel : UILabel = tapGesture.view as! UILabel
        if(tappedLabel.tag == 2000) {
            
            gender = "M"
            self.selectLabel(tappedLabel)
            self.deselectLabel(femaleLabel)
            genderShapeChanged()
        } else {
            
            gender = "F"
            self.selectLabel(tappedLabel)
            self.deselectLabel(maleLabel)
            genderShapeChanged()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if bmi == "height"{
            if (countryName == "INDIA" || countryCode == "1") {
                return 2
            } else {
                return 1
            }
        }else if bmi == "weight"{
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if bmi == "height"{
            if (countryName == "INDIA" || countryCode == "1") {
                return pickOption[component].count
            } else {
                return heightFieldArray.count
            }
        }
        else if bmi == "weight"{
            return weightFieldArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if bmi == "height"{
            if (countryName == "INDIA" || countryCode == "1") {
                return pickOption[component][row]
            } else {
                return heightFieldArray[row]
            }
        }
        else if bmi == "weight"{
            return weightFieldArray[row]
        }
        return pickOption[component][row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if bmi == "height"{
            if countryName == "INDIA" {
                
                
                let color = pickOption[0][pickerView.selectedRow(inComponent: 0)]
                let model = pickOption[1][pickerView.selectedRow(inComponent: 1)]
                let feetArray = color.components(separatedBy: " ")
                let inchArray = model.components(separatedBy: " ")
                let feet = Int(feetArray[0])!
                let inches = Int(inchArray[0])!
                if inchArray[0].count == 1 {
                    let totalCM: Int = Int((Float(Double(feet) * 30.48) + Float(Double(inches) * 2.54)))
                    heightTextField.text = "\(totalCM)"
                    
                    
                } else if inchArray[0].count == 2 {
                    let totalCM: Int = Int((Float(Double(feet) * 30.48) + Float(Double(inches) * 2.54)))
                    heightTextField.text = "\(totalCM)"
                    
                }

                
            }
            
          else  if countryCode == "1" {
                
                let color = pickOption[0][pickerView.selectedRow(inComponent: 0)];
                let model = pickOption[1][pickerView.selectedRow(inComponent: 1)];
                let feetArray = color.components(separatedBy: " ");
                let inchArray = model.components(separatedBy: " ");
                let feet = "\(feetArray[0])";
                let inches = "\(inchArray[0])";
                let totalInches = feet + "'" + inches + "''"
                
                let feet1 = Int(feetArray[0])!;
                let inches1 = Int(inchArray[0])!;
                if inchArray[0].count == 1 {
                    
                    self.heightTextField.text = totalInches;
                    
                    let totalCM: Int = Int((Float(Double(feet1) * 30.48) + Float(Double(inches1) * 2.54)));
                    self.totalCMS = "\(totalCM)"
              
                } else if inchArray[0].count == 2 {
                    
                    self.heightTextField.text = totalInches;
                    let totalCM: Int = Int((Float(Double(feet1) * 30.48) + Float(Double(inches1) * 2.54)));
                    self.totalCMS = "\(totalCM)";
                }
                
                
            } else {
                
                var selectedRow = 0;
                selectedRow = row;
                let myString: String = heightFieldArray[row]
                
                var myStringArr =  myString.components(separatedBy: " ")
                
                
                let totalHeight : String = myStringArr [0]
                var _: String = myStringArr [1]
                heightTextField.text = "\(totalHeight)"
                
            }
        }
        else if  bmi == "weight"{
            self.selectedHeightValue = 0
            
            var selectedRow = 0;
            selectedRow = row;
            let myString: String = weightFieldArray[row]
            
            var myStringArr =  myString.components(separatedBy: " ")
            
            
            let totalWeight : String = myStringArr [0]
            var _: String = myStringArr [1]
            weightTextField.text = "\(totalWeight)"
            
        }
        
        //        selectedValue = row
        //        column = component
        //        pickerView.selectRow(selectedValue, inComponent: column, animated: true)
        //
        
        
    }
    
    
    @objc func setSelectedBodyShape(tagVal: Int) {
        var selectedImg = self.bodyShapesContentView.viewWithTag(tagVal) as! UIImageView
        if bodyShapesString == "1"{
            selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "1";
        } else if bodyShapesString == "2" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "2";
        } else if bodyShapesString == "3" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "3";
            
        } else if bodyShapesString == "4" {
            selectedImg = self.bodyShapesContentView.viewWithTag(203) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "4";
            
        } else if bodyShapesString == "5" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "5";
            
        } else if bodyShapesString == "6" {
            selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "6";
        }  else if bodyShapesString == "7" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "7";
            
        }   else if bodyShapesString == "8" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "8";
            
        }  else if bodyShapesString == "9" {
            selectedImg = self.bodyShapesContentView.viewWithTag(203) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "9";
        }  else if bodyShapesString == "10" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "10";
            
        }   else if bodyShapesString == "11" {
            
            selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView;
            selectedImg.layer.borderWidth = 3;
            selectedImg.layer.borderColor = UIColor.green.cgColor;
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "11";
        }
    }
    
    
    @objc func setImageViewsOfGender() {
        
        genderSelectionSize = option1.frame.size.width ;
        
        option1.tag = 200;
        option1.layer.cornerRadius = genderSelectionSize / 2;
        option1.layer.borderWidth = 1;
        option1.layer.borderColor = UIColor.white.cgColor;
        option1.layer.masksToBounds = true;
        option1.contentMode = UIView.ContentMode.scaleAspectFit;
        
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option1TappedImage(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        option1.addGestureRecognizer(tapGesture1);
        option1.isUserInteractionEnabled = true;
        self.bodyShapesContentView.addSubview(option1);
        
        option2.tag = 201;
        option2.layer.cornerRadius = genderSelectionSize / 2;
        option2.layer.borderWidth = 1;
        option2.layer.borderColor = UIColor.white.cgColor;
        option2.layer.masksToBounds = true;
        
        let tapGesture2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option2TappedImage(_:)));
        tapGesture2.numberOfTapsRequired = 1;
        option2.addGestureRecognizer(tapGesture2);
        option2.isUserInteractionEnabled = true;
        self.bodyShapesContentView.addSubview(option2);
        
        option3.tag = 202;
        option3.layer.cornerRadius = genderSelectionSize / 2;
        option3.layer.borderWidth = 1;
        option3.layer.borderColor = UIColor.white.cgColor;
        option3.layer.masksToBounds = true;
        
        let tapGesture3 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option3TappedImage(_:)));
        tapGesture3.numberOfTapsRequired = 1;
        option3.addGestureRecognizer(tapGesture3);
        option3.isUserInteractionEnabled = true;
        self.bodyShapesContentView.addSubview(option3);
        
        option4.tag = 203;
        option4.layer.cornerRadius = genderSelectionSize / 2;
        option4.layer.borderWidth = 1;
        option4.layer.borderColor = UIColor.white.cgColor;
        option4.layer.masksToBounds = true;
        
        let tapGesture4 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option4TappedImage(_:)));
        tapGesture4.numberOfTapsRequired = 1;
        option4.addGestureRecognizer(tapGesture4);
        option4.isUserInteractionEnabled = true;
        self.bodyShapesContentView.addSubview(option4);
        
        option5.tag = 204;
        option5.layer.cornerRadius = genderSelectionSize / 2;
        option5.layer.borderWidth = 1;
        option5.layer.borderColor = UIColor.white.cgColor;
        option5.layer.masksToBounds = true;
        let tapGesture5 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option5TappedImage(_:)));
        tapGesture5.numberOfTapsRequired = 1;
        option5.addGestureRecognizer(tapGesture5);
        option5.isUserInteractionEnabled = true;
        self.bodyShapesContentView.addSubview(option5);
        
        option6.tag = 205;
        option6.layer.cornerRadius = genderSelectionSize / 2;
        option6.layer.borderWidth = 1;
        option6.layer.borderColor = UIColor.white.cgColor;
        option6.layer.masksToBounds = true;
        
        let tapGesture6 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.option6TappedImage(_:)));
        tapGesture6.numberOfTapsRequired = 1;
        option6.addGestureRecognizer(tapGesture6);
        option6.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option6);
    }
    
    @objc func clickedon(_ sender: UIButton) {
        sender.setImage(UIImage(named: "tweakCheck.png")!, for: UIControl.State.normal)
    }
    
    @objc func clickedOff(_ sender: UIButton){
        sender.setImage(UIImage(named: "uncheckTweak.png")!, for: UIControl.State.normal)
    }
    
    @objc func borderLabelsHidden(){
        self.option1.layer.borderColor = UIColor.clear.cgColor
        self.option2.layer.borderColor = UIColor.clear.cgColor
        self.option3.layer.borderColor = UIColor.clear.cgColor
        self.option4.layer.borderColor = UIColor.clear.cgColor
        self.option5.layer.borderColor = UIColor.clear.cgColor
        self.option6.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc func option1TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 200) {
            
            option = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            if gender == "M" {
                bodyShapesString = "1"
            } else if gender == "F" {
                bodyShapesString = "6"
            }
            
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func option2TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 201) {
            option = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            if gender == "M" {
                bodyShapesString = "2"
            } else if gender == "F" {
                bodyShapesString = "7"
            }
            
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func option3TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 202) {
            option = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            
            if gender == "M" {
                bodyShapesString = "3"
            } else if gender == "F" {
                bodyShapesString = "8"
            }
            
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func option4TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 203) {
            option = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            if gender == "M" {
                bodyShapesString = "4"
            } else if gender == "F" {
                bodyShapesString = "9"
            }
            
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func option5TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 204) {
            option = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            if gender == "M" {
                bodyShapesString = "5"
            } else if gender == "F" {
                bodyShapesString = "10"
            }
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func option6TappedImage(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        borderLabelsHidden()
        tappedImageView.layer.borderWidth = 3
        tappedImageView.layer.borderColor = UIColor.green.cgColor
        if(tappedImageView.tag == 205) {
            option = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            if gender == "F" {
                bodyShapesString = "11"
            }
        }
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    @objc func setborderLabels(){
        self.myProfile = uiRealm.objects(MyProfileInfo.self)
        for myProfileObj in self.myProfile! {
            if(myProfileObj.gender == "M") {
                if myProfileObj.bodyShape == "1"{
                    
                    bodyShapesString = "1"
                    self.setSelectedBodyShape(tagVal: 200)
                } else if myProfileObj.bodyShape == "2" {
                    
                    bodyShapesString = "2"
                    self.setSelectedBodyShape(tagVal: 201)
                } else if myProfileObj.bodyShape == "3" {
                    
                    bodyShapesString = "3"
                    
                    self.setSelectedBodyShape(tagVal: 202)
                } else if myProfileObj.bodyShape == "4" {
                    bodyShapesString = "4"
                    
                    self.setSelectedBodyShape(tagVal: 203)
                } else if myProfileObj.bodyShape == "5" {
                    
                    self.setSelectedBodyShape(tagVal: 204)
                    bodyShapesString = "5"
                    
                }
                
            } else {
                if myProfileObj.bodyShape == "6"{
                    
                    bodyShapesString = "6"
                    self.setSelectedBodyShape(tagVal: 200)
                } else if myProfileObj.bodyShape == "7" {
                    
                    bodyShapesString = "7"
                    self.setSelectedBodyShape(tagVal: 201)
                } else if myProfileObj.bodyShape == "8" {
                    
                    bodyShapesString = "8"
                    self.setSelectedBodyShape(tagVal: 202)
                } else if myProfileObj.bodyShape == "9" {
                    bodyShapesString = "9"
                    self.setSelectedBodyShape(tagVal: 203)
                } else if myProfileObj.bodyShape == "10" {
                    bodyShapesString = "10"
                    self.setSelectedBodyShape(tagVal: 204)
                } else if myProfileObj.bodyShape == "11" {
                    
                    bodyShapesString = "11"
                    self.setSelectedBodyShape(tagVal: 205)
                }
            }
        }
    }
    
    @objc func genderShapeChanged() {
        
        if gender == "M" {
            bodyShapesString = "1"
            borderLabelsHidden()
            self.setSelectedBodyShape(tagVal: 200)
        } else {
            bodyShapesString = "6"
            borderLabelsHidden()
            self.setSelectedBodyShape(tagVal: 200)
        }
    }
    
    @objc func setBodySizes() {
        
        self.myProfile = uiRealm.objects(MyProfileInfo.self)
        for myProfileObj in self.myProfile! {
            if(myProfileObj.gender == "M") {
                
                option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                option1.image = UIImage(named:"men_1.png")
                self.mlabel1.text =  bundle.localizedString(forKey: "body_shapes_male1", value: nil, table: nil)
                mlabel1.textAlignment = .center
                
                option2 = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                option2.image = UIImage(named:"men_2.png")
                self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
                label2.textAlignment = .center
                
                option3  = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                option3.image = UIImage(named:"men_3.png")
                self.mlabel3.text =  bundle.localizedString(forKey: "body_shapes_male3", value: nil, table: nil)
                mlabel3.textAlignment = .center
                
                option4 = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
                option4.image = UIImage(named:"men_4.png")
                self.mlabel4.text =  bundle.localizedString(forKey: "body_shapes_male4", value: nil, table: nil)
                mlabel4.textAlignment = .center
                
                option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                option5.image = UIImage(named:"men_5.png")
                self.mlabel5.text =  bundle.localizedString(forKey: "body_shapes_male5", value: nil, table: nil)
                mlabel5.textAlignment = .center
                
                option6  = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                self.flabel6.isHidden = true
                option6.isHidden = true
                option6.isUserInteractionEnabled = false
                flabel6.isHidden = true
                
            } else {
                option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                option1.image = UIImage(named:"women_1.png")
                self.mlabel1.text = bundle.localizedString(forKey: "body_shapes_female1", value: nil, table: nil)
                
                option2  = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                option2.image = UIImage(named:"women_2.png")
                self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
                
                option3 = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                option3.image = UIImage(named:"women_3.png")
                self.mlabel3.text = bundle.localizedString(forKey: "body_shapes_female3", value: nil, table: nil)
                
                option4  = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
                option4.image = UIImage(named:"women_4.png")
                self.mlabel4.text = bundle.localizedString(forKey: "body_shapes_female4", value: nil, table: nil)
                
                option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                option5.image = UIImage(named:"women_5.png")
                self.mlabel5.text = bundle.localizedString(forKey: "body_shapes_female5", value: nil, table: nil)
                
                option6 = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                option6.image = UIImage(named: "women_6.png")
                flabel6.isHidden = false
                self.flabel6.text = bundle.localizedString(forKey: "body_shapes_female6", value: nil, table: nil)
                option6.isHidden = false
                option6.isUserInteractionEnabled = true
                
            }
        }
    }
    
    @objc func genderSelection(){
        
        if (self.gender == "M") {
            self.gender = "M"
            option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"men_1.png")
            self.mlabel1.text = bundle.localizedString(forKey: "body_shapes_male1", value: nil, table: nil)
            mlabel1.textAlignment = .center
            
            option2 = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"men_2.png")
            self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
            label2.textAlignment = .center
            
            option3  = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"men_3.png")
            self.mlabel3.text =  bundle.localizedString(forKey: "body_shapes_male3", value: nil, table: nil)
            mlabel3.textAlignment = .center
            
            option4 = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"men_4.png")
            self.mlabel4.text =  bundle.localizedString(forKey: "body_shapes_male4", value: nil, table: nil)
            mlabel4.textAlignment = .center
            
            option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"men_5.png")
            self.mlabel5.text =  bundle.localizedString(forKey: "body_shapes_male5", value: nil, table: nil)
            mlabel5.textAlignment = .center
            
            option6  = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            self.flabel6.isHidden = true
            option6.isHidden = true
            option6.isUserInteractionEnabled = false
            flabel6.isHidden = true
            
            if bodyShapesString  == "11" && self.gender == "M" {
                let  selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                selectedImg.layer.borderWidth = 3
                selectedImg.layer.borderColor = UIColor.green.cgColor
                
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "1"
            }
        } else {
            self.gender = "F"
            option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"women_1.png")
            self.mlabel1.text = bundle.localizedString(forKey: "body_shapes_female1", value: nil, table: nil)
            
            option2  = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"women_2.png")
            self.label2.text = bundle.localizedString(forKey: "body_shapes_female2", value: nil, table: nil)
            
            option3 = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"women_3.png")
            self.mlabel3.text = bundle.localizedString(forKey: "body_shapes_female3", value: nil, table: nil)
            
            option4  = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"women_4.png")
            self.mlabel4.text = bundle.localizedString(forKey: "body_shapes_female4", value: nil, table: nil)
            
            option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"women_5.png")
            self.mlabel5.text = bundle.localizedString(forKey: "body_shapes_female5", value: nil, table: nil)
            
            option6 = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            option6.image = UIImage(named: "women_6.png")
            flabel6.isHidden = false
            self.flabel6.text = bundle.localizedString(forKey: "body_shapes_female6", value: nil, table: nil)
            option6.isHidden = false
            option6.isUserInteractionEnabled = true
            if bodyShapesString  == "11" && self.gender == "F" {
                
                let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                selectedImg.layer.borderWidth = 3
                selectedImg.layer.borderColor = UIColor.green.cgColor
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "11"
            }
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
        genderSelection()
    }
    
    @objc func deselectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.textColor = TweakAndEatColorConstants.AppDefaultColor
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3
        label.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
        genderSelection()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == heightTextField {
            self.bmi = "height"
            pickerView.reloadAllComponents()
            if countryCode == "1" {
                let height = heightTextField.text!
                let feetArray = height.components(separatedBy: "'")
                let feetInInt = Int(feetArray[0])
                let inchInInt = Int(feetArray[1])
                let feet = "\(feetArray[0])" + " " + "feet";
                let inch = "\(feetArray[1])";
                var inches = ""
                if (inch == "0" || inch == "1") {
                    inches = inch + " " + "inch"
                } else {
                    inches = inch + " " + "inches"
                }
                self.pickerView.selectRow(feetInInt! - 2, inComponent: 0, animated: true)
                self.pickerView.selectRow(inchInInt!, inComponent: 1, animated: true)
                self.pickerView(self.pickerView, didSelectRow: feetInInt! - 2, inComponent: 0)
                self.pickerView(self.pickerView, didSelectRow: inchInInt!, inComponent: 1)
            } else if countryCode == "91" {
                let heightInDouble = Double(heightTextField.text!)
                let hgtInString = showFootAndInchesFromCm(heightInDouble!)
                let feetArray = hgtInString.components(separatedBy: "'")
                let feetInInt = Int(feetArray[0])
                let inchInInt = Int(feetArray[1])
                self.pickerView.selectRow(feetInInt! - 2, inComponent: 0, animated: true)
                self.pickerView.selectRow(inchInInt!, inComponent: 1, animated: true)
                self.pickerView(self.pickerView, didSelectRow: feetInInt! - 2, inComponent: 0)
                self.pickerView(self.pickerView, didSelectRow: inchInInt!, inComponent: 1)
            } else {
                let wgt = Int(heightTextField.text!)
                
                self.pickerView.selectRow(wgt! - 20, inComponent: 0, animated: true)
                self.pickerView(self.pickerView, didSelectRow: wgt! - 20, inComponent: 0)
            }
            
        } else if textField == weightTextField {
            self.bmi = "weight"
            pickerView.reloadAllComponents()
            let wgt = Int(weightTextField.text!)
            
            self.pickerView.selectRow(wgt! - 20, inComponent: 0, animated: true)
            self.pickerView(self.pickerView, didSelectRow: wgt! - 20, inComponent: 0)
        }
    }
    
    
    @objc func showFootAndInchesFromCm(_ cms: Double) -> String {
        
        let feet = cms * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetShow)'\(inches)"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.emailTF {
//            emailValidation()
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ageTextField {
        let maxLength = 2
        let currentString: NSString = ageTextField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func emailValidation() {
        if !((self.emailTF.text?.isValidEmail())!) {
            let title = ""
            let message = "Please enter a valid email address !"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            
            return
            
        }
    }
    @objc func updateProfile() {
        if !((self.emailTF.text?.isValidEmail())!) {
            self.emailTF.becomeFirstResponder()
            self.tableView.scrollsToTop = true

            let title = ""
            let message = "Please enter a valid email address !"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            return
            
        }
        var provider = ""
        if UserDefaults.standard.value(forKey: "PROVIDER_NAME") != nil {
            provider = UserDefaults.standard.value(forKey: "PROVIDER_NAME") as AnyObject as! String
        } else {
            provider = ""
        }
        var tempDict = [String : AnyObject]();
        var weight = Int(weightTextField.text!)
        var height = Int(heightTextField.text!)
        if countryCode == "1" {
            let lbs = weight
            weight = Int(Double(lbs!) * 0.45)
            let heightValue = totalCMS
            height = Int(heightValue)
        }
        tempDict = ["age":  Int(ageTextField.text!) as AnyObject,
                    "bodyShape": Int(bodyShapesString) as AnyObject,
                    "gender": gender as AnyObject,
                    "weight": weight as AnyObject,
                    "height": height as AnyObject,
                    "foodhabit": food.joined(separator: ",") as AnyObject,
                    "allergies": allergy.joined(separator: ",")  as AnyObject,
                    "conditions": conditions.joined(separator: ",")  as AnyObject,
                    "goals": goals.joined(separator: ",")  as AnyObject,
                    "email": self.emailTF.text! as AnyObject,
                    "provider": provider as AnyObject]
      //  MBProgressHUD.showAdded(to: self.view, animated: true)
      APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATEPROFILE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["user" : tempDict as AnyObject], success: { response in
            
            APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.PROFILEFACTS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                var mob = ""
                if UserDefaults.standard.value(forKey: "msisdn") != nil {
                mob = UserDefaults.standard.value(forKey: "msisdn") as! String;
                }
                if (self.myProfile?.count)! > 0 {
                    
                    for profileObj in self.myProfile! {
                        deleteRealmObj(objToDelete: profileObj)
                    }
                    
                    let profile = MyProfileInfo()
                    profile.id = self.incrementID()
                    profile.name = self.nickNameTextField.text!
                    profile.age = self.ageTextField.text!
                    if self.gender == "M" {
                        profile.gender = "M"
                    } else {
                        profile.gender = "F"
                    }
                    profile.msisdn = mob
                    profile.weight = self.weightTextField.text!
                    profile.height = self.heightTextField.text!
                    
                    if self.food.count > 0 {
                        profile.foodHabits = self.food.joined(separator: ",")
                    } else {
                        profile.foodHabits = ""
                    }
                    if self.allergy.count > 0 {
                        profile.allergies = self.allergy.joined(separator: ",")
                    } else {
                        profile.allergies = ""
                    }
                    if self.conditions.count > 0 {
                        profile.conditions = self.conditions.joined(separator: ",")
                    } else {
                        profile.conditions = ""
                    }
                    if self.bodyShapesString == "" {
                        if profile.gender == "M"{
                            profile.bodyShape = "1"
                        } else {
                            profile.bodyShape = "6"
                        }
                    } else {
                        profile.bodyShape = self.bodyShapesString
                    }
                    profile.email = self.emailTF.text!
                    profile.providerName = provider
                    if self.goals.count > 0 {
                        profile.goals = self.goals.joined(separator: ",")
                    } else {
                        profile.goals = ""
                    }
                    
                    saveToRealmOverwrite(objType: MyProfileInfo.self, objValues: profile)
                }
            
                let ct = CleverTapClass()
                ct.updateCleverTapWithProp(isUpdateProfile: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_TRENDS"), object: nil);
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "update_profile_alert", value: nil, table: nil))
                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                if responseDic.count == 2 {
                    let responseResult =  responseDic["profileData"] as! [String : Int]
                    
                    if (self.pieChartInfo?.count)! > 0 {
                        
                        for pieChartObj in self.pieChartInfo! {
                            deleteRealmObj(objToDelete: pieChartObj)
                        }
                        
                        let chartValues = TweakPieChartValues()
                        chartValues.id = self.incrementID()
                        chartValues.carbsPerc = responseResult["carbsPerc"]!
                        chartValues.proteinPerc = responseResult["proteinPerc"]!
                        chartValues.fatPerc = responseResult["fatPerc"]!
                        chartValues.fiberPerc = responseResult["otherPerc"]!
                        saveToRealmOverwrite(objType: TweakPieChartValues.self, objValues: chartValues)
                        
                        
                    }
                } else{
                    
                }
                
            }, failure : { error in
                
                print("failure")
//                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertControllerStyle.alert)
//                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
            })
            
        }, failure : { error in
             print("failure")
//            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertControllerStyle.alert)
//            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
        })
    }
    
//    func calculateBMI(massInKilograms mass: Double, heightInCentimeters height: Double) -> Double {
//        return mass / ((height * height) / 10000)
//    }
//
    @IBAction func updateProfileAction(_ sender: Any) {
        self.updateProfile()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return bundle.localizedString(forKey: "your_profile_details", value: nil, table: nil)
        } else if section == 1 {
            return bundle.localizedString(forKey: "food_type", value: nil, table: nil)
        } else if section == 2 {
            return bundle.localizedString(forKey: "allergies", value: nil, table: nil)
        } else if section == 3 {
            return bundle.localizedString(forKey: "conditions", value: nil, table: nil)
        } else if section == 4 {
            return "Goals"
        } else if section == 5 {
            return bundle.localizedString(forKey: "body_shapes", value: nil, table: nil)
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        } else if indexPath.section == 1 {
            if self.foodHabitsArray.count % 2 == 0{
                return CGFloat((self.foodHabitsArray.count * 30)/2 + self.foodHabitsArray.count / 2 * 5 + 5)
            } else {
                return CGFloat((self.foodHabitsArray.count * 30)/2 + self.foodHabitsArray.count / 2 * 5 + 35)
            }
        } else if indexPath.section == 2 {
            if self.allergies.count % 2 == 0{
                return CGFloat((self.allergies.count * 30)/2 + self.allergies.count / 2 * 5 + 5)
            } else {
                return CGFloat((self.allergies.count * 30)/2 + self.allergies.count / 2 * 5 + 35)
            }
        } else if indexPath.section == 3 {
            if self.conditionsArray.count % 2 == 0{
                return CGFloat((self.conditionsArray.count * 30)/2 + self.conditionsArray.count / 2 * 5 + 5)
            } else {
                return CGFloat((self.conditionsArray.count * 30)/2 + self.conditionsArray.count / 2 * 5 + 35)
            }
        }  else if indexPath.section == 4 {
            if self.goalsArray.count % 2 == 0{
                return CGFloat((self.goalsArray.count * 50)/2 + self.goalsArray.count / 2 * 5 + 5)
            } else {
                return CGFloat((self.goalsArray.count * 50)/2 + self.goalsArray.count / 2 * 5 + 55)
            }
        } else if indexPath.section == 5 {
            return 260.0
        } else if indexPath.section == 6 {
            return 46.0
        }
        return 0
    }
    @objc func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
