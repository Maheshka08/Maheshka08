//
//  MyNutritionView.swift
//  Tweak and Eat
//
//  Created by Mehera on 26/06/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation
import UIKit

protocol MyNutritionButtonsTapped {
    func tappedOnLast10Tweaks()
    func tappedOnSelectYourMeal()
}

class MyNutritionView: UIView {
    @IBOutlet weak var myNutritionFatsView: CircularProgressView!
    @IBOutlet weak var viewWdthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var proteinsValue: UILabel!
    @IBOutlet weak var myNutritionProteinsView: CircularProgressView!
    
    @IBOutlet weak var carbsValue: UILabel!
    @IBOutlet weak var fatsValue: UILabel!
    var switchButton: SwitchWithText!
    @IBOutlet weak var caloriesValue: UILabel!
    @IBOutlet weak var myNutritionCarbsView: CircularProgressView!
    var delegate: MyNutritionButtonsTapped!
    @IBOutlet weak var last10TweaksLbl: UILabel!
    @IBOutlet weak var selectYourMealLbl: UILabel!
    @IBOutlet weak var last10TweaksView: UIView!
    @IBOutlet weak var selectYourMealView: UIView!
    @IBOutlet weak var myNutritionCaloriesView: UIView!
    
    func updateSwitchUI(bool: Bool) {
         switchButton = SwitchWithText(frame: CGRect(x: self.frame.width - 100, y: 14, width: 90, height: 30))
                self.addSubview(switchButton)
        self.switchButton.setStatus(bool)
    }
    
    @IBAction func last10TweaksTapped(_ sender: Any) {
        self.delegate.tappedOnLast10Tweaks()
    }
    @IBAction func selectYourMealTapped(_ sender: Any) {
        self.delegate.tappedOnSelectYourMeal()
    }
    
}
