
//  ProfileViewController.swift
//  Tweak and Eat
//  Created by Anusha Thota on 8/5/17.
//  Copyright © 2017 Purpleteal. All rights reserved.

import UIKit
import Realm
import RealmSwift


class ProfileViewController: UIViewController, LineChartDelegate {
    @IBOutlet var tweakPlateDescLbl: UILabel!
    
    @IBOutlet var tweakPlateImageView: UIImageView!
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        if yValues[0] != 0.0 {
                self.chartSelectedLbl.text = "Weight readings on \(xAxisDateTime[Int(x)]) : \n Weight : \(yValues[0]) kg "
            
        } else {
            self.chartSelectedLbl.text = "No Readings..."
        }

    }
    
    @IBOutlet var lineChartView: UIView!
    var data1 = [CGFloat]()
    var xAxisDateTime = [String]()
    var profileFacts : Results<TweakPieChartValues>?
    var weightReadings : Results<WeightInfo>?
    var xAxis = [String]()
    var label = UILabel()

    @IBOutlet var chartSelectedLbl: UILabel!
    @IBOutlet var profileSegmantControl: UISegmentedControl!

    var trackingPercentage = [Int]()
    var weightArray = NSMutableArray()
    var imageView = UIImageView()
    
    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightReading: UILabel!
    @IBOutlet weak var weightCount: UILabel!
    
    @IBOutlet weak var weightView: UIView!
     let lineChart = LineChart()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.refreshData), name: NSNotification.Name(rawValue: "READINGS_ADDED"), object: nil)
        profileSegmantControl.tintColor = UIColor.white
        profileArray()
        self.weightView.isHidden = true
        pieChartSegments()
    }
    
    override func viewDidLayoutSubviews() {
        if UIScreen.main.bounds.size.height == 480 {
            self.tweakPlateImageView.frame = CGRect(x:54, y: 2, width: 211, height: 211)
            self.pieChartView.frame = CGRect(x:74, y: 22, width: 173, height: 173)
            self.tweakPlateDescLbl.frame = CGRect(x:16, y: 212, width: 288, height: 154)
            
        }
    }
    
    func refreshData() {
          self.chartSelectedLbl.text = "Please tap on the graph to see the readings..."
        
        showChartView()
    }
    
    func profileArray() {
        self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        if (self.profileFacts?.count)! > 0 {
            for myProfileFacts in self.profileFacts! {
                
                self.trackingPercentage = [myProfileFacts.carbsPerc,myProfileFacts.fatPerc,myProfileFacts.proteinPerc,myProfileFacts.fiberPerc]
            }
        }
        
    }
    
    @IBAction func profileSegmentAct(_ sender: UISegmentedControl) {
             if (sender.selectedSegmentIndex == 0) {
                self.weightView.isHidden = true
                self.pieChartSegments()
              
        } else {
                self.weightView.isHidden = false
                imageView.removeFromSuperview()
                self.weightReadings = uiRealm.objects(WeightInfo.self)
                if (self.weightReadings?.count)! > 0 {
                refreshData()
                }

        }
        
    }
    
    func reloadChart() {
        weightArray = []
        xAxis = [String]()
        xAxisDateTime = [String]()
        data1 = [CGFloat]()
        self.weightReadings = uiRealm.objects(WeightInfo.self)
        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
        self.weightReadings = self.weightReadings!.sorted(by: sortProperties);
        let weightArrays = Array(self.weightReadings!)
        if weightArrays.count > 0 {
            for weight in weightArrays {
                let dict = ["datetime":weight.datetime,"weight" : weight.weight] as [String : Any]
                weightArray.add(dict)
            }
            let weightDict = weightArray.firstObject as! [String : Any]
            self.weightCount.text = String(weightDict["weight"] as! Int)
            self.dateLabel.text = weightDict["datetime"] as? String
        }
        
        
        if weightArrays.count > 0 {
            for weight in weightArrays {
                if data1.count != 5 {
                    data1.append(CGFloat(weight.weight))
                    xAxisDateTime.append(weight.datetime)
                    let datearray = weight.datetime.components(separatedBy: ",")
                    xAxis.append(datearray[1])
                }
            }
        }
        if data1.count == 1 {
            data1.append(0.0)
            xAxis.append("")
            xAxisDateTime.append("")
        }
        
        xAxisDateTime = xAxisDateTime.reversed()
        
        lineChart.x.labels.values = xAxis.reversed()
        lineChart.addLine(data1.reversed())
        
    }
    
    func showChartView() {
        weightArray = []
        xAxis = [String]()
        xAxisDateTime = [String]()
        data1 = [CGFloat]()
        self.weightReadings = uiRealm.objects(WeightInfo.self)
        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
        self.weightReadings = self.weightReadings!.sorted(by: sortProperties);
        let weightArrays = Array(self.weightReadings!)
        if weightArrays.count > 0 {
            for weight in weightArrays {
                let dict = ["datetime":weight.datetime,"weight" : weight.weight] as [String : Any]
                weightArray.add(dict)
            }
            let weightDict = weightArray.firstObject as! [String : Any]
            self.weightCount.text = String(weightDict["weight"] as! Double)
            self.dateLabel.text = weightDict["datetime"] as? String
        }

        if weightArrays.count > 0 {
            for weight in weightArrays {
                if data1.count != 5 {
                    data1.append(CGFloat(weight.weight))
                    xAxisDateTime.append(weight.datetime)
                    let datearray = weight.datetime.components(separatedBy: ",")
                    xAxis.append(datearray[1])
                }
            }
        }
        if data1.count == 1 {
            data1.append(0.0)
            xAxis.append("")
            xAxisDateTime.append("")
        }
    
    xAxisDateTime = xAxisDateTime.reversed()
    
    var views: [String: AnyObject] = [:]
    
    label.text = ""
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = NSTextAlignment.center
    self.view.addSubview(label)
    views["label"] = label
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[label]", options: [], metrics: nil, views: views))
    
    
    lineChart.animation.enabled = true
    lineChart.area = true
    lineChart.x.labels.visible = true
    lineChart.x.grid.count = 5
    lineChart.y.grid.count = 10
    lineChart.x.labels.values = xAxis.reversed()
    lineChart.y.labels.visible = true
        lineChart.clear()
    lineChart.addLine(data1.reversed())
    
    lineChart.translatesAutoresizingMaskIntoConstraints = false
    lineChart.delegate = self
    self.weightView.addSubview(lineChart)
        
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        //if device height <= 568
        if UIScreen.main.bounds.size.height == 568 {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==250)]", options: [], metrics: nil, views: views))
        } else if UIScreen.main.bounds.size.height == 480 {
           view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        } else{
             view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==300)]", options: [], metrics: nil, views: views))
        }
 }
    
    
    func pieChartSegments(){
        
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

    @IBAction func addWeightAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addWeight", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func incrementDatesID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WeightInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
