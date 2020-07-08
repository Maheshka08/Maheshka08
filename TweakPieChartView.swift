//
//  TweakPieChartView.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/25/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TweakPieChartView: UIView {
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var tweakPieChartView: UIView!
    @IBOutlet weak var logoBorderView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var tweakPieChartScrollView: UIScrollView!
    
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var profilePlateDesc: UILabel!
    
    @objc var delegate : WelcomeViewController! = nil;
    @objc var profileData : NSArray! = nil;
    
    var profileFacts : Results<TweakPieChartValues>?
    @objc var trackingPercentage = [Int]()
    
    @objc func profileArray(){
    self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        if (self.profileFacts?.count)! > 0 {
    for myProfileFacts in self.profileFacts! {

        self.trackingPercentage = [myProfileFacts.carbsPerc,myProfileFacts.fatPerc,myProfileFacts.proteinPerc,myProfileFacts.fiberPerc]
        }
     }
}
    @objc func beginning() {
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }

        profileArray()
        updateChartData()
        logoBorderView.clipsToBounds = true
        logoBorderView.layer.cornerRadius = logoBorderView.frame.size.width / 2
        animationView.clipsToBounds = true
        animationView.layer.cornerRadius = animationView.frame.size.width / 2
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = logoView.frame.size.width / 2
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
    }
    
    
    @IBAction func okAction(_ sender: Any) {
        self.delegate.switchToSeventhScreen()
    }
    
    @objc func updateChartData(){

        self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        for myProfileFacts in self.profileFacts! {
        self.pieChartView.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil)
, value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.carbsPerc))!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "fat", value: nil, table: nil)
, value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.fatPerc))!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "others", value: nil, table: nil)
, value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.fiberPerc))!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "protein", value: nil, table: nil)
, value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.proteinPerc))!))
        ]
        pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 13)
        pieChartView.showSegmentValueInLabel = true
      }
    
    }
}
