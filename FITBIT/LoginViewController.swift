//
//  LoginViewController.swift
//  SampleBit
//
//  Created by Stephen Barnes on 9/14/16.
//  Copyright © 2016 Fitbit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import HealthKit
import Alamofire
import AAInfographics

class WeightGraph {
    var dateTime: String
    var weight: String
    var snapShot: String
    init(dateTime: String, weight: String, snapShot: String) {
        self.dateTime = dateTime
        self.weight = weight
        self.snapShot = snapShot
    }
}
class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AuthenticationProtocol, LineChartDelegate {
    var wgt = "kg"
    @objc func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        if yValues[0] != 0.0 {
            self.chartSelectedLbl.text = "Weight readings on \(xAxisDateTime[Int(x)]) , \n Weight : \(yValues[0]) \(self.wgt) "
            
        } else {
            self.chartSelectedLbl.text = "No Readings..."
        }
    }
    var xLabelsArray = [String]()
    @objc var data1 = [CGFloat]()
    @objc var xAxis = [String]()
    @objc var weightsArray = NSMutableArray()
    @objc var label = UILabel()
    @objc let lineChart = LineChart()
    var weightGraphArray = [WeightGraph]()
    var weightArray = NSMutableArray()

    @objc var xAxisDateTime = [String]()
    @IBOutlet var chartSelectedLbl: UILabel!
    @IBOutlet var profileSegmantControl: UISegmentedControl!
    
    let aaChartV = AAChartView()
    @IBOutlet weak var weightTableView: UITableView!
    @IBOutlet weak var aaChartView: UIView!
    var weightReadings : Results<WeightInfo>?
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    
    @IBOutlet weak var weightView: UIView!
    @objc let healthStore = HealthHelper.sharedInstance.healthStore
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightReading: UILabel!
    @IBOutlet weak var weightCount: UILabel!
    // @IBOutlet weak var footerTextLbl: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var loadingView: UIView!
    
    @objc var authenticationController: AuthenticationController?
    @objc var FitbitDeviceRef : DatabaseReference!
    var fitbitDeviceInfo : Results<FitbitDeviceInfo>?
    
    let realm :Realm = try! Realm()
    @objc let formatter = DateFormatter()
    
    @objc var stepsDictionary = [String:AnyObject]()
    @objc var floorsDictionary = [String:AnyObject]()
    @objc var distanceDictionary = [String:AnyObject]()
    @objc var caloriesDictionary = [String:AnyObject]()
    @objc var activeMinsDictionary = [String:AnyObject]()
    @objc var activitiesArray = NSMutableArray()
    
    @IBOutlet weak var fitbitTableView: UITableView!
    
    @objc var myIndex : Int = 0
    @objc var myIndexPath : IndexPath = []
    @objc var countryCode = ""
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func getWeightDetails() {
        MBProgressHUD.showAdded(to: self.weightView, animated: true)

        Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "datetime").queryLimited(toLast: 7).observe(DataEventType.value, with: { (snapshot) in

            if snapshot.childrenCount > 0 {
                self.weightGraphArray = [WeightGraph]()
                self.weightsArray = NSMutableArray()
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                for tweakFeeds in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let feedObj = tweakFeeds.value as? [String : AnyObject];
                        var dateTime = ""
                        if (feedObj!["datetime"]  as AnyObject is NSNumber) {
                            dateTime = "\(feedObj!["datetime"]  as AnyObject as! NSNumber)"
                            
                        } else  if (feedObj!["datetime"]  as AnyObject is String) {
                            dateTime = feedObj!["datetime"]  as AnyObject as! String
                            
                        }
                    let weightGraphObj = WeightGraph(dateTime: dateTime, weight: feedObj!["weight"] as! String, snapShot: tweakFeeds.key)
                        self.weightGraphArray.append(weightGraphObj)
                    
                    
                }
                self.weightGraphArray = self.weightGraphArray.sorted(by: { $0.dateTime > $1.dateTime })
                for dict in self.weightGraphArray {
                    self.weightsArray.add(Double(dict.weight) as Any)
                    
                }
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    //   print(self.tweaksArray);
                    
                      MBProgressHUD.hide(for: self.weightView, animated: true);
                   
                    self.weightTableView.isHidden = false
                    self.weightTableView.reloadData()
                    self.updateChart(backGroundCol: "#168c7a", data: self.weightsArray.reversed() , name: "Weight", colorTheme: ["#FFFFFF"], title: "Your Last 7 Weight Readings")
                
                    
                }
            } else {
                MBProgressHUD.hide(for: self.weightView, animated: true);
self.updateChart(backGroundCol: "#168c7a", data: [] as [Any], name: "Weight", colorTheme: ["#FFFFFF"], title: "No Weight Readings!")
                self.weightsArray = NSMutableArray()
                self.weightGraphArray = [WeightGraph]()
                self.weightTableView.reloadData()
                self.weightTableView.isHidden = true
            }
        })
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func updateChart(backGroundCol: String, data: [Any], name: String, colorTheme: [Any], title: String) {
       // self.chartView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bouncePast)
            .title(title)//The chart title
            .subtitle("")//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["1", "2", "3", "4", "5", "6",
                         "7", "8", "9", "10"])
            .colorsTheme(colorTheme)
            .series([
                AASeriesElement()
                    .name(name)
                    .data(data)
                
                ])
        aaChartModel.yAxisGridLineWidth = 0.0
        aaChartV.scrollEnabled = false
        aaChartV.isClearBackgroundColor = true
        aaChartModel.gradientColorEnable = true
        aaChartModel.yAxisVisible = false
        aaChartModel.backgroundColor = backGroundCol
        aaChartModel.legendEnabled = false
        aaChartModel.axesTextColor = "#FFFFFF"
        aaChartModel.titleFontColor("#FFFFFF")
        aaChartModel.titleFontSize(16)
        
        
        
        aaChartV.aa_drawChartWithChartModel(aaChartModel)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil){
            
            self.myIndex = 0;
            self.performSegue(withIdentifier: "activityTracker", sender: self);
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.weightTableView.isHidden = true
        self.weightReadings = uiRealm.objects(WeightInfo.self)
        chartSelectedLbl.isHidden = true
        self.aaChartView.addSubview(self.aaChartV)
        lineChart.backgroundColor = UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "1" {
                self.wgt = "lbs"
            }
        }
        self.addBackButton()
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
        
        self.title  = bundle.localizedString(forKey: "devices", value: nil, table: nil)
        
        self.weightReading.text = bundle.localizedString(forKey: "weight_reading", value: nil, table: nil)
        
        self.fitbitDeviceInfo = self.realm.objects(FitbitDeviceInfo.self);
        
        if self.fitbitDeviceInfo?.count != 0 {
            let sortProperties = [SortDescriptor(keyPath: "deviceId", ascending: true)];
            self.fitbitDeviceInfo = self.fitbitDeviceInfo!.sorted(by: sortProperties);
        }
        
        self.headerLabel.numberOfLines = 0;
        
        self.headerLabel.text   = bundle.localizedString(forKey: "select_device", value: nil, table: nil)
        //
        //        self.footerTextLbl.numberOfLines = 0;
        //        self.footerTextLbl.textColor = UIColor.black;
        //
        //        self.footerTextLbl.text   = bundle.localizedString(forKey: "sync_devices_footer_text", value: nil, table: nil);
        
        self.weightView.isHidden = true
        
        if profileSegmantControl.selectedSegmentIndex == 0 {
            self.weightView.isHidden = true
            
            
        } else {
            self.weightView.isHidden = false
            
            if (self.weightReadings?.count)! > 0 {
             
              
               // refreshData1()
            }
        }
