//
//  TweakAndEatNOIntenetVIew.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatNOIntenetVIew: UIView {

    let screenHeight: CGFloat = UIScreen.main.bounds.height;

    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoBorderView: UIView!;
    @IBOutlet var welcomeToLabel: UILabel!;
    @IBOutlet var TweakandEatLabel: UILabel!;
    @IBOutlet var welcomeTextView: UIView!;
    @IBOutlet var welcomeTextDisplayView: UIView!;
    @IBOutlet var okButton: UIButton!;
    @IBOutlet var okButtonTop: NSLayoutConstraint!;

    func beginning() {
        logoBorderView.clipsToBounds = true;
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2;
        animationView.clipsToBounds = true;
        animationView.layer.cornerRadius = animationView.frame.size.width / 2;
        logoView.clipsToBounds = true;
        logoView.layer.cornerRadius = logoView.frame.size.width / 2;
        logoImageView.clipsToBounds = true;
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2;
        
        self.perform(#selector(TweakAndEatNOIntenetVIew.animateLogo), with: nil, afterDelay: 0.3);
    }
    
    func animateLogo() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.center = CGPoint(x: self.animationView.center.x, y: self.frame.origin.y + 110);
            }, completion: { (animate : Bool) in
                self.welcomeTextDisplayView.alpha = 1.0;
                self.welcomeTextDisplayView.frame = CGRect(x: self.welcomeTextDisplayView.frame.origin.x, y: self.animationView.center.y, width: self.welcomeTextDisplayView.frame.size.width, height: 0);
                UIView.animate(withDuration: 0.5, animations: {
                    self.welcomeToLabel.alpha = 1;
                    self.TweakandEatLabel.alpha = 1;
                    self.welcomeTextDisplayView.frame = CGRect(x: self.welcomeTextDisplayView.frame.origin.x, y: self.animationView.center.y, width: self.welcomeTextDisplayView.frame.size.width, height: self.screenHeight * 0.825);
                    }, completion: { (animate : Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.welcomeTextView.alpha = 1;
                            self.okButtonTop.constant = self.screenHeight * 0.825 - 100;
                            self.okButton.isHidden = false;
                            self.welcomeTextDisplayView.frame = CGRect(x: self.welcomeTextDisplayView.frame.origin.x, y: self.animationView.center.y, width: self.welcomeTextDisplayView.frame.size.width, height: self.screenHeight * 0.825 - 50);
                        })
                })
        })
    }
    
    @IBAction func onClickOfTryAgain(_ sender: AnyObject) {
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        if(appDelegate.networkReconnectionBlock != nil) {
            appDelegate.networkReconnectionBlock!();
        }
    }

}
