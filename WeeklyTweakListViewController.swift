//
//  WeeklyTweakListViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 02/04/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit
import Alamofire

class WeeklyTweakListViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var imagesArray = [String]()
    var srtDate = ""
    var eDate = ""
    var imageIndex = 0
    var dateInfo = ""
    var pullControl = UIRefreshControl()
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var eveningSnackLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var brunchLabel: UILabel!
    @IBOutlet weak var collectionViewForBreakfast: UICollectionView!
    @IBOutlet weak var noDataLabelForBreakfast: UILabel!
    

    @IBOutlet weak var collectionViewForBrunch: UICollectionView!
    @IBOutlet weak var noDataLabelForBrunch: UILabel!
    

    @IBOutlet weak var collectionViewForLunch: UICollectionView!
    @IBOutlet weak var noDataLabelForLunch: UILabel!
    

    @IBOutlet weak var collectionViewForEveningSnack: UICollectionView!
    @IBOutlet weak var noDataLabelForEveningSnack: UILabel!
    
     @IBOutlet weak var collectionViewForDinner: UICollectionView!
    @IBOutlet weak var noDataLabelForDinner: UILabel!

//    @IBOutlet weak var breakFastTextLbl: UILabel!
//    @IBOutlet weak var brunchTextLbl: UILabel!
//    @IBOutlet weak var lunchTextLbl: UILabel!
//    @IBOutlet weak var eveningSnackTextLbl: UILabel!
//    @IBOutlet weak var dinnerTextLbl: UILabel!
    var cellSection = 0

    
    var monthlyData: MonthlyTrendsBottom? {
        didSet {
            self.collectionViewForBreakfast.delegate = self
            self.collectionViewForBrunch.delegate = self
            self.collectionViewForLunch.delegate = self
            self.collectionViewForEveningSnack.delegate = self
            self.collectionViewForDinner.delegate = self
            self.collectionViewForBreakfast.dataSource = self
            self.collectionViewForBrunch.dataSource = self
            self.collectionViewForLunch.dataSource = self
            self.collectionViewForEveningSnack.dataSource = self
            self.collectionViewForDinner.dataSource = self
            self.collectionViewForBreakfast.reloadData()
            self.collectionViewForBrunch.reloadData()
            self.collectionViewForLunch.reloadData()
            self.collectionViewForEveningSnack.reloadData()
            self.collectionViewForDinner.reloadData()
            self.tableView.reloadData()
            let topRow = IndexPath(row: 0,
                                       section: 0)
                // 2
            self.tableView.scrollToRow(at: topRow,
                                           at: .top,
                                           animated: true)
//            self.collectionViewForBreakfast.scrollToItem(at: topRow,
//                                                         at: .top,
//                                                         animated: true)
//            self.collectionViewForBrunch.scrollToItem(at: topRow,
//                                                         at: .top,
//                                                         animated: true)
//            self.collectionViewForLunch.scrollToItem(at: topRow,
//                                                         at: .top,
//                                                         animated: true)
//            self.collectionViewForEveningSnack.scrollToItem(at: topRow,
//                                                         at: .top,
//                                                         animated: true)
//            self.collectionViewForDinner.scrollToItem(at: topRow,
//                                                         at: .top,
//                                                         animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewForBreakfast {
           return self.monthlyData?.data.breakfast.count ?? 0
        } else if collectionView == self.collectionViewForBrunch {
            return self.monthlyData?.data.brunch.count ?? 0
         } else if collectionView == self.collectionViewForLunch {
            return self.monthlyData?.data.lunch.count ?? 0
         } else if collectionView == self.collectionViewForEveningSnack {
            return self.monthlyData?.data.eveningSnack.count ?? 0
         } else if collectionView == self.collectionViewForDinner {
            return self.monthlyData?.data.dinner.count ?? 0
         }
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeeklyListCollectionViewCell
        if collectionView == self.collectionViewForBreakfast {
            let itemDict = (self.monthlyData?.data.breakfast[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val.imgs.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    //cell.calorieLabelTrends.text = ""
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"

                }
                cell.calorieLabelTrends.textColor = val.cals >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
            }
            
        } else if collectionView == self.collectionViewForBrunch {
            let itemDict = (self.monthlyData?.data.brunch[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val.imgs.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    //cell.calorieLabelTrends.text = ""
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                }
                cell.calorieLabelTrends.textColor = val.cals >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
            }
            
        } else if collectionView == self.collectionViewForLunch {
            let itemDict = (self.monthlyData?.data.lunch[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val.imgs.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    //cell.calorieLabelTrends.text = ""
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                }
                cell.calorieLabelTrends.textColor = val.cals >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
            }
            
        } else if collectionView == self.collectionViewForEveningSnack {
            let itemDict = (self.monthlyData?.data.eveningSnack[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val.imgs.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    //cell.calorieLabelTrends.text = ""
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                }
                cell.calorieLabelTrends.textColor = val.cals >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
            }
            
        } else if collectionView == self.collectionViewForDinner {
            let itemDict = (self.monthlyData?.data.dinner[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val.imgs.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    //cell.calorieLabelTrends.text = ""
                    cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                cell.calorieLabelTrends.text = val.cals > 0 ? "+\(val.cals)" : "\(val.cals)"
                }
                cell.calorieLabelTrends.textColor = val.cals >= 0 ? #colorLiteral(red: 0.07306484133, green: 0.805339992, blue: 0.1354261637, alpha: 1) : #colorLiteral(red: 0.9842862487, green: 0.03971153125, blue: 0.04987836629, alpha: 1)
            }
            
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var imagesArray = [String]()
        if collectionView == self.collectionViewForBreakfast {
            imagesArray = self.getImages(data: (self.monthlyData?.data.breakfast)!, index: indexPath.item, mealType: "Breakfast")

        } else if collectionView == self.collectionViewForBrunch {
            imagesArray = self.getImages(data: (self.monthlyData?.data.brunch)!, index: indexPath.item, mealType: "Brunch")

        } else if collectionView == self.collectionViewForLunch {
            imagesArray = self.getImages(data: (self.monthlyData?.data.lunch)!, index: indexPath.item, mealType: "Lunch")

        } else if collectionView == self.collectionViewForEveningSnack {
            imagesArray = self.getImages(data: (self.monthlyData?.data.eveningSnack)!, index: indexPath.item, mealType: "Evening Snack")

        } else if collectionView == self.collectionViewForDinner {
            imagesArray = self.getImages(data: (self.monthlyData?.data.dinner)!, index: indexPath.item, mealType: "Dinner")

        }
        if imagesArray.count == 0 {
            
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "No tweaks for today!")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PageViewImageSlider") as! PageViewImageSlider
        controller.itemIndex = 0
        controller.dateInfo = dateInfo
        controller.imagesArray = imagesArray
        self.present(controller, animated: true, completion: nil)
    }
    
    func getMonthlyTrendsBottom(startDate: String, endDate: String, completion:@escaping (Result<MonthlyTrendsBottom, AFError>)->Void) {
        let headers: HTTPHeaders = [
            "Authorization" : UserDefaults.standard.value(forKey: "userSession") as! String,
            "Content-Type": "application/json"]
        AF.request(URL(string: TweakAndEatURLConstants.GET_MONTLY_TRENDS_BOTTOM)!, method: .post, parameters: [
            "sdate": startDate,
            "edate": endDate
        ] as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable { (response: DataResponse<MonthlyTrendsBottom, AFError>) in
               completion(response.result)
           }
       }
    
    func getMonthlyTrendsBottom(startDate: String, endDate: String) {
        let headers: HTTPHeaders = [
            "Authorization" : UserDefaults.standard.value(forKey: "userSession") as! String,
            "Content-Type": "application/json"]
        AF.request(URL(string: TweakAndEatURLConstants.GET_MONTLY_TRENDS_BOTTOM)!, method: .post, parameters: [
            "sdate": startDate,
            "edate": endDate
        ] as [String : AnyObject], encoding: JSONEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            self.monthlyData = decoder.decodeResponse(from: response)
            self.showNoData(dataArray: (self.monthlyData?.data.breakfast)!, mealType: "breakfast", label: self.noDataLabelForBreakfast)
            self.showNoData(dataArray: (self.monthlyData?.data.brunch)!, mealType: "brunch", label: self.noDataLabelForBrunch)
            self.showNoData(dataArray: (self.monthlyData?.data.lunch)!, mealType: "lunch", label: self.noDataLabelForLunch)
            self.showNoData(dataArray: (self.monthlyData?.data.eveningSnack)!, mealType: "evening snack", label: self.noDataLabelForEveningSnack)
            self.showNoData(dataArray: (self.monthlyData?.data.dinner)!, mealType: "dinner", label: self.noDataLabelForDinner)
            
            
           
            
           
            
        }
    }
    
    func showNoData(dataArray: [[String : Meal]], mealType: String, label: UILabel) {
        var imgsArray = [String]()
        for itemDict in dataArray {
            for (key,val) in itemDict {
                print(key,val)
              
                let imageUrl = val.imgs.first as AnyObject as? String
                imgsArray.append(imageUrl!)
            }
        }
        if imgsArray.allSatisfy({$0 == "-"}) {
            DispatchQueue.main.async {
                label.isHidden = false
                label.isUserInteractionEnabled = false
                label.text = "Hey! Looks like you did not tweak your \(mealType).\nPlease tweak your \(mealType) also to get comparison reports."
            }
            
        } else {
            label.isHidden = true
        }
    }
    
    func getImages(data: [[String : Meal]], index: Int, mealType: String) -> [String] {
        self.imagesArray = []
        let dataDict: [String : Meal] = data[index]
        var imgUrl = ""
        self.dateInfo = ""
        for (key, _) in dataDict {
            self.dateInfo = key.getFormattedStringWithYear() + " - " + mealType
            let dataArr = dataDict[key]
            imgUrl = dataArr?.imgs.first ?? ""
            self.imagesArray = dataArr?.imgs ?? []

        }
        if imgUrl == "-" {
            return []
        }

        
        return self.imagesArray
    }
    
    func getMealTypeHeaders(calLimit: Int, mealType: String) -> String {
        return "\(mealType) (\(calLimit) Cals Limit / day)    "
        
    }
    @objc func refresh(_ sender: Any) {
        //  your code to reload tableView
        print("refreshing...")
        self.pullControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_MONTHLY_TOP_TRENDS"), object: true)
    }
    
    @objc func updateBottomTrends(_ notification: Notification) {
        let obj = notification.object as! [String]
        srtDate = obj[0]
        eDate = obj[1]
        
        self.getMonthlyTrendsBottom(startDate: obj[0], endDate: obj[1]) { result in
            switch result {
            case .success(let data):
                if data.callStatus == "GOOD" {
                    DispatchQueue.main.async {
                        self.breakfastLabel.text = self.getMealTypeHeaders(calLimit: data.dailyCalsLimit.breakfast, mealType: "Breakfast")
                        self.brunchLabel.text = self.getMealTypeHeaders(calLimit: data.dailyCalsLimit.brunch, mealType: "Brunch")
                        self.lunchLabel.text = self.getMealTypeHeaders(calLimit: data.dailyCalsLimit.lunch, mealType: "Lunch")
                        self.eveningSnackLabel.text = self.getMealTypeHeaders(calLimit: data.dailyCalsLimit.eveningSnack, mealType: "Evening Snack")
                        self.dinnerLabel.text = self.getMealTypeHeaders(calLimit: data.dailyCalsLimit.dinner, mealType: "Dinner")
                    }
                self.monthlyData = data
                self.showNoData(dataArray: (self.monthlyData?.data.breakfast)!, mealType: "breakfast", label: self.noDataLabelForBreakfast)
                self.showNoData(dataArray: (self.monthlyData?.data.brunch)!, mealType: "brunch", label: self.noDataLabelForBrunch)
                self.showNoData(dataArray: (self.monthlyData?.data.lunch)!, mealType: "lunch", label: self.noDataLabelForLunch)
                self.showNoData(dataArray: (self.monthlyData?.data.eveningSnack)!, mealType: "evening snack", label: self.noDataLabelForEveningSnack)
                self.showNoData(dataArray: (self.monthlyData?.data.dinner)!, mealType: "dinner", label: self.noDataLabelForDinner)
                }
            case .failure(let error):
                print(error.localizedDescription)
                TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection and try again!")
            }
        }

    }
    @objc func scrollTableViewToTop() {
        let topRow = IndexPath(row: 0,
                                   section: 0)
            // 2
        self.tableView.scrollToRow(at: topRow,
                                       at: .top,
                                       animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pullControl.attributedTitle = NSAttributedString(string: "Pull down to Collapse..")
       // pullControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        self.pullControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(pullControl)
//
        NotificationCenter.default.addObserver(self, selector: #selector(WeeklyTweakListViewController.scrollTableViewToTop), name: NSNotification.Name(rawValue: "SCROLL_TABLE_VIEW_TO_TOP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WeeklyTweakListViewController.updateBottomTrends(_:)), name: NSNotification.Name(rawValue: "GET_BOTTOM_TRENDS"), object: nil)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.breakfastLabel.layer.borderWidth = 1
        self.breakfastLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.brunchLabel.layer.borderWidth = 1
        self.brunchLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.lunchLabel.layer.borderWidth = 1
        self.lunchLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.eveningSnackLabel.layer.borderWidth = 1
        self.eveningSnackLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.dinnerLabel.layer.borderWidth = 1
        self.dinnerLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
       // self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 5
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeeklyTweakListCell
//        cell.collectionView.delegate = self
//        cell.collectionView.dataSource = self
//        cell.collectionView.reloadData()
//        cell.selectionStyle = .none
//
//        switch indexPath.section {
//        case 0:
//            cell.collectionView.tag = 100
//            self.cellSection = indexPath.row
//        case 1:
//            self.cellSection = indexPath.row
//        case 2:
//            self.cellSection = indexPath.row
//        case 3:
//            self.cellSection = indexPath.row
//        case 4:
//            self.cellSection = indexPath.row
//        default:
//            cell.mealTypeLabel.text = ""
//        }
//
//
//        // Configure the cell...
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewLbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerViewLbl.text = "Tweak list from \(srtDate.getFormattedString()) to \(eDate.getFormattedString())"
        headerViewLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 18.0)
        headerViewLbl.textColor = UIColor.init(red: 86.0/255.0, green: 48.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        headerViewLbl.backgroundColor = .white

        return headerViewLbl
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 40
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // example code
        if decelerate {
            if(scrollView.contentOffset.y < 0) {
               
            } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_MONTHLY_TOP_TRENDS"), object: false)
            }

        }
}

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: - UICollectionViewDelegateFlowLayout

extension WeeklyTweakListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: 80, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
