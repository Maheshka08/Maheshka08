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

class ManageProfileViewController: UITableViewController, UITextFieldDelegate {
    
    var myProfile : Results<MyProfileInfo>?
    var pieChartInfo : Results<TweakPieChartValues>?
    
    var selectGender : String = " "
    var foodhabit : String!
    
    
    @IBOutlet var registeredMobile: UILabel!
    @IBOutlet weak var dummy: UITextField!
    var allergies = [[String : AnyObject]]()
    var foodHabitsArray = [[String : AnyObject]]()
    var conditionsArray = [[String : AnyObject]]()
    var selectedAllergies = [String]()
    var selectedConditions = [String]()
    var genderSelectionSize : CGFloat!;
    let borderLabel : UILabel = UILabel();
    var food = [String]()
    var allergy = [String]()
    var conditions = [String]()
    
    var eggs : String = ""
    var Milk : String = ""
    var Nuts : String = ""
    var Shellfish : String = ""
    var Soy : String = ""
    var Wheat : String = ""
    var BloodPressure : String = ""
    var Cholesterol : String = ""
    var Diabetes : String = ""
    var y: CGFloat = 5
    var x: CGFloat = 10
    var y1: CGFloat = 5
    var y11: CGFloat = 5
    var x1: CGFloat = 10
    var food1 : String = ""
    var allergy1 : String = ""
    var conditions1 : String = ""
    
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
    
    var foodHabitsString: String = ""
    var allergiesString: String = ""
    var conditionsString: String = ""
    var bodyShapesString: String = ""
    var gender: String = ""
    
