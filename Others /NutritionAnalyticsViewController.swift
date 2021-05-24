//
//  NutritionAnalyticsViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 1/18/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NutritionAnalyticsViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, LineChartDelegate, UITableViewDelegate, UITableViewDataSource, ExpandPieChartDelegate {
    
    @objc let lineChartView = LineChart();
    @objc var xLabelsArray = [String]();
    @objc var whichPieChart: String = "";
    @objc var myIndex: Int = 0;
    @objc var dateFormatter = DateFormatter();
    @objc var userReportsRef : DatabaseReference!;
    @objc var tableArray = [[String:AnyObject]]();
    @objc var countryCode = "";
    @objc var Index = 0

    @IBOutlet weak var trendYourFriendLabel: UILabel!;
    @IBOutlet weak var lineChart: UIView!;
    @IBOutlet weak var noNutritionAnalyticsView: UIView!
    @IBOutlet weak var tweakPlateAlertLbl: UILabel!
    @IBOutlet weak var nutritionAnalyticsView: UIView!;
    @IBOutlet weak var totalNutritionLbl: UILabel!;
    @IBOutlet weak var chartView: UIView!;
    @IBOutlet weak var pieChartView: PieChart!;
    @IBOutlet weak var outerLineView: UIView!;
    @IBOutlet weak var nutritionLabelsCollectionView: UICollectionView!
    
    @IBOutlet weak var legendView: UIView!
    @IBOutlet weak var dateLbl: UILabel!;
    @IBOutlet weak var tweakImgView: UIImageView!;
    
    @IBOutlet weak var reportsInfoBtn: UIBarButtonItem!
    @IBOutlet weak var noReportsLabel: UILabel!;
    @IBOutlet weak var reportsTableView: UITableView!;
    @IBOutlet weak var reportsInfoView: UIView!;
    @IBOutlet weak var tweakSegment: UISegmentedControl!;
    
    @objc var nutritionValuesArray = NSMutableArray();
    @objc var showColorForItem = 0;
    @objc var tweaksArray = NSArray();
    @objc var tweakImagesArray = NSMutableArray();
    @objc var dateTimeArray = NSMutableArray();
    @objc var datesArray = [String]();
    @objc var proteinArray = NSMutableArray();
    @objc var fatsArray = NSMutableArray();
    @objc var carbsArray = NSMutableArray();
    @objc var caloriesArray = NSMutableArray();
    @objc let dateFormat = DateFormatter();
    @objc var carbs = 0;
    @objc var fiber = 0;
    @objc var fats = 0;
    @objc var others = 0;
    @objc var protein = 0;
    @objc var calories = 0;
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Reports"
        self.reportsTableView.isHidden = false
        self.reportsInfoView.isHidden = true;
        self.noNutritionAnalyticsView.isHidden = true
        self.nutritionAnalyticsView.isHidden = true
        self.trendYourFriendLabel.isHidden = true

        trendYourFriendLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.purple, thickness: 2.0);
        
        self.nutritionValuesArray = ["Calories","Carbs","Fats","Protein","Total"];
        
        self.tweakImgView.isUserInteractionEnabled = true;
        self.nutritionLabelsCollectionView.isHidden = false
        self.nutritionLabelsCollectionView.delegate = self
        self.nutritionLabelsCollectionView.dataSource = self
        
        let tappedOnImageView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        tappedOnImageView.numberOfTapsRequired = 1
        self.tweakImgView?.addGestureRecognizer(tappedOnImageView)
        
       // self.getLabelsPerc()
        bundle = Bundle.init(path: path!)! as Bundle;
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "AR" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
                self.nutritionValuesArray = ["Kalori","Karbohidrat","Lemak","Protein","Total"];
                
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
        }
        
       // self.view.bringSubviewToFront(reportsInfoView)
        tweakPlateAlertLbl.text = self.bundle.localizedString(forKey: "tweak_plate_alert", value: nil, table: nil)

        trendYourFriendLabel.text = self.bundle.localizedString(forKey: "trend", value: nil, table: nil)
        self.noReportsLabel.text = bundle.localizedString(forKey: "no_report", value: nil, table: nil);
        
        self.totalNutritionLbl.text = self.bundle.localizedString(forKey: "total_calories_lbl", value: nil, table: nil)
      //  self.title = self.bundle.localizedString(forKey: "nutrition_analytics", value: nil, table: nil)
        
    //    self.tweakSegment.layer.cornerRadius = 5;

        self.Index = 1
        
        self.noReportsLabel.text = "Your reports will be updated every Saturday and you will be informed through a notification as soon as the Reports are updated.\n\nYour Reports will include your 'Last week's report on what you have consumed in terms of %carbs, protein, fiber and fat' and some comments from our certified nutritionist.\n\nIt will also include 'Recommendations for the coming week in terms of both % carbs, protein, fiber and fat' and some Advise from our certified nutritionist."
        
        self.reportsInfoView.isHidden = true
        self.reportsInfoBtn.isEnabled = true
        self.reportsTableView.isHidden = false
        // self.reportsInfoView.isHidden = false
        self.nutritionAnalyticsView.isHidden = true
        self.trendYourFriendLabel.isHidden = true;
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let uid = Auth.auth().currentUser!.uid
        userReportsRef = Database.database().reference().child("UserReports").child(uid)
        userReportsRef.observe(DataEventType.value, with: { (snapshot) in
            self.tableArray = [[String:AnyObject]]()
            self.datesArray = [String]()
            if snapshot.childrenCount > 0 {
                DispatchQueue.global().async() {
                    print("Work Dispatched")
                    // Do heavy or time consuming work
                    
                    // Then return the work on the main thread and update the UI
                    // Create a weak reference to prevent retain cycle and get nil if self is released before run finishes
                    //self.resetAllArrays()
                    for child in snapshot.children {
                        
                        let snap = child as! DataSnapshot
                        print(snap.key)
                        //get each nodes data as a Dictionary
                        let dict = snap.value as! [String: AnyObject]
                        
                        self.datesArray.append(snap.key as String)
                        self.tableArray.append(dict)
                    }
                    
                    print(self.tableArray)
                    print(self.datesArray)
                    self.datesArray = self.datesArray.reversed()
                    self.tableArray = self.tableArray.reversed()
                    DispatchQueue.main.async() {
                        [weak self] in
                        // Return data and update on the main thread, all UI calls should be on the main thread
                        // you could also just use self?.method() if not referring to self in method calls.
                        MBProgressHUD.hide(for: (self?.view)!, animated: true)
                        
                        // self?.tableView.reloadData()
                        self?.reportsTableView.reloadData()
                        
                    }
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                if(self.tableArray.count == 0){
                    // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_reports", value: nil, table: nil))
                    self.reportsInfoView.isHidden = false
                    
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tweakSegment.tintColor = UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0);
//
//                // self.tabBarController?.tabBar.isHidden = false;
//        if tweakSegment.selectedSegmentIndex == 0 {
//            self.reportsTableView.isHidden = false;
////            self.reportsInfoBtn.isEnabled = true;
////            self.reportsInfoView.isHidden = true;
//           // self.nutritionAnalyticsView.isHidden = true;
//            ////self.trendYourFriendLabel.isHidden = true
//        } else if tweakSegment.selectedSegmentIndex == 1 {
//            self.trendYourFriendLabel.isHidden = true;
////            self.reportsTableView.isHidden = false;
////            self.reportsInfoBtn.isEnabled = true;
//            //            self.reportsInfoView.isHidden = false;
//            self.nutritionAnalyticsView.isHidden = true;
//        } else {
//
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.reportsTableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath) as! ReportsTableViewCell
        if cell.cellDelegate == nil {
            cell.cellDelegate = self
        }
        
        cell.cellIndexPath = indexPath.row
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let headerDate = self.dateFormat.date(from: self.datesArray[indexPath.row])
        self.dateFormat.dateFormat = "dd MMM yyyy"
        let headerDateStr = self.dateFormat.string(from: headerDate!)
        cell.dateLbl.text = "  " + headerDateStr
        let cellDict = self.tableArray[indexPath.row]
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let prevStartWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportStartDate"] as! String)
        let prevEndWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportEndDate"] as! String)
        let nextStartWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportStartDate"] as! String)
        let nextEndWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportEndDate"] as! String)
        self.dateFormat.dateFormat = "dd MMM yyyy"
        let prevStartDate = self.dateFormat.string(from: prevStartWeek!)
        let prevEndDate = self.dateFormat.string(from: prevEndWeek!)
        let nextStartDate = self.dateFormat.string(from: nextStartWeek!)
        let nextEndDate = self.dateFormat.string(from: nextEndWeek!)
        cell.prevReportsLbl.text = bundle.localizedString(forKey: "previous_weeks_report", value: nil, table: nil) + " \(prevStartDate)" + bundle.localizedString(forKey: "to", value: nil, table: nil) +  "  \(prevEndDate)"
        cell.nextReportsLbl.text =  bundle.localizedString(forKey: "next_weeks_report", value: nil, table: nil)  + " \(nextStartDate) " +  bundle.localizedString(forKey: "to", value: nil, table: nil) + " \(nextEndDate)"
        cell.prevWeekPieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 10)
        cell.prevWeekPieChartView.showSegmentValueInLabel = true
        cell.nextWeekPieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 10)
        cell.nextWeekPieChartView.showSegmentValueInLabel = true
        let keyExistsForPreviousWeek = cellDict["PreviousWeek"]?["advise"] as? String != nil
        //let val = keyExists
        if keyExistsForPreviousWeek == false
        {
            cell.prevTxtView.text = ""
        }else{
            cell.prevTxtView.text = cellDict["PreviousWeek"]?["advise"] as! String
            
        }
        
        let keyExistsForNextWeek = cellDict["NextWeek"]?["advise"] as? String != nil
        if keyExistsForNextWeek == false
        {
            cell.nextTxtView.text = ""
        }else{
            
            cell.nextTxtView.text = cellDict["NextWeek"]?["advise"] as! String
        }
        
        var prevValues = cellDict["PreviousWeek"] as! [String:AnyObject]
        
        var prevCarbStr = prevValues["pieValues"]?["Carbs"]as AnyObject as! String
        prevCarbStr = prevCarbStr.replacingOccurrences(of: "%", with: "")
        
        var prevFatStr = prevValues["pieValues"]?["Fats"]as AnyObject as! String
        prevFatStr = prevFatStr.replacingOccurrences(of: "%", with: "")
        
        var othersStr = prevValues["pieValues"]?["Others"]as AnyObject as! String
        othersStr = othersStr.replacingOccurrences(of: "%", with: "")
        
        var prevProteinStr = prevValues["pieValues"]?["Proteins"]as AnyObject as! String
        prevProteinStr = prevProteinStr.replacingOccurrences(of: "%", with: "")
        
        var nextValues = cellDict["NextWeek"] as! [String:AnyObject]
        
        var nextCarb = nextValues["pieValues"]?["Carbs"]as AnyObject as! String
        
        nextCarb = nextCarb.replacingOccurrences(of: "%", with: "")
        var nextFat = nextValues["pieValues"]?["Fats"]as AnyObject as! String
        nextFat = nextFat.replacingOccurrences(of: "%", with: "")
        
        var nextFibre = nextValues["pieValues"]?["Others"]as AnyObject as! String
        nextFibre = nextFibre.replacingOccurrences(of: "%", with: "")
        
        var nextProtein = nextValues["pieValues"]?["Proteins"]as AnyObject as! String
        nextProtein = nextProtein.replacingOccurrences(of: "%", with: "")
        
        cell.prevAdviseLabel.text = bundle.localizedString(forKey: "advise", value: nil, table: nil)
        cell.nextAdviseLabel.text = bundle.localizedString(forKey: "advise", value: nil, table: nil)
        
        cell.prevWeekPieChartView.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevCarbStr)!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "fat", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevFatStr)!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "others", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: othersStr)!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "protein", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevProteinStr)!))
        ]
        cell.nextWeekPieChartView.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextCarb)!)),
            Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "fat", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextFat)!)),
            Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "others", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextFibre)!)),
            Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "protein", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextProtein)!))
        ]
        
        return cell;
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.reportsInfoView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 437
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    @objc func prevWeekPieChartTapped(_ cell: ReportsTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.whichPieChart = "Prev"
        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
    }
    
    @objc func nextWeekPieChartTapped(_ cell: ReportsTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.whichPieChart = "Next"
        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
    }

    @IBAction func tweakSegAct(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.Index = 0
            let analyticsText = "Make the Trend your friend!<br/><br/><b>Tweak every time you eat or drink and get the tweak back with Nutrition Labels.</b><br/>You will get the tweak back with Nutrition Labels. See your Calorie Trend (and all your macronutrient trends) here and manage.<br/><br/>For e.g. if your trying to maintain weight ensure the Calorie trend is flat, or Trend it low to lose weight."
            self.noReportsLabel.text = analyticsText.html2String;
            self.reportsInfoBtn.isEnabled = true
            self.reportsInfoView.isHidden = true
            self.reportsTableView.isHidden = false
          //  self.reportsInfoView.isHidden = true
            self.nutritionAnalyticsView.isHidden = true
            if self.tweaksArray.count == 0  {
            self.nutritionAnalyticsView.isHidden = true
            self.trendYourFriendLabel.isHidden = true
            } else {
            //self.trendYourFriendLabel.isHidden = true
            }
        } else if (sender.selectedSegmentIndex == 1) {
            self.Index = 1
        
            self.noReportsLabel.text = "Your reports will be updated every Saturday and you will be informed through a notification as soon as the Reports are updated.\n\nYour Reports will include your 'Last week's report on what you have consumed in terms of %carbs, protein, fiber and fat' and some comments from our certified nutritionist.\n\nIt will also include 'Recommendations for the coming week in terms of both % carbs, protein, fiber and fat' and some Advise from our certified nutritionist."
            
            self.reportsInfoView.isHidden = true
            self.reportsInfoBtn.isEnabled = true
            self.reportsTableView.isHidden = false
            // self.reportsInfoView.isHidden = false
            self.nutritionAnalyticsView.isHidden = true
            self.trendYourFriendLabel.isHidden = true;
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let uid = Auth.auth().currentUser!.uid
            userReportsRef = Database.database().reference().child("UserReports").child(uid)
            userReportsRef.observe(DataEventType.value, with: { (snapshot) in
                self.tableArray = [[String:AnyObject]]()
                self.datesArray = [String]()
                if snapshot.childrenCount > 0 {
                    DispatchQueue.global().async() {
                        print("Work Dispatched")
                        // Do heavy or time consuming work
                        
                        // Then return the work on the main thread and update the UI
                        // Create a weak reference to prevent retain cycle and get nil if self is released before run finishes
                        //self.resetAllArrays()
                        for child in snapshot.children {
                            
                            let snap = child as! DataSnapshot
                            print(snap.key)
                            //get each nodes data as a Dictionary
                            let dict = snap.value as! [String: AnyObject]
                            
                            self.datesArray.append(snap.key as String)
                            self.tableArray.append(dict)
                        }
                        
                        print(self.tableArray)
                        print(self.datesArray)
                        self.datesArray = self.datesArray.reversed()
                        self.tableArray = self.tableArray.reversed()
                        DispatchQueue.main.async() {
                            [weak self] in
                            // Return data and update on the main thread, all UI calls should be on the main thread
                            // you could also just use self?.method() if not referring to self in method calls.
                            MBProgressHUD.hide(for: (self?.view)!, animated: true)
                            
                            // self?.tableView.reloadData()
                            self?.reportsTableView.reloadData()
                            
                        }
                    }
                    
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(self.tableArray.count == 0){
                       // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_reports", value: nil, table: nil))
                        self.reportsInfoView.isHidden = false
                        
                    }
                }
            })
        }
    }

    @objc func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        print(Int(x))
        print(self.tweaksArray.count)
        if (Int(x) == self.tweaksArray.count || Int(x) < 0) {
            return
        }
        let tweakImgStr = self.tweakImagesArray[Int(x)]; self.tweakImgView.sd_setImage(with: URL(string:tweakImgStr as! String))
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        let date = self.dateFormatter.date(from: (self.dateTimeArray[Int(x)] as? String)!);
        self.dateFormatter.dateFormat = "d MMM, EEE, yyyy hh:mm a";
        let dateString = self.dateFormatter.string(from: date!);
        self.dateLbl.text = dateString;
        
    }
    
    @objc func calculateAvgValues(val: Int) -> Int {
        
        return (val/self.tweaksArray.count)
        
    }
    
    @objc func getXLabels(lbls: Int) -> [String] {
        
        for i in 1...lbls {
            xLabelsArray.append("\(i)");
        }
        return xLabelsArray;
    }
    
    
    @IBAction func reportsInfoAct(_ sender: Any) {
        if self.reportsInfoView.isHidden == true{
            self.reportsInfoView.isHidden = false;
            if self.Index == 0 {
               // update label text
                let analyticsText = "Make the Trend your friend!<br/><br/><b>Tweak every time you eat or drink and get the tweak back with Nutrition Labels.</b><br/>See your Calorie Trend (and all your macronutrient trends) here and manage.<br/><br/>For e.g. if your trying to maintain weight ensure the Calorie trend is flat, or Trend it low to lose weight."
                self.noReportsLabel.text = analyticsText.html2String;

            } else {
                // update label text
                self.noReportsLabel.text = "Your reports will be updated every Saturday and you will be informed through a notification as soon as the Reports are updated.\n\nYour Reports will include your 'Last week's report on what you have consumed in terms of %carbs, protein, fiber and fat' and some comments from our certified nutritionist.\n\nIt will also include 'Recommendations for the coming week in terms of both % carbs, protein, fiber and fat' and some Advise from our certified nutritionist."
            }
        }else{
            self.reportsInfoView.isHidden = true;
        }
    }
    
    @objc func getLabelsPerc() {
        //api call for labelperc
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.labelPerc(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic);
            MBProgressHUD.hide(for: self.view, animated: true)
            if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                
                MBProgressHUD.hide(for: self.view, animated: true);
                self.tweaksArray = responseDic["tweaks"] as AnyObject as! NSArray
                if self.tweaksArray.count == 0  {
                    self.chartView.isHidden = true
                    self.nutritionLabelsCollectionView.isHidden = true
                    self.totalNutritionLbl.isHidden = true
                    self.trendYourFriendLabel.isHidden = true
                    
                    self.noNutritionAnalyticsView.isHidden = false
                   
                    
                    return;
                } else {
                    //self.trendYourFriendLabel.isHidden = true
                    self.nutritionAnalyticsView.isHidden = true
                }
                
                for dict in self.tweaksArray {
                    let tweaksDict = dict as! [String: AnyObject]
                    self.proteinArray.add(CGFloat(tweaksDict["protein_perc"] as! Int));
                    self.fatsArray.add(CGFloat(tweaksDict["fats_perc"] as! Int));
                    self.carbsArray.add(CGFloat(tweaksDict["carbs_perc"] as! Int));
                    self.caloriesArray.add(CGFloat(tweaksDict["total_calories"] as! Int));
                    self.dateTimeArray.add(tweaksDict["tweak_upd_dttm"] as! String);
                    self.tweakImagesArray.add(tweaksDict["tweak_modified_image_url"] as! String);
                    self.carbs += tweaksDict["carbs_perc"] as! Int
                    self.fiber += tweaksDict["fiber_perc"] as! Int
                    self.fats += tweaksDict["fats_perc"] as! Int
                    self.others += tweaksDict["others_perc"] as! Int
                    self.protein += tweaksDict["protein_perc"] as! Int
                    self.calories += tweaksDict["total_calories"] as! Int
                }
                
                self.showLineChartView(nutritionVal: "calories")
                self.legendView.isHidden = true;
                self.pieChartView.isHidden = true;
                self.outerLineView.isHidden = false;
                self.dateLbl.isHidden = false;
                self.tweakImgView.isHidden = false;
                let tweakImgStr = self.tweakImagesArray[0];
                self.tweakImgView.sd_setImage(with: URL(string:tweakImgStr as! String))
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let date = self.dateFormatter.date(from: (self.dateTimeArray[0] as? String)!);
                self.dateFormatter.dateFormat = "d MMM, EEE, yyyy hh:mm a";
                let dateString = self.dateFormatter.string(from: date!);
                self.dateLbl.text = dateString;
                
                self.chartView.isHidden = false
                self.totalNutritionLbl.isHidden = false
                self.nutritionLabelsCollectionView.isHidden = false
                
                self.nutritionLabelsCollectionView.reloadData();
                
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
            MBProgressHUD.hide(for: self.view, animated: true);
            if error?.code == -1011 {
                self.chartView.isHidden = true
                self.nutritionLabelsCollectionView.isHidden = true
                self.totalNutritionLbl.isHidden = true
                self.trendYourFriendLabel.isHidden = true
                
               self.noNutritionAnalyticsView.isHidden = false
                
                return;
            }
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true);
        dismiss(animated: true, completion: nil);
    }
    
    @objc func showLineChartView(nutritionVal: String) {
        lineChartView.clear()
        lineChartView.frame = lineChart.frame;
        
        lineChartView.animation.enabled = true
        lineChartView.area = false
        lineChartView.x.labels.visible = true
        lineChartView.y.labels.visible = true
        lineChartView.x.grid.visible = false
        lineChartView.y.grid.visible = false
        lineChartView.x.grid.count = 4
        lineChartView.y.grid.count = 5
        lineChartView.x.labels.values = self.getXLabels(lbls: self.tweaksArray.count);
        if nutritionVal == "calories" {
            lineChartView.addLine(self.caloriesArray as! [CGFloat]);
            
            lineChartView.colors = [UIColor.blue]
        } else if nutritionVal == "carbs" {
            lineChartView.addLine(self.carbsArray as! [CGFloat]);
            lineChartView.colors = [UIColor(red: 0.0/255.0, green: 107.0/255.0, blue: 98.0/255.0, alpha: 1.0)]
        } else if nutritionVal == "fat" {
            lineChartView.addLine(self.fatsArray as! [CGFloat]);
            lineChartView.colors = [UIColor(red: 163.0/255.0, green: 37.0/255.0, blue: 106.0/255.0, alpha: 1.0)]
        } else if nutritionVal == "protein" {
            lineChartView.addLine(self.proteinArray as! [CGFloat]);
            lineChartView.colors = [UIColor(red: 221.0/255.0, green: 107.0/255.0, blue: 86.0/255.0, alpha: 1.0)]
            
        }
        
        lineChartView.delegate = self
        self.lineChart.addSubview(lineChartView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.showColorForItem = indexPath.item;
        
        if indexPath.item == 0 {
            self.showLineChartView(nutritionVal: "calories")
            self.pieChartView.isHidden = true;
            self.outerLineView.isHidden = false;
            self.dateLbl.isHidden = false;
            self.tweakImgView.isHidden = false;
            self.legendView.isHidden = true;
            
        } else if indexPath.item == 1 {
            self.showLineChartView(nutritionVal: "carbs")
            self.pieChartView.isHidden = true;
            self.outerLineView.isHidden = false;
            self.dateLbl.isHidden = false;
            self.tweakImgView.isHidden = false;
            self.legendView.isHidden = true;
            
        } else if indexPath.item == 2 {
            self.showLineChartView(nutritionVal: "fat")
            self.pieChartView.isHidden = true;
            self.outerLineView.isHidden = false;
            self.dateLbl.isHidden = false;
            self.tweakImgView.isHidden = false;
            self.legendView.isHidden = true;
            
        } else if indexPath.item == 3 {
            self.showLineChartView(nutritionVal: "protein")
            self.pieChartView.isHidden = true;
            self.outerLineView.isHidden = false;
            self.dateLbl.isHidden = false;
            self.tweakImgView.isHidden = false;
            self.legendView.isHidden = true;
            
        } else if indexPath.item == 4 {
            self.legendView.isHidden = true;
            self.showPieChart();
            self.pieChartView.isHidden = false;
            self.outerLineView.isHidden = true;
            self.dateLbl.isHidden = true;
            self.tweakImgView.isHidden = true;
        }
        
        let selectedLabel = self.nutritionValuesArray[indexPath.row] as AnyObject;
        
        if selectedLabel as! String == "Total" {
            self.totalNutritionLbl.text =  self.bundle.localizedString(forKey: "total_nutrition_lbl", value: nil, table: nil)
        } else {
            self.totalNutritionLbl.text = self.bundle.localizedString(forKey: "total", value: nil, table: nil) + " " + (selectedLabel as! String) + " " + self.bundle.localizedString(forKey: "last_label", value: nil, table: nil);
        }
        
        self.nutritionLabelsCollectionView.reloadData();
    }
    
    @objc func showPieChart() {
        self.pieChartView.segments = [
            Segment(color: UIColor(red: 0.0/255.0, green: 107.0/255.0, blue: 98.0/255.0, alpha: 1.0), name: self.bundle.localizedString(forKey: "Carbs", value: nil, table: nil)
                , value: CGFloat(NumberFormatter().number(from: String(self.calculateAvgValues(val: carbs)))!)),
            Segment(color: UIColor(red:163.0/255.0, green: 37.0/255.0, blue: 106.0/255.0, alpha: 1.0), name:  self.bundle.localizedString(forKey: "fat", value: nil, table: nil)
                , value: CGFloat(NumberFormatter().number(from: String(self.calculateAvgValues(val: fats)))!)),
            Segment(color: UIColor(red: 221.0/255.0, green: 107.0/255.0, blue: 86.0/255.0, alpha: 1.0), name:  self.bundle.localizedString(forKey: "others", value: nil, table: nil)
                , value: CGFloat(NumberFormatter().number(from: String(self.calculateAvgValues(val: others)))!)),
            Segment(color: UIColor(red: 225.0/255.0, green: 182/255.0, blue: 107.0/255.0, alpha: 1.0), name:  self.bundle.localizedString(forKey: "protein", value: nil, table: nil)
                , value: CGFloat(NumberFormatter().number(from: String(self.calculateAvgValues(val: protein)))!))
        ]
        
        self.pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 13)
        self.pieChartView.showSegmentValueInLabel = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nutritionValuesArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRow", for: indexPath) as! AiDPCollectionViewCell;
        cell.lbl.text = self.nutritionValuesArray[indexPath.item] as AnyObject as? String;
        
        if indexPath.item == self.showColorForItem {
            cell.greenLbl.isHidden = true;
            cell.redLbl.isHidden = false;
            cell.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0);
        }
        else {
            cell.redLbl.isHidden = true;
            cell.greenLbl.isHidden = false;
            cell.backgroundColor = UIColor.white;
        }
        return cell
    }
    
    @objc func tappedOnImage() {
        let newImageView = UIImageView(image: self.tweakImgView.image);
        newImageView.frame = CGRect(x:0, y:0 - 64, width: self.view.frame.size.width, height: self.view.frame.size.height + 64);
        newImageView.backgroundColor = .black;
        newImageView.contentMode = .scaleAspectFit;
        newImageView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage));
        newImageView.addGestureRecognizer(tap);
        self.view.addSubview(newImageView);
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview();
        self.navigationController?.navigationBar.isHidden = false;
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExpandPieChart" {
            let destination = segue.destination as! ExpandedPieChart
            let cellDict = self.tableArray[self.myIndex]
            self.dateFormat.dateFormat = "yyyy-MM-dd"
            
            if self.whichPieChart == "Prev" {
                let prevStartWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportStartDate"] as! String)
                let prevEndWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportEndDate"] as! String)
                
                self.dateFormat.dateFormat = "dd MMM yyyy"
                let prevStartDate = self.dateFormat.string(from: prevStartWeek!)
                let prevEndDate = self.dateFormat.string(from: prevEndWeek!)
                
                destination.reports = bundle.localizedString(forKey: "previous_weeks_report", value: nil, table: nil) + " \(prevStartDate)" + bundle.localizedString(forKey: "to", value: nil, table: nil) +  "  \(prevEndDate)"
                var prevValues = cellDict["PreviousWeek"] as! [String:AnyObject]
                var prevCarbStr = prevValues["pieValues"]?["Carbs"]as AnyObject as! String
                prevCarbStr = prevCarbStr.replacingOccurrences(of: "%", with: "")
                
                var prevFatStr = prevValues["pieValues"]?["Fats"]as AnyObject as! String
                prevFatStr = prevFatStr.replacingOccurrences(of: "%", with: "")
                
                var othersStr = prevValues["pieValues"]?["Others"]as AnyObject as! String
                othersStr = othersStr.replacingOccurrences(of: "%", with: "")
                
                var prevProteinStr = prevValues["pieValues"]?["Proteins"]as AnyObject as! String
                prevProteinStr = prevProteinStr.replacingOccurrences(of: "%", with: "")
                
                destination.carb = prevCarbStr
                destination.fat = prevFatStr
                destination.fibre = othersStr
                destination.protein = prevProteinStr
                
            } else {
                
                let nextStartWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportStartDate"] as! String)
                let nextEndWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportEndDate"] as! String)
                self.dateFormat.dateFormat = "dd MMM yyyy"
                let nextStartDate = self.dateFormat.string(from: nextStartWeek!)
                let nextEndDate = self.dateFormat.string(from: nextEndWeek!)
                destination.reports =  bundle.localizedString(forKey: "next_weeks_report", value: nil, table: nil)  + " \(nextStartDate) " +  bundle.localizedString(forKey: "to", value: nil, table: nil) + " \(nextEndDate)"
                
                var nextValues = cellDict["NextWeek"] as! [String:AnyObject]
                var nextCarb = nextValues["pieValues"]?["Carbs"]as AnyObject as! String
                nextCarb = nextCarb.replacingOccurrences(of: "%", with: "")
                
                var nextFat = nextValues["pieValues"]?["Fats"]as AnyObject as! String
                nextFat = nextFat.replacingOccurrences(of: "%", with: "")
                
                var nextFibre = nextValues["pieValues"]?["Others"]as AnyObject as! String
                nextFibre = nextFibre.replacingOccurrences(of: "%", with: "")
                
                var nextProtein = nextValues["pieValues"]?["Proteins"]as AnyObject as! String
                nextProtein = nextProtein.replacingOccurrences(of: "%", with: "")
                
                destination.carb = nextCarb
                destination.fat = nextFat
                destination.fibre = nextFibre
                destination.protein = nextProtein
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
