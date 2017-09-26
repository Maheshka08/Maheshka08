//
//  ExpandedPieChart.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 01/08/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class ExpandedPieChart: UIViewController {
    var carb: String = ""
    var fat: String = ""
    var fibre: String = ""
    var protein: String = ""
    var reports: String = ""
    @IBOutlet var reportsLabel: UILabel!
    @IBOutlet var pieChart: PieChart!
    var week: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportsLabel.text = self.reports;
        self.tabBarController?.tabBar.isHidden = true;
        pieChart.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name:"Carbs", value: CGFloat(NumberFormatter().number(from: carb)!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: "Fats", value: CGFloat(NumberFormatter().number(from: fat)!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: "Others", value: CGFloat(NumberFormatter().number(from: fibre)!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: "Proteins", value: CGFloat(NumberFormatter().number(from: protein)!))
        ]
        
        pieChart.segmentLabelFont = UIFont.systemFont(ofSize: 16);
        pieChart.showSegmentValueInLabel = true;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
