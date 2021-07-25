//
//  TimelinesViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase
import FirebaseDatabase
import RealmSwift
import FirebaseAnalytics
import CoreLocation
import MobileCoreServices
import AVKit
import AVFoundation
import CleverTapSDK



class TimelinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource, TapOnAdsDelegate,LineChartDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchResultsUpdating, MYEDRDelegate {
    
    func getMealTypes() {
        APIWrapper.sharedInstance.getMealTypes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    self.mealTypeArray = (response["data"] as AnyObject as! NSArray) as! [[String : AnyObject]]
                    
                    print(self.mealTypeArray)
                    self.mealTypeTableView.delegate = self
                    self.mealTypeTableView.dataSource = self
                    self.mealTypeTableView.reloadData()
                    MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
//                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
//                                   animations: {
//
//                                    self.mealTypeTableView.isHidden = false
//                                    self.mealTypeTableViewHeightConstraint.constant = 250
//                                    self.view.layoutIfNeeded()
//                    },  completion: {(_ completed: Bool) -> Void in
//                    })
                    self.mealTypeView.isHidden = false

                    }
                
            }else {
                //error
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
                }
                print("error")
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
            }
            
            print("error")
            
        }
    }
    
//    func showMenu() {
//        let actionSheetAlertController: UIAlertController = UIAlertController(title: "Please select your meal type", message: nil, preferredStyle: .actionSheet)
//
//        for meal in self.mealTypeArray {
//            let menu = meal["name"] as! String
//             let action = UIAlertAction(title: menu, style: .default) { (action) in
//                self.mealTypeValue = meal["value"] as! Int
//                DispatchQueue.main.async {
//                    self.mealTypeLabel.text = "  " + menu
//
//                }
//             }
//
//
//
//             actionSheetAlertController.addAction(action)
//           }
//
////           let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
////           actionSheetAlertController.addAction(cancelActionButton)
//
//           self.present(actionSheetAlertController, animated: true, completion: nil)
//    }
    
    func copyMeal(_ cell: MYEDRCell) {
        
        getMealTypes()
        var tweak = TBL_Tweaks()
        if self.filteredTweaksList != nil {
        if self.filteredTweaksList!.count > 0 {
            tweak = self.filteredTweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        if self.tweaksList != nil {
        if self.tweaksList!.count > 0 {
            tweak = self.tweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        self.copyThisMealParams["tweakId"] = tweak.tweakId as AnyObject
        self.copyThisMealParams["mealType"] = tweak.mealType as AnyObject
       
        
    }
    
    func rateThisMeal(_ cell: MYEDRCell) {
        searchController.isActive = false

        self.starRatingView.isHidden = false
        //self.fiveStarView.value = CGFloat(1)
        var tweak = TBL_Tweaks()
        if self.filteredTweaksList != nil {
        if self.filteredTweaksList!.count > 0 {
            tweak = self.filteredTweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        if self.tweaksList != nil {
        if self.tweaksList!.count > 0 {
            tweak = self.tweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        self.fiveStarView.value = CGFloat(tweak.tweakRating);
        ratingParams["tid"] = "\(tweak.tweakId)"
        selectedRow = cell.myIndex

        
    }
    
    func askAQuestion(_ cell: MYEDRCell) {
        if UserDefaults.standard.value(forKey: "ASK_A_QUESTION") == nil {
        UserDefaults.standard.set("YES", forKey: "ASK_A_QUESTION")
            UserDefaults.standard.synchronize()
        if UserDefaults.standard.value(forKey: "COUNTRY_ISO") != nil {
            let eventName = TweakAndEatUtils.getEventNames(countryISO: UserDefaults.standard.value(forKey: "COUNTRY_ISO") as AnyObject as! String, eventName: "ask_a_question")
            print(eventName)
            Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "Ask a question"])
        }
        }
        //ChatVC
        var tweak = TBL_Tweaks()
        if self.filteredTweaksList != nil {
        if self.filteredTweaksList!.count > 0 {
            tweak = self.filteredTweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        if self.tweaksList != nil {
        if self.tweaksList!.count > 0 {
            tweak = self.tweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatVC;
        clickViewController?.tweakID = String(tweak.tweakId)
        if tweak.tweakModifiedImageURL == "" {
            clickViewController?.imageUrl =  tweak.tweakOriginalImageURL! as String;
        }
        else{
            clickViewController?.imageUrl =  tweak.tweakModifiedImageURL! as String;
        }
     self.navigationController?.pushViewController(clickViewController!, animated: true)
        
    }
    
    func shareToTweakWall(_ cell: MYEDRCell) {
        searchController.isActive = false

        var tweak = TBL_Tweaks()
        if self.filteredTweaksList != nil {
        if self.filteredTweaksList!.count > 0 {
            tweak = self.filteredTweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        if self.tweaksList != nil {
        if self.tweaksList!.count > 0 {
            tweak = self.tweaksList![cell.myIndex] as! TBL_Tweaks;
        }
        }
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate);
        let currentTime = Int64(currentTimeStamp);
        var imageUrl = ""
        if tweak.tweakModifiedImageURL == "" {
            imageUrl =  tweak.tweakOriginalImageURL! as String;
        }
        else{
            imageUrl =  tweak.tweakModifiedImageURL! as String;
        }
        if tweak.tweakUserComments != "" {
            self.tweakFeedsRef.child("TweakFeeds").childByAutoId().setValue(["feedContent": tweak.tweakUserComments!, "imageUrl": imageUrl, "gender": self.sex, "postedOn" : currentTime! , "tweakOwner": self.nicKName, "msisdn" : UserDefaults.standard.value(forKey: "msisdn") as! String, "awesomeCount" : 0, "commentsCount" : 0] as [String : AnyObject], withCompletionBlock: { (error, _) in
            if error == nil {
                //api
              //  self.showAlertSuccess()
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your Tweak has been Shared to Tweak Wall Sucessfully!")

            } else {
            }
                })

            
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let fullImageView : FullImageViewController = storyBoard.instantiateViewController(withIdentifier: "fullImageView") as! FullImageViewController;
            fullImageView.shareAction = false

        fullImageView.tweakUserComments = tweak.tweakUserComments ?? ""
        fullImageView.fullImage = cell.profileImageView.image;
        if tweak.tweakModifiedImageURL == "" {
            fullImageView.imageUrl =  tweak.tweakOriginalImageURL! as String;
        }
        else{
            fullImageView.imageUrl =  tweak.tweakModifiedImageURL! as String;
        }
       // fullImageView.imageUrl = tweak.tweakModifiedImageURL;

     
        
        self.navigationController?.present(fullImageView, animated: true, completion: nil);
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000);
        let strTimeStamp: String = "\(milliseconds)";
        return strTimeStamp;
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            return
        }
        if self.filterbyVal != "All" {
            tweaksList = nil


            let tempArr = globalFilteredTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)})

            filteredTweaksList = tempArr
            self.timelinesTableView.reloadData()

        } else {
            filteredTweaksList?.removeAll(keepingCapacity: false)
            let tempArr = globalTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)})

            tweaksList = tempArr
            self.timelinesTableView.reloadData()
        }

    }
    
    
    func getFilteredTweaks(filterBy: String) {
        filterbyVal = filterBy
        tweaksList = nil
        if filterBy == "Today" {
            if searchController.isActive {
                
                filteredTweaksList?.removeAll(keepingCapacity: false)
                let tempArr = globalTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)}).filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(Date().dateStringWithFormat(format: "d MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            } else {
                let tempArr = globalTweaksList?.filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(Date().dateStringWithFormat(format: "d MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            }

        } else if filterBy == "Yesterday" {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())

            if searchController.isActive {
                filteredTweaksList?.removeAll(keepingCapacity: false)
                let tempArr = globalTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)}).filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(yesterday!.dateStringWithFormat(format: "d MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            } else {

                let tempArr = globalTweaksList?.filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(yesterday!.dateStringWithFormat(format: "d MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            }
        } else if filterBy == "Last Week" {
            let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())

            if searchController.isActive {
                filteredTweaksList?.removeAll(keepingCapacity: false)
                let tempArr = globalTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)}).filter({TweakAndEatUtils.localTimeFromTZ(date: $0.tweakDateCreated!) > lastWeek!})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            } else {

                let tempArr = globalTweaksList?.filter({TweakAndEatUtils.localTimeFromTZ(date: $0.tweakDateCreated!) > lastWeek!})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            }
        } else if filterBy == "Last Month" {
            let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())

            if searchController.isActive {
                filteredTweaksList?.removeAll(keepingCapacity: false)
                let tempArr = globalTweaksList?.filter({$0.tweakUserComments.localizedCaseInsensitiveContains(searchController.searchBar.text!)}).filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(lastMonth!.dateStringWithFormat(format: "d MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            } else {

                let tempArr = globalTweaksList?.filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(lastMonth!.dateStringWithFormat(format: "MMM yyyy"))})

                filteredTweaksList = tempArr
                self.timelinesTableView.reloadData()
            }
        } else if filterBy == "The very beginning" {
            filteredTweaksList = globalTweaksList
            self.timelinesTableView.reloadData()
            let ind = IndexPath(row: self.globalTweaksList!.count - 1, section: 0)
            self.timelinesTableView.layoutIfNeeded()
            self.timelinesTableView.scrollToRow(at: ind, at: .bottom, animated: true)
        } else if filterbyVal == "All" {
            filteredTweaksList?.removeAll(keepingCapacity: false)
            

            filteredTweaksList = globalTweaksList
            self.timelinesTableView.reloadData()
        } else if filterbyVal == "Jump to a specific date" {
            self.datePickerView.isHidden = false
            
        }
        
        if searchController.isActive {
            return
        }
        if filteredTweaksList != nil {
            if filteredTweaksList!.count > 0 {
                self.globalFilteredTweaksList = filteredTweaksList
            } else {
                
            }
        }
        if filterbyVal != "Jump to a specific date" {
            if filteredTweaksList != nil {
                if filteredTweaksList!.count > 0 {
                    self.noEdrPopView.isHidden = true
                } else {
                    self.noEdrPopView.isHidden = false
                    self.noEdrLabel.text = "You don't have tweaks for \(filterBy)!"
                }
            } else {
                if tweaksList != nil {
            if tweaksList!.count > 0 {
                self.noEdrPopView.isHidden = true
            } else {
                self.noEdrPopView.isHidden = false
                self.noEdrLabel.text = "You don't have tweaks for \(filterBy)!"
            }
                }
        }
        }
    }
    
    
    @IBOutlet weak var noEdrPopView: UIView!
    @IBOutlet weak var noEdrLabel: UILabel!
  
    
    var sectionsForGamifyArray = [[String: AnyObject]]()
    var filterbyVal = "All"
    @IBOutlet weak var mealTypeView: UIView!
    var searchController: UISearchController!
    @objc let lineChartView = LineChart()
    @objc var dateFormatter = DateFormatter();
    @objc var nutritionValuesArray = NSMutableArray();
    @objc var itemsArray = NSMutableArray();
    @objc var labelImage : String = "";
    @objc var showColorForItem = 0;
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var countryCode = "";
    var floatingBtn = UIButton(type: .custom)
    @IBOutlet weak var legendView: UIView!
    @IBOutlet weak var dateLbl: UILabel!;
    @IBOutlet weak var tweakImgView: UIImageView!;
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var filterTweaksOptionsArray = ["All","Today", "Yesterday", "Last Week", "Last Month", "The very beginning", "Jump to a specific date"]
    var timeZoneAbbreviations: [String:String] { return TimeZone.abbreviationDictionary }
    @IBOutlet weak var starRatingView: UIView!
    var pickerDate = ""
    @IBOutlet weak var innerStarRatingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!;
    @IBOutlet weak var fiveStarView: HCSStarRatingView!
    @IBOutlet weak var chartView: UIView!;
    @IBOutlet weak var outerLineView: UIView!;
    @IBOutlet weak var nutritionLabelsCollectionView: UICollectionView!
    @IBOutlet weak var noReportsLabel: UILabel!;
    @IBOutlet weak var reportsTableView: UITableView!;
    @IBOutlet weak var nutritionAnalyticsView: UIView!;
    @IBOutlet weak var mealTypeTableView: UITableView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedIndex = 0
    var selectedRow = 0
    @objc let rc = UIRefreshControl();
    let realm :Realm = try! Realm();
    var myProfile : Results<MyProfileInfo>?;
    @objc var date : String!;
    @objc var nicKName : String = "";
    @objc var sex : String = "";
    @objc var age = "";
    @objc var gender = "";
    @objc var weight = "";
    @objc var height = "";
    @objc var longitude = "0";
    @objc var latitude = "0";
    @objc var adId: Int = 0;
    @objc var adType = "2";
    @objc var fromScreen = "";
    @objc let locationManager = CLLocationManager();
    @objc var fromGotIt = false
    @objc var userID = UserDefaults.standard.value(forKey: "msisdn") as! String + "@taefb.com";
    @objc var deviceInfo = UIDevice.current.modelName;
    var ptpPackage = ""
    @IBOutlet weak var pieChartView: PieChart!;
    @IBOutlet weak var reportsInfoBtn: UIBarButtonItem!;
    @objc var whichPieChart: String = "";
    @objc var myIndex: Int = 0;
    @objc var userReportsRef : DatabaseReference!;
    @objc var tweak : NSDictionary!;
    @IBOutlet weak var lineChart: UIView!;
    @IBOutlet weak var timelinesTableView: UITableView!;
    @objc var timeLineCell : TimelineTableViewCell! = nil;
    @objc var timeLineCellAd : TimelineTableViewCellWithAd! = nil;
    var copyThisMealParams = [String: AnyObject]()
    @objc var tweaksList : [AnyObject]?;
    @objc var globalTweaksList : [AnyObject]?;
    @objc var filteredTweaksList : [AnyObject]?;
    @objc var globalFilteredTweaksList : [AnyObject]?;
    @objc var comingFromSettings : Bool = false;
    
    @objc var tableArray = [[String:AnyObject]]();
    @objc var tableArray1 = [[String:String]]();
    @objc var tableArray2 = [[String:String]]();
    @objc var tableArray3 = [[String:String]]();
    var clubPackageSubscribed = ""
    @objc var carbs = 0;
    @objc var fiber = 0;
    @objc var fats = 0;
    @objc var others = 0;
    @objc var protein = 0;
    @objc var calories = 0;
    @objc var tableArrayVal1 = [String]();
    @objc var tableArrayVal2 = [String]();
    @objc var tableArrayVal3 = [String]();
    @objc var tableArrayKey1 = [String]();
    @objc var tableArrayKey2 = [String]();
    @objc var tableArrayKey3 = [String]();
    var mealTypeArray = [[String: AnyObject]]();
    @objc var proteinArray = NSMutableArray();
    @objc var fatsArray = NSMutableArray();
    @objc var carbsArray = NSMutableArray();
    @objc var caloriesArray = NSMutableArray();
    @objc var tweakImagesArray = NSMutableArray();
    @objc var dateTimeArray = NSMutableArray();
    @objc var datesArray = [String]();
    @objc let dateFormat = DateFormatter();
    @objc var nutritionAnalyticsBtnTapped = false;
    @objc var tweaksArray = NSArray();
    @objc var tweaksLabelsArray = NSMutableArray();
    @IBOutlet weak var reportsInfoView: UIView!;
    @IBOutlet weak var filterTweaksView: UIView!;
    @IBOutlet weak var filterByLabel: UILabel!;
    var ratingParams = [String : String]()
    @IBOutlet weak var totalNutritionLbl: UILabel!
    @IBOutlet weak var prevAdviseLabel: UILabel!;
    @IBOutlet weak var nextAdviseLabel: UILabel!;
    var topBannersDict = [String: AnyObject]()
    var topBannerImageLink = ""
    var topBannerImage = ""
    @objc var tweakFeedsRef : DatabaseReference!;
    @IBOutlet weak var lineChartWidthConstraint: NSLayoutConstraint!
    @objc var xLabelsArray = [String]();
    
    @objc func getXLabels(lbls: Int) -> [String] {
        
        for i in 1...lbls {
            xLabelsArray.append("\(i)");
        }
        return xLabelsArray;
    }
    
    @IBAction func fiveStarsView(_ sender: Any) {
        let ratingNumber = sender as! HCSStarRatingView;
        ratingParams["rate"] = "\(ratingNumber.value)"
    }
    
    @IBAction func filterTweaksTapped(_ sender: Any) {
        searchController.searchBar.endEditing(true)
        searchController.searchBar.text = ""
        searchController.isActive = false
        showMenu()
    }
    
    func showMenu() {
        let actionSheetAlertController: UIAlertController = UIAlertController(title: "Jump to..", message: nil, preferredStyle: .actionSheet)

        for option in self.filterTweaksOptionsArray {
            
             let action = UIAlertAction(title: option, style: .default) { (action) in
                //if option == "Today" {
                    DispatchQueue.main.async {
                    self.filterByLabel.text = option
                    }
                    self.getFilteredTweaks(filterBy: option)
               // }
               
             }

             

             actionSheetAlertController.addAction(action)
           }

//           let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//           actionSheetAlertController.addAction(cancelActionButton)

           self.present(actionSheetAlertController, animated: true, completion: nil)
    }
    @IBAction func datePickerCancelTapped(_ sender: Any) {
        self.datePickerView.isHidden = true
        self.getFilteredTweaks(filterBy: filterbyVal)
    }
    
    @IBAction func datepickerDoneTapped(_ sender: Any) {
        self.datePickerView.isHidden = true
        let tempArr = globalTweaksList?.filter({TweakAndEatUtils.localTimeFromTZ(dateString: $0.tweakDateCreated!).contains(self.pickerDate)})

        filteredTweaksList = tempArr
        self.timelinesTableView.reloadData()
        if filteredTweaksList != nil {
            if filteredTweaksList!.count > 0 {
                self.noEdrPopView.isHidden = true
            } else {
                self.noEdrPopView.isHidden = false
                self.noEdrLabel.text = "You don't have tweaks for the selected date!"
            }
        } else {
            if tweaksList != nil {
        if tweaksList!.count > 0 {
            self.noEdrPopView.isHidden = true
        } else {
            self.noEdrPopView.isHidden = false
            self.noEdrLabel.text = "You don't have tweaks for the selected date!"
        }
            }
    }

    }
    @IBAction func datePickerHandler(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        pickerDate = df.string(from: sender.date)
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
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.mealTypeView.isHidden = true
    }
    @IBAction func copyThisMealButtonTapped(_ sender: Any) {
        self.mealTypeView.isHidden = true

        let currentDate = Date()
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        let date = isoFormatter.string(from: currentDate);
        print(date)

        for (key,val) in self.timeZoneAbbreviations {
            let localTimeZone = val
            if localTimeZone == self.localTimeZoneName {
                
                self.copyThisMealParams["userLocalTime"] = date as AnyObject
                self.copyThisMealParams["userLocalTimezone"] = key as AnyObject
               
            }
        }
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.COPY_MEAL, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: self.copyThisMealParams , success: { response in
            print(response)

            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD"  {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.reloadTimelines()
                let ind = IndexPath(row: 0, section: 0)
                self.timelinesTableView.layoutIfNeeded()
                self.timelinesTableView.scrollToRow(at: ind, at: .top, animated: true)

            }
        }, failure : { error in
            print("failure")
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
//             DispatchQueue.main.async {
//                               self.sendButton.isHidden = true
//                   }
//             TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            
        })
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
            self.totalNutritionLbl.text =  "Total nutrition values from last 10 labels"
        } else {
            self.totalNutritionLbl.text = "Total" + " " + (selectedLabel as! String) + " " + "from last 10 labels";
        }
        
        self.nutritionLabelsCollectionView.reloadData();
    }
    
    @objc func moveToWall() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myWall : MyWallViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as! MyWallViewController;
       
        self.navigationController?.pushViewController(myWall, animated: true);
        return
    }
    func sendTweakRating(Withparams: [String: String]) {
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            
            APIWrapper.sharedInstance.updateRatingForTweak(ratingParams as NSDictionary,userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
               
                
                //Update the floating value to Label

                self.starRatingView.isHidden = true
                let alert = UIAlertController(title: "", message: self.bundle.localizedString(forKey: "rating_alert", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: UIAlertAction.Style.default, handler: { _ in
                    MBProgressHUD.showAdded(to: self.view, animated: true)

                    self.reloadTimeLinesAfterRating()
                    
                }));
                self.present(alert, animated: true, completion: nil);
                
                
           
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
                MBProgressHUD.hide(for: self.view, animated: true)
//                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//                let defaultAction = UIAlertAction(title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
            })
            
        
    }
    @IBAction func starRatingViewDoneTapped(_ sender: Any) {
        sendTweakRating(Withparams: ratingParams)

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
    func goToTAEClubMemPage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
       self.navigationController?.pushViewController(clickViewController!, animated: true)
         
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
    
    @objc func getLabelsPerc() {
        //api call for labelperc
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.labelPerc(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic);
            MBProgressHUD.hide(for: self.view, animated: true)
            if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                self.nutritionAnalyticsBtnTapped = true
                MBProgressHUD.hide(for: self.view, animated: true);
                self.tweaksArray = responseDic["tweaks"] as AnyObject as! NSArray
                if self.tweaksArray.count == 0  {
                    self.chartView.isHidden = true
                    self.nutritionLabelsCollectionView.isHidden = true
                    self.totalNutritionLbl.isHidden = true
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please tweak your plate to get Nutrition Analytics !!");
                    
                    return;
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
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please tweak your plate to get Nutrition Analytics !!");
                
                return;
            }
            //  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!");
        })
    }
    
    @objc func calculateAvgValues(val: Int) -> Int {
        
        return (val/self.tweaksArray.count)
        
        
    }
    func getTodayWeekDay()-> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let weekDay = dateFormatter.string(from: Date())
          return weekDay
    }
    
    func getTopBanners() {
        MBProgressHUD.hide(for: self.view, animated: true);
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
       
//        UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
            self.reloadTimelines();
        } else {
           let weekday = getTodayWeekDay()
            var weekNumber = 7
            switch weekday {
            case "Sunday":
                weekNumber = 0
                case "Monday":
                weekNumber = 1
                case "Tuesday":
                weekNumber = 2
                case "Wednesday":
                weekNumber = 3
                case "Thursday":
                weekNumber = 4
                case "Friday":
                weekNumber = 5
                case "Saturday":
                weekNumber = 6
            default:
                weekNumber = 0
            }
            Database.database().reference().child("GlobalVariables").child("Pages").child("TopBanners").child("MyEDR").child(self.countryCode).child("\(weekNumber)").observe(DataEventType.value, with: { (snapshot) in
                   
                    if snapshot.childrenCount > 0 {
                         self.topBannersDict = [String: AnyObject]()
                                let dispatch_group1 = DispatchGroup();
                                dispatch_group1.enter();
                                   for obj in snapshot.children.allObjects as! [DataSnapshot] {
                                   if obj.key == "iOS" {
                                        let topBannerObj = obj.value as AnyObject as! [String: AnyObject]
                                        self.topBannersDict = topBannerObj
                                    self.topBannerImage = self.topBannersDict["img"] as! String
                                    self.topBannerImageLink = self.topBannersDict["img_link"] as! String
                                    
                                    }
                                        
                                
                               
                        
                    }
                    
                        dispatch_group1.leave();

                        dispatch_group1.notify(queue: DispatchQueue.main) {
                            MBProgressHUD.hide(for: self.view, animated: true);
                            
                            self.reloadTimelines();
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.reloadTimelines();
                        }
            }
                   
                    
                   
                    
                })
        }
    }
    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        // No need to update anything if we're being dismissed.
