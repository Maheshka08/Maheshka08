//
//  TweakTrendReportViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 02/04/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit
import Alamofire

class TweakTrendReportViewController: UIViewController, ReloadTweakTrendsView {
    
    func reloadCalendarView(dt: String) {
        currMonInString = String(dt.suffix(2))
        currYrInString = String(dt.prefix(4))
        
        
        //self.getCalAssume(dt: "\(currYrInString)\(currMonInString)")
        self.getMonthlyTrendsTop(dt: dt)

    }
    
    func getBottomTrendsData(startDate: String, endDate: String) {
        
    }
    
    @IBAction func switchButtonTapped(_ sender: Any) {
        var calsAssume = 0
        if self.switchButton.currentImage == UIImage.init(named: "off_btn")  {
            calsAssume = 1
            self.switchButton.setImage(UIImage.init(named: "on_btn"), for: .normal)
        } else {
            calsAssume = 0
            self.switchButton.setImage(UIImage.init(named: "off_btn"), for: .normal)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_CAL_ASSUME, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: [
            "calsAssume": calsAssume
        ] as [String : AnyObject] , success: { response in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true);

            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
//                var currentMonth = ""
//                if self.currentMonthIndex < 10 {
//                    currentMonth = "0\(self.currentMonthIndex)"
//                } else {
//                    currentMonth = "\(self.currentMonthIndex)"
//                }
                
                self.getCalAssume(dt: "\(self.currYrInString)\(self.currMonInString)")
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
             //TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            
        })
    }
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var assumeStandardView: UIView!
    @IBOutlet weak var calendarLabelView: UIView!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var approxCalorieLeftView: UIView!
    var currMonInString = ""
    var currYrInString = ""
    var currentMonthIndex = 0
    var currentYear = 0
    var todaysDate = 0
    var toDate = ""
    var scrollUpOnce = 0
    var calendarViewHeight: CGFloat = 0.0
    var firstWeekDayOfMonth = 0
    @IBOutlet weak var approxCalorieLeftLabel: UILabel!
    var monthlyTrendsBottomData: MonthlyTrendsBottom!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    let calView: TAECalendarView = {
        let v=TAECalendarView(theme: TAECalendarView.MyTheme.light)
        
          v.translatesAutoresizingMaskIntoConstraints=false
          return v
      }()
    @IBOutlet weak var calendarView: UIView!
    

    @IBOutlet weak var assumeStandardViewHeightConstraint: NSLayoutConstraint!
    

    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func getCalAssume(dt: String) {
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.GET_CAL_ASSUME, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            print(responseDic)
            if responseDic["callStatus"] as! String == "GOOD" {
                if responseDic["calsAssume"] as! Int == 1 {
                    self.switchButton.setImage(UIImage.init(named: "on_btn"), for: .normal)
                } else {
                    self.switchButton.setImage(UIImage.init(named: "off_btn"), for: .normal)
                }
                self.getMonthlyTrendsTop(dt: dt)

            }
            
            
    },
        failure : { error in
            
           
        })
    }
  
    @objc func scrollHome(notification : NSNotification) {
        let notify = notification.object as! Bool
        if notify == false {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                self.calendarViewHeightConstraint.constant = 0
                self.calendarLabelView.isHidden = true
                self.calView.isHidden = true
                self.view.layoutIfNeeded()

            }) { _ in
                    self.scrollUpOnce += 1
                    self.calendarView.isHidden = true
                    if self.scrollUpOnce == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_TABLE_VIEW_TO_TOP"), object: nil);
                    }


            }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                self.calendarViewHeightConstraint.constant = self.calendarViewHeight
                    
                    self.calendarView.isHidden = false

                self.view.layoutIfNeeded()

            }) { _ in
                    self.calendarLabelView.isHidden = false
                    self.calView.isHidden = false



            }
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.assumeStandardView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(TweakTrendReportViewController.scrollHome(notification:)), name: NSNotification.Name(rawValue: "SCROLL_MONTHLY_TOP_TRENDS"), object: nil);
        let txt = "*Net + / - calories each day/week.\nRecommended calories assumed on no tweak."
        self.calendarLabel.text = txt
        //self.calendarLabel.setLineHeight(lineHeight: 25, txt: txt)

        self.calendarLabel.numberOfLines = 0
        //self.calendarLabel.textAlignment = .left
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currMonInString = currentMonthIndex < 10 ? "0\(currentMonthIndex)" : "\(currentMonthIndex))"
        currYrInString = "\(currentYear)"
