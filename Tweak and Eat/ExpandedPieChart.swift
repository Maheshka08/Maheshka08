//
//  ExpandedPieChart.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 01/08/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class ExpandedPieChart: UIViewController {
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var carb: String = ""
    @objc var fat: String = ""
    @objc var fibre: String = ""
    @objc var protein: String = ""
    @objc var reports: String = ""
    
    @IBOutlet weak var proteinLbl: UILabel!
    @IBOutlet var reportsLabel: UILabel!
    @IBOutlet var pieChart: PieChart!
    @objc var week: String = ""

    @IBOutlet weak var fibreLbl: UILabel!
    @IBOutlet weak var fatsLbl: UILabel!
    @IBOutlet weak var carbsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.carbsLbl.text = bundle.localizedString(forKey: "Carbs", value: nil, table: nil)
            self.fatsLbl.text = bundle.localizedString(forKey: "fat", value: nil, table: nil)
            self.fibreLbl.text = bundle.localizedString(forKey: "fiber", value: nil, table: nil)
            self.proteinLbl.text = bundle.localizedString(forKey: "protein", value: nil, table: nil)

        self.reportsLabel.text = self.reports;
        self.tabBarController?.tabBar.isHidden = true;
        pieChart.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: carb)!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name:bundle.localizedString(forKey: "fat", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: fat)!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name:   bundle.localizedString(forKey: "others", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: fibre)!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "protein", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: protein)!))
        ]
        
        pieChart.segmentLabelFont = UIFont.systemFont(ofSize: 16);
        pieChart.showSegmentValueInLabel = true;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
