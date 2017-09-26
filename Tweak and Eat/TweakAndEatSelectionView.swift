//
//  TweakAndEatSelectionView.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/7/17.
//  Copyright © 2017 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatSelectionView: UIView {

    @IBOutlet var conditionsHeightConstant: NSLayoutConstraint!
    @IBOutlet var allergiesHeightConstant: NSLayoutConstraint!
    @IBOutlet var foodhabitHeightConstant: NSLayoutConstraint!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var logoView: UIView!
    @IBOutlet var animationView: UIView!
    @IBOutlet var logoBorderView: UIView!
    @IBOutlet var vegLabel: UILabel!
    @IBOutlet var vegAndEggLabel: UILabel!
    @IBOutlet var selectionView: UIView!
    @IBOutlet var nonVegLabel: UILabel!
    @IBOutlet var conditionsContentView: UIView!
    @IBOutlet var allergiesContentView: UIView!
    @IBOutlet var foodHabitContentView: UIView!
    var foodhabit : String = ""
   
    var allergies : NSArray! = nil;
    var selectedAllergies = [String]()
    var selectedConditions = [String]()
    var food = [String]()
    var allergy = [String]()
    var conditions = [String]()
    
    var eggs : String = ""
    var Milk : String = " "
    var Nuts : String = " "
    var Shellfish : String = " "
    var Soy : String = " "
    var Wheat : String = " "
    var BloodPressure : String = " "
    var Cholesterol : String = " "
    var Diabetes : String = " "
    var y: CGFloat = 25
    var x: CGFloat = 10
    var y1: CGFloat = 25
    var y11: CGFloat = 25
    var x1: CGFloat = 10

    var allergiesArray = [[String : AnyObject]]()
    var foodHabitsArray = [[String : AnyObject]]()
    var conditionsArray = [[String : AnyObject]]()
    var profileData : NSArray! = nil;

    @IBOutlet weak var allergiesBox1: UIButton!
    @IBOutlet weak var allergiesBox2: UIButton!
    @IBOutlet weak var allergiesBox3: UIButton!
    @IBOutlet weak var allergiesBox4: UIButton!
    @IBOutlet weak var allergiesBox5: UIButton!
    @IBOutlet weak var allergiesBox6: UIButton!
    
    
    @IBOutlet weak var conditionBox1: UIButton!
    @IBOutlet weak var conditionBox2: UIButton!
    @IBOutlet weak var conditionBox3: UIButton!
    
    
    var delegate : WelcomeViewController! = nil;
    
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
        let label = self.viewWithTag(labelTag) as! UILabel
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
    
    func setUpViews() {
        var count = 0
        var tagBtn = 0
        var tagLbl = 100
        
        foodHabitsArray = UserDefaults.standard.value(forKey: "FOODHABITS") as! [[String : AnyObject]]
        allergiesArray = UserDefaults.standard.value(forKey: "ALLERGIES") as! [[String : AnyObject]]
        conditionsArray = UserDefaults.standard.value(forKey: "CONDITIONS") as! [[String : AnyObject]]
        
        for foodHabit in foodHabitsArray {
            let food = foodHabit["fh_name"] as AnyObject as? String
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 0, isChecked: false)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: food!, type: 0, tag: tagLbl, isChecked: false)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 0, isChecked: false)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: food!, type: 0, tag: tagLbl, isChecked: false)
                y = CGFloat(5 + y1)
                
            }
            
        }
        if self.foodHabitsArray.count % 2 == 0{
            self.foodhabitHeightConstant.constant = CGFloat((self.foodHabitsArray.count * 30)/2 + self.foodHabitsArray.count / 2 * 5 + 25)
        } else {
            self.foodhabitHeightConstant.constant =  CGFloat((self.foodHabitsArray.count * 30)/2 + self.foodHabitsArray.count / 2 * 5 + 60)
        }

        y = 25
        count = 0
        for allergy in allergiesArray {
            let allerg = allergy["alg_name"] as AnyObject as? String
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 1, isChecked: false)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: allerg!, type: 1, tag: tagLbl, isChecked: false)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 1, isChecked: false)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: allerg!, type: 1, tag: tagLbl, isChecked: false)
                y = CGFloat(5 + y11)
                
            }
            
        }
        if self.allergiesArray.count % 2 == 0{
            self.allergiesHeightConstant.constant = CGFloat((self.allergiesArray.count * 30)/2 + self.allergiesArray.count / 2 * 5 + 25)
        } else {
            self.allergiesHeightConstant.constant =  CGFloat((self.allergiesArray.count * 30)/2 + self.allergiesArray.count / 2 * 5 + 60)
        }

        y = 25
        count = 0
        for cond in conditionsArray {
            let condition = cond["cond_name"] as AnyObject as? String
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 10
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 2, isChecked: false)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: condition!, type: 2, tag: tagLbl, isChecked: false)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 2, isChecked: false)
                self.createFoodHabitLabel(xAxis: x1 + 42, yAxis: y, foodhabit: condition!, type: 2, tag: tagLbl, isChecked: false)
                y = CGFloat(5 + y11)
                
            }
            
        }
        
        if self.conditionsArray.count % 2 == 0{
            self.conditionsHeightConstant.constant = CGFloat((self.conditionsArray.count * 30)/2 + self.conditionsArray.count / 2 * 5 + 25)
        } else {
            self.conditionsHeightConstant.constant =  CGFloat((self.conditionsArray.count * 30)/2 + self.conditionsArray.count / 2 * 5 + 60)
        }
    }
    
    func setSelectionType(){
    
        vegLabel.tag = 100;
        vegAndEggLabel.tag = 101;
        nonVegLabel.tag = 102;
        self.selectLabel(vegLabel);
        
        nonVegLabel.isUserInteractionEnabled = true;
        vegAndEggLabel.isUserInteractionEnabled = true;
        vegLabel.isUserInteractionEnabled = true;
        
        self.vegLabel.layer.borderWidth = 1;
        self.vegLabel.layer.borderColor =  TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.vegLabel.layer.cornerRadius = 4;
        
        
        self.vegAndEggLabel.layer.borderWidth = 1;
        self.vegAndEggLabel.layer.borderColor =  TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.vegAndEggLabel.layer.cornerRadius = 4;
        
        self.nonVegLabel.layer.borderWidth = 1;
        self.nonVegLabel.layer.borderColor =  TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.nonVegLabel.layer.cornerRadius = 4;

        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatSelectionView.labelGenderOptionTapped(_:)));
        tapGesture.numberOfTapsRequired = 1;
        
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatSelectionView.labelGenderOptionTapped(_:)));
        tapGesture1.numberOfTapsRequired = 1;
        
        let tapGesture2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweakAndEatSelectionView.labelGenderOptionTapped(_:)));
        tapGesture2.numberOfTapsRequired = 1;
        nonVegLabel.addGestureRecognizer(tapGesture2);
        vegAndEggLabel.addGestureRecognizer(tapGesture1);
        vegLabel.addGestureRecognizer(tapGesture);
        
        self.selectionView.addSubview(vegLabel);
        self.selectionView.addSubview(vegAndEggLabel);
        self.selectionView.addSubview(nonVegLabel);

    }
    
    
    @IBAction func allergyAct1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            selectedAllergies.append("Eggs")
            self.eggs = "Eggs"
            self.clickedon(allergiesBox1)
        }
        else
        {
            self.eggs = ""
            self.clickedOff(allergiesBox1)
        }
    }
    
    @IBAction func allergyAct2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            selectedAllergies.append("Milk")
            self.Milk = "Milk"
            self.clickedon(allergiesBox2)
        }
        else
        {
            self.Milk = " "
            self.clickedOff(allergiesBox2)
        }
    }

    @IBAction func allergyAct3(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            selectedAllergies.append("Nuts")
            self.Nuts = "Nuts"
            //self.selectedAllergies = "Wheat (Gluten)"
            self.clickedon(allergiesBox3)
            
        }
        else
        {
            self.Nuts = " "
            self.clickedOff(allergiesBox3)
        }
    }
    
    @IBAction func allergyAct4(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            selectedAllergies.append("Shellfish")
            self.Shellfish = "Shellfish"
            //self.selectedAllergies = "Milk"
            self.clickedon(allergiesBox4)
            
        }
        else
        {
            self.Shellfish = " "
            self.clickedOff(allergiesBox4)
            
        }
    }
    
    @IBAction func allergyAct5(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            selectedAllergies.append("Soy")
            self.Soy = "Soy"
           // self.selectedAllergies = "Eggs"
            self.clickedon(allergiesBox5)
        }
        else
        {
            self.Soy = " "
            self.clickedOff(allergiesBox5)
        }

    }
    
    @IBAction func allergyAct6(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
             selectedAllergies.append("Wheat (Gluten)")
            self.Wheat = "Wheat (Gluten)"
            self.clickedon(allergiesBox6)
        }
        else
        {
            self.Wheat = " "
            self.clickedOff(allergiesBox6)
            
        }
    }
    
    @IBAction func conditionAct1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            selectedConditions.append("Blood Pressure")
            self.BloodPressure = "Blood Pressure"
            self.clickedon(conditionBox1)
        }
        else
        {
            self.BloodPressure = " "
            self.clickedOff(conditionBox1)
        }

    }
    
    @IBAction func conditionAct2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            selectedConditions.append("Cholesterol")
            self.Cholesterol = "Cholesterol"
            self.clickedon(conditionBox2)
            
        }
        else
        {
            self.Cholesterol = " "
            self.clickedOff(conditionBox2)
            
        }
    }
    
    @IBAction func conditionAct3(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            selectedConditions.append("Diabetes")
            self.Diabetes = "Diabetes"
            self.clickedon(conditionBox3)
            
        }
        else
        {
            self.Diabetes = ""
            self.clickedOff(conditionBox3)
            
        }
    }
    
    func clickedon(_ sender: UIButton) {
        sender.setImage(UIImage(named: "tweakCheck.png")!, for: UIControlState.normal)
    }
    
    func clickedOff(_ sender: UIButton){
        sender.setImage(UIImage(named: "uncheckTweak.png")!, for: UIControlState.normal)
    }
    
    // Receive action
    func labelGenderOptionTapped(_ tapGesture: UITapGestureRecognizer) {
        var tappedLabel : UILabel = tapGesture.view as! UILabel
        if(tappedLabel.tag == 100) {
            self.selectLabel(vegLabel)
            foodhabit = "1"
             vegLabel = selectionView.viewWithTag(100) as! UILabel
            self.deselectLabel(vegAndEggLabel)
            self.deselectLabel(nonVegLabel)
        } else if(tappedLabel.tag == 101){
              self.selectLabel(vegAndEggLabel)
            foodhabit = "2"
             vegAndEggLabel = selectionView.viewWithTag(101) as! UILabel
             self.deselectLabel(vegLabel)
            self.deselectLabel(nonVegLabel)
            
        }else if(tappedLabel.tag == 102){
            foodhabit = "3"
            self.selectLabel(nonVegLabel)
              nonVegLabel = selectionView.viewWithTag(102) as! UILabel
            self.deselectLabel(vegAndEggLabel)
            self.deselectLabel(vegLabel)
        }
        UIView.animate(withDuration: 0.5, animations: {
            tappedLabel =  tapGesture.view as! UILabel
            
        })
    }
   
    
    func selectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.backgroundColor = TweakAndEatColorConstants.AppDefaultColor
    }
    
    func deselectLabel(_ label : UILabel) {
        label.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        label.textColor = TweakAndEatColorConstants.AppDefaultColor
        label.backgroundColor = UIColor.white
    }

    @IBAction func okAction(_ sender: Any) {
    
        self.delegate.switchToEighthScreen()
        
    }

    func beginning() {
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
