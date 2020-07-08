
//  ProfileViewController.swift
//  Tweak and Eat
//  Created by Anusha Thota on 8/5/17.
//  Copyright © 2017 Purpleteal. All rights reserved.

import UIKit
import Realm
import RealmSwift


class ProfileViewController: UIViewController, LineChartDelegate {
    
    @IBOutlet var tweakPlateDescLbl: UILabel!;
    @IBOutlet var tweakPlateImageView: UIImageView!;
    
    var xLabelsArray = [String]()

    @IBOutlet weak var profilePlateLbl: UILabel!
    @objc var performSegue = ""
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    
    @objc func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        if yValues[0] != 0.0 {
                self.chartSelectedLbl.text = "Weight readings on \(xAxisDateTime[Int(x)]) : \n Weight : \(yValues[0]) kg "
            
        } else {
            self.chartSelectedLbl.text = "No Readings..."
        }
    }
    
    @IBOutlet var lineChartView: UIView!
    @objc var data1 = [CGFloat]()
    @objc var xAxisDateTime = [String]()
    var profileFacts : Results<TweakPieChartValues>?
    var weightReadings : Results<WeightInfo>?
    @objc var xAxis = [String]()
    @objc var label = UILabel()

    @IBOutlet var chartSelectedLbl: UILabel!
    @IBOutlet var profileSegmantControl: UISegmentedControl!

    @objc var trackingPercentage = [Int]()
    @objc var weightArray = NSMutableArray()
    @objc var imageView = UIImageView()
    
    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightReading: UILabel!
    @IBOutlet weak var weightCount: UILabel!
  
    @IBOutlet weak var weightView: UIView!
     @objc let lineChart = LineChart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idealPlateStaticText()
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
        
      //  self.title = "MY IDEAL PLATE"
         self.profilePlateLbl.text = bundle.localizedString(forKey: "profile_plate_label", value: nil, table: nil)
          self.tweakPlateDescLbl.text = bundle.localizedString(forKey: "profile_plate_desc", value: nil, table: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.refreshData), name: NSNotification.Name(rawValue: "READINGS_ADDED"), object: nil)
        profileSegmantControl.tintColor = UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)
        profileArray()
        
        lineChart.backgroundColor = UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)


        self.weightView.isHidden = true
        
        if profileSegmantControl.selectedSegmentIndex == 0 {
            self.weightView.isHidden = true
           getProfileData()
             self.profileSegmantControl.isHidden = true
            // self.navigationItem.title = "My Ideal Plate"
            
        } else {
            self.weightView.isHidden = false
          //  self.title = "My Weight Trends"
            self.profileSegmantControl.isHidden = true
            imageView.removeFromSuperview()
           
            self.weightReadings = uiRealm.objects(WeightInfo.self)
            if (self.weightReadings?.count)! > 0 {
                refreshData()
            }
        }
        
        if self.performSegue == "PurchasedPackages" {
            self.profileSegmantControl.selectedSegmentIndex = 1
            self.profileSegmantControl.isHidden = true
            self.title = "My Weight Trends"
            self.weightView.isHidden = false
            self.profilePlateLbl.isHidden = true
           
            imageView.removeFromSuperview()
            self.weightReadings = uiRealm.objects(WeightInfo.self)
            if (self.weightReadings?.count)! > 0 {
                refreshData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfileData()
    }
    
    @objc func incrementID() -> Int {
        let db = DBManager()
        return (db.realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    override func viewDidLayoutSubviews() {
        if UIScreen.main.bounds.size.height == 480 {
            self.tweakPlateImageView.frame = CGRect(x:54, y: 2, width: 211, height: 211)
            self.pieChartView.frame = CGRect(x:74, y: 22, width: 173, height: 173)
            self.tweakPlateDescLbl.frame = CGRect(x:16, y: 212, width: 288, height: 154)
        }
    }
    
    @objc func refreshData() {
        self.chartSelectedLbl.text = "Please tap on the graph to see the readings...";
        showChartView();
    }
    
    
    func idealPlateStaticText() {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getIdealPlateStaticText(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                print(response)
                let data = response["data"] as! [[String: AnyObject]]
                print(data[0])
                let formattedString = NSMutableAttributedString()
                formattedString
                    .bold("MY IDEAL PLATE: \n\n")
                    .normal((data[0]["static_value"] as! String).html2String)
                
                self.tweakPlateDescLbl.attributedText = formattedString

                //self.tweakPlateDescLbl.text = "MY IDEAL PLATE" + (data[0]["static_value"] as! String).html2String

            }
        }) { (error : NSError!) -> (Void) in
            print("failure");
            
            TweakAndEatUtils.hideMBProgressHUD();
        }
    }
    
    @objc func profileArray() {
        self.profileFacts = uiRealm.objects(TweakPieChartValues.self)
        if (self.profileFacts?.count)! > 0 {
            for myProfileFacts in self.profileFacts! {
                
                self.trackingPercentage = [myProfileFacts.carbsPerc,myProfileFacts.fatPerc,myProfileFacts.proteinPerc,myProfileFacts.fiberPerc];
            }
        }
    }
    
    @IBAction func profileSegmentAct(_ sender: UISegmentedControl) {
             if (sender.selectedSegmentIndex == 0) {
                self.weightView.isHidden = true;
                self.pieChartSegments();
              
              //  self.title = "My Ideal Plate"
              
        } else {
             //    self.title = "My Weight Trends"
                self.weightView.isHidden = false;
              
                imageView.removeFromSuperview();
                self.weightReadings = uiRealm.objects(WeightInfo.self);
                if (self.weightReadings?.count)! > 0 {
                    refreshData();
                }
          }
    }
    
    @objc func reloadChart() {
        weightArray = [];
        xAxis = [String]();
        xAxisDateTime = [String]();
        data1 = [CGFloat]();
        
        self.weightReadings = uiRealm.objects(WeightInfo.self);
        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)];
        self.weightReadings = self.weightReadings!.sorted(by: sortProperties);
        let weightArrays = Array(self.weightReadings!);
        if weightArrays.count > 0 {
            for weight in weightArrays {
                let dict = ["datetime":weight.datetime,"weight" : weight.weight] as [String : Any];
                weightArray.add(dict);
            }
            let weightDict = weightArray.firstObject as! [String : Any];
            self.weightCount.text = String(weightDict["weight"] as! Int);
            self.dateLabel.text = weightDict["datetime"] as? String;
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
    
    @objc func showChartView() {
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
            //self.dateLabel.text = weightDict["datetime"] as? String
        }
        
        if weightArrays.count > 0 {
            for weight in weightArrays {
                if data1.count != 7 {
                    data1.append(CGFloat(weight.weight))
                    xAxisDateTime.append(weight.datetime)
                    let datearray = weight.datetime.components(separatedBy: ",")
                    xAxis.append(datearray[1])
                }
            }
        }
        //        if data1.count == 1 {
        //            xAxis = [String]()
        //            xAxisDateTime = [String]()
        //            data1 = [CGFloat]()
        //
        //            data1.append(20.0)
        //            xAxis.append("1")
        //            xAxisDateTime.append("")
        //        }
        
        xAxisDateTime = xAxisDateTime.reversed()
        
        var views: [String: AnyObject] = [:]
        
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[label]", options: [], metrics: nil, views: views))
        lineChart.clear()
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.x.labels.visible = true
        lineChart.y.labels.visible = true
        lineChart.x.grid.visible = false
        lineChart.y.grid.visible = false
        lineChart.x.grid.count = 4
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xAxis.reversed();
        lineChart.addLine(data1.reversed());
        lineChart.delegate = self
        lineChart.colors = [UIColor.purple]
        
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.weightView.addSubview(lineChart)
        
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        
        if UIScreen.main.bounds.size.height == 568 {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==250)]", options: [], metrics: nil, views: views))
        } else if UIScreen.main.bounds.size.height == 480 {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        } else{
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==300)]", options: [], metrics: nil, views: views))
        }
    }
    
    @objc func getXLabels(lbls: Int) -> [String] {
        
        for i in 1...lbls {
            xLabelsArray.append("\(i)");
        }
        return xLabelsArray;
    }
    
    @objc func getProfileData() {
    if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
    APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.PROFILEFACTS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
    
    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
    if responseDic.count == 2 {
    let responseResult =  responseDic["profileData"] as! [String : Int]
    let chartValues = TweakPieChartValues()
    chartValues.id = self.incrementID()
    chartValues.carbsPerc = responseResult["carbsPerc"]!
    chartValues.proteinPerc = responseResult["proteinPerc"]!
    chartValues.fatPerc = responseResult["fatPerc"]!
    chartValues.fiberPerc = responseResult["fiberPerc"]!
    saveToRealmOverwrite(objType: TweakPieChartValues.self, objValues: chartValues)
    }
    
    self.pieChartSegments()
    
    }, failure : { error in
        print("failure")
//    let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertControllerStyle.alert)
//
//    let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//    alertController.addAction(defaultAction)
//    self.present(alertController, animated: true, completion: nil)
    
    })
    }
    
    }
    
    @objc func pieChartSegments() {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        label.center = CGPoint(x: 175, y: 5)
//        label.textAlignment = .center
//        label.text = "I'am a test label"
//        self.view.addSubview(label)
       
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

    @IBAction func addWeightAction(_ sender: Any)  {
        self.performSegue(withIdentifier: "addWeight", sender: self)
    }

    
    @objc func incrementDatesID() -> Int  {
        let realm = try! Realm()
        return (realm.objects(WeightInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
