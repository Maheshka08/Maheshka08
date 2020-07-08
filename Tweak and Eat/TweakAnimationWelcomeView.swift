//
//  TweakAnimationWelcomeView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/08/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TweakAnimationWelcomeView: UIView {
    
    @objc let screenHeight: CGFloat = UIScreen.main.bounds.height;
    
    @IBOutlet var refreshView: UIView!
    @IBOutlet var animationView: UIView!;
    @IBOutlet var welcomeNote: UILabel!;
    @IBOutlet var welcomeToLabel: UILabel!;
    @IBOutlet var TweakandEatLabel: UILabel!;
    @IBOutlet var looseWeightNote: UILabel!;
    @IBOutlet var welcomeTextView: UIView!;
    @IBOutlet var welcomeTextDisplayView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var okButton: UIButton!;
    @IBOutlet var okButtonTop: NSLayoutConstraint!;
    @IBOutlet var logoBorderView: UIView!;
    
    @IBOutlet weak var languageSelectionView: UIView!
    @IBOutlet weak var languageSelectionLabel: UILabel!
    @IBOutlet weak var blockedUserView: UIView!
    @objc var delegate : WelcomeViewController! = nil;
    
    @IBOutlet weak var bahasaButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @objc let gapBetweenOkBtnAndText :CGFloat = 30;
    @objc let halfOfImage : CGFloat = 80;
    @objc let firstLabels : CGFloat = 70;
    
    @objc func setWelcomeViewText(_ welcomeText: String, looseWeightText : String) {
        welcomeNote.text = welcomeText;
        looseWeightNote.text = looseWeightText;
    }
    
    @IBAction func onClickOfOk(_ sender: AnyObject) {
        delegate.switchToThirdScreen();
    }
    
    @IBAction func bahasButtonTapped(_ sender: Any) {
     delegate.languageSelected(lang: "BA")
    }
    
    
    @IBAction func videoAction(_ sender: Any) {
        self.delegate.playVideoStartPage()
    }
 
    @IBAction func englishButtonTapped(_ sender: Any) {
        delegate.languageSelected(lang: "EN")
    }
    @IBAction func refreshPage(_ sender: Any) {
      
        delegate.getStaticText(lang: "EN")
    }
   
    @objc func animateLogo() {
        self.welcomeTextView.alpha = 1;
        self.welcomeToLabel.alpha = 1;
        self.TweakandEatLabel.alpha = 1;
        self.welcomeTextDisplayView.alpha = 1.0;
        self.okButton.isHidden = false;
   }
    
    @objc func beginning() {
        logoBorderView.clipsToBounds = true;
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2;
        animationView.clipsToBounds = true;
        animationView.layer.cornerRadius = animationView.frame.size.width / 2;
        logoView.clipsToBounds = true;
        logoView.layer.cornerRadius = logoView.frame.size.width / 2;
        logoImageView.clipsToBounds = true;
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2;
    }
}
