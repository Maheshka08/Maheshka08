//
//  TimelinesViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AudioToolbox
import GoogleMobileAds
import Firebase
import FirebaseDatabase

class TimelinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, GADInterstitialDelegate, ExpandPieChartDelegate {
    @IBOutlet var reportsTableView: UITableView!
     let rc = UIRefreshControl()
    var delegates : TimelineTableViewCell? =  nil;
        lazy var adBannerView: GADBannerView = {
            let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait);
            adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
            adBannerView.delegate = self;
            adBannerView.rootViewController = self;
            
            return adBannerView;
        }()
    
    @IBOutlet var reportsInfoBtn: UIBarButtonItem!
    var whichPieChart: String = ""
    var myIndex: Int = 0
    var userReportsRef : DatabaseReference!
    var interstitial: GADInterstitial?;
    var tweak : NSDictionary!;
    @IBOutlet var timelinesTableView: UITableView!;
    var timeLineCell : TimelineTableViewCell! = nil;
    var timeLineCellAd : TimelineTableViewCellWithAd! = nil;
    var tweaksList : [AnyObject]?;
    var comingFromSettings : Bool = false;
    var dailyTipsDictionary : [String : String] = [:]
    var tableArray = [[String:AnyObject]]()
    var tableArray1 = [[String:String]]()
    var tableArray2 = [[String:String]]()
    var tableArray3 = [[String:String]]()
    var tableArrayVal1 = [String]()
    var tableArrayVal2 = [String]()
    var tableArrayVal3 = [String]()
    var tableArrayKey1 = [String]()
    var tableArrayKey2 = [String]()
    var tableArrayKey3 = [String]()
    var datesArray = [String]()
    let dateFormat = DateFormatter()
    
    @IBOutlet weak var reportsInfoView: UIView!
    
    @IBOutlet weak var tweakSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reportsInfoView.layer.cornerRadius = 5
        self.reportsInfoView.layer.borderWidth = 2
        self.reportsInfoView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor

       
         self.tweakSegment.layer.cornerRadius = 5;
        self.timelinesTableView.register(UINib.init(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCell");
        self.timelinesTableView.register(UINib.init(nibName: "TimelineTableViewCellWithAd", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCellWithAd");
        MBProgressHUD.showAdded(to: self.view, animated: true);

        self.reloadTimelines()
        
    }
    
    @IBAction func reportsInfoAction(_ sender: Any) {
        
        if self.reportsInfoView.isHidden == true{
            self.reportsInfoView.isHidden = false
        }else{
            self.reportsInfoView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        tweakSegment.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false;
        if tweakSegment.selectedSegmentIndex == 0 {
            timelinesTableView.isHidden = false;
            self.reportsTableView.isHidden = true
            self.reportsInfoBtn.isEnabled = false
            self.reportsInfoView.isHidden = true
            
        
        } else if tweakSegment.selectedSegmentIndex == 1 {
            self.timelinesTableView.isHidden = true;
            self.reportsTableView.isHidden = false
            self.reportsInfoBtn.isEnabled = true
        
        }

        
        timelinesSync();
        if(comingFromSettings == true){
            UIView.animate(withDuration: 1.0) {
                self.tabBarController?.tabBar.isHidden = false;
            }
            comingFromSettings = false;
        }
         NotificationCenter.default.addObserver(self, selector: #selector(TimelinesViewController.reloadTweaks), name: NSNotification.Name(rawValue: "NEWREMINDER"), object: nil)
        
        //TWEAKID
        NotificationCenter.default.addObserver(self, selector: #selector(TimelinesViewController.reloadTimelines), name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
        
    }
    
    func reloadTweaks() {
        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
       
        self.timelinesTableView.reloadData();

    }
    
    func reloadTimelines(){
        let userdefaults = UserDefaults.standard
        

        if let savedValue = userdefaults.string(forKey: "USERBLOCKED"){
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "NO EDR")
            return
        }else{
            tweaksList = [AnyObject]()
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            
            APIWrapper.sharedInstance.getTimelines(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
                
                //DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    let tweaks : [AnyObject]? = response[TweakAndEatConstants.TWEAKS] as? [AnyObject];
                    if(tweaks != nil) {
                        for tweak in tweaks! {
                            DataManager.sharedInstance.saveTweak(tweak: tweak as! NSDictionary);
                        }
                        // }
                        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
                        
                        //DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.timelinesTableView.reloadData();
                        //}
                        if ((UserDefaults.standard.value(forKey: "TWEAK_ID")) != nil){
                            let tweakObject : TBL_Tweaks? = DataManager.sharedInstance.fetchTWEAKWithId(value: UserDefaults.standard.value(forKey: "TWEAK_ID") as Any as! NSNumber);
                            if (tweakObject != nil) {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                                let timelineDetail : TimelinesDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "timelineDetailViewController") as! TimelinesDetailsViewController;
                                timelineDetail.timelineDetails = tweakObject
                                UserDefaults.standard.removeObject(forKey: "TWEAK_ID");
                                self.navigationController?.pushViewController(timelineDetail, animated: true);
                            }
                            
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "NO EDR")
                    }
                    
                }
                
                
                
            }) { (error : NSError!) -> (Void) in
                MBProgressHUD.hide(for: self.view, animated: true);
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "NO EDR")
                MBProgressHUD.hide(for: self.view, animated: true);
            }
        }
    
        
        self.tweaksList = DataManager.sharedInstance.fetchTweaks();
        MBProgressHUD.hide(for: self.view, animated: true);
        self.timelinesTableView.reloadData();


    }
    

    @IBAction func tweaksSegAct(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            timelinesTableView.isHidden = false;
            self.reportsInfoBtn.isEnabled = false
            self.reportsTableView.isHidden = true
            self.reportsInfoView.isHidden = true
            if(self.tweaksList?.count == 0){
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "NO EDR")
                
            }
        
        } else if (sender.selectedSegmentIndex == 1) {

            self.reportsInfoBtn.isEnabled = true
           timelinesTableView.isHidden = true;
            self.reportsTableView.isHidden = false
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
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "NO REPORTS")
                        self.reportsInfoView.isHidden = false
                        
                    }
                    
                }
            })
            
        }
 
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

    
    func infOButtonClicked(){
        if self.reportsInfoView.isHidden == true{
        self.reportsInfoView.isHidden = false
        }else{
         self.reportsInfoView.isHidden = true
        }
    }
    
    
    func timelinesSync(){
        rc.addTarget(self, action: #selector(TimelinesViewController.refresh(refreshControl:)), for: UIControlEvents.valueChanged);
        if #available(iOS 10.0, *) {
            timelinesTableView.refreshControl = rc;
        } else {
            // Fallback on earlier versions
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timelinesTableView {
            if(self.tweaksList != nil) {
                return tweaksList!.count;
            } else {
                return 0;
            }
        }
        if tableView == self.reportsTableView {
            return self.datesArray.count
        }
       return 0
    }
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing();
    }
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var timelineCell : TimelineTableViewCell;
        var timelineCellWithAd : TimelineTableViewCellWithAd;
        
        var cell : UITableViewCell!;

        if tableView == timelinesTableView {

                if indexPath.row % 2 != 0{
            let identifier = "TimelineTableViewCellWithAd";
            
            timelineCellWithAd = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as! TimelineTableViewCellWithAd;
            
            let tweak : TBL_Tweaks = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            
            if  tweak.tweakModifiedImageURL == "" {
                timelineCellWithAd.profileImageView.sd_setImage(with: URL(string: tweak.tweakOriginalImageURL ?? ""));
    
                
            }
            else {
                timelineCellWithAd.profileImageView.sd_setImage(with: URL(string: tweak.tweakModifiedImageURL ?? ""));
                
            }
           
            if (adBannerView.superview == nil) {
                adBannerView.load(GADRequest());
            }
            timelineCellWithAd.adMobView .addSubview(adBannerView);
            if(tweak.tweakDateUpdated == nil || tweak.tweakDateUpdated == "") {
                timelineCellWithAd.timelineDate.text = tweak.tweakDateCreated;
            } else {
                timelineCellWithAd.timelineDate.text = tweak.tweakDateUpdated;
            }
            timelineCellWithAd.timelineTitle.text = tweak.tweakSuggestedText;
            timelineCellWithAd.starRatingView.value = CGFloat(tweak.tweakRating);
            
            timelineCellWithAd.borderView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor;
            timelineCellWithAd.ratingLabel.text = "\(tweak.tweakRating) / 5.0";
            
            timelineCellWithAd.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateCreated!);
            
            timelineCellWithAd.selectionStyle = UITableViewCellSelectionStyle.none;
            cell = timelineCellWithAd;
            
            
        }
        else{
            
            let identifier = "TimelineTableViewCell";
            
            timelineCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as! TimelineTableViewCell;

            
            let tweak : TBL_Tweaks = self.tweaksList![indexPath.row] as! TBL_Tweaks;
            
            if  tweak.tweakModifiedImageURL == "" {
                timelineCell.profileImageView.sd_setImage(with: URL(string: tweak.tweakOriginalImageURL ?? ""));
                
            }
            else {
                timelineCell.profileImageView.sd_setImage(with: URL(string: tweak.tweakModifiedImageURL ?? ""));
                
            }
            
            
            if(tweak.tweakDateUpdated == nil || tweak.tweakDateUpdated == "") {
                timelineCell.timelineDate.text = tweak.tweakDateCreated;
            } else {
                timelineCell.timelineDate.text = tweak.tweakDateUpdated;
            }
            timelineCell.timelineTitle.text = tweak.tweakSuggestedText;
            timelineCell.starRatingView.value = CGFloat(tweak.tweakRating);
            
            timelineCell.borderView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor;
            timelineCell.ratingLabel.text = "\(tweak.tweakRating) / 5.0";
            
            timelineCell.timelineDate.text = TweakAndEatUtils.localTimeFromTZ(dateString: tweak.tweakDateCreated!);
            
            timelineCell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell = timelineCell;
            
        }
            return cell;
        }
        if tableView == self.reportsTableView {
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
            cell.prevReportsLbl.text =  "Previous week's report from \(prevStartDate) to \(prevEndDate)"
            cell.nextReportsLbl.text =  "Next week's report from \(nextStartDate) to \(nextEndDate)"
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
            
            
            cell.prevWeekPieChartView.segments = [
                Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name:"Carbs", value: CGFloat(NumberFormatter().number(from: prevCarbStr)!)),
                Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: "Fats", value: CGFloat(NumberFormatter().number(from: prevFatStr)!)),
                Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: "Others", value: CGFloat(NumberFormatter().number(from: othersStr)!)),
                Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: "Proteins", value: CGFloat(NumberFormatter().number(from: prevProteinStr)!))
            ]
            cell.nextWeekPieChartView.segments = [
                Segment(color: UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), name:"Carbs", value: CGFloat(NumberFormatter().number(from: nextCarb)!)),
                Segment(color: UIColor(red:255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0), name: "Fats", value: CGFloat(NumberFormatter().number(from: nextFat)!)),
                Segment(color: UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0), name: "Others", value: CGFloat(NumberFormatter().number(from: nextFibre)!)),
                Segment(color: UIColor(red: 0.0/255.0, green: 155.0/255.0, blue: 58.0/255.0, alpha: 1.0), name: "Proteins", value: CGFloat(NumberFormatter().number(from: nextProtein)!))
            ]
            
            
            return cell;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == timelinesTableView {
        if indexPath.row % 2 != 0 {
            return 204;
        }
        else
        {
            return 149;
        }
        }
        if tableView == self.reportsTableView {
            return 437
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.reportsTableView {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == timelinesTableView {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let timelineDetail : TimelinesDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "timelineDetailViewController") as! TimelinesDetailsViewController;
        timelineDetail.timelineDetails = self.tweaksList![indexPath.row] as! TBL_Tweaks;
        self.navigationController?.pushViewController(timelineDetail, animated: true);
        }
    }
    
    // ExpandPieChartDelegate methods
    
    func prevWeekPieChartTapped(_ cell: ReportsTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.whichPieChart = "Prev"
        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
    }
   
    func nextWeekPieChartTapped(_ cell: ReportsTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.whichPieChart = "Next"
        self.performSegue(withIdentifier: "ExpandPieChart", sender: self)
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
                
                destination.reports =  "Previous week's reports from \(prevStartDate) to \(prevEndDate)"
            
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
                 destination.reports =  "Next week's reports from \(nextStartDate) to \(nextEndDate)"

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
