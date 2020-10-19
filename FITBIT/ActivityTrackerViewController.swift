//
//  ActivityTrackerViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 22/02/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Alamofire
import HealthKit
import Realm
import RealmSwift
import AAInfographics
import Firebase
import FirebaseDatabase

class ActivityTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        if yValues[0] != 0.0 {
            self.chartSelectedLabel.text = "Weight readings on \(xAxisDateTime[Int(x)]) : \n Weight : \(yValues[0]) \(self.wgt) "
            
        } else {
            self.chartSelectedLabel.text = "No Readings..."
        }
    }
    var backBtn = UIButton()
    var xLabelsArray = [String]()
    @objc var stepsDictionary = [String:AnyObject]()
    @objc var floorsDictionary = [String:AnyObject]()
    @objc var distanceDictionary = [String:AnyObject]()
    @objc var caloriesDictionary = [String:AnyObject]()
    @objc var activeMinsDictionary = [String:AnyObject]()
    @objc var fitnessDataArray = NSMutableArray()
    @objc var dataArray = NSArray()
    @objc var dateFormatter = DateFormatter()
    @objc var deviceID: Int = 0
    @objc let formatter = DateFormatter()
    @objc var weightArray = NSMutableArray()
    @objc var xAxisDateTime = [String]()

    var weightGraphArray = [WeightGraph]()
    var weightsArray = NSMutableArray()
    @IBOutlet weak var fitnessSegControl: UISegmentedControl!
    
    @IBOutlet weak var weightReading: UILabel!
    @IBOutlet weak var weightCount: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIBarButtonItem!
    @IBOutlet weak var headerTxtLabel: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    var wgt = "kg"
    let aaChartV = AAChartView()
    @IBOutlet weak var weightTableView: UITableView!
    @IBOutlet weak var aaChartView: UIView!
    @IBOutlet weak var chartSelectedLabel: UILabel!
    @objc var data1 = [CGFloat]()
    @objc var xAxis = [String]()
    @objc var label = UILabel()
    @objc let lineChart = LineChart()

    @IBOutlet weak var weightView: UIView!
    var weightReadings : Results<WeightInfo>?
    
    @objc let healthStore = HealthHelper.sharedInstance.healthStore
    
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
                    self.updateChart(backGroundCol: "#168c7a", data: self.weightsArray.reversed() as! [Any], name: "Weight", colorTheme: ["#FFFFFF"], title: "Your Last 7 Weight Readings")
                    
                    
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
    
    func currentTimeInMiliseconds(dateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        
        let currentDate = dateFormatter.date(from:dateStr)
        let since1970 = currentDate!.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
                      backBtn.setImage(UIImage(named: "backIcon"), for: .normal)
                      backBtn.frame = CGRect(0, 0, 30, 30)
                      backBtn.addTarget(self, action: #selector(ActivityTrackerViewController.action), for: .touchUpInside);
                      self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backBtn), animated: true);
        self.aaChartView.addSubview(self.aaChartV)

        lineChart.backgroundColor = UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "1" {
                self.wgt = "lbs"
            }
        }
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
       self.weightReading.text = bundle.localizedString(forKey: "weight_reading", value: nil, table: nil)
        if fitnessSegControl.selectedSegmentIndex == 0 {
            self.weightView.isHidden = true

        } else {
            self.weightView.isHidden = false

//            if (self.weightReadings?.count)! > 0 {
//                refreshData1()
//            }
        }
        self.weightReadings = uiRealm.objects(WeightInfo.self)

        if (self.weightReadings?.count)! > 0 {
            
            if UserDefaults.standard.value(forKey: "WEIGHT_SENT_TO_FIREBASE") == nil {
                for wght in self.weightReadings! {
                    let milliseconds = currentTimeInMiliseconds(dateStr: wght.datetime); Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["weight": "\(wght.weight)", "datetime": milliseconds])
                }
                UserDefaults.standard.setValue("YES", forKey: "WEIGHT_SENT_TO_FIREBASE")
                UserDefaults.standard.synchronize()
            }
        }

        formatter.dateFormat = "yyyy-MM-dd"

        if UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil {
            self.deviceID = 1
        } else if UserDefaults.standard.value(forKey: "HEALTHKIT") != nil {
            self.deviceID = 2
        }
        
        if self.deviceID == 1 {
           
             self.headerTxtLabel.text = bundle.localizedString(forKey: "fitBit_headerText", value: nil, table: nil)
            self.title  = bundle.localizedString(forKey: "fitBit", value: nil, table: nil)

        } else if self.deviceID == 2 {

            self.title  = bundle.localizedString(forKey: "health_kit", value: nil, table: nil)
            self.headerTxtLabel.text = bundle.localizedString(forKey: "health_kit_headerText", value: nil, table: nil)
            
        }
   
        MBProgressHUD.showAdded(to: self.view, animated: true);
        if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
            if UserDefaults.standard.value(forKey: "LAST7DAYS") != nil {
                
                let last7Days = UserDefaults.standard.value(forKey: "LAST7DAYS") as! [String]
                if (last7Days.contains(Date.getWantedDate(forLastNDays: 1)) && last7Days.contains(Date.getWantedDate(forLastNDays: 2)) && last7Days.contains(Date.getWantedDate(forLastNDays: 3)) && last7Days.contains(Date.getWantedDate(forLastNDays: 4)) && last7Days.contains(Date.getWantedDate(forLastNDays: 5)) && last7Days.contains(Date.getWantedDate(forLastNDays: 6)) && last7Days.contains(Date.getWantedDate(forLastNDays: 7)))   {
                    self.getActivitiesData()
                } else {
                    
                    self.getHealthActivitiesData()
                    
                }
            }
        }
        
        if (UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil && UserDefaults.standard.value(forKey: "HEALTHKIT") == nil) {
            
            if UserDefaults.standard.value(forKey: "LAST7DAYS") != nil {
                
                let last7Days = UserDefaults.standard.value(forKey: "LAST7DAYS") as! [String]
               
                if (last7Days.contains(Date.getWantedDate(forLastNDays: 1)) && last7Days.contains(Date.getWantedDate(forLastNDays: 2)) && last7Days.contains(Date.getWantedDate(forLastNDays: 3)) && last7Days.contains(Date.getWantedDate(forLastNDays: 4)) && last7Days.contains(Date.getWantedDate(forLastNDays: 5)) && last7Days.contains(Date.getWantedDate(forLastNDays: 6)) && last7Days.contains(Date.getWantedDate(forLastNDays: 7)))   {
                    self.getActivitiesData()
                } else {
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    for i in 1 ... 7 {
                        if !(last7Days.contains(Date.getWantedDate(forLastNDays: i))) {
                            self.getActivities(selectedDate: Date.getWantedDate(forLastNDays: i))
                        }
                    }
                    dispatch_group.leave()
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        
                        let last7Days = Date.getDates(forLastNDays: 7)
                        
                        UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                        self.getActivitiesData()
                    }
                }
            }  else {
                self.getActivitiesData()
                
            }

        }
    }
    
    @objc func refreshData1() {
        self.chartSelectedLabel.text = "Please tap on the graph to see the readings...";
      //  showChartView();
    }
    
    @objc func action() {
    self.navigationController?.popViewController(animated: true)
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
           // self.dateLabel.text = weightDict["datetime"] as? String
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
    
    @IBAction func addWeightAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addWeight", sender: self)
    }
    
    
    @IBAction func fitnessSegControl(_ sender: UISegmentedControl) {
                if (sender.selectedSegmentIndex == 0) {
                    self.weightView.isHidden = true;
        
                } else {
                    self.weightView.isHidden = false;
//                    self.weightReadings = uiRealm.objects(WeightInfo.self);
//                    if (self.weightReadings?.count)! > 0 {
//                        refreshData1();
//                    }
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
       // self.weightReadings = uiRealm.objects(WeightInfo.self);
        getWeightDetails()

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
    
    
    @objc func getActivitiesData() {
         let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getFitnessData(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            
            print("This is run on the background queue")
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                MBProgressHUD.hide(for: self.view, animated: true);
                let fitbitDataDictionary = responceDic as! NSDictionary
                self.dataArray = fitbitDataDictionary["fitnessData"] as! NSArray
                if self.dataArray.count == 0 {
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "You have no data!!")
                    return
                }
                for dict in self.dataArray {
                    let dictionary = dict as! NSDictionary
                    if dictionary["uft_device_type"] as! Int == self.deviceID {
                        self.fitnessDataArray.add(dictionary)
                    }
                }
                self.activityTableView.reloadData()
                
            }
            
        }) { (error : NSError!) -> (Void) in
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            MBProgressHUD.hide(for: self.view, animated: true);
        }
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
                  
                    self.disconnectDevice(token: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
                    return
            }
            self.sendFitBitData(dateString: selectedDate, fitBitDictionary: dictionary as NSDictionary)
            
        }
        dataTask.resume()
    }
    
    @objc func getActivitesFromHealthKit(selectedDate: String, qtyType:HKQuantityTypeIdentifier,completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: qtyType.rawValue)) // The type of data we are requesting
        
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        var anchorComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
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
                completion(resultCount)
            }
        }
        healthStore?.execute(stepsQuery)
    }
    
    @objc func getHealthActivitiesData() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let stepsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let flightsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)
        let distanceCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let caloriesCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let activeMinsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)
        
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
                        print(" Steps: \(value)")
                        
                        dict["date"] = dates as AnyObject
                        dict["steps"] = "\(value.cleanValue)" as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        self.stepsDictionary[dates] = dict as AnyObject
                        
                    })
                }
                
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .flightsClimbed, completion: {value in
                        print(" Steps: \(value)")
                        
                        dict["date"] = dates as AnyObject
                        dict["floors"] = "\(value.cleanValue)" as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        self.floorsDictionary[dates] = dict as AnyObject
                       
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .distanceWalkingRunning, completion: {val in
                        print(" Steps: \(val)")
                        let str = "\(val)"
                        dict["date"] = dates as AnyObject
                        if(str.contains("0.")) {
                            let doubleStr = String(format: "%.2f", val)
                            dict["distance"] = doubleStr as AnyObject
                            
                        } else {
                            dict["distance"] = "\(Double(val).rounded(toPlaces: 2))" as AnyObject
                            
                        }
                        dict["deviceType"] = 2 as AnyObject
                        self.distanceDictionary[dates] = dict as AnyObject
                        
                    })
                    
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .activeEnergyBurned, completion: {val in
                        print(" Steps: \(val)")
                        dict["date"] = dates as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        dict["calories"] = "\(val.cleanValue)" as AnyObject
                        self.caloriesDictionary[dates] = dict as AnyObject
                        
                    })
                    
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .appleExerciseTime, completion: {val in
                        print(" Steps: \(val)")
                        dict["deviceType"] = 2 as AnyObject
                        dict["activeMins"] = "\(val.cleanValue)" as AnyObject as AnyObject
                        self.activeMinsDictionary[dates] = dict as AnyObject
                        
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
                            
                            let last7Days = Date.getDates(forLastNDays: 7)
                            let dispatch_group = DispatchGroup()
                            dispatch_group.enter()
                            for dates in last7Days {
                               
                                let paramsDictionary = ["date": dates,
                                                        "steps":  "\((self.stepsDictionary[dates]!["steps"] as AnyObject).integerValue as Int)",
                                    "floors": "\((self.floorsDictionary[dates]!["floors"] as AnyObject).integerValue as Int)",
                                    "distance": "\((self.distanceDictionary[dates]!["distance"] as AnyObject).doubleValue as Double)",
                                    "activeMins": "0",
                                    "calories": "0",
                                    "deviceType": "2"]
                                self.sendHealthkitData(dateString: dates, dict: paramsDictionary as NSDictionary)
                            
                            }
                            dispatch_group.leave()
                            dispatch_group.notify(queue: DispatchQueue.main) {
                                MBProgressHUD.hide(for: self.view, animated: true);
                                UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                                self.getActivitiesData()
                                
                            }
                        }
                    }
                }
                
            }
            else {
                
            }
            
        })
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.weightTableView {
            return 58;
            
        } else if tableView == self.activityTableView {
        return 253
        }
        return 58
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addReadings" {
            let cellDict = sender as! WeightGraph
            let destination = segue.destination as! MHAAddReadingsContainer
            destination.snapShot = cellDict.snapShot
            destination.dateTime = cellDict.dateTime
            destination.weight = cellDict.weight
        }
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
    @IBAction func popBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.activityTableView {
            if self.fitnessDataArray.count > 0 {
                MBProgressHUD.hide(for: self.view, animated: true);
                return self.fitnessDataArray.count;
                
            }
        }
        else if tableView == self.weightTableView {
            if self.weightGraphArray.count > 0 {
                return self.weightGraphArray.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let noCell = UITableViewCell()
        if tableView == self.activityTableView {
         let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ActivityTrackerCell;
        
        cell.stepsTitle.text = bundle.localizedString(forKey: "steps", value: nil, table: nil)
        cell.activeMinsTitle.text = bundle.localizedString(forKey: "active_min", value: nil, table: nil)
        cell.caloriesTitle.text = bundle.localizedString(forKey: "calories", value: nil, table: nil).replacingOccurrences(of: ":", with: "")
          cell.distanceTitle.text = bundle.localizedString(forKey: "distance", value: nil, table: nil)
          cell.floorsTitle.text = bundle.localizedString(forKey: "floors", value: nil, table: nil)
        
        let cellDictionary = self.fitnessDataArray[indexPath.row] as! NSDictionary
        cell.activeMinLbl.text = "\(cellDictionary["uft_active_mins"] as! Int)"
        cell.caloriesLbl.text = "\(cellDictionary["uft_calories"] as! Int)"
        cell.stepsLbl.text = "\(cellDictionary["uft_steps"] as! Int)"
        cell.floorsLbl.text = "\(cellDictionary["uft_floors"] as! Int)"
        cell.distanceLbl.text = "\(cellDictionary["uft_distance"] as! Double)" + " KMs"
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateStr = cellDictionary["uft_date"] as! String
        let dateFrmStr = self.dateFormatter.date(from: dateStr)
        self.dateFormatter.dateFormat = "d MMM, EEE, yyyy"
        
        cell.dateLbl.text = "  " + self.dateFormatter.string(from: dateFrmStr!)
        
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
        return noCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func disconnectDevice(token: String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let clientID = FitBitDetails.clientID
        let clientSecret = FitBitDetails.clientSecret
      
        let base64 = base64String("\(clientID):\(clientSecret)")
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic \(base64)"
        ]
        let parameters = ["token": token]
        
        Alamofire.request("https://api.fitbit.com/oauth2/revoke", method: .post, parameters: parameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case.success(let data):
                print("success",data)
                MBProgressHUD.hide(for: self.view, animated: true);

                UserDefaults.standard.removeObject(forKey: "FITBIT_TOKEN")
                let alertController = UIAlertController(title:  self.bundle.localizedString(forKey: "disconnected", value: nil, table: nil), message: self.bundle.localizedString(forKey: "disconnected_FitBit", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DISCONNECTED_DEVICE"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)

            case.failure(let error):
                print("Not Success",error)
                MBProgressHUD.hide(for: self.view, animated: true);

                  TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            }
        }
    }
    
    @objc func base64String(_ string: String) -> String {
        // Create NSData object
        let nsdata: Data? = string.data(using: .utf8)
        // Get NSString from NSData object in Base64
        let base64Encoded = nsdata?.base64EncodedString(options: [])
        return base64Encoded ?? ""
    }
    
    
    @IBAction func disconnectTapped(_ sender: Any) {
        var msg = ""
        if self.deviceID == 1 {
            msg = self.bundle.localizedString(forKey: "fitbit_disconnect", value: nil, table: nil)
        } else if deviceID == 2 {
            msg = self.bundle.localizedString(forKey: "health_kit_disconnect", value: nil, table: nil)
        }
        let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "disconnect", value: nil, table: nil), message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if self.deviceID == 1 {
            self.disconnectDevice(token: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
            } else if self.deviceID == 2 {
                UserDefaults.standard.removeObject(forKey: "HEALTHKIT")
                UserDefaults.standard.removeObject(forKey: "HEALTHKIT_DISCONNECTED")

                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "disconnected", value: nil, table: nil), message: self.bundle.localizedString(forKey: "disconnected_HealthKit", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let okAction1 = UIKit.UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DISCONNECTED_DEVICE"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                }
               
                // Add the actions
                alertController.addAction(okAction1)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: self.bundle.localizedString(forKey: "no", value: nil, table: nil), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
