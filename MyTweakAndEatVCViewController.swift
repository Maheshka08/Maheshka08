//
//  MyTweakAndEatVCViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase
import AAInfographics

class MyTweakAndEatVCViewController: UIViewController, LineChartDelegate, UITableViewDelegate, UITableViewDataSource, MyNutritionButtonsTapped {
    
    func tappedOnLast10Tweaks() {
           self.myNutritionViewSelectYourMealTableView.isHidden = true
           self.myNutritionViewLast10TweaksTableView.frame = CGRect(x: self.myNutritionDetailsView.last10TweaksView.frame.minX, y: self.myNutritionDetailsView.frame.maxY, width: self.myNutritionDetailsView.selectYourMealView.frame.width, height: 200)
                  self.myNutritionViewLast10TweaksTableView.delegate = self
                  self.myNutritionViewLast10TweaksTableView.dataSource = self
                  self.view.addSubview(self.myNutritionViewLast10TweaksTableView)
                  if  self.myNutritionViewSelectYourMealTableView.isHidden == true {
                    //  MBProgressHUD.showAdded(to: self.myNutritionViewLast10TweaksTableView, animated: true)
                   self.myNutritionViewLast10TweaksTableView.isHidden = false
                    self.myNutritionViewLast10TweaksTableView.reloadData()
                  }
                 // self.getMealTypes(tblView: self.myNutritionViewLast10TweaksTableView)
       }
       