//        todaysDate = Calendar.current.component(.day, from: Date())
////        firstWeekDayOfMonth=getFirstWeekDay() - 1
//        firstWeekDayOfMonth = getFirstWeekDay() == 1 ? 7 : getFirstWeekDay() - 1
//        if firstWeekDayOfMonth == 7 {
//            toDate =
//        }
//        let calendar = NSCalendar.current
//        var startOfTheWeek: NSDate?
//        var endOfWeek: NSDate!
//        var interval = TimeInterval(0)
//
//        calendar.rangeOfUnit(.WeekOfMonth, startDate: &startOfTheWeek, interval: &interval, forDate: NSDate())
//        endOfWeek = startOfTheWeek!.addingTimeInterval(interval - 1)
        
        assumeStandardView.layer.cornerRadius = 15
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.calendarView.addSubview(calView)
        calView.topAnchor.constraint(equalTo: self.calendarView.topAnchor, constant: 10).isActive=true
        calView.rightAnchor.constraint(equalTo: self.calendarView.rightAnchor, constant: -12).isActive=true
        calView.leftAnchor.constraint(equalTo: self.calendarView.leftAnchor, constant: 12).isActive=true
        calView.bottomAnchor.constraint(equalTo: self.calendarLabelView.bottomAnchor, constant: 3).isActive=true
        calView.delegate = self
        let greenColor = #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1);
        let redColor = #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1);
        let excessText = "+"
        let deficitText = "-"
                
        let attrsString =  NSMutableAttributedString(string:txt);
        
        let rangeOfExcessText = (txt as NSString).range(of: excessText)
        if (rangeOfExcessText.length > 0) {
            attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:greenColor,range:rangeOfExcessText)
            attrsString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 22), range: rangeOfExcessText)
        }
        let rangeOfDeficitText = (txt as NSString).range(of: deficitText)
        if (rangeOfDeficitText.length > 0) {
            attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:redColor,range:rangeOfDeficitText)
            attrsString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 22), range: rangeOfDeficitText)
        }
                
        // set attributed text
        calendarLabel.attributedText = attrsString
        self.containerView.layer.cornerRadius = 15
        self.calendarView.layer.cornerRadius = 15
        self.calendarLabelView.layer.cornerRadius = 20
        self.calendarLabel.textAlignment = .center
        self.approxCalorieLeftLabel.layer.cornerRadius = 9
        self.approxCalorieLeftView.layer.cornerRadius = 15
        self.approxCalorieLeftLabel.clipsToBounds = true
        if UserDefaults.standard.value(forKey: "MEAN_CALORIES") != nil {
            self.approxCalorieLeftLabel.text = "\(String(describing: UserDefaults.standard.value(forKey: "MEAN_CALORIES") as! Int))   "
        }
        //getMonthlyTrendsBottom()
        var currentMonth = ""
        if currentMonthIndex < 10 {
            currentMonth = "0\(currentMonthIndex)"
        } else {
            currentMonth = "\(currentMonthIndex)"
        }
        
        //getCalAssume(dt: "\(currentYear)\(currentMonth)")
        getMonthlyTrendsTop(dt: "\(currentYear)\(currentMonth)")
        
        
        // Do any additional setup after loading the view.
    }
    
    func getMonthlyTrendsTop(dt: String) {
        self.getMonthlyTrendsTop(dt: dt) { result in
            switch result {
            
            case .success(let todo):
                if todo.callStatus == "GOOD" {
                if todo.data.count == 48 {
                    self.calendarViewHeightConstraint.constant = 460

                } else if todo.data.count == 40 {
                    self.calendarViewHeightConstraint.constant = 420

                } else if todo.data.count == 32 {
                    self.calendarViewHeightConstraint.constant = 380
                }
                    self.calendarViewHeight = self.calendarViewHeightConstraint.constant
                self.view.setNeedsLayout()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MONTHLY_TOP_DATA"), object: todo.data);
                var startWeek = ""
                var endWeek = ""
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let todoDict = todo.data.first as [String : Int?]?
                for (key, _) in todoDict! {
                    let now = self.convertDateToLocalTime(df.date(from: key)!)

                    startWeek = self.convertDateToLocalTime(now.startOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
                    endWeek = self.convertDateToLocalTime(now.endOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_BOTTOM_TRENDS"), object: [startWeek, endWeek]);
                }
                
                }

            case .failure( let error):
                print(error.localizedDescription)
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection and try again!")
            }
        }
    }
    
    func convertDateToLocalTime(_ date: Date) -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
            return Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date)!
    }
    
    func getMonthlyTrendsTop(dt: String, completion:@escaping (Result<MonthlyTrendsTop, AFError>)->Void) {
        let headers: HTTPHeaders = [
            "Authorization" : UserDefaults.standard.value(forKey: "userSession") as! String,
            "Content-Type": "application/json"]
        AF.request(URL(string: TweakAndEatURLConstants.GET_MONTLY_TRENDS_TOP)!, method: .post, parameters: [
            "mdate": dt] as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable { (response: DataResponse<MonthlyTrendsTop, AFError>) in
               completion(response.result)
           }
       }
    
//    func getMonthlyTrendsTop(dt: String) {
//        let headers: HTTPHeaders = [
//            "Authorization" : UserDefaults.standard.value(forKey: "userSession") as! String,
//            "Content-Type": "application/json"]
//        AF.request(URL(string: TweakAndEatURLConstants.GET_MONTLY_TRENDS_TOP)!, method: .post, parameters: [
//            "mdate": dt] as [String : AnyObject], encoding: JSONEncoding.default, headers: headers).responseData { response in
//            let decoder = JSONDecoder()
//            let todo: MonthlyTrendsTop = decoder.decodeResponse(from: response)
//            print(todo)
//                if todo.data.count == 48 {
//                    self.calendarViewHeightConstraint.constant = 430
//
//                } else if todo.data.count == 40 {
//                    self.calendarViewHeightConstraint.constant = 390
//
//                } else if todo.data.count == 32 {
//                    self.calendarViewHeightConstraint.constant = 350
//                }
//                self.view.setNeedsLayout()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MONTHLY_TOP_DATA"), object: todo.data);
//                var startWeek = ""
//                var endWeek = ""
//                let df = DateFormatter()
//                df.dateFormat = "yyyy-MM-dd"
//                let todoDict = todo.data.first as [String : Int?]?
//                for (key, _) in todoDict! {
//                    let now = self.convertDateToLocalTime(df.date(from: key)!)
//
//                    startWeek = self.convertDateToLocalTime(now.startOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
//                    endWeek = self.convertDateToLocalTime(now.endOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_BOTTOM_TRENDS"), object: [startWeek, endWeek]);
//                }
//
//
//
//        }
//    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
    
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func getMonthlyTrendsBottoma() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.GET_MONTLY_TRENDS_BOTTOM, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: [
            "sdate": "2021-02-08",
            "edate": "2021-02-14"
        ] as [String : AnyObject] , success: { response in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true);

            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
               
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
             //TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            
        })
        
    }
    
//    func getMonthlyTrendsTop() {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//
//        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.GET_MONTLY_TRENDS_TOP, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: [
//            "sdate": "2021-04-26",
//            "edate": "2021-06-06"
//        ] as [String : AnyObject] , success: { response in
//            print(response)
//            MBProgressHUD.hide(for: self.view, animated: true);
//
//
//            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
//            let responseResult = responseDic["callStatus"] as! String;
//            if  responseResult == "GOOD" {
//
//            }
//        }, failure : { error in
//            MBProgressHUD.hide(for: self.view, animated: true);
//
//            print("failure")
//             //TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
//
//        })
//
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.assumeStandardViewHeightConstraint.constant = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
