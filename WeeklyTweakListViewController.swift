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
            self.tableView.scrollsToTop = true
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
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    cell.calorieLabelTrends.text = ""
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val["Cals"]?.first?.replacingOccurrences(of: "-", with: "")

                }
            }
            
        } else if collectionView == self.collectionViewForBrunch {
            let itemDict = (self.monthlyData?.data.brunch[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    cell.calorieLabelTrends.text = ""
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val["Cals"]?.first?.replacingOccurrences(of: "-", with: "")
                }
            }
            
        } else if collectionView == self.collectionViewForLunch {
            let itemDict = (self.monthlyData?.data.lunch[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    cell.calorieLabelTrends.text = ""
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val["Cals"]?.first?.replacingOccurrences(of: "-", with: "")
                }
            }
            
        } else if collectionView == self.collectionViewForEveningSnack {
            let itemDict = (self.monthlyData?.data.eveningSnack[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    cell.calorieLabelTrends.text = ""
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    cell.calorieLabelTrends.text = val["Cals"]?.first?.replacingOccurrences(of: "-", with: "")
                }
            }
            
        } else if collectionView == self.collectionViewForDinner {
            let itemDict = (self.monthlyData?.data.dinner[indexPath.row])!
            for (key,val) in itemDict {
                print(key,val)
                let keyArray = key.components(separatedBy: "-")
                cell.weekDayLabelTrends.text = keyArray.last?.deletingPrefix("0").getOrdinalValue()
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                    cell.calorieLabelTrends.text = ""
                } else {
                cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                cell.calorieLabelTrends.text = val["Cals"]?.first?.replacingOccurrences(of: "-", with: "")
                }
            }
            
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var imagesArray = [String]()
        if collectionView == self.collectionViewForBreakfast {
            imagesArray = self.getImages(data: (self.monthlyData?.data.breakfast)!, index: indexPath.item)

        } else if collectionView == self.collectionViewForBrunch {
            imagesArray = self.getImages(data: (self.monthlyData?.data.brunch)!, index: indexPath.item)

        } else if collectionView == self.collectionViewForLunch {
            imagesArray = self.getImages(data: (self.monthlyData?.data.lunch)!, index: indexPath.item)

        } else if collectionView == self.collectionViewForEveningSnack {
            imagesArray = self.getImages(data: (self.monthlyData?.data.eveningSnack)!, index: indexPath.item)

        } else if collectionView == self.collectionViewForDinner {
            imagesArray = self.getImages(data: (self.monthlyData?.data.dinner)!, index: indexPath.item)

        }
        if imagesArray.count == 0 {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PageViewImageSlider") as! PageViewImageSlider
        controller.itemIndex = self.imageIndex
        controller.imagesArray = imagesArray
        self.present(controller, animated: true, completion: nil)
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
    
    func showNoData(dataArray: [[String : [String : [String]]]], mealType: String, label: UILabel) {
        var imgsArray = [String]()
        for itemDict in dataArray {
            for (key,val) in itemDict {
                print(key,val)
              
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                imgsArray.append(imageUrl!)
            }
        }
        if imgsArray.allSatisfy({$0 == "-"}) {
            DispatchQueue.main.async {
                label.isHidden = false
                label.text = "Hey! Looks like you did not tweak your \(mealType).\nPlease tweak your \(mealType) also to get comparison reports."
            }
            
        }
    }
    
    func getImages(data: [[String : [String : [String]]]], index: Int) -> [String] {
        self.imagesArray = []
        let dataDict: [String : [String : [String]]] = data[index]
        var imgUrl = ""
        for (key, _) in dataDict {
            let dataArr = dataDict[key]
            imgUrl = dataArr!["Imgs"]?.first as AnyObject as? String ?? ""

        }
        if imgUrl == "-" {
            return []
        }
        let dataArray = data
        for itemDict in dataArray {
            for (key,val) in itemDict {
                print(key,val)
              
                let imageUrl = val["Imgs"]?.first as AnyObject as? String
                if imageUrl == "-" {
                    //cell.foodPlateTrends.image = UIImage.init(named: "X_img")
                } else {
                //cell.foodPlateTrends.sd_setImage(with: URL(string: imageUrl!))
                    self.imagesArray.append(imageUrl!)
                }
            }
        }
        
        self.imageIndex = self.imagesArray.index(of: imgUrl) ?? 0
        return self.imagesArray
    }
    
    @objc func updateBottomTrends(_ notification: Notification) {
        let obj = notification.object as! [String]
        srtDate = obj[0]
        eDate = obj[1]
        
        self.getMonthlyTrendsBottom(startDate: obj[0], endDate: obj[1])

    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
