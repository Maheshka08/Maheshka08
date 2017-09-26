//
//  TweakAnimationWelcomeView.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/08/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAnimationWelcomeView: UIView {
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height;
    
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
    
    @IBOutlet weak var blockedUserView: UIView!
    var delegate : WelcomeViewController! = nil;
    
    let gapBetweenOkBtnAndText :CGFloat = 30;
    let halfOfImage : CGFloat = 80;
    let firstLabels : CGFloat = 70;
    
    func setWelcomeViewText(_ welcomeText: String, looseWeightText : String) {
        welcomeNote.text = welcomeText;
        looseWeightNote.text = looseWeightText;
    }
    
    @IBAction func onClickOfOk(_ sender: AnyObject) {
        delegate.switchToSecondScreen();
    }
    
   
    
    func animateLogo() {
        self.welcomeTextView.alpha = 1;
        self.welcomeToLabel.alpha = 1;
        self.TweakandEatLabel.alpha = 1;
        self.welcomeTextDisplayView.alpha = 1.0;
        self.okButton.isHidden = false;
           }
    
    func beginning() {
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
