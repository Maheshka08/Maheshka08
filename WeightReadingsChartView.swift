//
//  WeightReadingsChartView.swift
//  Tweak and Eat
//
//  Created by mac on 06/07/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit


class WeightReadingsChartView: UIView {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lineChart: UIView!
    var lineChartView = LineChart()
    @IBOutlet weak var weightTableView: UITableView!

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
