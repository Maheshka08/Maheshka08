//
//  TweakAndEatFinalIntroScreen.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 20/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData


class TweakAndEatFinalIntroScreen: UIView {

    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var logoBorderView: UIView!;
    @IBOutlet var titleLabel: UILabel!;
    var delegate : WelcomeViewController! = nil;
    var timelines : TimelinesDetailsViewController! = nil;
    var tweakOtpView : TweakAndEatOTPView! = nil;
    var dbArray:[AnyObject] = [];
    
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

    @IBAction func onClickOfOkay(sender: AnyObject) {
        self.delegate.resignRegistrationScreen()
        
        //self.delegate.homeInfoApiCalls()
    }
}