//        for wgt in self.weightReadings! {
//            deleteRealmObj(objToDelete: wgt)
//        }
//        if (self.weightReadings?.count)! == 0 {
//          //  MBProgressHUD.showAdded(to: self.view, animated: true);
//
//            Database.database().reference().child("UserWeight").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                if snapshot.childrenCount > 0 {
//                    let dispatch_group = DispatchGroup();
//                    dispatch_group.enter();
//                    for weightObj in snapshot.children.allObjects as! [DataSnapshot] {
//                        let weightObjct = weightObj.value as! [String: AnyObject];
//                        for (key,val) in weightObjct {
//                             let weightObject = val as! [String: AnyObject];
//
//
//                        let myWeightObj = WeightInfo()
//var dateFromMilli = 0
//                            if (weightObject["datetime"] as AnyObject is NSNumber) {
//                                dateFromMilli = Int((weightObject["datetime"] as AnyObject) as! NSNumber)
//
//                            } else  if (weightObject["datetime"] as AnyObject is String) {
//                                dateFromMilli = Int(weightObject["datetime"] as AnyObject as! String)!
//
//                            }
//                            let dateFromMilliSec = dateFromMilli.dateFromMilliseconds()
//                         let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
//                            let theDateStr = dateFormatter.string(from: dateFromMilliSec)
//
//                        myWeightObj.datetime = theDateStr
//                        myWeightObj.weight = Double(weightObject["weight"] as AnyObject as! String)!
//                        myWeightObj.id = self.incrementDatesID()
//                        myWeightObj.timeIn = dateFormatter.date(from: theDateStr)!
//                        saveToRealmOverwrite(objType: WeightInfo.self, objValues: myWeightObj)
//                        }
//                    }
//                    UserDefaults.standard.setValue("YES", forKey: "WEIGHT_SENT_TO_FIREBASE")
//                    UserDefaults.standard.synchronize()
//                    dispatch_group.leave();
//                    dispatch_group.notify(queue: DispatchQueue.main) {
//                        MBProgressHUD.hide(for: self.view, animated: true);
//                        self.refreshData1()
//
//                    }
//                }
//            })
//        }
        if (self.weightReadings?.count)! > 0 {
            
            if UserDefaults.standard.value(forKey: "WEIGHT_SENT_TO_FIREBASE") == nil {
                for wght in self.weightReadings! {
                    let milliseconds = currentTimeInMiliseconds(dateStr: wght.datetime); Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["weight": "\(wght.weight)", "datetime": milliseconds])
                }
                UserDefaults.standard.setValue("YES", forKey: "WEIGHT_SENT_TO_FIREBASE")
                UserDefaults.standard.synchronize()
            }
        }
        
        formatter.dateFormat = "yyyy-MM-dd";
        
        FitbitDeviceRef = Database.database().reference().child("UserDevices");
        authenticationController = AuthenticationController(delegate: self);
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        self.getFireBaseData();
        
    }
    
    override func viewDidLayoutSubviews() {
        
      
        if (IS_iPHONE5 || IS_IPHONE4) {
            
            aaChartV.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
           
        } else if IS_iPHONE678P {
            
            aaChartV.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
            
        } else if IS_iPHONE678 {
            aaChartV.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
            
        } else if IS_iPHONEXXS {
            aaChartV.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
            
        } else if IS_iPHONEXRXSMAX {
            aaChartV.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
            
        }
        
    }
    
    @objc func incrementDatesID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WeightInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func currentTimeInMiliseconds(dateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"

        let currentDate = dateFormatter.date(from:dateStr)
        let since1970 = currentDate!.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    @IBAction func profileSegmentAct(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.weightView.isHidden = true;
            self.fitbitTableView.isHidden = false
        } else {
            self.weightView.isHidden = false;
            self.fitbitTableView.isHidden = true
            self.weightReadings = uiRealm.objects(WeightInfo.self);
            if (self.weightReadings?.count)! > 0 {
               // refreshData1();
            }
        }
    }
    
    
