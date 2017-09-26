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
    

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var tweakPieChartView: UIView!
    @IBOutlet weak var logoBorderView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var tweakPieChartScrollView: UIScrollView!
    
    var delegate : WelcomeViewController! = nil;
    
    var profileData : NSArray! = nil;
    
    var profileFacts : Results<TweakPieChartValues>?
    var trackingPercentage = [Int]()
    
    func profileArray(){
    self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        if (self.profileFacts?.count)! > 0 {
    for myProfileFacts in self.profileFacts! {

        self.trackingPercentage = [myProfileFacts.carbsPerc,myProfileFacts.fatPerc,myProfileFacts.proteinPerc,myProfileFacts.fiberPerc]
        }
    }
        
    }
    func beginning() {
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
    
    func updateChartData(){
//        if UIScreen.main.bounds.size.height == 480 {
//        self.tweakPieChartScrollView.contentSize = CGSize(width: self.frame.size.width, height: 668)
//        }
        self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        for myProfileFacts in self.profileFacts! {
        self.pieChartView.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name:"carbPerc", value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.carbsPerc))!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: "fatPerc", value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.fatPerc))!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: "fiberPerc", value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.fiberPerc))!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: "proteinPerc", value: CGFloat(NumberFormatter().number(from: String(myProfileFacts.proteinPerc))!))
        ]
        pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 13)
        pieChartView.showSegmentValueInLabel = true
    }
    
    }
}
