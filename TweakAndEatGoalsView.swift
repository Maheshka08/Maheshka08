//
//  TweakAndEatGoalsView.swift
//  Tweak and Eat
//
//  Created by mac on 18/02/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class TweakAndEatGoalsView: UIView {
    
    @IBOutlet var selectionView: UIView!
    @IBOutlet var foodhabitHeightConstant: NSLayoutConstraint!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var logoView: UIView!
    @IBOutlet var animationView: UIView!
    @IBOutlet var logoBorderView: UIView!
    @IBOutlet var foodHabitContentView: UIView!
    @objc var foodhabit : String = ""
    @IBOutlet weak var foodHabitsLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    @objc var goals = [String]()
    @objc var fooddHabitName = "goal_name"
    @objc var foodHabitsArray = [[String : AnyObject]]()
    @objc var delegate : WelcomeViewController! = nil;
    @objc var y: CGFloat = 25
    @objc var x: CGFloat = 10
    @objc var y1: CGFloat = 25
    @objc var y11: CGFloat = 25
    @objc var x1: CGFloat = 10
    
    @IBAction func okAction(_ sender: Any) {
        
        self.delegate.switchToEighthScreen()
        
    }
    
    @objc func clickedon(_ sender: UIButton) {
        sender.setImage(UIImage(named: "tweakCheck.png")!, for: UIControl.State.normal)
    }
    
    @objc func clickedOff(_ sender: UIButton){
        sender.setImage(UIImage(named: "uncheckTweak.png")!, for: UIControl.State.normal)
    }
    
    @objc func createButton(xAxis: CGFloat, yAxis: CGFloat, tag: Int, type: Int, isChecked: Bool) {
        let checkBoxBtn = UIButton()
        checkBoxBtn.frame = CGRect(x:xAxis, y:yAxis, width:50, height: 50)
        checkBoxBtn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
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
        }
    }
    
    @objc func btnPressed(_ sender: UIButton!) {
        print(sender.tag)
        let labelTag = sender.tag + 100
        let label = self.viewWithTag(labelTag) as! UILabel
        print(label.text!)
        if label.isDescendant(of: self.foodHabitContentView) {
            if (sender.currentImage?.isEqual(UIImage(named: "tweakCheck.png")))! {
                self.clickedOff(sender)
                if goals.contains(label.text!) {
                    goals.remove(at: goals.index(of: label.text!)!)
                }
            } else {
                self.clickedon(sender)
                goals.append(label.text!)
            }
        }
    }
    
    @objc func createFoodHabitLabel(xAxis: CGFloat, yAxis: CGFloat, foodhabit: String, type: Int, tag: Int, isChecked: Bool) {
        let foodHabitLabel = UILabel()
        foodHabitLabel.frame = CGRect(x:xAxis, y:yAxis, width:130, height: 50)
        foodHabitLabel.numberOfLines = 0
        foodHabitLabel.font = UIFont.systemFont(ofSize: 15.0)
        foodHabitLabel.text = foodhabit
        if isChecked == true {
            if type == 0 {
                goals.append(foodhabit)
            }
            
        }
        foodHabitLabel.tag = tag
        x1 = foodHabitLabel.frame.maxX
        //y1 = foodHabitLabel.frame.minY
        if type == 0 {
            self.foodHabitContentView.addSubview(foodHabitLabel)
        }
        
    }
    
    @objc func setUpViews() {
        var count = 0
        var tagBtn = 0
        var tagLbl = 100
        
        foodHabitsArray = UserDefaults.standard.value(forKey: "GOALS") as! [[String : AnyObject]]
        print(foodHabitsArray)
        for foodHabit in foodHabitsArray {
            let food = foodHabit[fooddHabitName] as AnyObject as? String
            count += 1
            
            
            if count % 2 != 0 {
                tagBtn += 1
                tagLbl += 1
                x = 2
                self.createButton(xAxis: x, yAxis: y, tag: tagBtn, type: 0, isChecked: false)
                self.createFoodHabitLabel(xAxis: x + 2, yAxis: y, foodhabit: food!, type: 0, tag: tagLbl, isChecked: false)
                
            } else {
                tagBtn += 1
                tagLbl += 1
                
                self.createButton(xAxis: x1 + 2, yAxis: y, tag: tagBtn, type: 0, isChecked: false)
                self.createFoodHabitLabel(xAxis: x1 + 52, yAxis: y, foodhabit: food!, type: 0, tag: tagLbl, isChecked: false)
                y = CGFloat(5 + y1)
                
            }
            
        }
        if self.foodHabitsArray.count % 2 == 0{
            self.foodhabitHeightConstant.constant = CGFloat((self.foodHabitsArray.count * 50)/2 + self.foodHabitsArray.count / 2 * 5 + 25)
        } else {
            self.foodhabitHeightConstant.constant =  CGFloat((self.foodHabitsArray.count * 50)/2 + self.foodHabitsArray.count / 2 * 5 + 60)
        }
        
       
    }

    
    @objc func beginning() {
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            if (UserDefaults.standard.value(forKey: "LANGUAGE") as! String == "AR") {
                fooddHabitName = "fh_ba_name"
            }
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