//    @objc func refreshData1() {
//        self.chartSelectedLbl.text = "Please tap on the graph to see the readings...";
//        showChartView();
//    }
//
//    @objc func showChartView() {
//        weightArray = []
//        xAxis = [String]()
//        xAxisDateTime = [String]()
//        data1 = [CGFloat]()
//        self.weightReadings = uiRealm.objects(WeightInfo.self)
//        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
//        self.weightReadings = self.weightReadings!.sorted(by: sortProperties);
//        let weightArrays = Array(self.weightReadings!)
//        if weightArrays.count > 0 {
//            for weight in weightArrays {
//                let dict = ["datetime":weight.datetime,"weight" : weight.weight] as [String : Any]
//                weightArray.add(dict)
//            }
//            let weightDict = weightArray.firstObject as! [String : Any]
//            self.weightCount.text = String(weightDict["weight"] as! Double)
//            //self.dateLabel.text = weightDict["datetime"] as? String
//        }
//
//        if weightArrays.count > 0 {
//            for weight in weightArrays {
//                if data1.count != 7 {
//                    data1.append(CGFloat(weight.weight))
//                    xAxisDateTime.append(weight.datetime)
//                    let datearray = weight.datetime.components(separatedBy: ",")
//                    xAxis.append(datearray[1])
//                }
//            }
//        }
//        //        if data1.count == 1 {
//        //            xAxis = [String]()
//        //            xAxisDateTime = [String]()
//        //            data1 = [CGFloat]()
//        //
//        //            data1.append(20.0)
//        //            xAxis.append("1")
//        //            xAxisDateTime.append("")
//        //        }
//
//        xAxisDateTime = xAxisDateTime.reversed()
//
//        var views: [String: AnyObject] = [:]
//
//        label.text = ""
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = NSTextAlignment.center
//        self.view.addSubview(label)
//        views["label"] = label
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[label]", options: [], metrics: nil, views: views))
//        lineChart.clear()
//        lineChart.animation.enabled = true
//        lineChart.area = false
//        lineChart.x.labels.visible = true
//        lineChart.y.labels.visible = true
//        lineChart.x.grid.visible = false
//        lineChart.y.grid.visible = false
//        lineChart.x.grid.count = 4
//        lineChart.y.grid.count = 5
//        lineChart.x.labels.values = xAxis.reversed();
//        lineChart.addLine(data1.reversed());
//        lineChart.delegate = self
//         lineChart.colors = [UIColor.purple]
//
//
//        lineChart.translatesAutoresizingMaskIntoConstraints = false
//        lineChart.delegate = self
//        self.weightView.addSubview(lineChart)
//
//        views["chart"] = lineChart
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
//
//        if UIScreen.main.bounds.size.height == 568 {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==250)]", options: [], metrics: nil, views: views))
//        } else if UIScreen.main.bounds.size.height == 480 {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
//        } else{
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==300)]", options: [], metrics: nil, views: views))
//        }
//    }
    
    @objc func getXLabels(lbls: Int) -> [String] {
        
        for i in 1...lbls {
            xLabelsArray.append("\(i)");
        }
        return xLabelsArray;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.fitbitTableView {
        let view = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 74));
        let footerTextLbl = UILabel(frame: CGRect(x: 10 , y: 0, width: tableView.frame.size.width - 20, height: 140));
        footerTextLbl.text  = bundle.localizedString(forKey: "sync_devices_footer_text", value: nil, table: nil);
        // footerTextLbl.textAlignment = .center
        footerTextLbl.numberOfLines = 0;
        footerTextLbl.font = UIFont(name: "QUESTRIAL-REGULAR", size: 15.0);
        footerTextLbl.textColor = UIColor.black;
        
        view.addSubview(footerTextLbl);
        return view;
        }
        return nil
        
    }
    
    @objc func refreshData() {
        self.getFireBaseData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        getWeightDetails()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.refreshData), name: NSNotification.Name(rawValue: "DISCONNECTED_DEVICE"), object: nil);
       
        self.weightReadings = uiRealm.objects(WeightInfo.self);
        if (self.weightReadings?.count)! > 0 {
          //  refreshData1();
        }
    }
    
    @objc func getFireBaseData(){
        
        FitbitDeviceRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for fitbitDevices in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let fitbitObj = fitbitDevices.value as? [String : AnyObject];
                    
                    let fitbitDeviceObj = FitbitDeviceInfo();
                    if fitbitObj?.index(forKey: "deviceActiveIos") != nil {
                        let deviceActiveIos = (fitbitObj?["deviceActiveIos"] as AnyObject) as! Int;
                        if deviceActiveIos == 1 {
                            fitbitDeviceObj.deviceActive = (fitbitObj?["deviceActive"] as AnyObject) as! Int;
                            fitbitDeviceObj.deviceId = (fitbitObj?["deviceId"] as AnyObject) as! Int;
                            fitbitDeviceObj.deviceLogo = (fitbitObj?["deviceLogo"] as AnyObject) as! String;
                            fitbitDeviceObj.deviceName = (fitbitObj?["deviceName"] as AnyObject) as! String;
                            
                            fitbitDeviceObj.snapShot = fitbitDevices.key;
                            saveToRealmOverwrite(objType: FitbitDeviceInfo.self, objValues: fitbitDeviceObj);
                        }
                    }
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    let sortProperties = [SortDescriptor(keyPath: "deviceId", ascending: true)];
                    self.fitbitDeviceInfo = self.fitbitDeviceInfo!.sorted(by: sortProperties);
                    self.fitbitTableView.reloadData();
                    
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.fitbitTableView {
            if self.fitbitDeviceInfo!.count > 0 {
                MBProgressHUD.hide(for: self.view, animated: true);
                return self.fitbitDeviceInfo!.count;

            }
        }
         else if tableView == self.weightTableView {
            if self.weightGraphArray.count > 0 {
            return self.weightGraphArray.count
        }
        }
        return 0
    }
    
    @objc func getHealthActivitiesData() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let stepsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.stepCount);
        
        let flightsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.flightsClimbed);
        let distanceCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning);
        let caloriesCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned);
        let activeMinsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime);
        
        let typestoRead = NSSet(objects: stepsCount!, flightsCount!, distanceCount!, caloriesCount!, activeMinsCount!)
        
        self.healthStore?.requestAuthorization(toShare: nil, read: typestoRead as? Set<HKObjectType>, completion: { (success, error) in
            if success {
                print("SUCCESS")
                
                let dispatch_group1 = DispatchGroup()
                dispatch_group1.enter()
                let last7Days = Date.getDates(forLastNDays: 7)
                
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .stepCount, completion: {value in
                        print(" Steps: \(value)");
                        
                        dict["date"] = dates as AnyObject;
                        dict["steps"] = "\(value.cleanValue)" as AnyObject;
                        dict["deviceType"] = 2 as AnyObject;
                        self.stepsDictionary[dates] = dict as AnyObject;
                        
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .flightsClimbed, completion: {value in
                        print(" Steps: \(value)");
                        
                        dict["date"] = dates as AnyObject
                        dict["floors"] = "\(value.cleanValue)" as AnyObject;
                        dict["deviceType"] = 2 as AnyObject;
                        self.floorsDictionary[dates] = dict as AnyObject;
                        
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .distanceWalkingRunning, completion: {val in
                        print(" Steps: \(val)")
                        let str = "\(val)";
                        dict["date"] = dates as AnyObject;
                        if(str.contains("0.")) {
                            let doubleStr = String(format: "%.2f", val);
                            dict["distance"] = doubleStr as AnyObject;
                            
                        } else {
                            dict["distance"] = "\(Double(val).rounded(toPlaces: 2))" as AnyObject;
                            
                        }
                        dict["deviceType"] = 2 as AnyObject;
                        self.distanceDictionary[dates] = dict as AnyObject;
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .activeEnergyBurned, completion: {val in
                        print(" Steps: \(val)");
                        dict["date"] = dates as AnyObject;
                        dict["deviceType"] = 2 as AnyObject;
                        dict["calories"] = "\(val.cleanValue)" as AnyObject;
                        self.caloriesDictionary[dates] = dict as AnyObject;
                        
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .appleExerciseTime, completion: {val in
                        print(" Steps: \(val)")
                        dict["deviceType"] = 2 as AnyObject;
                        dict["activeMins"] = "\(val.cleanValue)" as AnyObject as AnyObject;
                        self.activeMinsDictionary[dates] = dict as AnyObject;
                        
                    })
                }
                
                dispatch_group1.leave()
                dispatch_group1.notify(queue: DispatchQueue.main) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        // change 2 to desired number of seconds
                        // Your code with delay
                        UserDefaults.standard.set("YES", forKey: "HEALTHKIT")
                        if self.stepsDictionary.count > 0 && self.distanceDictionary.count > 0 && self.floorsDictionary.count > 0 && self.activeMinsDictionary.count > 0 && self.caloriesDictionary.count > 0 {
                            //self.performSegue(withIdentifier: "activityTracker", sender: self)
                            let last7Days = Date.getDates(forLastNDays: 7)
                            let dispatch_group = DispatchGroup()
                            dispatch_group.enter()
                            for dates in last7Days {
                                //if !(last7Days.contains(dates)) {
                                
                                
                                let paramsDictionary = ["date": dates,
                                                        "steps":  "\((self.stepsDictionary[dates]!["steps"] as AnyObject).integerValue as Int)",
                                    "floors": "\((self.floorsDictionary[dates]!["floors"] as AnyObject).integerValue as Int)",
                                    "distance": "\((self.distanceDictionary[dates]!["distance"] as AnyObject).doubleValue as Double)",
                                    "activeMins": "0",
                                    "calories": "0",
                                    "deviceType": "2"]
                                self.sendHealthkitData(dateString: dates, dict: paramsDictionary as NSDictionary);
                                
                            }
                            dispatch_group.leave()
                            dispatch_group.notify(queue: DispatchQueue.main) {
                                MBProgressHUD.hide(for: self.view, animated: true);
                                UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                                self.performSegue(withIdentifier: "activityTracker", sender: self);
                                
                            }
                        }
                    }
                }
            }
            else {
                
            }
            
        })
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.weightTableView {
        return "Recorded Weight Readings"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.weightTableView {
        return 64
        }
        return 0
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      //  let indexP = self.weightTableView.indexPathForSelectedRow
        let cellDict = self.weightGraphArray[(indexPath.row)]
        print(cellDict.snapShot)
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.showAlert(message: "delete this reading?", action: "Delete", cellDict: cellDict);
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            self.showAlert(message: "edit this reading?", action: "Edit", cellDict: cellDict );
        }
        
        edit.backgroundColor = UIColor.blue
         delete.backgroundColor = UIColor.red
        
        return [delete, edit]
    }
    
    func showAlert(message: String, action: String, cellDict: WeightGraph) {
        let alert = UIAlertController(title: "", message: "Are you sure, you want to " + message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: action,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        if action == "Delete" {
                                            Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).child(cellDict.snapShot).removeValue()
                                        } else if action == "Edit" {
                                            self.performSegue(withIdentifier: "addReadings", sender: cellDict)

                                        }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.fitbitTableView {
        self.myIndexPath = indexPath;
        self.myIndex = indexPath.row;
        let cellDictionary = self.fitbitDeviceInfo?[indexPath.row];
        
        let deviceName = cellDictionary?["deviceName"] as AnyObject as? String;
        
        if deviceName == "FitBit" {
            
            if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                
                authenticationController?.login(fromParentViewController: self);
                
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil){
                
                self.performSegue(withIdentifier: "activityTracker", sender: self);
                
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                
                let msg = "Do you want to disconnect from Health Kit?";
                
                let alertController = UIAlertController(title: "You can only connect to one device !!", message: msg, preferredStyle: UIAlertController.Style.alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed");
                    UserDefaults.standard.removeObject(forKey: "HEALTHKIT");
                    UserDefaults.standard.removeObject(forKey: "HEALTHKIT_DISCONNECTED");
                    
                    let alertController = UIAlertController(title: "DISCONNECTED!", message: "You've successfully disconnected from Health Kit", preferredStyle: UIAlertController.Style.alert);
                    
                    let okAction1 = UIKit.UIAlertAction(title: "OK", style: .default) {
                        UIAlertAction in
                        NSLog("OK Pressed");
                        self.fitbitTableView.reloadData();
                    }
                    // Add the actions
                    alertController.addAction(okAction1);
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil);
                    
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed");
                }
                
                // Add the actions
                alertController.addAction(okAction);
                alertController.addAction(cancelAction);
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil);
            }
        }
        
        if (deviceName == "Health Kit")  {
            
            if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                self.getHealthActivitiesData();
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil) {
                
                let msg = "Do you want to disconnect from FitBit?";
                
                let alertController = UIAlertController(title: "You can only connect to one device !!", message: msg, preferredStyle: UIAlertController.Style.alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.disconnectDevice(token: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String);
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed");
                }
                
                // Add the actions
                alertController.addAction(okAction);
                alertController.addAction(cancelAction);
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil);
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                self.getHealthActivitiesData();
            }
        }
        } else {
            
        }
    }
    
    @objc func base64String(_ string: String) -> String {
        // Create NSData object
        let nsdata: Data? = string.data(using: .utf8);
        // Get NSString from NSData object in Base64
        let base64Encoded = nsdata?.base64EncodedString(options: []);
        return base64Encoded ?? ""
    }
    
    @objc func disconnectDevice(token: String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let clientID = FitBitDetails.clientID;
        let clientSecret = FitBitDetails.clientSecret;
        
        let base64 = base64String("\(clientID):\(clientSecret)");
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic \(base64)"
        ]
        let parameters = ["token": token]
        
        AF.request("https://api.fitbit.com/oauth2/revoke", method: .post, parameters: parameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:AFDataResponse<Any>) in
            
            switch(response.result) {
            case.success(let data):
                print("success",data)
                MBProgressHUD.hide(for: self.view, animated: true);
                
                UserDefaults.standard.removeObject(forKey: "FITBIT_TOKEN");
                let alertController = UIAlertController(title: "DISCONNECTED!", message: "You've successfully disconnected from FitBit", preferredStyle: UIAlertController.Style.alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed");
                    self.fitbitTableView.reloadData();
                }
                
                // Add the actions
                alertController.addAction(okAction);
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil);
                
            case.failure(let error):
                print("Not Success",error)
                MBProgressHUD.hide(for: self.view, animated: true);
                //check_internet_connection
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "activityTracker" {
            
            let cellDict = self.fitbitDeviceInfo?[self.myIndex];
            let destination = segue.destination as! ActivityTrackerViewController;
            
            if cellDict?["deviceId"] as! Int == 2 {
                
                MBProgressHUD.hide(for: self.view, animated: true);// change 2 to desired number of seconds
                // Your code with delay
                destination.deviceID = cellDict?["deviceId"] as! Int;
                destination.stepsDictionary = self.stepsDictionary;
                destination.floorsDictionary = self.floorsDictionary;
                destination.distanceDictionary = self.distanceDictionary;
                destination.caloriesDictionary = self.caloriesDictionary;
                destination.activeMinsDictionary = self.activeMinsDictionary;
                
            } else {
                destination.deviceID = cellDict?["deviceId"] as! Int;
            }
            
        } else if segue.identifier == "addReadings" {
            let cellDict = sender as! WeightGraph
            let destination = segue.destination as! MHAAddReadingsContainer
            destination.snapShot = cellDict.snapShot
            destination.dateTime = cellDict.dateTime
            destination.weight = cellDict.weight
        }
    }
    
    @objc func getActivitesFromHealthKit(selectedDate: String, qtyType:HKQuantityTypeIdentifier,completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: qtyType.rawValue)) // The type of data we are requesting
        
        let calendar = NSCalendar.current;
        let interval = NSDateComponents();
        interval.day = 1;
        var anchorComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        anchorComponents.hour = 0;
        let anchorDate = calendar.date(from: anchorComponents);
        
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents);
        stepsQuery.initialResultsHandler = {query, results, error in
            
            var resultCount = 0.0
            let endDate = self.formatter.date(from: selectedDate)
            
            if let myResults = results{
                if let sum = myResults.statistics(for: endDate!)?.sumQuantity() {
                    if qtyType == .stepCount {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                        
                    } else if qtyType == .flightsClimbed {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                        
                    } else if qtyType == .distanceWalkingRunning {
                        resultCount = sum.doubleValue(for: HKUnit.meter()) /
                        1000
                        
                    } else if qtyType == .activeEnergyBurned {
                        resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                    } else if qtyType == .appleExerciseTime {
                        resultCount = sum.doubleValue(for: HKUnit.minute())
                    }
                }
                completion(resultCount)
                
            } else {
                // mostly not executed
                print(error?.localizedDescription)
                completion(resultCount)
            }
        }
        healthStore?.execute(stepsQuery)
    }
    
    @objc func getActivitesFromHealthKit1(daysAgo: Int, qtyType:HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: qtyType.rawValue))!
        
        let now = Date()
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -daysAgo, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: twoDaysAgo, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                print("\(String(describing: error?.localizedDescription)) ")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                if qtyType == .stepCount {
                    resultCount = sum.doubleValue(for: HKUnit.count())
                    
                } else if qtyType == .flightsClimbed {
                    resultCount = sum.doubleValue(for: HKUnit.count())
                    
                } else if qtyType == .distanceWalkingRunning {
                    resultCount = sum.doubleValue(for: HKUnit.meter()) /
                    1000
                    
                }
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthStore?.execute(query)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noCell = UITableViewCell()
        if tableView == fitbitTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyFitbitTableViewCell;
        if self.fitbitDeviceInfo != nil {
            
            cell.cellIndexPath = indexPath.row
            cell.myIndexPath = indexPath
            cell.selectionStyle = .none
            
            let cellDictionary = self.fitbitDeviceInfo?[indexPath.row]
            
            let deviceName = cellDictionary?["deviceName"] as AnyObject as? String
            let imageUrl = cellDictionary?["deviceLogo"] as AnyObject as? String
            cell.deviceLogo.sd_setImage(with: URL(string: imageUrl!));
            if (deviceName == "FitBit" && UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil) {
                cell.connectedLabel.isHidden = false
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                
            }
            if (deviceName == "FitBit" && UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil)  {
                cell.connectedLabel.isHidden = true
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            if (deviceName == "Health Kit" && UserDefaults.standard.value(forKey: "HEALTHKIT") != nil) {
                cell.connectedLabel.isHidden = false
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                
            }
            if (deviceName == "Health Kit" && UserDefaults.standard.value(forKey: "HEALTHKIT") == nil)  {
                cell.connectedLabel.isHidden = true
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
        }
        return cell
        } else if tableView == self.weightTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weightCell", for: indexPath) as! WeightGraphTableCell;
            if self.weightGraphArray.count > 0 {
            let cellDict = self.weightGraphArray[indexPath.row]
             if countryCode == "1" {
                cell.weightLbl.text = cellDict.weight + " lbs"
             } else {
                cell.weightLbl.text = cellDict.weight + " kgs"
            }
            var dateFromMilli = 0
            if (cellDict.dateTime as AnyObject is NSNumber) {
                dateFromMilli = Int(truncating: cellDict.dateTime as AnyObject as! NSNumber)
                
            } else  if (cellDict.dateTime as AnyObject is String) {
                dateFromMilli = Int(cellDict.dateTime as AnyObject as! String)!
                
            }
            let dateFromMilliSec = dateFromMilli.dateFromMilliseconds()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            cell.dateTimeLbl.text = dateFormatter.string(from: dateFromMilliSec)
            return cell
            }
            
        }
        return noCell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.fitbitTableView {
            return 68;

        } else if tableView == self.weightTableView {
            return 58;
            
        }
        return 58
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: AnyObject) {
        if UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil {
            
            authenticationController?.login(fromParentViewController: self)
            
        } else{
            self.performSegue(withIdentifier: "activityTracker", sender: self)
            
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        AuthenticationController.logout()
    }
    
  
    
    
    // MARK: AuthenticationProtocol
    @objc func getActivities(selectedDate: String) {
        FitbitAPI.sharedInstance.authorize(with: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
        let datePath = "https://api.fitbit.com/1/user/-/activities/date/\(selectedDate).json"
        
        guard let session = FitbitAPI.sharedInstance.session,
            let stepURL = URL(string: datePath) else {
                return
        }
        let dataTask = session.dataTask(with: stepURL) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
                return
            }
            
            guard let data = data,
                let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
                    return
            }
            let dispatch_group = DispatchGroup()
            dispatch_group.enter()
            
            self.sendFitBitData(dateString: selectedDate, fitBitDictionary: dictionary as NSDictionary)
            dispatch_group.leave()
            dispatch_group.notify(queue: DispatchQueue.main) {
                MBProgressHUD.hide(for: self.view, animated: true);
                let last7Days = Date.getDates(forLastNDays: 7)
                UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                self.fitbitTableView.reloadData()
                
            }
            
        }
        dataTask.resume()
    }
    
    @objc func sendHealthkitData(dateString: String, dict: NSDictionary) {
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: dict as! [String : AnyObject] , success: { response in
            print(response)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    @objc func sendFitBitData(dateString: String, fitBitDictionary: NSDictionary) {
        let activities = fitBitDictionary["summary"] as AnyObject as! NSDictionary
        var floors = ""
        if let floorsVal = activities["floors"]  {
            floors = "\(floorsVal as! Int64)"
        } else {
            floors = "0"
        }
        var km = ""
        let distanceArray = activities["distances"] as! NSArray
        let distanceDict = distanceArray[0] as! NSDictionary
        km = "\(distanceDict["distance"] as! Double)"
        let paramsDictionary = ["date": dateString,
                                "steps": "\(activities["steps"] as! Int64)",
            "floors": floors,
            "distance": km,
            "activeMins": "\(activities["veryActiveMinutes"] as! Int64)",
            "calories": "\(activities["caloriesOut"] as! Int64)",
            "deviceType": "1"]
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    
    @IBAction func addWeightAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addWeight", sender: self)
    }
    
    
    @objc func authorizationDidFinish(_ success: Bool) {
        print("Hello World with \(success)!")
        if success == false {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        if UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil {
            
            let last7Days = Date.getDates(forLastNDays: 7)
            
            for dates in last7Days {
                self.getActivities(selectedDate: dates)
            }
        } else {
            MBProgressHUD.hide(for: self.view, animated: true);
        }
    }
}

extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}