       func tappedOnSelectYourMeal() {
           self.myNutritionViewLast10TweaksTableView.isHidden = true
           self.myNutritionViewSelectYourMealTableView.frame = CGRect(x: self.myNutritionDetailsView.selectYourMealView.frame.minX, y: self.myNutritionDetailsView.frame.maxY, width: self.myNutritionDetailsView.selectYourMealView.frame.width, height: 310)
           self.myNutritionViewSelectYourMealTableView.delegate = self
           self.myNutritionViewSelectYourMealTableView.dataSource = self
           self.view.addSubview(self.myNutritionViewSelectYourMealTableView)
           if  self.myNutritionViewSelectYourMealTableView.isHidden == true {
               MBProgressHUD.showAdded(to: self.myNutritionViewSelectYourMealTableView, animated: true)
            self.myNutritionViewSelectYourMealTableView.isHidden = false
           }
           self.getMealTypes(tblView: self.myNutritionViewSelectYourMealTableView)
           
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
               return self.mealTypeArray.count
               } else if tableView == self.myNutritionViewLast10TweaksTableView {
                          return self.dataBtnArray.count
               }
               return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.textColor = .white
            if tableView == self.myNutritionViewSelectYourMealTableView {
                cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1);
                cell.textLabel?.textColor = .white

            } else {
        cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.6);
            }
        cell.textLabel?.textAlignment = .center
        let cellDict = self.mealTypeArray[indexPath.row];
        cell.textLabel?.text = (cellDict["name"] as! String)
        return cell;
        } else if tableView == self.myNutritionViewLast10TweaksTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.textLabel?.text = self.dataBtnArray[indexPath.row];
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1);
            cell.textLabel?.textColor = .white

            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
        let cellDict = self.mealTypeArray[indexPath.row];
        self.mealType = cellDict["value"] as! Int
          //  if tableView == self.mealTypeTableView {
        self.mealTypeLabel.text = (cellDict["name"] as! String)
        //    } else if tableView == self.myNutritionViewSelectYourMealTableView {
                
                self.nutritionViewSelectedMeal = (cellDict["name"] as! String)
          //  }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        tableView.isHidden = true
                        self.view.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
        })
        self.setDefaultDataBtns(name: self.dataBtnName)
        } else if tableView == self.myNutritionViewLast10TweaksTableView {
            
            let data = self.dataBtnArray[indexPath.row];
            self.nutritionViewLast10TweaksDataVal = data
            tableView.isHidden = true
            self.dataBtnName = self.dataBtnDict[data]!
            self.myNutritionDetailsView.last10TweaksLbl.text = data
            self.setDefaultDataBtns(name: self.dataBtnName)
            
        }

    }
    
    var switchButton: SwitchWithText!

    var last10Data = [LastTenData]()
    var todayData = [TodayData]()
    var weekData = [WeekData]()
    var monthData = [MonthData]()
    var dataSelected = ""
    var mealType = 0
    var trends = "Calories"
    var myNutritionViewSelectYourMealTableView = UITableView()
    var myNutritionViewLast10TweaksTableView = UITableView()
    var loadingView = UIView()
    @IBOutlet weak var minCalCountLabel: UILabel!
    @IBOutlet weak var myNutritionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var monthBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dietPlanImageView: UIImageView!
    @IBOutlet weak var noGraphDataLabel: UILabel!
    @IBOutlet weak var mealTypeTableView: UITableView!
    @IBOutlet weak var topButtonsDataView: UIView!
    @IBOutlet weak var last10TweaksBtn: UIButton!
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var weekBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var selectYourMealTypeView: UIView!
    @IBOutlet weak var mealTypeLabel: UILabel!;
    var fromWhichVC = ""
    var pkgName = ""
    @IBOutlet weak var mealTypeView: UIView!
    var dataBtnName = "lastTenData"
    @IBOutlet weak var protienButton: UIButton!
    @IBOutlet weak var fatButton: UIButton!
    @IBOutlet weak var caloriesButton: UIButton!
    @IBOutlet weak var carbsButton: UIButton!
    @objc var ptpPackage = ""
    @IBOutlet weak var immunityBoosterView: UIView!
    
    @objc var myNutritionDetailsView : MyNutritionView! = nil;

    
    var mealTypeArray = [[String: AnyObject]]();
    @IBOutlet weak var trendButtonsView: UIView!
    @IBOutlet weak var outerChartView: UIView!
  
    private let maxDragPosition = UIScreen.main.bounds.size.height - 150
    

    let aaChartView = AAChartView()
    @IBOutlet weak var last10TweaksLbl: UILabel!
    @IBOutlet weak var myTrendsLabel: UILabel!
    
    @IBOutlet weak var chartView: UIView!
    
    
    @IBAction func backAction(_ sender: Any) {
//        if self.fromWhichVC == "MoreInfoPremiumPackagesViewController" {
//        self.navigationController?.popToRootViewController(animated: true)
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    var showGraph = false
    let realm :Realm = try! Realm();
    var myProfileInfo : Results<MyProfileInfo>?;
    var system = 0;
    var countryCode = "";
    var packageID = "";
    var callStatus = "callStatus";
    
    @objc var unsubScribePlan = "";
    @objc var alreadyUnsubscribed = false;
    @objc var caloriesArray = NSMutableArray();
    @objc var carbsArray = NSMutableArray();
    @objc var fatssArray = NSMutableArray();
    @objc var proteinArray = NSMutableArray()
    @objc var nutritionLabelPackagesArray = NSMutableArray();
    @IBOutlet weak var okIndiaUnSubBtn: UIButton!;
    @IBOutlet weak var noBtn: UIButton!;
    @IBOutlet weak var finalnsubView: UIView!;
    @IBOutlet weak var unsubscribeBtn: UIButton!;
    @IBOutlet weak var cancelBtn: UIButton!;
    @IBOutlet weak var noNutritionAnalyticsView: UIView!;
    @IBOutlet weak var unsubscribePlanView: UIView!;
    @IBOutlet weak var tweakPlateAlertLbl: UILabel!;
    
    @IBOutlet weak var tipImage: UIImageView!;
    @IBOutlet weak var tipsTextView: UITextView!;
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var myAiDPView: UIView!
    @IBOutlet weak var myChatView: UIView!
    @IBOutlet weak var myNutritionView: UIView!
    @objc var tweaksArray = NSArray();
    @IBOutlet weak var lineChart: UIView!
    
    @objc var calories = 0;
    @objc let lineChartView = LineChart();
    @objc var xLabelsArray = [String]();
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    var dataBtnArray = [String]()
    var dataBtnDict = [String: String]()
    var nutritionViewSelectedMeal = "Select your meal"
    var nutritionViewLast10TweaksDataVal = "Last 10 Tweaks"
    @IBOutlet weak var myAiDPLbl: UILabel!
    @IBOutlet weak var myAiDPBtn: UIButton!
    @IBOutlet weak var helpIcon: UIBarButtonItem!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var indUnsubsView: UIView!
    @IBOutlet weak var nutritionDescLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var unsubIndiaPkgBtn: UIButton!
    
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
    
    func updateChartFromSecondTime(backGroundCol: String, data: [Any], name: String, colorTheme: [Any]) {
        self.chartView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.last10TweaksLbl.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.topButtonsDataView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.mealTypeTableView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bouncePast)
            .title("")//The chart title
            .subtitle("")//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["1", "2", "3", "4", "5", "6",
                         "7", "8", "9", "10"])
            .colorsTheme(["#FFFFFF"])
            .series([
                AASeriesElement()
                    .name(name)
                    .data(data)
                
                ])
        aaChartModel.yAxisGridLineWidth = 0.0
        aaChartView.scrollEnabled = false
        aaChartView.isClearBackgroundColor = true
        aaChartModel.gradientColorEnable = true
        aaChartModel.yAxisVisible = false
        aaChartModel.backgroundColor = backGroundCol
        aaChartModel.legendEnabled = false
        aaChartModel.axesTextColor = "#FFFFFF"
        
        aaChartView.aa_refreshChartWholeContentWithChartModel(aaChartModel)
        
    }
    
    func updateChart(backGroundCol: String, data: [Any], name: String, colorTheme: [Any]) {
        self.last10TweaksLbl.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.chartView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.topButtonsDataView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.mealTypeTableView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bouncePast)
            .title("")//The chart title
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
        aaChartView.scrollEnabled = false
        aaChartView.isClearBackgroundColor = true
        aaChartModel.gradientColorEnable = true
        aaChartModel.yAxisVisible = false
        aaChartModel.backgroundColor = backGroundCol
        aaChartModel.legendEnabled = false
        aaChartModel.axesTextColor = "#FFFFFF"
        
        
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    @objc func getTrends() {
        //api call for labelperc
        self.loadingView.isHidden = false
        MBProgressHUD.showAdded(to: self.loadingView, animated: true)
        if UserDefaults.standard.value(forKey: "userSession") == nil {
            
        } else {
            // MBProgressHUD.showAdded(to: self.view, animated: true)
            self.caloriesArray = NSMutableArray()
            self.carbsArray = NSMutableArray()
            self.fatssArray = NSMutableArray()
            self.proteinArray = NSMutableArray()
            self.tweaksArray = NSArray()
            self.last10Data = [LastTenData]()
            self.todayData = [TodayData]()
            self.monthData = [MonthData]()
            self.weekData = [WeekData]()
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            APIWrapper.sharedInstance.getTweakLabels(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                print(responseDic);
                MBProgressHUD.hide(for: self.view, animated: true)
                if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    //self.tweaksArray = responseDic["tweaks"] as AnyObject as! NSArray
                    let tweakDict = responseDic as AnyObject as! [String: AnyObject]
                    let tweakLblDict = tweakDict["tweaks"] as! [String : AnyObject]
                    self.getDataTrendsArray(dictionary: tweakLblDict, tweakDictionary: tweakDict)
                    self.setDefaultDataBtns(name: self.dataBtnName)
                    
                    
                    
                }
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
                MBProgressHUD.hide(for: self.view, animated: true);
                if error?.code == -1011 {
                    
               
                    self.setDefaultsTrendBtns()
                    //   self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: [20,100,30,150,200,50,300,40,400,30], name: "Calories", colorTheme: ["#528039"])
                    self.updateChart(backGroundCol: "#168c7a", data:  [20,100,30,150,200,50,300,40,400,30] as [Any], name: "Calories", colorTheme: ["#FFFFFF"])
                    
                }
                //            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            })
        }
    }
    
    func setDefaultsTrendBtns() {
        DispatchQueue.main.async {
            
            
            self.myTrendsLabel.text = "MY CALORIE TRENDS"
            self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.carbsButton.layer.borderColor = UIColor.white.cgColor
            self.carbsButton.layer.borderWidth = 1
            self.caloriesButton.layer.borderColor = UIColor.white.cgColor
            self.caloriesButton.layer.borderWidth = 1
            self.fatButton.layer.borderColor = UIColor.white.cgColor
            self.fatButton.layer.borderWidth = 1
            self.protienButton.layer.borderColor = UIColor.white.cgColor
            self.protienButton.layer.borderWidth = 1
            self.last10TweaksLbl.text = " Last 10 Tweaks"
            self.last10TweaksLbl.layer.borderColor = UIColor.white.cgColor
            self.last10TweaksLbl.layer.borderWidth = 1
            self.last10TweaksLbl.layer.cornerRadius = 5
            self.carbsButton.layer.cornerRadius = 5
            self.caloriesButton.layer.cornerRadius = 5
            self.fatButton.layer.cornerRadius = 5
            self.protienButton.layer.cornerRadius = 5
        }
    }
    
    @IBAction func caloriesInfoBtnTapped(_ sender: Any) {
        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your Approximate calorie range left for the day is indicated here.\n\n Calorie range indicated is calculated automatically based on your personal profile i.e your height,weight,BMI etc");
        
    }
    @IBAction func todayBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "todaysData"
        self.last10TweaksLbl.text = " Today"
        self.nutritionViewSelectedMeal = "Select your meal"
        self.nutritionViewLast10TweaksDataVal = "Today"
        self.setDefaultDataBtns(name: "todaysData")
    }
    @IBAction func weekBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "weeksData"
        self.last10TweaksLbl.text = " Week"
        self.nutritionViewSelectedMeal = "Select your meal"
        self.nutritionViewLast10TweaksDataVal = "Week"
        self.setDefaultDataBtns(name: "weeksData")
    }
    
    @IBAction func monthBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "monthsData"
        self.last10TweaksLbl.text = " Month"
        self.nutritionViewSelectedMeal = "Select your meal"
        self.nutritionViewLast10TweaksDataVal = "Month"
        self.setDefaultDataBtns(name: "monthsData")
    }
    
    @IBAction func last10TweaksBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "lastTenData"
        self.last10TweaksLbl.text = " Last 10 Tweaks"
        self.nutritionViewSelectedMeal = "Select your meal"
        self.nutritionViewLast10TweaksDataVal = "Last 10 Tweaks"
        self.setDefaultDataBtns(name: "lastTenData")
        
        
    }
    
    @IBAction func selectMealTypeBtnTapped(_ sender: Any) {
        if  self.mealTypeTableView.isHidden == true {
            MBProgressHUD.showAdded(to: self.mealTypeTableView, animated: true)
            self.mealTypeTableView.isHidden = false
        }
        self.getMealTypes(tblView: self.mealTypeTableView)
    }
    
    func setDefaultDataBtns(name: String) {
        self.caloriesArray = NSMutableArray()
        self.carbsArray = NSMutableArray()
        self.fatssArray = NSMutableArray()
        self.proteinArray = NSMutableArray()
        self.noGraphDataLabel.isHidden = true
        if name == "lastTenData" {
            self.last10TweaksBtn.layer.cornerRadius = 5
            self.last10TweaksBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            if self.last10Data.count > 0 {
            var sortingArr = [LastTenData]()
            if self.mealType != 0 {
              sortingArr = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
            } else {
                sortingArr = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
            }
            for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        } else if name == "todaysData" {
            self.todayBtn.layer.cornerRadius = 5
            self.todayBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
             if self.todayData.count > 0 {
            var sortingArr = [TodayData]()
            if self.mealType != 0 {
                sortingArr = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
            } else {
                sortingArr = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
            }
          
            for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }  else if name == "weeksData" {
            self.weekBtn.layer.cornerRadius = 5
            self.weekBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
           if self.weekData.count > 0 {
                var sortingArr = [WeekData]()
                if self.mealType != 0 {
                    sortingArr = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
                } else {
                    sortingArr = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
                }
                
                for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }   else if name == "monthsData" {
            self.monthBtn.layer.cornerRadius = 5
            self.monthBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
         if self.monthData.count > 0 {
                var sortingArr = [MonthData]()
                if self.mealType != 0 {
                    sortingArr = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
                } else {
                    sortingArr = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
                }
                
                for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }
        UserDefaults.standard.set(self.caloriesArray, forKey: "GET_TREND_CALORIES")
        UserDefaults.standard.synchronize()
        MBProgressHUD.hide(for: self.loadingView, animated: true);
        self.loadingView.isHidden = true
        if self.showGraph == true {
            DispatchQueue.main.async {
                            if self.trends == "Calories" {
                                     
                                  self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: self.caloriesArray as! [Any], name: "Calories", colorTheme: ["#528039"])
                                      
                                  } else if self.trends == "Carbs" {
                                      self.updateChartFromSecondTime(backGroundCol: "#ce1371", data: self.carbsArray as! [Any], name: "Carbs", colorTheme: ["#9E1B76"])
                                  } else if self.trends == "Protein" {
                                      self.updateChartFromSecondTime(backGroundCol: "#69b04c", data: self.proteinArray as! [Any], name: "Protein", colorTheme: ["#0B6B64"])
                                  } else if self.trends == "Fats" {
                                      self.updateChartFromSecondTime(backGroundCol: "#d49741", data: self.fatssArray as! [Any], name: "Fat", colorTheme: ["#D79F53"])
                                  }
                                  if (self.caloriesArray.count == 0 || self.carbsArray.count == 0 || self.proteinArray.count == 0 ||
                                  self.fatssArray.count == 0) {
                                      self.noGraphDataLabel.isHidden = false
                                      self.noGraphDataLabel.text = "No Trends found! Start Tweaking now to see your own Nutritional Trend here. Make the Trend your friend! "
                                      self.view.bringSubviewToFront(self.noGraphDataLabel)
                                  }
                       }
       
        } else {
            self.showMyNutritionDetails()
        }
    }
    
    func getMealTypes(tblView: UITableView) {
        APIWrapper.sharedInstance.getMealTypes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    MBProgressHUD.hide(for: tblView, animated: true)
                    self.mealTypeArray = (response["data"] as AnyObject as! NSArray) as! [[String : AnyObject]]
                    let allType: [String:AnyObject] = ["value": 0 as AnyObject , "name": "All" as AnyObject];
                    self.mealTypeArray.insert(allType, at: 0)
                    print(self.mealTypeArray)
                    tblView.reloadData()
                   
                }
                
            }else {
                //error
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: tblView, animated: true)
                }
                print("error")
                
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: tblView, animated: true)
            }
            
           
            
        }
    }
    func updateSwitchUI(bool: Bool) {
    
        self.switchButton.setStatus(bool)
    }
    @objc func swapViews(_ notification: NSNotification) {
        
        let bool = notification.object as! Bool
        UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
               }, completion: {(_ completed: Bool) -> Void in
                if bool == true {
                    if (self.myNutritionDetailsView != nil) {
                        self.myNutritionViewLast10TweaksTableView.isHidden = true
                        self.myNutritionViewSelectYourMealTableView.isHidden = true
                        self.myNutritionDetailsView.isHidden = true
                        self.showGraph = true
                        //self.myNutritionDetailsView.switchButton.setStatus(bool)
                        self.updateSwitchUI(bool: true)
                        self.setDefaultDataBtns(name: self.dataBtnName)
                    }
                } else {
                    if (self.myNutritionDetailsView != nil) {
                        self.mealTypeTableView.isHidden = true

                                   self.myNutritionDetailsView.isHidden = false
                                   self.showGraph = false
                         self.myNutritionDetailsView.switchButton.setStatus(false)
                                   self.setDefaultDataBtns(name: self.dataBtnName)
                    }
                }

                self.updateUIAccordingTOEachDevice()

        })
        
        
    }
    
    func updateUIAccordingTOEachDevice() {
        if (IS_iPHONE5 || IS_IPHONE4) {
            if self.showGraph == false {
                aaChartView.frame = CGRect(x: 0, y: 0, width: 320, height: 170)
                self.chatViewHeightConstraint.constant = 170
            } else {
            aaChartView.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
           self.chatViewHeightConstraint.constant = 200
            }
            self.monthBtnTrailingConstraint.constant = 0;
        } else if IS_iPHONE678P {
            if self.showGraph == false {
                aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
                self.chatViewHeightConstraint.constant = 170
            } else {
            self.chatViewHeightConstraint.constant = 160
            aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 160)
            }
         
            self.monthBtnTrailingConstraint.constant = 50;
            self.myNutritionTopConstraint.constant = 80;
            
        } else if IS_iPHONE678 {
            if self.showGraph == false {
                self.chatViewHeightConstraint.constant = 170
                aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 170)
            } else {
            self.chatViewHeightConstraint.constant = 160
            aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 160)
            }
           self.myNutritionTopConstraint.constant = 15
            self.monthBtnTrailingConstraint.constant = 30;
            
        } else if IS_iPHONEXXS {
            self.myNutritionTopConstraint.constant = 50
            if self.showGraph == false {
                self.chatViewHeightConstraint.constant = 170
                aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 170)
            } else {
            self.chatViewHeightConstraint.constant = 200
            aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
            }
            self.monthBtnTrailingConstraint.constant = 30;
            
        } else if IS_iPHONEXRXSMAX {
            self.myNutritionTopConstraint.constant = 80
            if self.showGraph == false {
            self.chatViewHeightConstraint.constant = 170
            aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
            } else {
                self.chatViewHeightConstraint.constant = 200
                aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
            }
            self.monthBtnTrailingConstraint.constant = 50;
            
        }
        self.view.layoutIfNeeded()
          self.loadingView.frame = CGRect(x: self.outerChartView.frame.origin.x, y: self.view.frame.origin.y, width: self.outerChartView.frame.size.width, height: self.chartView.frame.maxY)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews();
        
        self.updateUIAccordingTOEachDevice()
        
    }
    
    @IBAction func trendsButtonTapped(_ sender: Any) {
        let btn = sender as! UIButton
        DispatchQueue.main.async {
            self.caloriesButton.alpha = 1.0
            self.carbsButton.alpha = 1.0
            self.fatButton.alpha = 1.0
            self.protienButton.alpha = 1.0
            self.fatButton.backgroundColor = UIColor.clear
            self.protienButton.backgroundColor = UIColor.clear
            self.carbsButton.backgroundColor = UIColor.clear
            self.caloriesButton.backgroundColor = UIColor.clear
        }
        
        if btn.currentTitle == "Calories" {
            self.trends = "Calories"
            DispatchQueue.main.async {
                
                self.myTrendsLabel.text = "MY CALORIE TRENDS"
                self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            // self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: self.caloriesArray as! [Any], name: "Calories", colorTheme: ["#528039"])
        } else if btn.currentTitle == "Carbs" {
            self.trends = "Carbs"
            DispatchQueue.main.async {
                
                self.myTrendsLabel.text = "MY CARB TRENDS"
                self.carbsButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            // self.updateChartFromSecondTime(backGroundCol: "#ce1371", data: self.carbsArray as! [Any], name: "Carbs", colorTheme: ["#9E1B76"])
        } else if btn.currentTitle == "Protein" {
            self.trends = "Protein"
            DispatchQueue.main.async {
                
                self.myTrendsLabel.text = "MY PROTEIN TRENDS"
                self.protienButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            //self.updateChartFromSecondTime(backGroundCol: "#69b04c", data: self.proteinArray as! [Any], name: "Protein", colorTheme: ["#0B6B64"])
        } else if btn.currentTitle == "Fats" {
            self.trends = "Fats"
            DispatchQueue.main.async {
                
                self.myTrendsLabel.text = "MY FATS TRENDS"
                self.fatButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            //self.updateChartFromSecondTime(backGroundCol: "#d49741", data: self.fatssArray as! [Any], name: "Fat", colorTheme: ["#D79F53"])
        }
        self.setDefaultDataBtns(name: self.dataBtnName)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.set("MY_TAE", forKey: "SWAP_SWITCH_VIEW")
        UserDefaults.standard.synchronize()
                if UserDefaults.standard.value(forKey: "APPROX_CALORIES") != nil {
            let approxCal = UserDefaults.standard.value(forKey: "APPROX_CALORIES") as AnyObject as! Int
            DispatchQueue.main.async {
                self.minCalCountLabel.text = "\(approxCal <= 0 ? 0: approxCal)";
            }
        }
    }
    func showCircularProgressViews() {
        self.myNutritionDetailsView.last10TweaksLbl.text = self.nutritionViewLast10TweaksDataVal
               self.myNutritionDetailsView.selectYourMealLbl.text = self.nutritionViewSelectedMeal
        var count = CGFloat(0)
               for val in self.carbsArray {
                   count += val as! CGFloat
               }
               let carbsVal = Double(count/CGFloat(self.carbsArray.count))
               self.myNutritionDetailsView.carbsValue.text = carbsVal.isNaN ? "0 %" : "\(carbsVal.round(to:2)) %"
               count = CGFloat(0)
               for val in self.fatssArray {
                   count += val as! CGFloat
               }
               let fatsVal = Double(count/CGFloat(self.fatssArray.count))
               self.myNutritionDetailsView.fatsValue.text = fatsVal.isNaN ? "0 %" : "\(fatsVal.round(to:2)) %"
               count = CGFloat(0)
               for val in self.proteinArray {
                   count += val as! CGFloat
               }
               let proteinVal = Double(count/CGFloat(self.proteinArray.count))
               self.myNutritionDetailsView.proteinsValue.text = proteinVal.isNaN ? "0 %" : "\(proteinVal.round(to:2)) %"
               count = CGFloat(0)
                      for val in self.caloriesArray {
                          count += val as! CGFloat
                      }
               self.myNutritionDetailsView.caloriesValue.text = count.isNaN ? "0" : "\(Int(count))"
               
               let image = UIImage(named: "calories")
                              let imageView = UIImageView(image: image!)
                              imageView.frame = CGRect(x: 0, y: 0, width: self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.width, height: self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.width)
                              self.myNutritionDetailsView.myNutritionCaloriesView.addSubview(imageView)
              showCircularProgressViews(image: "carbs", someViews: self.myNutritionDetailsView.myNutritionCarbsView, value: (carbsVal/Double(100)).round(to:2), progressColor: UIColor.init(red: 208.0/255.0, green: 235.0/255.0, blue: 165.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 85.0/255.0, green: 123.0/255.0, blue: 34.0/255.0, alpha: 1.0))
               showCircularProgressViews(image: "fats", someViews: self.myNutritionDetailsView.myNutritionFatsView, value: (fatsVal/Double(100)).round(to:2),progressColor: UIColor.init(red: 229.0/255.0, green: 202.0/255.0, blue: 155.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 140.0/255.0, green: 90.0/255.0, blue: 31.0/255.0, alpha: 1.0) )

                     showCircularProgressViews(image: "protein", someViews: self.myNutritionDetailsView.myNutritionProteinsView, value: (proteinVal/Double(100)).round(to:2), progressColor: UIColor.init(red: 163.0/255.0, green: 189.0/255.0, blue: 234.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 16.0/255.0, green: 54.0/255.0, blue: 123.0/255.0, alpha: 1.0))
        if (self.caloriesArray.count == 0 || self.carbsArray.count == 0 || self.proteinArray.count == 0 ||
        self.fatssArray.count == 0) {
        //TweakAndEatUtils.AlertView.showAlert(view: self, message: "No Trends found! Start Tweaking now to see your own Nutritional Trend here. Make the Trend your friend! ")

        }
    }
    
    func showMyNutritionDetails() {
        if (self.myNutritionDetailsView == nil) {
        self.myNutritionDetailsView = (Bundle.main.loadNibNamed("MyNutritionView", owner: self, options: nil)! as NSArray).firstObject as? MyNutritionView;
        self.myNutritionDetailsView.frame = CGRect(x: 0, y: self.outerChartView.frame.minY, width: self.view.frame.width, height: self.chartView.frame.maxY)
        self.myNutritionDetailsView.delegate = self
        self.myNutritionViewSelectYourMealTableView.backgroundColor = UIColor.groupTableViewBackground
        self.myNutritionViewLast10TweaksTableView.backgroundColor = UIColor.groupTableViewBackground
       self.myNutritionDetailsView.last10TweaksLbl.text = self.nutritionViewLast10TweaksDataVal
              self.myNutritionDetailsView.selectYourMealLbl.text = self.nutritionViewSelectedMeal
        self.view.addSubview(self.myNutritionDetailsView)
            self.myNutritionDetailsView.updateSwitchUI(bool: false)
       
             if IS_iPHONE5 || IS_IPHONE4 {
                self.myNutritionDetailsView.viewHghtConstraint.constant = 70
                        self.myNutritionDetailsView.viewWdthConstraint.constant = 70
                    } else if IS_iPHONE678 {
                        self.myNutritionDetailsView.viewHghtConstraint.constant = 84
                        self.myNutritionDetailsView.viewWdthConstraint.constant = 84
                    } else if IS_iPHONE678P {
                        self.myNutritionDetailsView.viewHghtConstraint.constant = 93.67
                        self.myNutritionDetailsView.viewWdthConstraint.constant = 93.67
                    } else if IS_iPHONEXRXSMAX {
                        self.myNutritionDetailsView.viewHghtConstraint.constant = 93.5
                        self.myNutritionDetailsView.viewWdthConstraint.constant = 93.5
                      } else if IS_iPHONEXXS {
                        self.myNutritionDetailsView.viewHghtConstraint.constant = 83.67
                        self.myNutritionDetailsView.viewWdthConstraint.constant = 83.67
                    }
                    self.myNutritionDetailsView.layoutIfNeeded()
                    self.myNutritionDetailsView.myNutritionCarbsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
                    self.myNutritionDetailsView.myNutritionFatsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
                    self.myNutritionDetailsView.myNutritionProteinsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
              //v2.frame = v1.frame
       self.showCircularProgressViews()
        } else {
            self.showCircularProgressViews()
        }
    }
    
    func showCircularProgressViews(image: String, someViews: CircularProgressView, value: Double, progressColor: UIColor, trackColor: UIColor) {
             let image = UIImage(named: image)
                    let imageView = UIImageView(image: image!)
                    imageView.frame = CGRect(x: 0, y: 0, width: someViews.frame.size.width, height: someViews.frame.size.width)
                    someViews.addSubview(imageView)
             someViews.progressClr = progressColor
             someViews.trackClr = trackColor
                    someViews.createCircularPath()
        someViews.progressAnimation(duration: 1.5,val: value)
         }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "GET_TREND_CALORIES") != nil {
                   let calArray = UserDefaults.standard.value(forKey: "GET_TREND_CALORIES")
            self.nutritionViewSelectedMeal = "Select your meal"
            self.nutritionViewLast10TweaksDataVal = "Last 10 Tweaks"
          self.mealType = 0
            self.mealTypeLabel.text = "All"
            self.dataBtnName = "lastTenData"
            self.trends = "Calories"
             nutritionViewSelectedMeal = "Select your meal"
                nutritionViewLast10TweaksDataVal = "Last 10 Tweaks"
            DispatchQueue.main.async {
                      self.caloriesButton.alpha = 1.0
                      self.carbsButton.alpha = 1.0
                      self.fatButton.alpha = 1.0
                      self.protienButton.alpha = 1.0
                      self.fatButton.backgroundColor = UIColor.clear
                      self.protienButton.backgroundColor = UIColor.clear
                      self.carbsButton.backgroundColor = UIColor.clear
                      self.caloriesButton.backgroundColor = UIColor.clear
                  }
                 
                      self.trends = "Calories"
                      DispatchQueue.main.async {

                      self.myTrendsLabel.text = "MY CALORIE TRENDS"
                          self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
                      }
            self.setDefaultDataBtns(name: "lastTenData")
            
                //   self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: calArray as! [Any], name: "Calories", colorTheme: ["#528039"])
               } else {
                   
               }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.loadingView.backgroundColor = UIColor.white
               self.loadingView.isHidden = true
               self.outerChartView.addSubview(self.loadingView)
        self.dataBtnArray = ["Last 10 Tweaks", "Today", "Week", "Month"]
        self.dataBtnDict = ["Last 10 Tweaks": "lastTenData", "Today": "todaysData", "Week": "weeksData", "Month": "monthsData"]
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewLast10TweaksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
       self.switchButton = SwitchWithText(frame: CGRect(x: self.view.frame.width - 100, y: 2.5, width: 90, height: 30))
        self.mealTypeView.addSubview(switchButton)
        NotificationCenter.default.addObserver(self, selector: #selector(MyTweakAndEatVCViewController.swapViews(_:)), name: NSNotification.Name(rawValue: "SWAP_VIEW_IN_MYTAE"), object: nil);
        
        self.minCalCountLabel.text = ""

        self.mealTypeTableView.delegate = self
        self.mealTypeTableView.dataSource = self;
        self.minCalCountLabel.layer.cornerRadius = 10.0
        self.minCalCountLabel.clipsToBounds = true
        self.last10TweaksLbl.textAlignment = .center
        self.last10TweaksLbl.isHidden = true
        self.selectYourMealTypeView.layer.cornerRadius = 6
        self.mealTypeView.backgroundColor = UIColor.black.withAlphaComponent(0.3); self.selectYourMealTypeView.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        self.last10TweaksBtn.layer.cornerRadius = 10
        self.last10TweaksBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        self.unsubscribeBtn.layer.cornerRadius = 10;
        self.cancelBtn.layer.cornerRadius = 10;
        self.yesBtn.layer.cornerRadius = 10;
        self.noBtn.layer.cornerRadius = 10;
        self.noNutritionAnalyticsView.isHidden = true;
        self.outerView.isHidden = true;
        self.chartView.addSubview(aaChartView)
        setDefaultsTrendBtns()
        getTrends()
        
        self.updateChart(backGroundCol: "#168c7a", data:  [] as [Any], name: "Calories", colorTheme: ["#FFFFFF"])
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self);
        unsubIndiaPkgBtn.layer.cornerRadius = 10;
        let nickName = self.myProfileInfo?.first?.name as AnyObject as! String
        self.nickNameLabel.text = "Welcome" + " "  + nickName
        bundle = Bundle.init(path: path!)! as Bundle;
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        //self.countryCode = "1"
        if self.countryCode == "91" {
            self.immunityBoosterView.isHidden = false
        } else {
          self.immunityBoosterView.isHidden = true
        }
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }
        if countryCode == "1" {
            self.unsubScribePlan = TweakAndEatURLConstants.UNSUBSCRIBE_USA
            tipImage.image = UIImage.init(named: "tip_of_the_day")
            self.title = "My Tweak & Eat"
            self.myAiDPLbl.text = "My Diet Plan"
            self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
        } else if countryCode == "60" ||  countryCode == "62" {
            self.unsubScribePlan = TweakAndEatURLConstants.UNSUBSCRIBE_MYS
            tipImage.image = UIImage.init(named: "tip_of_the_day4")
            if self.packageID == "-MysRamadanwgtLoss99" {
                self.title = "Ramadan Weight Loss"
            } else {
            self.title = "My AiDP"
            }
            self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
            
            self.myAiDPLbl.text = "My Diet Plan"
        } else if countryCode == "91" {
           //mytaeunsubind
            self.unsubScribePlan = TweakAndEatURLConstants.UNSUBSCRIBE_IND
            if self.packageID == "-AiDPwdvop1HU7fj8vfL" {
                tipImage.image = UIImage.init(named: "tip_of_the_day4")
                self.title = "My AiDP"
                self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
               // self.myAiDPBtn.setImage(UIImage(named: "my_diet_plan_icon"), for: .normal)
                
                self.myAiDPLbl.text = "My Diet Plan"//IndWLIntusoe3uelxER
            } else if packageID == "-IndIWj1mSzQ1GDlBpUt" {
                tipImage.image = UIImage.init(named: "tip_of_the_day")
                self.title = "My Tweak & Eat"
                self.myAiDPLbl.text = "My Diet Plan"
                self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
               // self.myAiDPBtn.setImage(UIImage(named: "my_diet_plan_icon"), for: .normal)
            } else if packageID == "-IndWLIntusoe3uelxER" {
                           tipImage.image = UIImage.init(named: "tip_of_the_day")
                           self.title = "Weight Loss with Intermittent Fasting"
                           self.myAiDPLbl.text = "My Diet Plan"
                           self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
                          // self.myAiDPBtn.setImage(UIImage(named: "my_diet_plan_icon"), for: .normal)
                       }
        }
        if self.packageID == self.ptpPackage {
            tipImage.image = UIImage.init(named: "tip_of_the_day4")
            self.title = "My AiBP"
            self.dietPlanImageView.image = UIImage(named: "my_diet_plan_icon")
            // self.myAiDPBtn.setImage(UIImage(named: "my_diet_plan_icon"), for: .normal)
            
            self.myAiDPLbl.text = "My Diet Plan"
        }
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "AR" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
                
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
            
        }
        
        tweakPlateAlertLbl.text = self.bundle.localizedString(forKey: "tweak_plate_alert", value: nil, table: nil)

        self.outerView.layer.cornerRadius = 5
        self.outerView.layer.borderWidth = 2;
        self.outerView.layer.borderColor = UIColor.lightGray.cgColor;
        self.tipsView.layer.cornerRadius = 5
        self.tipsView.layer.borderWidth = 2;
        self.tipsView.layer.borderColor = UIColor.lightGray.cgColor;
        self.myNutritionView.layer.cornerRadius = 15
       
        self.myChatView.layer.cornerRadius = 15
        self.immunityBoosterView.layer.cornerRadius = 15
      
        self.myAiDPView.layer.cornerRadius = 15
        DispatchQueue.main.async {
            self.caloriesButton.alpha = 1.0
            self.carbsButton.alpha = 1.0
            self.fatButton.alpha = 1.0
            self.protienButton.alpha = 1.0
            self.fatButton.backgroundColor = UIColor.clear
            self.protienButton.backgroundColor = UIColor.clear
            self.carbsButton.backgroundColor = UIColor.clear
        }
        
       // self.getLabelsPerc()
        self.didYouKnowStaticText()
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "backIcon"), for: .normal)
        btn1.frame = CGRect(0, 0, 30, 30)
        btn1.addTarget(self, action: #selector(MyTweakAndEatVCViewController.action), for: .touchUpInside);        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
       // self.showLineChartView(nutritionVal: "calories")
        // Do any additional setup after loading the view.
        
    }
    
    func getDataTrendsArray(dictionary: [String: AnyObject], tweakDictionary: [String: AnyObject]) {
        // let dictionary: [String: AnyObject] = self.loadJson(filename: "sample")!["tweaks"] as! [String : AnyObject]
        var minCalories = 0
        var maxCalories = 0
        var todayCalories = 0
        // let calDictionary: [String: AnyObject] = self.loadJson(filename: "sample")!
        minCalories = tweakDictionary["userMinCalsPerDay"] as AnyObject as! Int
        maxCalories = tweakDictionary["userMaxCalsPerDay"] as AnyObject as! Int
        if dictionary.index(forKey: "lastTenData") != nil {
            let last10DataArray = dictionary["lastTenData"] as AnyObject as! NSArray
            for data in last10DataArray {
                let dataDict = data as! [String: AnyObject]
                self.last10Data.append(LastTenData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.last10Data = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        if dictionary.index(forKey: "todaysData") != nil {
            let todayDataArray = dictionary["todaysData"] as AnyObject as! NSArray
            for data in todayDataArray {
                let dataDict = data as! [String: AnyObject]
                todayCalories += dataDict["total_calories"] as! Int
                self.todayData.append(TodayData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.todayData = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        
        let mean: CGFloat = CGFloat((minCalories + maxCalories) / 2)
        let approxCal = Int(mean) - todayCalories
        self.minCalCountLabel.text = "\(approxCal <= 0 ? 0: approxCal)";
        if dictionary.index(forKey: "weeksData") != nil {
            let weeksDataArray = dictionary["weeksData"] as AnyObject as! NSArray
            for data in weeksDataArray {
                let dataDict = data as! [String: AnyObject]
                self.weekData.append(WeekData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.weekData = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        if dictionary.index(forKey: "monthsData") != nil {
            
            let monthDataArray = dictionary["monthsData"] as AnyObject as! NSArray
            for data in monthDataArray {
                let dataDict = data as! [String: AnyObject]
                self.monthData.append(MonthData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
            }
            self.monthData = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.unsubscribePlanView.isHidden = true;
    }
    
    @IBAction func unsubscribeTapped(_ sender: Any) {
        self.finalnsubView.isHidden = false;
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        //        print(Int(x))
        //        print(self.tweaksArray.count)
        //        if (Int(x) == self.tweaksArray.count || Int(x) < 0) {
        //            return
        //        }
    }
    
    @IBAction func noBtnTapped(_ sender: Any) {
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        //        let myTweakandEatViewController : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        //        self.navigationController?.pushViewController(myTweakandEatViewController, animated: true);
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBAction func yesBtnTapped(_ sender: Any) {
        
        //api call
        getFirebaseData()
    }
    
    @objc func action() {
        if self.fromWhichVC == "MoreInfoPremiumPackagesViewController" || self.fromWhichVC == "MyTweakAndEatVCViewController" || self.fromWhichVC == "CaloriesLeftForTheDayController" {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
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

                    self.noNutritionAnalyticsView.isHidden = false

                    return;
                } else {
                    self.outerView.isHidden = false
                }
                
                for dict in self.tweaksArray {
                    let tweaksDict = dict as! [String: AnyObject]
                   
                    self.caloriesArray.add(CGFloat(tweaksDict["total_calories"] as! Int));
                    
                    self.calories += tweaksDict["total_calories"] as! Int
                }
                
                self.showLineChartView(nutritionVal: "calories")
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
            MBProgressHUD.hide(for: self.view, animated: true);
            if error?.code == -1011 {
              
                self.noNutritionAnalyticsView.isHidden = false
                return

            }
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let items = [URL(string: "https://itunes.apple.com/in/app/tweak-eat/id1267286348?mt=8")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)

    }
   
    @objc func didYouKnowStaticText(){
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getRequest(TweakAndEatURLConstants.DAILYTIPS, sessionString: userSession, success:
            { (responseDic : AnyObject!) -> (Void) in
                
                if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responseDic as! [String:AnyObject];
                    let reminders : [String:AnyObject]? = response["tweaks"]  as? [String:AnyObject];
                    print(reminders!);
                   
                    self.tipsTextView.text = reminders?["pkg_evt_message"] as? String;

                }
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
        }
    }
    
    @objc func getXLabels(lbls: Int) -> [String] {
        
        for i in 1...lbls {
            xLabelsArray.append("\(i)");
        }
        return xLabelsArray;
    }
    
   func getFirebaseData() {
     MBProgressHUD.showAdded(to: self.view, animated: true);
    Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
    // this runs on the background queue
    // here the query starts to add new 10 rows of data to arrays
    self.nutritionLabelPackagesArray = NSMutableArray();
    
    if snapshot.childrenCount > 0 {
    
    let dispatch_group = DispatchGroup();
    dispatch_group.enter();
    
    for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
    
    if premiumPackages.key == self.packageID  {
    let packageObj = premiumPackages.value as? [String : AnyObject];
    if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
        if packageObj?["systemFlag"] as! Bool == false {
            self.system = 0;
            
        } else {
            self.system = 1;
        }
        if self.alreadyUnsubscribed == false {
            self.unsubscribeApiForUSA()
        }
    } else {
    TweakAndEatUtils.AlertView.showAlert(view: self, message: "There is no package available. Please try again later!!");
    }
    }
    }
    dispatch_group.leave();
    dispatch_group.notify(queue: DispatchQueue.main) {
    
   
    MBProgressHUD.hide(for: self.view, animated: true);
    }
    
    } else {
    MBProgressHUD.hide(for: self.view, animated: true);
    
    }
    })
    }
    
    func unsubscribeApiForUSA() {
       // MBProgressHUD.showAdded(to: self.view, animated: true)
        var paramsDictionary = [String: AnyObject]()
        if self.packageID == "-AiDPwdvop1HU7fj8vfL" || self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
            paramsDictionary = ["packageId": self.packageID] as [String : AnyObject]
            self.callStatus = "CallStatus"
        } else {
            paramsDictionary = ["system": self.system] as [String : AnyObject]
        }
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(self.unsubScribePlan, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response!)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic[self.callStatus] as! String;
            if  responseResult == "GOOD" {
                self.alreadyUnsubscribed = true
                MBProgressHUD.hide(for: self.view, animated: true)
                var msg = ""
                if self.packageID == "-AiDPwdvop1HU7fj8vfL" {
                     msg = "You have successfully unsubscribed from \"My AiDP\" Service";
                } else {
                 msg = "You have successfully unsubscribed from \"My Tweak & Eat\" Service";
                }
                
                let alertController = UIAlertController(title:"", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            if error?.code == -1011 {
                let msg = "Sorry your unsubscription was not processed successfully.If this continue please email to appsmanager@purpleteal.com with your phone number";

                let alertController = UIAlertController(title:"", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            
            
                return
            }
            print("failure")
//            let msg = "Sorry your unsubscription was not processed successfully.Please email to appsmanager@purpleteal.com with your phone number";
             let msg = "Your internet connection appears to be offline.";
            
            let alertController = UIAlertController(title:"", message: msg, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        })
    
    }
    
    @IBAction func myNutritionAct(_ sender: Any) {
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.mealTypeTableView.isHidden = true
        self.performSegue(withIdentifier: "nutritionAnalytics", sender: self)
    }

    @IBAction func myChatAct(_ sender: Any) {
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.mealTypeTableView.isHidden = true
         self.performSegue(withIdentifier: "chat", sender: self)
    }
    
    @IBAction func myAiDPAct(_ sender: Any) {
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.mealTypeTableView.isHidden = true
        if self.packageID == "-AiDPwdvop1HU7fj8vfL" || self.packageID == "-MzqlVh6nXsZ2TCdAbOp" || self.countryCode == "1"  || self.packageID == "-MalAXk7gLyR3BNMusfi" || self.countryCode == "60" || self.packageID == "-SgnMyAiDPuD8WVCipga"  || self.packageID == "-IdnMyAiDPoP9DFGkbas" || self.packageID == self.ptpPackage || self.countryCode == "65" || self.countryCode == "62" || self.countryCode == "63"  {
         self.performSegue(withIdentifier: "aidpPurchasePack", sender: self)
        } else if self.packageID == "-IndIWj1mSzQ1GDlBpUt" || self.packageID == "-MysRamadanwgtLoss99" || self.packageID == "-IndWLIntusoe3uelxER" {
            self.performSegue(withIdentifier: "dietPlan", sender: self)

        }
    }
    func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    @IBAction func immunityBoosterTapped(_ sender: Any) {
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.mealTypeTableView.isHidden = true
        self.performSegue(withIdentifier: "goToRecipes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            let destination = segue.destination as! ChatVC;
            destination.fromPackages = true;
            if UserDefaults.standard.value(forKey: "AIDP_EXP_DATE") != nil {
                           let start = Date()
                           let end = UserDefaults.standard.value(forKey: "AIDP_EXP_DATE")
                           let diff = calculateDaysBetweenTwoDates(start: start, end: end as! Date)
                           if diff < 22 {
                            destination.hideBottomMessageBox = true
                            //2020-07-14T05:22:06.000Z
                           }
                       }
            if countryCode == "1" {
                if self.packageID == self.ptpPackage {
                    destination.chatID = self.ptpPackage
                } else if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
                    destination.chatID = "-MzqlVh6nXsZ2TCdAbOp"
                }
            } else if countryCode == "60" {
                if self.packageID == self.ptpPackage {
                    destination.chatID = self.ptpPackage
                } else if self.packageID == "-MalAXk7gLyR3BNMusfi" {
                    destination.chatID = "-MalAXk7gLyR3BNMusfi"
                } else if self.packageID == "-MysRamadanwgtLoss99" {
                   destination.chatID = "-MysRamadanwgtLoss99"
                }
            } else if countryCode == "91" {
                destination.chatID = self.packageID;
            } else if countryCode == "65" {
                if self.packageID == self.ptpPackage {
                    destination.chatID = self.ptpPackage
                } else if self.packageID == "-SgnMyAiDPuD8WVCipga" {
                    destination.chatID = "-SgnMyAiDPuD8WVCipga"
                }
            } else if countryCode == "62" {
                if self.packageID == self.ptpPackage {
                    destination.chatID = self.ptpPackage
                } else if self.packageID == "-IdnMyAiDPoP9DFGkbas" {
                    destination.chatID = "-IdnMyAiDPoP9DFGkbas"
                }
            } else if countryCode == "63" {
                destination.chatID  = self.ptpPackage
                
            }

        } else if segue.identifier == "aidpPurchasePack" {
            let popOverVC = segue.destination as! AiDPViewController;
           // popOverVC.stayHere = false;
          //AIDP_EXP_DATE
           
            if countryCode == "1" {
                if self.packageID == self.ptpPackage {
                    popOverVC.packageId = self.ptpPackage
                } else if self.packageID == "-MzqlVh6nXsZ2TCdAbOp" {
                    popOverVC.packageId = "-MzqlVh6nXsZ2TCdAbOp"
                }
            } else if countryCode == "60" {
                if self.packageID == self.ptpPackage {
                    popOverVC.packageId = self.ptpPackage
                } else if self.packageID == "-MalAXk7gLyR3BNMusfi" {
                    popOverVC.packageId = "-MalAXk7gLyR3BNMusfi"
                }
            } else if countryCode == "65" {
                if self.packageID == self.ptpPackage {
                    popOverVC.packageId = self.ptpPackage
                } else if self.packageID == "-SgnMyAiDPuD8WVCipga" {
                    popOverVC.packageId = "-SgnMyAiDPuD8WVCipga"
                }
            } else if countryCode == "62" {
                if self.packageID == self.ptpPackage {
                popOverVC.packageId = self.ptpPackage
                } else if self.packageID == "-IdnMyAiDPoP9DFGkbas" {
                    popOverVC.packageId = "-IdnMyAiDPoP9DFGkbas"
                }
            } else if countryCode == "63" {
                popOverVC.packageId = self.ptpPackage
               
            }  else if countryCode == "91" {
                if self.packageID == self.ptpPackage {
                    popOverVC.packageId = self.ptpPackage
                } else if self.packageID == "-AiDPwdvop1HU7fj8vfL" {
                    popOverVC.packageId = "-AiDPwdvop1HU7fj8vfL";

                } else if self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                    popOverVC.packageId = "-IndIWj1mSzQ1GDlBpUt";
                    
                } else if self.packageID == "-IndWLIntusoe3uelxER" {
                    popOverVC.packageId = "-IndWLIntusoe3uelxER";
                                   
                }
                
            }
            
            //popOverVC.packageId = self.packageID
            //popOverVC.smallImage = "https://s3.ap-south-1.amazonaws.com/tweakandeatpremiumpacks/aidp_small_org.png";
            
        } else if segue.identifier == "dietPlan" {
           // let cellDict = self.savedPremiumPackagesArray[self.myIndexPath.row] as! [String: AnyObject];
            
            let destination = segue.destination as! DietPlanViewController;
            destination.snapShot = self.packageID
            
        } else if segue.identifier == "goToRecipes" {
              let destination = segue.destination as! TweakRecipeViewController;
            destination.showImmunityBoosterRecipes = true
        }
    }
    
    @objc func showLineChartView(nutritionVal: String) {
        
        lineChartView.clear();
        lineChartView.frame = lineChart.frame;
        
        lineChartView.animation.enabled = true;
        lineChartView.area = false;
        lineChartView.x.labels.visible = true;
        lineChartView.y.labels.visible = true;
        lineChartView.x.grid.visible = false;
        lineChartView.y.grid.visible = false;
        lineChartView.x.grid.count = 4;
        lineChartView.y.grid.count = 5;
        lineChartView.x.labels.values = self.getXLabels(lbls: self.tweaksArray.count);
        
        
        if nutritionVal == "calories" {
            lineChartView.addLine(self.caloriesArray as! [CGFloat]);
            lineChartView.colors = [UIColor.purple];
        }
        
        lineChartView.delegate = self;
        self.lineChart.addSubview(lineChartView);
    }
  
    @IBAction func indUnsubAction(_ sender: Any) {
        self.indUnsubsView.isHidden = true;
        self.finalnsubView.isHidden = false;
    }
    
    @IBAction func unSubOKAct(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true);
    }
    
    func getExactDate(dateString : String, days: Int) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "d MMM yyyy";
        let myDate = dateFormatter.date(from: dateString)!;
        let exactDate = Calendar.current.date(byAdding: .day, value: -days, to: myDate);
        let somedateString = dateFormatter.string(from: exactDate!);
        print("your next Date is \(somedateString)");
        return somedateString;
    }
    
    func getIndiaSubDetails() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.MY_TANDE_PKG_DETAILS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["packageId" : self.packageID] as [String: AnyObject], success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.indUnsubsView.isHidden = false
                let data = responseDic["Data"] as AnyObject as! [String: AnyObject]
                print(data)

                let subHeading1 = "Your Nutritionist info: \n\n"
                let completeNutritionText = subHeading1 + (data["nu_signature"] as! String).html2String
//                let str = subHeading
//                let welcomeAttribute = [NSAttributedString.Key.foregroundColor: UIColor.purple]
//                let welcomeAttrString = NSMutableAttributedString(string: str, attributes: welcomeAttribute)
                
                let textString = completeNutritionText;
                let range = (textString as NSString).range(of: subHeading1);
                let attributedString = NSMutableAttributedString(string: textString);
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range);
                
                self.nutritionDescLabel.attributedText = attributedString;
                let subHeading2 = "Package Info: \n\n"
                let expDateLbl = "Active until ";
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                if (data["mpp_pkg_exp_dttm"] is NSNull) {
                   return
                }
                let expDateStr =  data["mpp_pkg_exp_dttm"] as? String
                //let expDateStr =  "2019-07-24T17:19:43.000Z"
                let expDate = dateFormatter.date(from: expDateStr!);
                dateFormatter.dateFormat = "d MMM yyyy"
                let formattedDate = dateFormatter.string(from: expDate!)
                //let stringFromDate = dateFormatter.date(from: formattedDate)
                let pkgDuration = data["mpp_pkg_duration"] as! Int
                //let pkgDuration = 2
                let completePackageInfo = subHeading2 + expDateLbl + formattedDate

                
                let now = Date()
                //let endDate = now.addingTimeInterval(24 * 3600 * 17)
                let endDate = expDate
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day]
                formatter.unitsStyle = .full
                let days = formatter.string(from: now, to: endDate!)!
                
                print(days) // 2 weeks, 3 days
                let daysArray = days.components(separatedBy: " ")
                let weeksCount = Int(daysArray[0])! / 7
                var remainingSubscription = ""
                var exactDateForUnsub = ""
                if pkgDuration == 2 {
                    exactDateForUnsub = self.getExactDate(dateString: formattedDate, days: 1)
                    remainingSubscription = "You can unsubscribe after \(exactDateForUnsub)"
                } else if pkgDuration == 1 || pkgDuration == 3 {
                    exactDateForUnsub = self.getExactDate(dateString: formattedDate, days: 7)
                    remainingSubscription = "You can unsubscribe after \(exactDateForUnsub)"
                } else if pkgDuration == 6 {
                    exactDateForUnsub = self.getExactDate(dateString: formattedDate, days: 14)
                    remainingSubscription = "You can unsubscribe after \(exactDateForUnsub)"
                } else if pkgDuration == 12 {
                    exactDateForUnsub = self.getExactDate(dateString: formattedDate, days: 38)
                    remainingSubscription = "You can unsubscribe after \(exactDateForUnsub)"
                }
                self.unsubScribeText(remainingSubscription: remainingSubscription, subHeading2: subHeading2, completePackageInfo: completePackageInfo, isUnSubscribeBtn: true)
                if pkgDuration == 2 {
//                    let currentDate = Date();
//                    if expDate! < currentDate {
//
//                    }
                    remainingSubscription = ""
                    self.unsubScribeText(remainingSubscription: remainingSubscription, subHeading2: subHeading2, completePackageInfo: completePackageInfo, isUnSubscribeBtn: false)
                    
//                    let textString = completePackageInfo + "\n" + "\n" + remainingSubscription
//                    let range = (textString as NSString).range(of: subHeading2)
//                    let attributedString = NSMutableAttributedString(string: textString)
//
//                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)
//
//                    self.expiryDateLabel.attributedText = attributedString;
//                    self.unsubIndiaPkgBtn.isHidden = true
                } else if pkgDuration == 1 || pkgDuration == 3 {
                    if weeksCount <= 1 {
                        remainingSubscription = ""
                        self.unsubScribeText(remainingSubscription: remainingSubscription, subHeading2: subHeading2, completePackageInfo: completePackageInfo, isUnSubscribeBtn: false)

                    }
                } else if pkgDuration == 6 {
                    if weeksCount <= 2 {
                        remainingSubscription = ""
                        self.unsubScribeText(remainingSubscription: remainingSubscription, subHeading2: subHeading2, completePackageInfo: completePackageInfo, isUnSubscribeBtn: false)
                    }
                    
                } else if pkgDuration == 12 {
                    if weeksCount <= 4 {
                        remainingSubscription = ""
                        self.unsubScribeText(remainingSubscription: remainingSubscription, subHeading2: subHeading2, completePackageInfo: completePackageInfo, isUnSubscribeBtn: false)
                        
                    }
                }
            }
        }, failure: { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline");
            
        })
    }
    
    func unsubScribeText(remainingSubscription: String, subHeading2: String, completePackageInfo: String, isUnSubscribeBtn: Bool) {
        let textString = completePackageInfo + "\n" + remainingSubscription
        let range = (textString as NSString).range(of: subHeading2)
        let attributedString = NSMutableAttributedString(string: textString)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)
        
        self.expiryDateLabel.attributedText = attributedString;
        self.unsubIndiaPkgBtn.isHidden = isUnSubscribeBtn
        self.okIndiaUnSubBtn.isHidden = true

    }
    
    @IBAction func helpIconTapped(_ sender: Any) {
        
            if self.packageID == "-AiDPwdvop1HU7fj8vfL" || self.packageID == "-IndIWj1mSzQ1GDlBpUt" {
                if self.indUnsubsView.isHidden == true {
                    self.getIndiaSubDetails()
                } else {
 
                }
                
            } else {
                if self.unsubscribePlanView.isHidden == true {
                    self.unsubscribePlanView.isHidden = false
                } else {
            }
        }
    }
}


