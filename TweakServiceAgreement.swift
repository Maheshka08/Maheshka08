//
//  TweakServiceAgreement.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 9/20/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class TweakServiceAgreement: UIView {
    @objc var delegate : WelcomeViewController! = nil;
    
    @objc var checkbox = UIImage(named: "whiteCheckedBox");
    @objc var uncheckBox =  UIImage(named:"whiteCheckbox");
    
    @IBOutlet weak var checkBoxBtn: UIButton!;
    var isboxclicked:Bool!;
    
    
    @IBOutlet weak var termsServiceTextView: UITextView!
    
    @IBOutlet weak var agreedBtn: UIButton!
    @IBOutlet weak var termsOfUseLabel: UILabel!
    
    @IBAction func agreeAction(_ sender: Any) {
        
        self.delegate.switchToSixthScreen();
    }
    
    @IBAction func checkBoxAct(_ sender: UIButton) {
      
        sender.isSelected = !sender.isSelected;
        
        if(sender.isSelected == true)
        {
            checkBoxBtn.setImage(checkbox, for: UIControl.State.normal);
            agreedBtn.isHighlighted = false;
            agreedBtn.isUserInteractionEnabled = true;
        }
        else
        {
            checkBoxBtn.setImage(uncheckBox, for: UIControl.State.normal);
            agreedBtn.isHighlighted = true;
            agreedBtn.isUserInteractionEnabled = false;
        }
    }

    @objc func setTermsOfUse(_ attributedText : NSAttributedString) {
        
        termsServiceTextView.attributedText = attributedText;
        
    }
}