    func createButton(xAxis: CGFloat, yAxis: CGFloat, tag: Int, type: Int, isChecked: Bool) {
        let checkBoxBtn = UIButton()
        checkBoxBtn.frame = CGRect(x:xAxis, y:yAxis, width:30, height: 30)
        checkBoxBtn.addTarget(self, action: #selector(ManageProfileViewController.btnPressed(_:)), for: .touchUpInside)
        checkBoxBtn.tag = tag
        if isChecked == false {
            self.clickedOff(checkBoxBtn)
        } else {
            self.clickedon(checkBoxBtn)
        }
        x = checkBoxBtn.frame.maxX
        y1 = checkBoxBtn.frame.maxY
        y11 = checkBoxBtn.frame.maxY
        if type == 0 {
            self.foodHabitContentView.addSubview(checkBoxBtn)
        } else if type == 1 {
            self.allergiesContentView.addSubview(checkBoxBtn)
        } else if type == 2 {
            self.conditionsContentView.addSubview(checkBoxBtn)
        }
    }
    
    func btnPressed(_ sender: UIButton!) {
        print(sender.tag)
        let labelTag = sender.tag + 100
        let label = self.view.viewWithTag(labelTag) as! UILabel
        print(label.text!)
        if label.isDescendant(of: self.foodHabitContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender)
                if food.contains(label.text!) {
                    food.remove(at: food.index(of: label.text!)!)
                }
            } else {
                self.clickedon(sender)
                food.append(label.text!)
            }
            
            
        } else if label.isDescendant(of: self.allergiesContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender)
                if allergy.contains(label.text!) {
                    allergy.remove(at: allergy.index(of: label.text!)!)
                }
            } else {
                self.clickedon(sender)
                allergy.append(label.text!)
            }
            
            
        } else if label.isDescendant(of: self.conditionsContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender)
                if conditions.contains(label.text!) {
                    conditions.remove(at: conditions.index(of: label.text!)!)
                }
            } else {
                self.clickedon(sender)
                conditions.append(label.text!)
            }
            
            
        }
        
    }
    
    
    func createFoodHabitLabel(xAxis: CGFloat, yAxis: CGFloat, foodhabit: String, type: Int, tag: Int, isChecked: Bool) {
        let foodHabitLabel = UILabel()
        foodHabitLabel.frame = CGRect(x:xAxis, y:yAxis, width:120, height: 30)
        foodHabitLabel.font = UIFont.systemFont(ofSize: 13.0)
        foodHabitLabel.text = foodhabit
        if isChecked == true {
            if type == 0 {
                food.append(foodhabit)
            } else if type == 1 {
                allergy.append(foodhabit)
            } else if type == 2 {
                conditions.append(foodhabit)
            }
        }
        foodHabitLabel.tag = tag
        x1 = foodHabitLabel.frame.maxX
        //y1 = foodHabitLabel.frame.minY
        if type == 0 {
            self.foodHabitContentView.addSubview(foodHabitLabel)
        } else if type == 1 {
            self.allergiesContentView.addSubview(foodHabitLabel)
        } else if type == 2 {
            self.conditionsContentView.addSubview(foodHabitLabel)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
       
        
//        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update Profile", style: .plain, target: self, action: #selector(barButtonItemClicked))
        
        
        let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.registeredMobile.text = "Registered Mobile: +\(msisdn)"
        self.myProfile = uiRealm.objects(MyProfileInfo.self)
        self.pieChartInfo = uiRealm.objects(TweakPieChartValues.self)
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        for dataStr in self.myProfile! {
            foodHabitsString = dataStr.foodHabits
            allergiesString = dataStr.allergies
            conditionsString = dataStr.conditions
            bodyShapesString = dataStr.bodyShape
            gender = dataStr.gender
            
        }
        
        self.updateProfileBtn.layer.backgroundColor = TweakAndEatColorConstants.AppDefaultColor.cgColor
        self.updateProfileBtn.layer.cornerRadius = 5
        foodHabitsArray = UserDefaults.standard.value(forKey: "FOODHABITS") as! [[String : AnyObject]]
        allergies = UserDefaults.standard.value(forKey: "ALLERGIES") as! [[String : AnyObject]]
        conditionsArray = UserDefaults.standard.value(forKey: "CONDITIONS") as! [[String : AnyObject]]
        //foodHabitsArray = ["Vegan","Dairy OK","Eggs OK","Fish OK","Chicken & Goat OK","Pork OK","Beef OK"]
        //foodHabitsArray = ["Vegan","Dairy OK"]
        var count = 0
        var tagBtn = 0
        var tagLbl = 100
        
        
        var buttonCheckedOrNot: Bool = false
        for foodHabit in foodHabitsArray {
            food1 = (foodHabit["fh_name"] as AnyObject as? String)!
            if foodHabitsString.components(separatedBy: (",")).count > 1 {
                let foodArray1 = foodHabitsString.components(separatedBy: (","))
                if foodArray1 .contains(food1) {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            } else {
                if foodHabitsString == food1 {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            }
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 0, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: food1, type: 0, tag: tagLbl, isChecked: buttonCheckedOrNot)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 0, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: food1, type: 0, tag: tagLbl, isChecked: buttonCheckedOrNot)
                y = CGFloat(5 + y1)
                
            }
            
        }
        
        y = 5
        count = 0
        for allergy in allergies {
            allergy1 = (allergy["alg_name"] as AnyObject as? String)!
            if allergiesString.components(separatedBy: (",")).count > 1 {
                let allergyArray1 = allergiesString.components(separatedBy: (","))
                if allergyArray1 .contains(allergy1) {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            } else {
                if allergiesString == allergy1 {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            }
            
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 1, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: allergy1, type: 1, tag: tagLbl, isChecked: buttonCheckedOrNot)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 1, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: allergy1, type: 1, tag: tagLbl, isChecked: buttonCheckedOrNot)
                y = CGFloat(5 + y11)
                
            }
            
        }
        
        y = 5
        count = 0
        for cond in conditionsArray {
            conditions1 = (cond["cond_name"] as AnyObject as? String)!
            if conditionsString.components(separatedBy: (",")).count > 1 {
                let conditionsArray1 = conditionsString.components(separatedBy: (","))
                if conditionsArray1 .contains(conditions1) {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            } else {
                if conditionsString == conditions1 {
                    buttonCheckedOrNot = true
                } else {
                    buttonCheckedOrNot = false
                }
            }
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 2, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: conditions1, type: 2, tag: tagLbl, isChecked: buttonCheckedOrNot)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 2, isChecked: buttonCheckedOrNot)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: conditions1, type: 2, tag: tagLbl, isChecked: buttonCheckedOrNot)
                y = CGFloat(5 + y11)
                
            }
            
        }
        
        setImageViewsOfGender()
        setborderLabels()
        setBodySizes()
        if gender == "M" {
            if bodyShapesString == "1"{
                bodyShapesString = "1"
                self.setSelectedBodyShape(tagVal: 200)
            } else if bodyShapesString == "2" {
                bodyShapesString = "2"
                self.setSelectedBodyShape(tagVal: 201)
            } else if bodyShapesString == "3" {
                bodyShapesString = "3"
                self.setSelectedBodyShape(tagVal: 202)
            } else if bodyShapesString == "4" {
                bodyShapesString = "4"
                self.setSelectedBodyShape(tagVal: 203)
            } else if bodyShapesString == "5" {
                self.setSelectedBodyShape(tagVal: 204)
                bodyShapesString = "5"
            }
            
        } else {
            if bodyShapesString == "6"{
                bodyShapesString = "6"
                self.setSelectedBodyShape(tagVal: 200)
            } else if bodyShapesString == "7" {
                bodyShapesString = "7"
                self.setSelectedBodyShape(tagVal: 201)
            } else if bodyShapesString == "8" {
                bodyShapesString = "8"
                self.setSelectedBodyShape(tagVal: 202)
            } else if bodyShapesString == "9" {
                bodyShapesString = "9"
                self.setSelectedBodyShape(tagVal: 203)
            } else if bodyShapesString == "10" {
                bodyShapesString = "10"
                self.setSelectedBodyShape(tagVal: 204)
            } else if bodyShapesString == "11" {
                bodyShapesString = "11"
                self.setSelectedBodyShape(tagVal: 205)
            }
            
        }
        
        maleLabel.text = "M";
        maleLabel.tag = 2000;
        self.selectLabel(maleLabel);
        maleLabel.isUserInteractionEnabled = true;
        self.maleLabel.backgroundColor = UIColor.clear
        
        femaleLabel.text = "F";
        femaleLabel.tag = 2001;
        self.deselectLabel(femaleLabel);
        femaleLabel.isUserInteractionEnabled = true;
        self.femaleLabel.backgroundColor = UIColor.clear
        self.femaleLabel.textColor = UIColor.white
        
        for myProfileObj in self.myProfile! {
            
            self.ageTextField.text = myProfileObj.age;
            self.heightTextField.text = myProfileObj.height;
            self.weightTextField.text = myProfileObj.weight;
            self.nickNameTextField.text = myProfileObj.name;
            
            if myProfileObj.gender == "M" {
                maleLabel.layer.backgroundColor = UIColor.white.cgColor
                maleLabel.textColor = TweakAndEatColorConstants.AppDefaultColor
                self.selectLabel(maleLabel)
                self.deselectLabel(femaleLabel)
            } else {
                femaleLabel.layer.backgroundColor = UIColor.white.cgColor
                femaleLabel.textColor = TweakAndEatColorConstants.AppDefaultColor
                self.selectLabel(femaleLabel)
                self.deselectLabel(maleLabel)
            }
            
        }
        
    }
    