//        if !searchController.isActive {
//            return
//        }
//
//        // you can access the text in the search bar as below
//        var filterString = searchController.searchBar.text
//
//        print(filterString)
//
//        // write some code to filter the data provided to your tableview
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweakFeedsRef = Database.database().reference();
        
        self.filterTweaksView.layer.cornerRadius = 10
        self.mealTypeView.isHidden = true
        self.mealTypeTableView.delegate = self
        self.mealTypeTableView.dataSource = self
        self.mealTypeView.backgroundColor =  UIColor.black.withAlphaComponent(0.8)
        self.starRatingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.datePickerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.datePicker.backgroundColor = .white
        self.datePicker.maximumDate = Date()
        self.innerStarRatingView.layer.cornerRadius = 20
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false;
            controller.searchBar.returnKeyType = .done
            controller.searchBar.placeholder = "cheese, pasta, pizza, dosa"
            
            timelinesTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
                if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        CleverTap.sharedInstance()?.recordEvent("EDR_viewed")
        NotificationCenter.default.addObserver(self, selector: #selector(TimelinesViewController.reloadTimelines), name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATIONS"), object: nil)

        // timelinesTableView.backgroundColor = UIColor.white
        //        let data = ["msg": "Woohoo! Now our Premium Services is rated the BEST in Health & Wellness segment! Please click on  our Premium Services and try it. You owe it to yourself", "imgUrlString":"https://s3.ap-south-1.amazonaws.com/tweakandeatpush/push_img_20190226_01.jpg", "link": "-AiDPwdvop1HU7fj8vfL"] as [String: AnyObject]
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_POPUP"), object: data)
        self.title = "My EDR (Electronic Diet Record)"
        // self.noEdrPopView.isHidden = true
//        self.timelinesTableView.estimatedRowHeight = 332.0
//        self.timelinesTableView.rowHeight = UITableView.automaticDimension
//        let homeBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-1"), style: .plain, target: self, action: #selector(TimelinesViewController.clickButton))
//        homeBarButtonItem.tintColor = UIColor.black
//        self.navigationItem.rightBarButtonItem  = homeBarButtonItem
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        }
        
        if countryCode != "91" {
            
        }
        
        
        self.nutritionValuesArray = ["Calories","Carbs","Fats","Protein","Total"];
        self.tweakImgView.isUserInteractionEnabled = true
        self.totalNutritionLbl.text = "Total Calories from last 10 labels"
        
        let tappedOnImageView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        tappedOnImageView.numberOfTapsRequired = 1
        self.tweakImgView?.addGestureRecognizer(tappedOnImageView)
        self.chartView.isHidden = true
        self.nutritionLabelsCollectionView.isHidden = true
        self.totalNutritionLbl.isHidden = true
        
        bundle = Bundle.init(path: path!)! as Bundle;
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
                
            }
        }
        
        
        
        self.noReportsLabel.text = bundle.localizedString(forKey: "no_report", value: nil, table: nil);
        
        self.myProfile = self.realm.objects(MyProfileInfo.self);
        //self.myProfileInfo = self.realm.objects(MyProfileInfo.self);

        for myProfileObj in self.myProfile! {
            self.age = myProfileObj.age;
            self.height = myProfileObj.height;
            self.weight = myProfileObj.weight;
            self.gender = myProfileObj.gender;
            nicKName = myProfileObj.name;
            sex = myProfileObj.gender;
        }
        
        self.reportsInfoView.layer.cornerRadius = 5;
        self.reportsInfoView.layer.borderWidth = 2;
        self.reportsInfoView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        
        self.timelinesTableView.register(UINib.init(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCell");
        self.timelinesTableView.register(UINib.init(nibName: "TimelineTableViewCellWithAd", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCellWithAd");
        MBProgressHUD.showAdded(to: self.view, animated: true);
        timelinesTableView.isHidden = false;
        self.reportsTableView.isHidden = true;
        self.reportsInfoView.isHidden = true;
        self.nutritionAnalyticsView.isHidden = true
       // self.floatingButton()

    }
    
    func floatingButton(){
        self.floatingBtn.frame = CGRect(x: self.view.frame.width - 90, y: self.view.frame.height - 90, width: 50, height: 50)
          self.floatingBtn.setTitle(" + ", for: .normal)
        self.floatingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
          self.floatingBtn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
          self.floatingBtn.clipsToBounds = true
        self.floatingBtn.layer.cornerRadius = self.floatingBtn.frame.size.width / 2
          self.floatingBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
          self.floatingBtn.layer.borderWidth = 3.0
        self.floatingBtn.addTarget(self,action: #selector(TimelinesViewController.floatingButtonTapped), for: .touchUpInside)
        if let window = UIWindow.key {
                 window.addSubview(self.floatingBtn)
             }
      }
    
    @objc func floatingButtonTapped() {
        // camera action
         self.checkTweakable()
    }
    
    
    
     @objc func checkTweakable(){
        DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.CHECKTWEAKABLE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            if  responseResult == "GOOD" {
                
                print("Sucess")
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                           self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                       }
                var labelsCount = 0
                      if UserDefaults.standard.value(forKey: "USER_LABELS_COUNT") != nil {
                          labelsCount = UserDefaults.standard.value(forKey: "USER_LABELS_COUNT") as! Int
                      }
                if self.countryCode == "91" {//IndWLIntusoe3uelxER
                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil  {
                    DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    }
                    self.takephoto();
                    }  else {
                    self.getGlobalVariablesData()
                    }

                } else {
                    DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    }
                self.takephoto();
                }
                
                
            } else{
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
                self.addChild(popOverVC);
                popOverVC.EDRViewController = self
                let htmlTxt =  responseDic["msg"] as! String
                popOverVC.popUpText = htmlTxt.html2String
                popOverVC.popUp = true
                self.view.addSubview(popOverVC.view);
                popOverVC.didMove(toParent: self);
                
            }
        }, failure : { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
//            self.premiumIconBarButton.isEnabled = true;
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    

    
    @objc func takephoto() {
        
        let optionMenu = UIAlertController(title: nil, message: bundle.localizedString(forKey: "capture_food", value: nil, table: nil), preferredStyle: .actionSheet);
        
        // 2
        let cameraAction = UIAlertAction(title: bundle.localizedString(forKey: "camera", value: nil, table: nil), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        let saveAction = UIAlertAction(title: bundle.localizedString(forKey: "choose_photo_library", value: nil, table: nil), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        
        
        let cancelAction = UIAlertAction(title: bundle.localizedString(forKey: "action_cancel", value: nil, table: nil), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cameraAction);
        optionMenu.addAction(saveAction);
        optionMenu.addAction(cancelAction);
        
        self.present(optionMenu, animated: true, completion: nil);
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.faceDetection(detect: image)
            dismiss(animated:false, completion: nil);
            
        }
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
    }
    
    @objc func faceDetection(detect: UIImage) {
        
        guard let personciImage = CIImage(image: detect) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        print(faces!.count)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        var message: String = self.bundle.localizedString(forKey: "detected_a_face", value: nil, table: nil)
        if faces!.count > 5 {
            message = "We detected so many faces!"
        } else if faces!.count > 1 && faces!.count <= 2 {
            message = "We detected faces!"
        } else if faces!.count == 2 {
            message = "We detected 2 faces!"
        } else if faces!.count == 3 {
            message = "We detected 3 faces!"
        }  else if faces!.count == 4 {
            message = "We detected 4 faces!"
        }  else if faces!.count == 5 {
            message = "We detected 5 faces!"
        }
        message = message +  self.bundle.localizedString(forKey: "detect_face", value: nil, table: nil)
        for face in faces as! [CIFaceFeature] {
            var faceViewBounds = face.bounds.applying(transform)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
        if faces!.count > 0 {
            let alert = UIAlertController(title: self.bundle.localizedString(forKey: "say_cheese", value: nil, table: nil), message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        DispatchQueue.global().async() {
            print("Work Dispatched")
            // Do heavy or time consuming work
            let imageData: NSData = self.countryCode == "1" ?detect.jpegData(compressionQuality: 0.8)! as NSData : detect.jpegData(compressionQuality: 0.6)! as NSData
            let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
            let str = "data:image/jpeg;base64,";
            let imgBase64 = str + strBase64;
            
            let currentDate = Date()
            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
            let date = isoFormatter.string(from: currentDate);
            print(date)
            for (key,val) in self.timeZoneAbbreviations {
                let localTimeZone = val
                if localTimeZone == self.localTimeZoneName {
                    let tweakImageParams : [String : String] = ["fromOs" : "IOS", "lat" : self.latitude, "lng" : self.longitude, "newImage" : imgBase64, "userLocalTime" : date, "userLocalTimezone" : key ];
                    // “userLocalTime”: “2019-06-17 14:00:00",
                    //“userLocalTimezone”: “IST”
                    DispatchQueue.main.async() {
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakShareViewController") as! TweakShareViewController;
                        clickViewController.tweakImage = detect  as UIImage;
                        clickViewController.parameterDict1 = tweakImageParams as [String : AnyObject];
                        
                        self.navigationController?.pushViewController(clickViewController, animated: false);
                        
                    }
                    return
                }
            }
            
            let tweakImageParams : [String : String] = ["fromOs" : "IOS", "lat" : self.latitude, "lng" : self.longitude, "newImage" : imgBase64, "userLocalTime" : date, "userLocalTimezone" : "" ];
            // “userLocalTime”: “2019-06-17 14:00:00",
            //“userLocalTimezone”: “IST”
            DispatchQueue.main.async() {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakShareViewController") as! TweakShareViewController;
                clickViewController.tweakImage = detect  as UIImage;
                clickViewController.parameterDict1 = tweakImageParams as [String : AnyObject];
                
                self.navigationController?.pushViewController(clickViewController, animated: false);
                
            }
            
        }
    
    }
    
    func getGlobalVariablesData() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        Database.database().reference().child("GlobalVariables").child("Pages").child("GamifyingLevel0").child(self.countryCode).child("iOS").observe(DataEventType.value, with: { (snapshot) in
                   
                    if snapshot.childrenCount > 0 {
                         self.sectionsForGamifyArray = []
                                let dispatch_group1 = DispatchGroup();
                                dispatch_group1.enter();
                                   for obj in snapshot.children.allObjects as! [DataSnapshot] {
                                    if obj.key == "Sections" {
                                        let sectionsArray = obj.value as AnyObject as! NSArray
                                        self.sectionsForGamifyArray = sectionsArray as AnyObject as! [[String : AnyObject]]
                                        
                                    }
                               
                        
                    }
                    
                        dispatch_group1.leave();

                        dispatch_group1.notify(queue: DispatchQueue.main) {
                            MBProgressHUD.hide(for: self.view, animated: true);
                            
                            self.performSegue(withIdentifier: "gamify", sender: self)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        }
                        self.takephoto();
            }
                   
                    
                   
                    
                })
    }
    
    @objc func clickButton(){
        print("button click")
        self.navigationController?.popToRootViewController(animated: true)
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
    
    @objc func adTapped(_ cell: TimelineTableViewCellWithAd) {
        print(cell.adId);
        if cell.adId == 0 {
            return
        }
        if cell.adLocalUrl == "" {
            let version = self.iOSVersion();
            
            let urlString = TweakAndEatURLConstants.ENDPOINT_CLICK_AD + "adId=" + "\(cell.adId)" + "&adType=" + "\(self.adType)" + "&appCode=" + "\(TweakAndEatConstants.TAE_APP_ID_FOR_ADS)" + "&appOs=IOS&appOsVersion=" + "\(version)" + "&userId=" + "\(self.userID)" + "&userAge=" + "\(self.age)" + "&userGender=" + "\(self.gender)" + "&userHeight=" + "\(self.height)" + "&userWeight=" + "\(self.weight)" + "&lat=" + "\(self.latitude)" + "&long=" + "\(self.longitude)" + "&deviceInfo=" + "\(deviceInfo.replacingOccurrences(of: " ", with: "%20"))"
            //let url = URLCache(string: urlString)!
            let url = URL(string: urlString)!;
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil);
            } else {
                UIApplication.shared.openURL(url);
            }
        } else {
            
            self.navigationController?.popToRootViewController(animated: true);
            if cell.adLocalUrl != "HOMEPAGE" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ADLOCALURL"), object: cell.adLocalUrl);
            }
        }
    }
    
    @IBAction func reportsInfoAction(_ sender: Any) {
        
        if self.reportsInfoView.isHidden == true{
            self.reportsInfoView.isHidden = false;
        }else{
            self.reportsInfoView.isHidden = true;
        }
    }
    
    
    @objc func iOSVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.floatingBtn.removeFromSuperview()
        searchController.searchBar.isHidden = true
        searchController.searchBar.endEditing(true)
        self.globalTweaksList = nil
        self.globalFilteredTweaksList = nil
        self.tweaksList = nil
        self.filteredTweaksList = nil
        self.filterbyVal = "All"
        self.filterByLabel.text = "All"
        DispatchQueue.main.async {
            self.searchController.isActive = false
        }
        searchController.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.isHidden = false

        self.navigationItem.hidesBackButton = true;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(TimelinesDetailsViewController.moveToWall), name: NSNotification.Name(rawValue: "TWEAK_SHARED"), object: nil)
       // self.reloadTimelines();
        self.getTopBanners()
        
        timelinesSync();
        if(comingFromSettings == true){
            UIView.animate(withDuration: 1.0) {
                self.tabBarController?.tabBar.isHidden = false;
            }
            comingFromSettings = false;
        }
        NotificationCenter.default.addObserver(self, selector: #selector(TimelinesViewController.reloadTweaks), name: NSNotification.Name(rawValue: "NEWREMINDER"), object: nil)
        
        
    }
    
    @objc func reloadTweaks() {
        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
        
        self.timelinesTableView.reloadData();
        
    }
    
    @objc func reloadTimeLinesAfterRating() {
        
            let userdefaults = UserDefaults.standard
            if let savedValue = userdefaults.string(forKey: "USERBLOCKED"){
                self.noEdrPopView.isHidden = false
                self.noEdrLabel.text = self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil)
                return
            }else{
                let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
                
                APIWrapper.sharedInstance.getTimelines(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
                    
                    print("This is run on the background queue")
                    if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                        let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                        let tweaks : [AnyObject]? = response[TweakAndEatConstants.TWEAKS] as? [AnyObject];
                        if(tweaks != nil) {
                            for tweak in tweaks! {
                                DataManager.sharedInstance.saveTweak(tweak: tweak as! NSDictionary);
                            }
                            self.globalTweaksList = DataManager.sharedInstance.fetchTweaks();
                            self.timelinesTableView.reloadRows(at: [IndexPath(row: self.selectedRow, section: 0)], with: .automatic)
                            print("This is run on the main queue, after the previous code in outer block")
                            MBProgressHUD.hide(for: self.view, animated: true);

                        }
                    }
                }) { (error : NSError!) -> (Void) in
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if error?.code == -1011 {
                        //                     TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil))
                        //                    let alertController = UIAlertController(title: "", message: self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                        //
                        //                    let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "button_ok", value: nil, table: nil)
                        //                    , style: UIAlertAction.Style.default) {
                        //                        UIAlertAction in
                        //                        self.navigationController?.popViewController(animated: true)
                        //                    }
                        //                    alertController.addAction(okAction)
                        //
                        //                    // Present the controller
                        //                    self.present(alertController, animated: true, completion: nil)
                        
                        self.noEdrPopView.isHidden = false
                        self.noEdrLabel.text = self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil)
                    } else {
                        // TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                    }
                }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true);
        }
    
    
    @objc func reloadTimelines(){
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: "USERBLOCKED"){
            self.noEdrPopView.isHidden = false
            self.noEdrLabel.text = self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil)
            return
        }else{
            tweaksList = [AnyObject]()
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            
            APIWrapper.sharedInstance.getTimelines(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
                
                print("This is run on the background queue")
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    let tweaks : [AnyObject]? = response[TweakAndEatConstants.TWEAKS] as? [AnyObject];
                    if(tweaks != nil) {
                        for tweak in tweaks! {
                            DataManager.sharedInstance.saveTweak(tweak: tweak as! NSDictionary);
                        }
                        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
                        self.globalTweaksList = DataManager.sharedInstance.fetchTweaks();
               
                        self.timelinesTableView.reloadData();

                        
                        print("This is run on the main queue, after the previous code in outer block")
                        MBProgressHUD.hide(for: self.view, animated: true);
                        if ((UserDefaults.standard.value(forKey: "TWEAK_ID")) != nil){
                            let tweakObject : TBL_Tweaks? = DataManager.sharedInstance.fetchTWEAKWithId(value: UserDefaults.standard.value(forKey: "TWEAK_ID") as Any as! NSNumber);
                            if (tweakObject != nil) {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                                let timelineDetail : TimelinesDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "timelineDetailViewController") as! TimelinesDetailsViewController;
                                timelineDetail.tweakId = Int(truncating: UserDefaults.standard.value(forKey: "TWEAK_ID") as Any as! NSNumber)
                                
                                timelineDetail.timelineDetails = tweakObject
                                timelineDetail.tweakStatus = Int(truncating: tweakObject?.tweakStatus as Any as! NSNumber)
                                timelineDetail.tweaksList = self.tweaksList;
                                timelineDetail.tweakUserComments = tweakObject!.tweakUserComments! as String

                                if tweakObject!.tweakModifiedImageURL == "" {
                                    timelineDetail.imageUrl =  tweakObject!.tweakOriginalImageURL! as String;
                                }
                                else{
                                    timelineDetail.imageUrl =  tweakObject!.tweakModifiedImageURL! as String;
                                }
                                timelineDetail.tweakSuggestedText = tweakObject!.tweakSuggestedText == "" ? self.bundle.localizedString(forKey: "no_tweak_yet", value: nil, table: nil): tweakObject!.tweakSuggestedText!; UserDefaults.standard.removeObject(forKey: "TWEAK_ID");
                                self.navigationController?.pushViewController(timelineDetail, animated: true);
                                
                            }
                            
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.noEdrPopView.isHidden = false
                        self.noEdrLabel.text = self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil)
                        //   TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil))
                    }
                }
            }) { (error : NSError!) -> (Void) in
                MBProgressHUD.hide(for: self.view, animated: true);
                if error?.code == -1011 {
                    //                     TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil))
                    //                    let alertController = UIAlertController(title: "", message: self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                    //
                    //                    let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "button_ok", value: nil, table: nil)
                    //                    , style: UIAlertAction.Style.default) {
                    //                        UIAlertAction in
                    //                        self.navigationController?.popViewController(animated: true)
                    //                    }
                    //                    alertController.addAction(okAction)
                    //
                    //                    // Present the controller
                    //                    self.present(alertController, animated: true, completion: nil)
                    
                    self.noEdrPopView.isHidden = false
                    self.noEdrLabel.text = self.bundle.localizedString(forKey: "no_edr_text", value: nil, table: nil)
                } else {
                    // TweakAndEatUtils.AlertView.showAlert(view: self, message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                }
            }
        }
        
        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
        MBProgressHUD.hide(for: self.view, animated: true);
        self.timelinesTableView.reloadData();
    }
    
    
    
    
    @objc func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    @objc func infOButtonClicked(){
        if self.reportsInfoView.isHidden == true{
            self.reportsInfoView.isHidden = false
        }else{
            self.reportsInfoView.isHidden = true
        }
    }
    
    func goToHomePage() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
           let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.navigationController?.pushViewController(clickViewController!, animated: true)
          
       }
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        
                    }
                    
                }
                
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if packageObj.count == 0 {
                        self.goToHomePage()
                        return
                    }
                    self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
                }
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "nutritionLabels" {
                      let pkgID = sender as! String
                      let popOverVC = segue.destination as! NutritionLabelViewController;
                      popOverVC.packageID = pkgID
               popOverVC.fromWhichVC = "GamifyViewCOntroller"
                  
                  } else if segue.identifier == "moreInfo" {
                             let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
                             
                             let cellDict = sender as AnyObject as! [String: AnyObject]
                             popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
                             popOverVC.fromHomePopups = true
           } else if segue.identifier == "myTweakAndEat" {
                      let destination = segue.destination as! MyTweakAndEatVCViewController
                     // if self.countryCode == "91" {
                          let pkgID = sender as! String
                          destination.packageID = pkgID

                     // }
                  }
       }
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
        self.navigationController?.pushViewController(clickViewController!, animated: true)

    }
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    func goToBuyScreen(packageID: String, identifier: String) {
            UserDefaults.standard.set(identifier, forKey: "POP_UP_IDENTIFIERS")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                                  MBProgressHUD.showAdded(to: self.view, animated: true);
                                  }
                                  self.moveToAnotherView(promoAppLink: packageID)

    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    //                       let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
    //        vc.packageID = packageID
    //        vc.identifierFromPopUp = identifier
    //         vc.fromHomePopups = true
    //                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    //                       navController?.pushViewController(vc, animated: true);
        }
    
    func goToTAEClub() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                   let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                   let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                   navController?.pushViewController(vc, animated: true);
       }
    
    func goToDesiredVC(promoAppLink: String) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if promoAppLink == "HOME" || promoAppLink == "" {
                   self.goToHomePage()
                   
               } else if promoAppLink == "CLUBAIDP_PUR_IND_OP_1M" {
                if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
                } else {
               self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: promoAppLink)
                }
               } else if promoAppLink == "CLUB_PURCHASE" || promoAppLink == "CLUB_PUR_IND_OP_1M" {
                   if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                     self.goToTAEClubMemPage()
                   } else {
                    if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                        self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                    }
                    if self.countryCode == "91" {
                    self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                    } else {
                        self.goToPurchaseTAEClubScreen()

                    }
                    

                }
               }else if promoAppLink == "NCP_PUR_IND_OP" {
                if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
                    self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: promoAppLink)
                }
            } else if promoAppLink == "MYAIDP_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                    self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);

                } else {
            self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: promoAppLink)
                }
            } else if promoAppLink == "MYTAE_PUR_IND_OP_3M" || promoAppLink == "WLIF_PUR_IND_OP_3M" {
                if promoAppLink == "MYTAE_PUR_IND_OP_3M" {
                    if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                     self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                        //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                    } else {
                self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: promoAppLink)
                    }
                } else if promoAppLink == "WLIF_PUR_IND_OP_3M" {
                    if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                     self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                        //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                    } else {
                self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: promoAppLink)
                    }
                }
            } else if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == clubPackageSubscribed {
                //MYTAE_PUR_IND_OP_3M
                          if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                             self.goToTAEClubMemPage()
                           } else {
                            DispatchQueue.main.async {
                                MBProgressHUD.showAdded(to: self.view, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
            } else if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
                
                
                if UserDefaults.standard.value(forKey: promoAppLink) != nil {
                    self.goToNutritonConsultantScreen(packageID: promoAppLink)
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true);
                    }
                    self.moveToAnotherView(promoAppLink: promoAppLink)

                    
                    
                }
                
            }
        if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubInd4tUPXHgVj9w3" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubUsa5nDa1M8WcRA6" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-Qis3atRaproTlpr4zIs" || promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionLabels", sender: promoAppLink)

        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)
                       
                   }
               } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                

            }
        }
    }
    
    
    
    @objc func bannerClicked() {
        
        self.goToDesiredVC(promoAppLink: self.topBannerImageLink)
    }
    
    @objc func timelinesSync(){
        rc.addTarget(self, action: #selector(TimelinesViewController.refresh(refreshControl:)), for: UIControl.Event.valueChanged);
        if #available(iOS 10.0, *) {
            timelinesTableView.refreshControl = rc;
        } else {
            // Fallback on earlier versions
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if tableView == self.mealTypeTableView {
            let headerView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.text = "  Please choose the meal type"
            headerView.numberOfLines = 0
            headerView.backgroundColor = .groupTableViewBackground
            headerView.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)


            return headerView
        

        }

        return UIView()
    }
    func goToTweakTrends() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TweakTrendReportViewController = storyBoard.instantiateViewController(withIdentifier: "TweakTrendReportViewController") as! TweakTrendReportViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    @objc func reportsButtonTapped() {
        goToTweakTrends()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timelinesTableView {
            if (self.filteredTweaksList?.count ?? 0 > 0) {
                return self.filteredTweaksList!.count
            } else {
            if(self.tweaksList != nil) {
              

                return tweaksList!.count;
            } else {
                
                return 0;
            }
            }
        }
        if tableView == self.reportsTableView {
            return self.datesArray.count
        }
        if tableView == self.mealTypeTableView {
            if mealTypeArray.count > 0 {
                return mealTypeArray.count
            }
            return 0
        }
        return 0
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing();
    }
    
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        searchController.searchBar.isHidden = true
        searchController.searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.searchController.isActive = false
        }
        searchController.resignFirstResponder()
        
        if self.fromGotIt == false {
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            let _ = self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if tableView == self.mealTypeTableView {
//            return "Please choose the meal type you would like to copy for this meal"
//        }
//        return ""
//    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // var timelineCell : MYEDRCell;
        var timelineCellWithAd : TimelineTableViewCellWithAd;
        
        var cell : UITableViewCell!;
        
        if tableView == timelinesTableView {
            
            //            if indexPath.row % 2 != 0{
            //                let identifier = "TimelineTableViewCellWithAd";
            //
            //                timelineCellWithAd = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as! TimelineTableViewCellWithAd;
            //                timelineCellWithAd.buttonDelegate = self
            //                timelineCellWithAd.buttonDelegate = self
            //                //self.serveAD(timelineCellWithAd)
            //                let tweak : TBL_Tweaks = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            //
            //                if  tweak.tweakModifiedImageURL == "" {
            //                    timelineCellWithAd.profileImageView.sd_setImage(with: URL(string: tweak.tweakOriginalImageURL ?? ""));
            //
            //                }
            //                else {
            //                    timelineCellWithAd.profileImageView.sd_setImage(with: URL(string: tweak.tweakModifiedImageURL ?? ""));
            //
            //                }
            //                if(tweak.tweakDateUpdated == nil || tweak.tweakDateUpdated == "") {
            //                    timelineCellWithAd.timelineDate.text = tweak.tweakDateCreated;
            //                } else {
            //                    timelineCellWithAd.timelineDate.text = tweak.tweakDateUpdated;
            //                }
            //                timelineCellWithAd.timelineTitle.text = tweak.tweakSuggestedText?.replacingOccurrences(of: "\n", with: "");
            //                if timelineCellWithAd.timelineTitle.text == "" {
            //                    timelineCellWithAd.timelineTitle.text = bundle.localizedString(forKey: "no_tweak_yet", value: nil, table: nil)
            //                }
            //                timelineCellWithAd.starRatingView.value = CGFloat(tweak.tweakRating);
            //
            //                timelineCellWithAd.borderView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor;
            //                timelineCellWithAd.ratingLabel.text = "\(tweak.tweakRating) / 5.0";
            //
            //                timelineCellWithAd.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateCreated!);
            //
            //                timelineCellWithAd.selectionStyle = UITableViewCell.SelectionStyle.none;
            //                cell = timelineCellWithAd;
            //
            //            }
            //            else{
            
            let identifier = "myCell";
            let timelineCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as! MYEDRCell;
            
            var tweak = TBL_Tweaks()
            if self.filteredTweaksList != nil {
            if self.filteredTweaksList!.count > 0 {
                tweak = self.filteredTweaksList![indexPath.row] as! TBL_Tweaks;
            }
            }
            if self.tweaksList != nil {
            if self.tweaksList!.count > 0 {
                tweak = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            }
            }
            if tweak.tweakStatus == 4 {
                timelineCell.askAQuestionHeightConstraint.constant = 35
            } else {
                timelineCell.askAQuestionHeightConstraint.constant = 0
            }
            if  tweak.tweakModifiedImageURL == "" {
                timelineCell.profileImageView.sd_setImage(with: URL(string: tweak.tweakOriginalImageURL ?? ""));
                
            }
            else {
                timelineCell.profileImageView.sd_setImage(with: URL(string: tweak.tweakModifiedImageURL ?? ""));
                
            }
            
            if(tweak.tweakDateUpdated == nil || tweak.tweakDateUpdated == "") {
                timelineCell.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateCreated!);
            } else {
                timelineCell.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateUpdated!);
            }
            timelineCell.timelineTitle.text = tweak.tweakSuggestedText?.replacingOccurrences(of: "\n", with: " ");
            if timelineCell.timelineTitle.text == "" {
                timelineCell.timelineTitle.text = bundle.localizedString(forKey: "no_tweak_yet", value: nil, table: nil)
            }
            timelineCell.starRatingView.value = CGFloat(tweak.tweakRating);
            
            timelineCell.contentView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor;
            timelineCell.ratingLabel.text = "\(tweak.tweakRating) / 5.0";
            
           // timelineCell.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateCreated!);
            if self.gender == "F" {
                timelineCell.genderImgView.image = UIImage.init(named: "wall_female")
            } else {
                timelineCell.genderImgView.image = UIImage.init(named: "wall_male")
            }
//            if tweak.tweakUserComments?.count ?? 0 > 0 {
//            timelineCell.userCommentsLabel.text = "\n" + tweak.tweakUserComments! + "\n"
//            } else {
//                timelineCell.userCommentsLabel.text = tweak.tweakUserComments!
//            }
            //print(tweak.mealType)
            timelineCell.delegate = self
            timelineCell.myIndex = indexPath.row
            if tweak.mealType == 1 {
                timelineCell.mealTypeLabel.text = "Breakfast"
            } else if tweak.mealType == 2 {
                timelineCell.mealTypeLabel.text = "Brunch"
            } else if tweak.mealType == 3 {
                timelineCell.mealTypeLabel.text = "Lunch"
            } else if tweak.mealType == 5 {
                timelineCell.mealTypeLabel.text = "Evening Snack"
            } else if tweak.mealType == 7 {
                timelineCell.mealTypeLabel.text = "Dinner"
            }
            timelineCell.caloriesLabel.text = "\(tweak.calories)"
            timelineCell.carbsLabel.text = "\(tweak.carbs)%"
            timelineCell.fatsLabel.text = "\(tweak.fats)%"
            timelineCell.proteinLabel.text = "\(tweak.protein)%"
            
            timelineCell.userCommentsLabel.text = tweak.tweakUserComments!
            
          
            timelineCell.selectionStyle = UITableViewCell.SelectionStyle.none;
            //}
            return timelineCell;
        }
        if tableView == self.mealTypeTableView {
            let mealCell = tableView.dequeueReusableCell(withIdentifier: "meal", for: indexPath)
            let cellDict = self.mealTypeArray[indexPath.row];
            mealCell.textLabel?.text = (cellDict["name"] as! String)
            mealCell.textLabel?.font = UIFont(name:"QUESTRIAL-REGULAR", size: 19.0)
            let mealType = cellDict["value"] as! Int
            mealCell.tintColor = .black
            if copyThisMealParams["mealType"] as! Int == mealType {
                mealCell.accessoryType = .checkmark
            } else {
                mealCell.accessoryType = .none
            }
            

            return mealCell
            
        }
        //        if tableView == self.reportsTableView {
        //            let cell = self.reportsTableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath) as! ReportsTableViewCell
        //            if cell.cellDelegate == nil {
        //                cell.cellDelegate = self
        //            }
        //
        //            cell.cellIndexPath = indexPath.row
        //            self.dateFormat.dateFormat = "yyyy-MM-dd"
        //            let headerDate = self.dateFormat.date(from: self.datesArray[indexPath.row])
        //            self.dateFormat.dateFormat = "dd MMM yyyy"
        //            let headerDateStr = self.dateFormat.string(from: headerDate!)
        //            cell.dateLbl.text = "  " + headerDateStr
        //            let cellDict = self.tableArray[indexPath.row]
        //            self.dateFormat.dateFormat = "yyyy-MM-dd"
        //            let prevStartWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportStartDate"] as! String)
        //            let prevEndWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportEndDate"] as! String)
        //            let nextStartWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportStartDate"] as! String)
        //            let nextEndWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportEndDate"] as! String)
        //            self.dateFormat.dateFormat = "dd MMM yyyy"
        //            let prevStartDate = self.dateFormat.string(from: prevStartWeek!)
        //            let prevEndDate = self.dateFormat.string(from: prevEndWeek!)
        //            let nextStartDate = self.dateFormat.string(from: nextStartWeek!)
        //            let nextEndDate = self.dateFormat.string(from: nextEndWeek!)
        //            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
        //                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
        //                if language == "EN" {
        //                    cell.prevReportsLbl.font =  cell.prevReportsLbl.font.withSize(14)
        //                    cell.nextReportsLbl.font =  cell.prevReportsLbl.font.withSize(14)
        //                } else if language == "BA" {
        //                    cell.prevReportsLbl.font =  cell.prevReportsLbl.font.withSize(12)
        //                    cell.nextReportsLbl.font =  cell.prevReportsLbl.font.withSize(13)
        //                }
        //            }
        //            cell.prevReportsLbl.text = bundle.localizedString(forKey: "previous_weeks_report", value: nil, table: nil) + " \(prevStartDate)" + bundle.localizedString(forKey: "to", value: nil, table: nil) +  "  \(prevEndDate)"
        //            cell.nextReportsLbl.text =  bundle.localizedString(forKey: "next_weeks_report", value: nil, table: nil)  + " \(nextStartDate) " +  bundle.localizedString(forKey: "to", value: nil, table: nil) + " \(nextEndDate)"
        //            cell.prevWeekPieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 10)
        //            cell.prevWeekPieChartView.showSegmentValueInLabel = true
        //            cell.nextWeekPieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 10)
        //            cell.nextWeekPieChartView.showSegmentValueInLabel = true
        //            let keyExistsForPreviousWeek = cellDict["PreviousWeek"]?["advise"] as? String != nil
        //            //let val = keyExists
        //            if keyExistsForPreviousWeek == false
        //            {
        //                cell.prevTxtView.text = ""
        //            }else{
        //                cell.prevTxtView.text = cellDict["PreviousWeek"]?["advise"] as! String
        //
        //            }
        //
        //            let keyExistsForNextWeek = cellDict["NextWeek"]?["advise"] as? String != nil
        //            if keyExistsForNextWeek == false
        //            {
        //                cell.nextTxtView.text = ""
        //            }else{
        //
        //                cell.nextTxtView.text = cellDict["NextWeek"]?["advise"] as! String
        //            }
        //
        //            var prevValues = cellDict["PreviousWeek"] as! [String:AnyObject]
        //
        //            var prevCarbStr = prevValues["pieValues"]?["Carbs"]as AnyObject as! String
        //            prevCarbStr = prevCarbStr.replacingOccurrences(of: "%", with: "")
        //
        //            var prevFatStr = prevValues["pieValues"]?["Fats"]as AnyObject as! String
        //            prevFatStr = prevFatStr.replacingOccurrences(of: "%", with: "")
        //
        //            var othersStr = prevValues["pieValues"]?["Others"]as AnyObject as! String
        //            othersStr = othersStr.replacingOccurrences(of: "%", with: "")
        //
        //            var prevProteinStr = prevValues["pieValues"]?["Proteins"]as AnyObject as! String
        //            prevProteinStr = prevProteinStr.replacingOccurrences(of: "%", with: "")
        //
        //            var nextValues = cellDict["NextWeek"] as! [String:AnyObject]
        //
        //            var nextCarb = nextValues["pieValues"]?["Carbs"]as AnyObject as! String
        //
        //            nextCarb = nextCarb.replacingOccurrences(of: "%", with: "")
        //
        //            var nextFat = nextValues["pieValues"]?["Fats"]as AnyObject as! String
        //            nextFat = nextFat.replacingOccurrences(of: "%", with: "")
        //
        //            var nextFibre = nextValues["pieValues"]?["Others"]as AnyObject as! String
        //            nextFibre = nextFibre.replacingOccurrences(of: "%", with: "")
        //
        //            var nextProtein = nextValues["pieValues"]?["Proteins"]as AnyObject as! String
        //            nextProtein = nextProtein.replacingOccurrences(of: "%", with: "")
        //
        //            cell.prevAdviseLabel.text = bundle.localizedString(forKey: "advise", value: nil, table: nil)
        //            cell.nextAdviseLabel.text = bundle.localizedString(forKey: "advise", value: nil, table: nil)
        //
        //            cell.prevWeekPieChartView.segments = [
        //                Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevCarbStr)!)),
        //                Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "fat", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevFatStr)!)),
        //                Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name:  bundle.localizedString(forKey: "others", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: othersStr)!)),
        //                Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "protein", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: prevProteinStr)!))
        //            ]
        //            cell.nextWeekPieChartView.segments = [
        //                Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "Carbs", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextCarb)!)),
        //                Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "fat", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextFat)!)),
        //                Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "others", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextFibre)!)),
        //                Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: bundle.localizedString(forKey: "protein", value: nil, table: nil), value: CGFloat(NumberFormatter().number(from: nextProtein)!))
        //            ]
        //
        //            return cell;
        //        }
        
        return cell;
    }
    
    @objc func clickOnAD() {
        let version = self.iOSVersion()
        
        let urlString = TweakAndEatURLConstants.ENDPOINT_CLICK_AD + "adId=" + "\(self.adId)" + "&adType=" + "\(self.adType)" + "&appCode=" + "\(TweakAndEatConstants.TAE_APP_ID_FOR_ADS)" + "&appOs=IOS&appOsVersion=" + "\(version)" + "&userId=" + "\(self.userID)" + "&userAge=" + "\(self.age)" + "&userGender=" + "\(self.gender)" + "&userHeight=" + "\(self.height)" + "&userWeight=" + "\(self.weight)" + "&lat=" + "\(self.latitude)" + "&long=" + "\(self.longitude)" + "&deviceInfo=" + "\(deviceInfo.replacingOccurrences(of: " ", with: "%20"))"
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if tableView == timelinesTableView {
    //            if indexPath.row % 2 != 0 {
    //                return 375;
    //            }
    //            else
    //            {
    //                return 316;
    //            }
    //        }
    //        if tableView == self.reportsTableView {
    //            return 437
    //        }
    //        return 0
    //    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.reportsTableView {
            return 1
        } else if tableView == self.timelinesTableView {
//            if self.topBannersDict.count > 0 {
//               return 80
//            }
//            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil || UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
//                return 60
//
//            }
            return 0
        } else if tableView == self.mealTypeTableView {
            return 40
        }
        return 0
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 332
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == timelinesTableView {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let timelineDetail : TimelinesDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "timelineDetailViewController") as! TimelinesDetailsViewController;
            timelineDetail.isFromOneSignal = true
            var tweak = TBL_Tweaks()
            if self.filteredTweaksList != nil {
            if self.filteredTweaksList!.count > 0 {
                tweak = self.filteredTweaksList![indexPath.row] as! TBL_Tweaks;
            }
            }
            if self.tweaksList != nil {
            if self.tweaksList!.count > 0 {
                tweak = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            }
            }
            timelineDetail.timelineDetails = tweak;
            timelineDetail.selectedIndex = indexPath.row
            self.selectedIndex = indexPath.row
            //let tweak : TBL_Tweaks = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            timelineDetail.tweakId = Int(tweak.tweakId)
            
            timelineDetail.tweakSuggestedText = tweak.tweakSuggestedText == "" ? self.bundle.localizedString(forKey: "no_tweak_yet", value: nil, table: nil): tweak.tweakSuggestedText!;
            timelineDetail.tweakStatus = Int(truncating: tweak.tweakStatus as Any as! NSNumber)
            
            if tweak.tweakModifiedImageURL == "" {
                timelineDetail.imageUrl =  tweak.tweakOriginalImageURL! as String;
            }
            else{
                timelineDetail.imageUrl =  tweak.tweakModifiedImageURL! as String;
            }
            
            timelineDetail.tweaksList = self.tweaksList
            timelineDetail.tweakUserComments = tweak.tweakUserComments! as String
            self.navigationController?.pushViewController(timelineDetail, animated: true);
        }
        if tableView == self.mealTypeTableView {
            let cellDict = self.mealTypeArray[indexPath.row];
            self.copyThisMealParams["mealType"] = cellDict["value"] as! Int as AnyObject
            self.mealTypeTableView.reloadData()

        }
    }
    
    //    // ExpandPieChartDelegate methods
    //
    //    func prevWeekPieChartTapped(_ cell: ReportsTableViewCell) {
    //        self.myIndex = cell.cellIndexPath
    //        self.whichPieChart = "Prev"
    //        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
    //    }
    //
    //    func nextWeekPieChartTapped(_ cell: ReportsTableViewCell) {
    //        self.myIndex = cell.cellIndexPath
    //        self.whichPieChart = "Next"
    //        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
    //    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "ExpandPieChart" {
    //            let destination = segue.destination as! ExpandedPieChart
    //            let cellDict = self.tableArray[self.myIndex]
    //            self.dateFormat.dateFormat = "yyyy-MM-dd"
    //
    //            if self.whichPieChart == "Prev" {
    //                let prevStartWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportStartDate"] as! String)
    //                let prevEndWeek = self.dateFormat.date(from: cellDict["PreviousWeek"]?["reportEndDate"] as! String)
    //
    //                self.dateFormat.dateFormat = "dd MMM yyyy"
    //                let prevStartDate = self.dateFormat.string(from: prevStartWeek!)
    //                let prevEndDate = self.dateFormat.string(from: prevEndWeek!)
    //
    //                destination.reports = bundle.localizedString(forKey: "previous_weeks_report", value: nil, table: nil) + " \(prevStartDate)" + bundle.localizedString(forKey: "to", value: nil, table: nil) +  "  \(prevEndDate)"
    //                var prevValues = cellDict["PreviousWeek"] as! [String:AnyObject]
    //                var prevCarbStr = prevValues["pieValues"]?["Carbs"]as AnyObject as! String
    //                prevCarbStr = prevCarbStr.replacingOccurrences(of: "%", with: "")
    //
    //                var prevFatStr = prevValues["pieValues"]?["Fats"]as AnyObject as! String
    //                prevFatStr = prevFatStr.replacingOccurrences(of: "%", with: "")
    //
    //                var othersStr = prevValues["pieValues"]?["Others"]as AnyObject as! String
    //                othersStr = othersStr.replacingOccurrences(of: "%", with: "")
    //
    //                var prevProteinStr = prevValues["pieValues"]?["Proteins"]as AnyObject as! String
    //                prevProteinStr = prevProteinStr.replacingOccurrences(of: "%", with: "")
    //
    //                destination.carb = prevCarbStr
    //                destination.fat = prevFatStr
    //                destination.fibre = othersStr
    //                destination.protein = prevProteinStr
    //
    //            } else {
    //
    //                let nextStartWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportStartDate"] as! String)
    //                let nextEndWeek = self.dateFormat.date(from: cellDict["NextWeek"]?["reportEndDate"] as! String)
    //                self.dateFormat.dateFormat = "dd MMM yyyy"
    //                let nextStartDate = self.dateFormat.string(from: nextStartWeek!)
    //                let nextEndDate = self.dateFormat.string(from: nextEndWeek!)
    //                destination.reports =  bundle.localizedString(forKey: "next_weeks_report", value: nil, table: nil)  + " \(nextStartDate) " +  bundle.localizedString(forKey: "to", value: nil, table: nil) + " \(nextEndDate)"
    //
    //                var nextValues = cellDict["NextWeek"] as! [String:AnyObject]
    //                var nextCarb = nextValues["pieValues"]?["Carbs"]as AnyObject as! String
    //                nextCarb = nextCarb.replacingOccurrences(of: "%", with: "")
    //
    //                var nextFat = nextValues["pieValues"]?["Fats"]as AnyObject as! String
    //                nextFat = nextFat.replacingOccurrences(of: "%", with: "")
    //
    //                var nextFibre = nextValues["pieValues"]?["Others"]as AnyObject as! String
    //                nextFibre = nextFibre.replacingOccurrences(of: "%", with: "")
    //
    //                var nextProtein = nextValues["pieValues"]?["Proteins"]as AnyObject as! String
    //                nextProtein = nextProtein.replacingOccurrences(of: "%", with: "")
    //
    //                destination.carb = nextCarb
    //                destination.fat = nextFat
    //                destination.fibre = nextFibre
    //                destination.protein = nextProtein
    //
    //            }
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
