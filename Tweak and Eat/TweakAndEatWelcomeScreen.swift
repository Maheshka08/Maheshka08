//
//  TweakAndEatWelcomeScreen.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 03/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatWelcomeScreen: UIView {

    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var textScroll: UITextView!;
    @IBOutlet var logoBorderView: UIView!;
    
    var delegate : WelcomeViewController! = nil;

    func setIntroText(_ attributedText : NSAttributedString) {

        textScroll.attributedText = attributedText;

    }
    
    @IBAction func onClickOfOk(_ sender: AnyObject) {
        delegate.switchToThirdScreen();
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
