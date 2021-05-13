//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

//struct Colors {
//    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
//    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
//}
//
//struct Style {
//    static var bgColor = UIColor.white
//    static var monthViewLblColor = UIColor.purple
//    static var monthViewBtnRightColor = UIColor.black
//    static var monthViewBtnLeftColor = UIColor.black
//    static var activeCellLblColor = UIColor.white
//    static var activeCellLblColorHighlighted = UIColor.black
//    static var weekdaysLblColor = UIColor.black
//
//    static func themeDark(){
//        bgColor = Colors.darkGray
//        monthViewLblColor = UIColor.white
//        monthViewBtnRightColor = UIColor.white
//        monthViewBtnLeftColor = UIColor.white
//        activeCellLblColor = UIColor.white
//        activeCellLblColorHighlighted = UIColor.black
//        weekdaysLblColor = UIColor.white
//    }
//
//    static func themeLight(){
//        bgColor = UIColor.white
//        monthViewLblColor = UIColor.black
//        monthViewBtnRightColor = UIColor.black
//        monthViewBtnLeftColor = UIColor.black
//        activeCellLblColor = UIColor.black
//        activeCellLblColorHighlighted = UIColor.white
//        weekdaysLblColor = UIColor.black
//    }
//}

protocol ReloadTweakTrendsView {
    func reloadCalendarView(dt: String)
    func getBottomTrendsData(startDate: String, endDate: String)
}

class TAECalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TAEMonthViewDelegate {
    var thirtyDaysfromNow: NSDate {
        return NSCalendar.current.date(byAdding: .day, value: 30, to: Date())! as NSDate
    }
    var delegate: ReloadTweakTrendsView?
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var selectedDate = 0
    var presentYear = 0
    var todaysDate = 0
    var thirtyTHDay = 0
    var currentDate = ""
    var currentMonth = 0
    var getNumberOfDays = 0
    var firstWeekDayOfMonth = 0
    var index = 0
    var clubMemberExpDate = 0//(Sunday-Saturday 1-7)
    var dataArray = [[String: Int?]]() {
        didSet {
            self.myCollectionView.reloadData()
        }
    }
    enum MyTheme {
        case light
        case dark
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func thirtyDaysFromNow() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dateStr = formatter.string(from: self.thirtyDaysfromNow as Date)
        self.thirtyTHDay = Int(dateStr)!
        
        
        
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<8 {
        (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    @objc func updateCollectionView(_ notification: Notification) {
        self.dataArray = notification.object as! [[String: Int?]]
    }
    
    func initializeView() {
        NotificationCenter.default.addObserver(self, selector: #selector(TAECalendarView.updateCollectionView(_:)), name: NSNotification.Name(rawValue: "MONTHLY_TOP_DATA"), object: nil)
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
//        firstWeekDayOfMonth=getFirstWeekDay() - 1
        
        firstWeekDayOfMonth = getFirstWeekDay() == 1 ? 7 : getFirstWeekDay() - 1
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        self.thirtyDaysFromNow()
        currentDate = Date().dateStringWithFormat(format: "yyyy-MM-dd")
        let currMonArray = currentDate.components(separatedBy: "-")
        currentMonth = Int(currMonArray[1])!
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "Cell")
        if currentYear == presentYear && currentMonthIndex == presentMonthIndex {
            monthView.btnRight.isUserInteractionEnabled = false
            monthView.btnRight.setImage(UIImage.init(named: "cal_right_arrow"), for: .normal)

        } else {
            monthView.btnRight.isUserInteractionEnabled = true
            monthView.btnRight.setImage(UIImage.init(named: "cal_right_arrow-1"), for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count > 0 {
            return dataArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCVCell
        //cell.backgroundColor=UIColor.clear
        cell.lbl.textColor = Style.activeCellLblColor
        cell.dotImageView.isHidden = false
        cell.emoji.isHidden = true
        let itemDict = self.dataArray[indexPath.item]
        for (key,val) in itemDict {
            if key.contains("-") {
            let keyArray = key.components(separatedBy: "-")
                let keyDate = key.date!
                let keyString = keyArray[1].deletingPrefix("0")
                if currentMonthIndex == currentMonth {
                    if Int(keyString)! <= currentMonthIndex && (keyDate <= self.currentDate.date! )   {
                        index = indexPath.item
                        cell.backgroundColor = UIColor.groupTableViewBackground
                        cell.layer.borderWidth = 1
                        cell.layer.borderColor = UIColor.clear.cgColor
                        cell.dotImageView.isHidden = false
                        cell.lbl.text = keyArray.last?.deletingPrefix("0")
                        cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                        cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                        cell.emoji.isHidden = true
                        cell.calorieLbl.isHidden = false
                        cell.lbl.isHidden = false

                    } else {
                        cell.backgroundColor = UIColor.clear
                        cell.layer.borderWidth = 1
                        cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                        cell.lbl.text = keyArray.last?.deletingPrefix("0")
                        //cell.calorieLbl.text = ""
                        cell.emoji.isHidden = true
                        cell.dotImageView.isHidden = true
                        cell.calorieLbl.isHidden = true
                        cell.lbl.isHidden = false

                        

                    }
                } else {
                    cell.backgroundColor = UIColor.groupTableViewBackground
                    cell.layer.borderWidth = 1
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.dotImageView.isHidden = false
                    cell.lbl.isHidden = false
                    cell.lbl.text = keyArray.last?.deletingPrefix("0")
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                    cell.emoji.isHidden = true
                    cell.calorieLbl.isHidden = false

                }
               
               
            } else if key.contains("_") {
                cell.backgroundColor = UIColor.clear
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                cell.emoji.image = val ?? 0 >= 0 ? UIImage.init(named: "smily_emoji") : UIImage.init(named: "sad_emoji")
                cell.dotImageView.isHidden = true
                cell.emoji.isHidden = false
                cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                cell.calorieLbl.isHidden = true
                cell.lbl.isHidden = true
                if currentMonthIndex == currentMonth {

                if indexPath.item == 7 && (0...7).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if indexPath.item == 15 && (8...15).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if  indexPath.item == 23 && (16...23).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if indexPath.item == 31 && (24...31).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if indexPath.item == 39 && (32...39).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if indexPath.item == 47 && (40...47).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else if indexPath.item == 55 && (48...55).contains(index) {
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.isHidden = false
                    cell.emoji.isHidden = false
                    cell.calorieLbl.text = val ?? 0 > 0 ? "+\(val ?? 0)" : "\(val ?? 0)"
                    cell.calorieLbl.textColor = val ?? 0 >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
                } else {
                    cell.emoji.isHidden = true
                    cell.dotImageView.isHidden = true
                    cell.calorieLbl.text = ""
                    cell.calorieLbl.isHidden = true

                }
                } else {
                    cell.calorieLbl.isHidden = false
                }
//                if  indexPath.item > index {
//                    cell.emoji.isHidden = true
//                    cell.calorieLbl.text = ""
//                    cell.calorieLbl.isHidden = true
//                }

            }
        }
//                if indexPath.item <= firstWeekDayOfMonth  - 2  {
//
//                    cell.backgroundColor = .clear
//                } else {
//                    //self.getNumberOfDays += 1
//                
//                    cell.backgroundColor = UIColor.groupTableViewBackground
//                    }
//                }

//        if indexPath.item <= firstWeekDayOfMonth  - 2  {
//            cell.isHidden=true
//        } else if indexPath.item < 7 {
//            let calcDate = indexPath.row-firstWeekDayOfMonth+2
//            cell.isHidden=false
//            cell.lbl.text="\(calcDate)"
//            let upperLimitDate = todaysDate
//            if calcDate < todaysDate + 1 && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
//                cell.isUserInteractionEnabled=false
//                //cell.lbl.textColor = UIColor.lightGray
//                monthView.btnRight.isHidden = (currentMonthIndex == presentMonthIndex && currentYear == presentYear)
////                monthView.btnRight.isHidden = false
////                monthView.btnLeft.isHidden = false
//            }
////            else if indexPath.item > upperLimitDate + 1 && currentYear == presentYear && currentMonthIndex != presentMonthIndex {
////                cell.isUserInteractionEnabled=false
////                //cell.lbl.textColor = UIColor.lightGray
////                monthView.btnRight.isHidden = true
////            }
////            else {
////                cell.isUserInteractionEnabled=true
////               // cell.lbl.textColor = Style.activeCellLblColor
////            }
//        } else  {
//            var calcDate = 0
//            calcDate = indexPath.row - 1 - firstWeekDayOfMonth + 2
//
//            if indexPath.item == 7 || indexPath.item == 15 || indexPath.item == 23 || indexPath.item == 31 {
//                cell.emoji.image = UIImage.init(named: "grinning-face-emoji")
//                cell.dotImageView.isHidden = true
//                cell.emoji.isHidden = false
//
//                //cell.isHidden=true
//
//            } else {
//            cell.isHidden=false
//            cell.lbl.text="\(calcDate)"
//            let upperLimitDate = todaysDate
//            if calcDate < todaysDate + 1 && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
//                cell.isUserInteractionEnabled=false
//                //cell.lbl.textColor = UIColor.lightGray
//                monthView.btnRight.isHidden = (currentMonthIndex == presentMonthIndex && currentYear == presentYear)
////                monthView.btnRight.isHidden = false
////                monthView.btnLeft.isHidden = false
//            }
////            else if indexPath.item > upperLimitDate + 1 && currentYear == presentYear && currentMonthIndex != presentMonthIndex {
////                cell.isUserInteractionEnabled=false
////                //cell.lbl.textColor = UIColor.lightGray
////                monthView.btnRight.isHidden = true
////            }
////            else {
////                cell.isUserInteractionEnabled=true
////               // cell.lbl.textColor = Style.activeCellLblColor
////            }
//        }
//        }
        return cell
    }
    func convertDateToLocalTime(_ date: Date) -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
            return Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath) as! DateCVCell
        if cell.calorieLbl.isHidden == true {
            return
        }
        cell.backgroundColor=UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var startWeek = ""
        var endWeek = ""
        var itemDict = self.dataArray[indexPath.item]

       
        if indexPath.item == 6 || indexPath.item == 14 || indexPath.item == 22 || indexPath.item == 30 || indexPath.item == 38 || indexPath.item == 46 || indexPath.item == 54 {
            itemDict = self.dataArray[indexPath.item - 1]
        }
       
        for (key, _) in itemDict {
            if key.contains("-") {

            let now = convertDateToLocalTime(df.date(from: key)!)

             startWeek = convertDateToLocalTime(now.startOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
             endWeek = convertDateToLocalTime(now.endOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")

            print("Local time is: \(now)")

            print("Start of week is: \(startWeek)")
            print("End of week is: \(endWeek)")
            } else if key.contains("_") {
                 itemDict = self.dataArray[indexPath.item - 2]

                for (key, _) in itemDict {
                    if key.contains("-") {

                    let now = convertDateToLocalTime(df.date(from: key)!)

                     startWeek = convertDateToLocalTime(now.startOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")
                     endWeek = convertDateToLocalTime(now.endOfWeek!).dateStringWithFormat(format: "yyyy-MM-dd")

                    print("Local time is: \(now)")

                    print("Start of week is: \(startWeek)")
                    print("End of week is: \(endWeek)")
                    }
                }
            }
        }
        self.delegate?.getBottomTrendsData(startDate: startWeek, endDate: endWeek)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_BOTTOM_TRENDS"), object: [startWeek, endWeek]);
//        let cellViews: [UIView] = cell!.subviews
//        for view in cellViews {
//            if view.isKind(of: UILabel.self) {
//                let lbl = view as! UILabel
//                self.selectedDate = Int(lbl.text!)!
//                lbl.textColor = UIColor.white
//
//            }
//        }
      //  let lbl = cell?.subviews[0] as! UILabel
        //self.selectedDate = Int(lbl.text!)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DATE_SELECTED"), object: nil);
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        let itemDict = self.dataArray[indexPath.item]
        for (key,val) in itemDict {
            if key.contains("-") {
            let keyArray = key.components(separatedBy: "-")
                let keyDate = key.date!
                let keyString = keyArray[1].deletingPrefix("0")
                if currentMonthIndex == currentMonth {
                if Int(keyString)! <= currentMonthIndex && (keyDate <= self.currentDate.date! ) {
                    cell?.backgroundColor=UIColor.groupTableViewBackground

                } else {
                    cell?.backgroundColor=UIColor.clear

                }
                } else {
                    cell?.backgroundColor=UIColor.groupTableViewBackground

                }

            } else if key.contains("_") {
                cell?.backgroundColor=UIColor.clear


            }
        }
//        let lbl = cell?.subviews[0] as! UILabel
//        lbl.textColor = Style.activeCellLblColor
//        let cellViews: [UIView] = cell!.subviews
//        for view in cellViews {
//            if view.isKind(of: UILabel.self) {
//                let lbl = view as! UILabel
//                self.selectedDate = Int(lbl.text!)!
//                lbl.textColor = Style.activeCellLblColor
//
//            }
//        }


    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/8 - 8
        let height: CGFloat = 44
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        selectedDate = 0
        currentMonthIndex=monthIndex+1
        currentYear = year
        index = 0

        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        //firstWeekDayOfMonth=getFirstWeekDay() - 1
        firstWeekDayOfMonth = getFirstWeekDay() == 1 ? 7 : getFirstWeekDay() - 1
        
        //myCollectionView.reloadData()
//        monthView.btnRight.isUserInteractionEnabled = true
//        monthView.btnRight.setImage(UIImage.init(named: "cal_right_arrow-1"), for: .normal)
//        monthView.btnRight.isHidden = (currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        if currentYear == presentYear && currentMonthIndex == presentMonthIndex {
            monthView.btnRight.isUserInteractionEnabled = false
            monthView.btnRight.setImage(UIImage.init(named: "cal_right_arrow"), for: .normal)

        } else {
            monthView.btnRight.isUserInteractionEnabled = true
            monthView.btnRight.setImage(UIImage.init(named: "cal_right_arrow-1"), for: .normal)
        }
        var currentMonth = ""
        if currentMonthIndex < 10 {
            currentMonth = "0\(currentMonthIndex)"
        } else {
            currentMonth = "\(currentMonthIndex)"
        }
        self.delegate?.reloadCalendarView(dt: "\(currentYear)\(currentMonth)")
        
        //getMonthlyTrendsTop(dt: "\(currentYear)\(currentMonth)")
//        let todate = "\(currentYear)-\(currentMonthIndex)-01".date
//        if firstWeekDayOfMonth == 7 {
//            let todate = todate?.dayBefore.dateStringWithFormat(format: "yyyy-MM-dd")
//            
//        }
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 5).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 5).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        weekdaysView.addBorders(color: .lightGray, margins: 0, borderLineSize: 0.5, attribute: .top)

        
    }
    
    let monthView: TAEMonthView = {
        let v=TAEMonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: TAEWeekdaysView = {
        let v=TAEWeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.groupTableViewBackground
//        layer.cornerRadius=10
//        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        addSubview(dotImageView)
        addSubview(calorieLbl)
        addSubview(emoji)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: dotImageView.topAnchor).isActive=true
        //lbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dotImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        dotImageView.bottomAnchor.constraint(equalTo: calorieLbl.topAnchor).isActive=true
        dotImageView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        dotImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        calorieLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        calorieLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        calorieLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        //calorieLbl.heightAnchor.constraint(equalToConstant: 15).isActive = true

        emoji.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive=true
        emoji.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        emoji.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        emoji.bottomAnchor.constraint(equalTo: calorieLbl.topAnchor, constant: 2).isActive=true
        emoji.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 15)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let dotLbl: UILabel = {
        let label = UILabel()
        label.text = ".\n"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font=UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = .green
        label.textColor=Colors.darkRed
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let calorieLbl: UILabel = {
        let label = UILabel()
        label.text = "300"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font=UIFont.boldSystemFont(ofSize: 10)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let dotImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFit
        imgV.image = UIImage.init(named: "dot")
    
        return imgV
    }()
    
    let emoji: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFit
    
        return imgV
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
//extension Date {
//    var weekday: Int {
//        return Calendar.current.component(.weekday, from: self)
//    }
//
//    var firstDayOfTheMonth: Date {
//        
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
//    }
//}
//
////get date from string
//extension String {
//    static var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
//    
//    var date: Date? {
//        return String.dateFormatter.date(from: self)
//    }
//}













