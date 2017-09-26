//
//  TweakServiceAgreement.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 9/20/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class TweakServiceAgreement: UIView {
    var delegate : WelcomeViewController! = nil;
    
    var checkbox = UIImage(named: "whiteCheckedBox")
    var uncheckBox =  UIImage(named:"whiteCheckbox")
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    var isboxclicked:Bool!
    
    @IBOutlet weak var agreedBtn: UIButton!
    @IBOutlet weak var termsServiceTextView: UITextView!
    @IBAction func agreeAction(_ sender: Any) {
        
        self.delegate.switchToSixthScreen()
    }
    
    
   
    @IBAction func checkBoxAct(_ sender: UIButton) {
        
        
   
        sender.isSelected = !sender.isSelected
        

        if(sender.isSelected == true)
        {
            checkBoxBtn.setImage(checkbox, for: UIControlState.normal)
            agreedBtn.isHighlighted = false
            agreedBtn.isUserInteractionEnabled = true
        }
        else
        {
            checkBoxBtn.setImage(uncheckBox, for: UIControlState.normal)
            agreedBtn.isHighlighted = true
            agreedBtn.isUserInteractionEnabled = false
        }
        
        
    }

    
    func setTermsOfUse(_ attributedText : NSAttributedString) {
        
        termsServiceTextView.attributedText = attributedText;
        
    }
}
