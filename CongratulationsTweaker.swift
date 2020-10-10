//
//  CongratulationsTweaker.swift
//  Tweak and Eat
//
//  Created by Mehera on 10/10/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation

class CongratulationsTweaker: UIView {
    
    @IBOutlet weak var review2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var review1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var screenOneBgHeighgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var review1TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var review1Bg: UIImageView!
    @IBOutlet weak var review2Bg: UIImageView!
    @IBOutlet weak var screenOneBg: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @objc var delegate : WelcomeViewController! = nil;
    
    @objc func beginning() {
        self.nextBtn.isHidden = true

        if IS_iPHONEXRXSMAX {
            self.review1TopConstraint.constant = 280
        } else if IS_iPHONE678P {
            self.review1TopConstraint.constant = 280
        } else if IS_iPHONE678 {
            self.review1TopConstraint.constant = 250
        } else if IS_iPHONEXXS {
            self.review1TopConstraint.constant = 250
        } else if IS_iPHONE5 {
            self.review1TopConstraint.constant = 220
        }

    }
    @IBAction func nextBtnTapped(_ sender: Any) {
        
    }
    
}
