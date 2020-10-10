//
//  HowToTweak.swift
//  Tweak and Eat
//
//  Created by Mehera on 10/10/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation

class HowToTweak: UIView {
    @IBOutlet weak var step1BgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var step2BgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var screenOneBgHeighgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var review1TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var letsTweakBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var step3BgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var youAreDoneBgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var step1Bg: UIImageView!
    @IBOutlet weak var step2Bg: UIImageView!
    @IBOutlet weak var step3Bg: UIImageView!
    @IBOutlet weak var youAreDoneBg: UIImageView!
    @IBOutlet weak var screenOneBg: UIImageView!
    @IBOutlet weak var letsTweakBtn: UIButton!
    @objc var delegate : WelcomeViewController! = nil;
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var youAreDoneTopConstraint: NSLayoutConstraint!
    @objc func beginning() {
        self.letsTweakBtn.isHidden = true
        self.previousBtn.isHidden = true


           if IS_iPHONEXRXSMAX {
               self.review1TopConstraint.constant = 190
            self.youAreDoneTopConstraint.constant = 30
           } else if IS_iPHONE678P {
               self.review1TopConstraint.constant = 165
            self.youAreDoneTopConstraint.constant = 15
           } else if IS_iPHONE678 {
               self.review1TopConstraint.constant = 150
               self.youAreDoneTopConstraint.constant = 10
           } else if IS_iPHONEXXS {
               self.review1TopConstraint.constant = 160
            self.youAreDoneTopConstraint.constant = 30
           } else if IS_iPHONE5 {
               self.review1TopConstraint.constant = 220
           }

       }
    
    @IBAction func previouBtnTapped(_ sender: Any) {
        //self.backgroudView.removeFromSuperview()
        self.removeFromSuperview()
        self.delegate.showCongratulationsTweakerView()
        
    }
    @IBAction func letsTweakBtnTapped(_ sender: Any) {
        //self.backgroudView.removeFromSuperview()

        if delegate.infoIconTapped == true {
            self.delegate.resignHowToTweakScreen()
            
        } else {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let dispatch_group = DispatchGroup();
                    dispatch_group.enter();
            //        UserDefaults.standard.set("44", forKey: "COUNTRY_CODE")
            //                          UserDefaults.standard.synchronize()
                    self.delegate.homeInfoApiCalls()
                    
                    self.delegate.checkAppVersion()
                    self.delegate.setUpUI()
                    self.delegate.getTrends()
                    self.delegate.showButtonsView()
                    
                    appDelegate.getAnnouncements()
                    
                    self.delegate.showButtonsView()
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
                        self.delegate.resignHowToTweakScreen()

                    }
        }
    }
    
}
