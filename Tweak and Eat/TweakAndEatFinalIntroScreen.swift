//
//  TweakAndEatFinalIntroScreen.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 20/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging
import CleverTapSDK

class TweakAndEatFinalIntroScreen: UIView {

    @IBOutlet weak var justTweakView: UIView!
    @IBOutlet var animationView: UIView!;
    @IBOutlet var logoView: UIView!;
    @IBOutlet var logoImageView: UIImageView!;
    @IBOutlet var logoBorderView: UIView!;
  
    @objc var delegate : WelcomeViewController! = nil;
    @objc var timelines : TimelinesDetailsViewController! = nil;
    @objc var tweakOtpView : TweakAndEatOTPView! = nil;
    @objc var dbArray:[AnyObject] = [];
    
    
    @IBOutlet weak var takePhotoOfNextMeal: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!;
    @IBOutlet weak var okBtn: UIButton!
    
    @objc func beginning() {
        self.justTweakView.layer.cornerRadius = 10
        self.justTweakView.layer.borderWidth = 2
        self.justTweakView.layer.borderColor = UIColor.black.cgColor
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dispatch_group = DispatchGroup();
        dispatch_group.enter();
//        UserDefaults.standard.set("44", forKey: "COUNTRY_CODE")
//                          UserDefaults.standard.synchronize()
        CleverTap.sharedInstance()?.recordEvent("Home_viewed")
        self.delegate.homeInfoApiCalls()
        
        self.delegate.checkAppVersion()
        self.delegate.setUpUI()
        self.delegate.getTrends()
        self.delegate.showButtonsView()
        
        appDelegate.getAnnouncements()
        self.delegate.setupSiaButton()
        self.delegate.getAdDetails()
        //self.delegate.checkUserPremiumMember()
        //self.delegate.checkUserPremiumMember1()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
           
          let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            self.delegate.setUpInfoBarButton()
            if countryCode == "91"{
                    self.delegate.getClubHome1()
                   // self.delegate.getClubHome2()
               // self.delegate.getClub1Info()
                           
               self.delegate.getNutritionistFBID()
                self.delegate.getUserCallSchedueDetails()
                //self.delegate.getPremiumBtn()
            } else if countryCode == "63" {
                self.delegate.setUpPhilippinesView()
            } 
        }
        dispatch_group.leave();
        dispatch_group.notify(queue: DispatchQueue.main) {
            self.delegate.resignRegistrationScreen()

        }
       // self.delegate.playVideo()
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.AuthStateDidChange, object: Auth.auth(), queue: nil) { _ in
//            self.delegate.registrationProcess()
//
//            let user = Auth.auth().currentUser
//        }
//        if UserDefaults.standard.string(forKey: "userSession") != nil{
//
//            Auth.auth().addStateDidChangeListener { auth, user in
//                if user != nil {
//                    // User is signed in. Show home screen
//                    self.delegate.registrationProcess()
//                } else {
//                    // No User is signed in. Show user the login screen
//                }
//            }
//        }

    }
}
