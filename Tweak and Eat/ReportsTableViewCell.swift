//
//  ReportsTableViewCell.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 31/07/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

protocol ExpandPieChartDelegate {
    
    func prevWeekPieChartTapped(_ cell: ReportsTableViewCell)
    func nextWeekPieChartTapped(_ cell: ReportsTableViewCell)
    
}

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet var nextWeekPieChartView: PieChart!;
    @IBOutlet var prevWeekPieChartView: PieChart!;
    @IBOutlet var nextReportsLbl: UILabel!;
    @IBOutlet var prevReportsLbl: UILabel!;
    @IBOutlet var dateLbl: UILabel!;
    var cellDelegate: ExpandPieChartDelegate?;
    @objc var cellIndexPath : Int = 0;

    @IBOutlet var nextTxtView: UITextView!;
    @IBOutlet var prevTxtView: UITextView!;
    @IBOutlet var nextView: UIView!;
    @IBOutlet var prevView: UIView!;
    
    
    @IBOutlet weak var prevAdviseLabel: UILabel!
    @IBOutlet weak var nextAdviseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.prevView.layer.cornerRadius = 5.0;
        self.prevView.layer.borderWidth = 1;
        self.prevView.layer.borderColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor;
        self.nextView.layer.cornerRadius = 5.0;
        self.nextView.layer.borderWidth = 1;
        self.nextView.layer.borderColor = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor;
        if UIScreen.main.bounds.size.height == 480 {
        self.prevReportsLbl.font = UIFont.systemFont(ofSize: 11.0)
            self.nextReportsLbl.font = UIFont.systemFont(ofSize: 11.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

    @IBAction func nextWeekPieChartBtnTapped(_ sender: Any) {
        self.cellDelegate?.nextWeekPieChartTapped(self)
    }
    @IBAction func prevWeekPieChartBtnTapped(_ sender: Any)
    {
        self.cellDelegate?.prevWeekPieChartTapped(self)
    }
}