//    func barButtonItemClicked() {
//        
//        self.updateProfile()
//        
//    }
    
    
    func setSelectedBodyShape(tagVal: Int) {
        var selectedImg = self.bodyShapesContentView.viewWithTag(tagVal) as! UIImageView
        if bodyShapesString == "1"{
            
            selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "1"
            
        } else if bodyShapesString == "2" {
            //for 5s Screen
            if UIScreen.main.bounds.size.height == 568  {
                selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "2"
            } //for 7s plus Screen
            else if UIScreen.main.bounds.size.height == 736 {
                selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 48, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "2"
            }
                // for 4s Screen
            else if UIScreen.main.bounds.size.height == 480 {
                selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "2"
            }
                
                
            else //for 6s plus Screen
            {
                selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 28, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "2"
            }
        } else if bodyShapesString == "3" {
            if UIScreen.main.bounds.size.height == 568 {
                selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "3"
            }else if UIScreen.main.bounds.size.height == 736 {
                selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 94, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "3"
            }
                //for iphone 4S
            else if UIScreen.main.bounds.size.height == 480 {
                selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "3"
            }
                
            else{
                selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 55, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "3"
            }
        } else if bodyShapesString == "4" {
            selectedImg = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
            self.bodyShapesContentView.addSubview(selectedImg);
            bodyShapesString = "4"
            
        } else if bodyShapesString == "5" {
            if UIScreen.main.bounds.size.height == 568 {
                selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "5"
            }else if UIScreen.main.bounds.size.height == 736 {
                selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 48, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "5"
            }
                //for iphone 4S
            else if UIScreen.main.bounds.size.height == 480 {
                selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "5"
            }
            else{
                selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX + 28, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "5"
            }
        }
        else {
            if bodyShapesString == "6"{
                
                selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "6"
                
            } else if bodyShapesString == "7" {
                if UIScreen.main.bounds.size.height == 568  {
                    selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "7"
                }
                else if UIScreen.main.bounds.size.height == 480 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "7"
                }
                    
                else if UIScreen.main.bounds.size.height == 736 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 48, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "7"
                }
                    
                else {
                    selectedImg = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 28, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "7"
                }
            } else if bodyShapesString == "8" {
                if UIScreen.main.bounds.size.height == 568 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "8"
                }
                    //for iphone 4S
                else if UIScreen.main.bounds.size.height == 480 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "8"
                }
                    
                else if UIScreen.main.bounds.size.height == 736 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 94, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "8"
                }
                    
                else{
                    selectedImg = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 55, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "8"
                    
                }
            } else if bodyShapesString == "9" {
                
                selectedImg = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "9"
                
            } else if bodyShapesString == "10" {
                if UIScreen.main.bounds.size.height == 568  {
                    selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "10"
                }
                    //for iphone 4S
                else if UIScreen.main.bounds.size.height == 480 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "10"
                }
                    
                else if UIScreen.main.bounds.size.height == 736 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 48, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "10"
                }
                    
                else{
                    selectedImg = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 28, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "10"
                    
                }
            } else if bodyShapesString == "11" {
                if UIScreen.main.bounds.size.height == 568 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                    //for iphone 4S
                else if UIScreen.main.bounds.size.height == 480 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX - 67 , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                else if UIScreen.main.bounds.size.height == 736 {
                    selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 95, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                    
                    
                    
                else{
                    selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 55, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
            }
        }
    }
    
    func setImageViewsOfGender() {
        genderSelectionSize = option1.frame.size.width ;
        
        option1.tag = 200;
        option1.layer.cornerRadius = genderSelectionSize / 2;
        option1.layer.borderWidth = 1;
        option1.layer.borderColor = UIColor.white.cgColor;
        option1.layer.masksToBounds = true;
        option1.contentMode = UIViewContentMode.scaleAspectFit;
        
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        option1.addGestureRecognizer(tapGesture1);
        option1.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option1);
        
        
        option2.tag = 201;
        option2.layer.cornerRadius = genderSelectionSize / 2;
        option2.layer.borderWidth = 1;
        option2.layer.borderColor = UIColor.white.cgColor;
        option2.layer.masksToBounds = true;
        
        let tapGesture2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture2.numberOfTapsRequired = 1;
        option2.addGestureRecognizer(tapGesture2);
        option2.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option2);
        
        
        option3.tag = 202;
        option3.layer.cornerRadius = genderSelectionSize / 2;
        option3.layer.borderWidth = 1;
        option3.layer.borderColor = UIColor.white.cgColor;
        option3.layer.masksToBounds = true;
        
        let tapGesture3 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture3.numberOfTapsRequired = 1;
        option3.addGestureRecognizer(tapGesture3);
        option3.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option3);
        
        
        option4.tag = 203;
        option4.layer.cornerRadius = genderSelectionSize / 2;
        option4.layer.borderWidth = 1;
        option4.layer.borderColor = UIColor.white.cgColor;
        option4.layer.masksToBounds = true;
        
        let tapGesture4 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture4.numberOfTapsRequired = 1;
        option4.addGestureRecognizer(tapGesture4);
        option4.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option4);
        
        
        option5.tag = 204;
        option5.layer.cornerRadius = genderSelectionSize / 2;
        option5.layer.borderWidth = 1;
        option5.layer.borderColor = UIColor.white.cgColor;
        option5.layer.masksToBounds = true;
        let tapGesture5 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture5.numberOfTapsRequired = 1;
        option5.addGestureRecognizer(tapGesture5);
        option5.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option5);
        
        
        option6.tag = 205;
        option6.layer.cornerRadius = genderSelectionSize / 2;
        option6.layer.borderWidth = 1;
        option6.layer.borderColor = UIColor.white.cgColor;
        option6.layer.masksToBounds = true;
        
        let tapGesture6 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManageProfileViewController.labelSizeOptionTapped(_:)));
        tapGesture6.numberOfTapsRequired = 1;
        option6.addGestureRecognizer(tapGesture6);
        option6.isUserInteractionEnabled = true;
        
        self.bodyShapesContentView.addSubview(option6);
        let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
        
        borderLabel.backgroundColor = UIColor.green;
        borderLabel.layer.cornerRadius = genderSelectionSize / 2;
        borderLabel.layer.masksToBounds = true;
        borderLabel.tag = 199;
        
        self.bodyShapesContentView.addSubview(borderLabel);
        
        
        
        borderLabel.frame = CGRect(x: selectedImg.frame.minX + 76, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize);
        
        
    }
    
    
    
    func clickedon(_ sender: UIButton) {
        sender.setImage(UIImage(named: "tweakCheck.png")!, for: UIControlState.normal)
    }
    
    func clickedOff(_ sender: UIButton){
        sender.setImage(UIImage(named: "uncheckTweak.png")!, for: UIControlState.normal)
    }
    
    func labelSizeOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        let tappedImageView : UIImageView = tapGesture.view as! UIImageView
        
        UIView.animate(withDuration: 0.5, animations: {
            self.borderLabel.frame = CGRect(x: tappedImageView.frame.minX, y: tappedImageView.frame.minY, width: self.genderSelectionSize, height: self.genderSelectionSize)
            
        })
        
        let borderLabel : UILabel = self.bodyShapesContentView.viewWithTag(199) as! UILabel
        
        let option : UIImageView
        
        if(tappedImageView.tag == 200) {
            option = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            if gender == "M" {
                bodyShapesString = "1"
            } else if gender == "F" {
                bodyShapesString = "6"
            }
            
        } else if(tappedImageView.tag == 201) {
            option = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            if gender == "M" {
                bodyShapesString = "2"
            } else if gender == "F" {
                bodyShapesString = "7"
            }
            
        }else if(tappedImageView.tag == 202) {
            option = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            
            if gender == "M" {
                bodyShapesString = "3"
            } else if gender == "F" {
                bodyShapesString = "8"
            }
            
        }else if(tappedImageView.tag == 203) {
            option = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            if gender == "M" {
                bodyShapesString = "4"
            } else if gender == "F" {
                bodyShapesString = "9"
            }
            
        }else if(tappedImageView.tag == 204) {
            option = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            if gender == "M" {
                bodyShapesString = "5"
            } else if gender == "F" {
                bodyShapesString = "10"
            }
        }else if(tappedImageView.tag == 205) {
            option = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            if gender == "F" {
                bodyShapesString = "11"
            }
            
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            borderLabel.frame = CGRect(x: tappedImageView.frame.minX, y: tappedImageView.frame.minY, width: self.genderSelectionSize, height: self.genderSelectionSize)
            
        })
        
        self.bodyShapesContentView.addSubview(tappedImageView)
    }
    
    func setborderLabels(){
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
    
    func setBodySizes() {
        
        self.myProfile = uiRealm.objects(MyProfileInfo.self)
        for myProfileObj in self.myProfile! {
            if(myProfileObj.gender == "M") {
                
                option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                option1.image = UIImage(named:"men_1.png")
                self.mlabel1.text = "SUPER FIT"
                mlabel1.textAlignment = .center
                
                option2 = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                option2.image = UIImage(named:"men_2.png")
                self.label2.text = "FIT"
                label2.textAlignment = .center
                
                option3  = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                option3.image = UIImage(named:"men_3.png")
                self.mlabel3.text = "AVERAGE"
                mlabel3.textAlignment = .center
                
                option4 = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
                option4.image = UIImage(named:"men_4.png")
                self.mlabel4.text = "BOTTOM"
                mlabel4.textAlignment = .center
                
                option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                option5.image = UIImage(named:"men_5.png")
                self.mlabel5.text = "CENTRAL"
                mlabel5.textAlignment = .center
                
                option6  = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                self.flabel6.isHidden = true
                option6.isHidden = true
                option6.isUserInteractionEnabled = false
                flabel6.isHidden = true
                
                
            } else {
                option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                option1.image = UIImage(named:"women_1.png")
                self.mlabel1.text = "HOUR GLASS"
                
                option2  = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
                option2.image = UIImage(named:"women_2.png")
                self.label2.text = "FIT"
                
                option3 = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
                option3.image = UIImage(named:"women_3.png")
                self.mlabel3.text = "SLENDAR"
                
                option4  = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
                option4.image = UIImage(named:"women_4.png")
                self.mlabel4.text = "PEAR"
                
                option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
                option5.image = UIImage(named:"women_5.png")
                self.mlabel5.text = "APPLE"
                
                option6 = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                option6.image = UIImage(named: "women_6.png")
                flabel6.isHidden = false
                self.flabel6.text = "HEAVY"
                option6.isHidden = false
                option6.isUserInteractionEnabled = true
                
            }
        }
    }
    
    func genderSelection(){
        
        if(self.gender == "M") {
            self.gender = "M"
            option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"men_1.png")
            self.mlabel1.text = "SUPER FIT"
            mlabel1.textAlignment = .center
            
            option2 = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"men_2.png")
            self.label2.text = "FIT"
            label2.textAlignment = .center
            
            option3  = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"men_3.png")
            self.mlabel3.text = "AVERAGE"
            mlabel3.textAlignment = .center
            
            option4 = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"men_4.png")
            self.mlabel4.text = "BOTTOM"
            mlabel4.textAlignment = .center
            
            option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"men_5.png")
            self.mlabel5.text = "CENTRAL"
            mlabel5.textAlignment = .center
            
            option6  = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            self.flabel6.isHidden = true
            option6.isHidden = true
            option6.isUserInteractionEnabled = false
            flabel6.isHidden = true
            
            //borderLabel.removeFromSuperview()
            if bodyShapesString  == "11" && self.gender == "M"{
                let  selectedImg = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
                borderLabel.frame = CGRect(x: selectedImg.frame.minX , y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                self.bodyShapesContentView.addSubview(selectedImg);
                bodyShapesString = "1"
            }
        } else {
            self.gender = "F"
            option1 = self.bodyShapesContentView.viewWithTag(200) as! UIImageView
            option1.image = UIImage(named:"women_1.png")
            self.mlabel1.text = "HOUR GLASS"
            
            option2  = self.bodyShapesContentView.viewWithTag(201) as! UIImageView
            option2.image = UIImage(named:"women_2.png")
            self.label2.text = "FIT"
            
            option3 = self.bodyShapesContentView.viewWithTag(202) as! UIImageView
            option3.image = UIImage(named:"women_3.png")
            self.mlabel3.text = "SLENDAR"
            
            option4  = self.bodyShapesContentView.viewWithTag(203) as! UIImageView
            option4.image = UIImage(named:"women_4.png")
            self.mlabel4.text = "PEAR"
            
            option5 = self.bodyShapesContentView.viewWithTag(204) as! UIImageView
            option5.image = UIImage(named:"women_5.png")
            self.mlabel5.text = "APPLE"
            
            option6 = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
            option6.image = UIImage(named: "women_6.png")
            flabel6.isHidden = false
            self.flabel6.text = "HEAVY"
            option6.isHidden = false
            option6.isUserInteractionEnabled = true
            if bodyShapesString  == "11" && self.gender == "F"{
                
                if UIScreen.main.bounds.size.height == 568  {
                    let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }else if UIScreen.main.bounds.size.height == 736 {
                    let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 95, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                else if UIScreen.main.bounds.size.height == 480 {
                    let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                    
                else{
                    let selectedImg = self.bodyShapesContentView.viewWithTag(205) as! UIImageView
                    borderLabel.frame = CGRect(x: selectedImg.frame.minX + 55, y: selectedImg.frame.minY, width: genderSelectionSize, height: genderSelectionSize)
                    self.bodyShapesContentView.addSubview(selectedImg);
                    bodyShapesString = "11"
                }
                
            }
            
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
        
        genderSelection()
    }
    
    func deselectLabel(_ label : UILabel) {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dummy.resignFirstResponder()
        return true
    }
    
    func updateProfile() {
        var tempDict = [String : AnyObject]();
        tempDict = ["age":  Int(ageTextField.text!) as AnyObject,
                    "bodyShape": Int(bodyShapesString) as AnyObject,
                    "gender": gender as AnyObject,
                    "weight": Int(weightTextField.text!) as AnyObject,
                    "height": Int(heightTextField.text!) as AnyObject,
                    "foodhabit": food.joined(separator: ",") as AnyObject,
                    "allergies": allergy.joined(separator: ",")  as AnyObject,
                    "conditions": conditions.joined(separator: ",")  as AnyObject]
        
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATEPROFILE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["user" : tempDict as AnyObject], success: { response in
            
            
            APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.PROFILEFACTS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                
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
                        if profile.gender == "M" {
                            profile.bodyShape = "1"
                        } else {
                            profile.bodyShape = "6"
                        }
                    } else {
                        profile.bodyShape = self.bodyShapesString
                    }
                    
                    saveToRealmOverwrite(objType: MyProfileInfo.self, objValues: profile)
                }
                
                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                if responseDic.count == 2 {
                    let responseResult =  responseDic["profileData"] as! [String : Int]
                    
                    if (self.pieChartInfo?.count)! > 0 {
                        
                        for pieChartObj in self.pieChartInfo! {
                            deleteRealmObj(objToDelete: pieChartObj)
                        }
                        
                        //let values = responseResult["proteinPerc"]!
                        let chartValues = TweakPieChartValues()
                        chartValues.id = self.incrementID()
                        chartValues.carbsPerc = responseResult["carbsPerc"]!
                        chartValues.proteinPerc = responseResult["proteinPerc"]!
                        chartValues.fatPerc = responseResult["fatPerc"]!
                        chartValues.fiberPerc = responseResult["fiberPerc"]!
                        saveToRealmOverwrite(objType: TweakPieChartValues.self, objValues: chartValues)
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your Profile has been Updated Sucessfully!")
                        
                    }
                } else{
                    
                }
                
            }, failure : { error in
                
                print("failure")
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
            
            //MBProgressHUD.hide(for: self.view, animated: true);
            
        }, failure : { error in
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        self.updateProfile()
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 188
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
        } else if indexPath.section == 4 {
            return 260.0
        } else if indexPath.section == 5 {
            return 46.0
        }
        return 0
    }
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

