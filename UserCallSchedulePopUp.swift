//
//  UserCallSchedulePopUp.swift
//  Tweak and Eat
//
//  Created by Mehera on 08/05/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

protocol UserCallSchedule {
    func closeBtnTapped()
}

class UserCallSchedulePopUp: UIView {

    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var ourCerifiedNutritionistLbl: UILabel!
    @IBOutlet weak var whenLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var outerView: UIView!
     var userCallScheduleDelegate : UserCallSchedule!
    @IBOutlet weak var yourCallLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @objc func beginning() {
        self.closeBtn.layer.cornerRadius = 15
        self.okayButton.layer.cornerRadius = 15
        self.innerView.layer.cornerRadius = 15
        self.outerView.backgroundColor = .clear
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        self.ourCerifiedNutritionistLbl.text = "Our Certified Nutritionist will be calling you on your registered mobile number: \(UserDefaults.standard.value(forKey: "msisdn") ?? "")"
        
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.userCallScheduleDelegate.closeBtnTapped()
    }
}
