//
//  DietPlanViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 07/04/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DietPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DietButtonCellDelegate {
    @IBOutlet weak var dietPopupView: UIView!

    @IBOutlet weak var saveButton: UIButton!;
    @IBOutlet weak var dateLabel: UILabel!;
    @IBOutlet weak var dayLabel: UILabel!;
    @IBOutlet weak var nextButton: UIButton!;
    @IBOutlet weak var prevButton: UIButton!;
    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var calenderBtn: UIBarButtonItem!;

    @IBOutlet weak var dismissView: UIView!
    
    @objc var dietPlanArray = NSMutableArray();
    @objc var dictCount = 0
    @objc var currentDate = "";
    @objc var formatter = DateFormatter();
    @objc var dietPlanReference : DatabaseReference!;
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    @objc var snapShot = "";
    @objc var dayFormatter = DateFormatter();
    @objc var firstKey = ""
    @objc var dietDate = ""
    @objc var dietDay = ""
    @objc var counter = 1
    
    @IBOutlet weak var dateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Diet Plan";
        formatter.dateFormat = "dd-MM-yyyy";
        let result = formatter.string(from: Date());
        self.dateLabel.text = result;
        self.currentDate = result;
        
        self.dateView.isHidden = true
        self.saveButton.isHidden = true
        self.tableView.isHidden = true
        self.dismissView.isHidden = true
       
        dayFormatter.dateFormat = "EEEE";
        let currentDayString: String = dayFormatter.string(from: Date());
        self.dayLabel.text = currentDayString;
        
        self.dietPlanReference = Database.database().reference().child("UserPremiumPackages");
        self.prevButton.layer.cornerRadius = self.prevButton.frame.size.width / 2;
        self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width / 2;
        if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
            nextButton.isHidden = true
            prevButton.isHidden = true
            calenderBtn.isEnabled = false
            calenderBtn.tintColor = UIColor.white
        }
        self.checkNutritionistPublishedDietPlan();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dietPlanArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! DietPlanCell;
        
        if cell.dietButtonDelegate == nil {
            cell.dietButtonDelegate = self;
        }
        cell.cellIndexPath = indexPath.row;
        cell.myIndexPath = indexPath;
        

        let cellDict = self.dietPlanArray[indexPath.row] as! NSDictionary;
        if cellDict.count > 0 {
            self.dateView.isHidden = false
            self.saveButton.isHidden = false
            self.tableView.isHidden = false
            self.dismissView.isHidden = true
        if (cellDict["name"] != nil) {
            cell.foodNameLabel.text = (cellDict["name"] as? String)!;
            }
            if (cellDict["diet"] != nil) {
                cell.dietLabel.text = (cellDict["diet"] as? String)! + "\n";
            }
            if (cellDict["qty"] != nil) {

                cell.qtyLabel.text = (cellDict["qty"] as? String)! + "\n";
            }
            if (cellDict["time"] != nil) {

                cell.timeLabel.text = cellDict["time"] as? String;
            }
        if cellDict["selected"] as? Bool == true {
           
            cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
        } else {
            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
        }

        } else {
            
            self.dateView.isHidden = true
            self.saveButton.isHidden = true
            self.tableView.isHidden = true
            self.dismissView.isHidden = false
            let refreshAlert = UIAlertController(title: "", message: "No Diet Plan Available!!" , preferredStyle: UIAlertController.Style.alert);
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here");
                self.navigationController?.popViewController(animated: true);
            }))
            self.present(refreshAlert, animated: true, completion: nil);
        }
        if self.saveButton.currentTitle == "APPROVE" {
            cell.checkBoxButton.isHidden = true;
        } else {
            cell.checkBoxButton.isHidden = false;
        }
        if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
            cell.checkBoxButton.isHidden = true
        }

     return cell
    }
    
    @objc func cellTappedCheckBox(_ cell: DietPlanCell) {
        
        self.myIndexPath = cell.myIndexPath;
        
        if cell.checkBoxButton.imageView?.image == UIImage.init(named: "checked_box.png") {
            
            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
            let cellDict = self.dietPlanArray[self.myIndexPath.row] as! NSMutableDictionary;
            cellDict["selected"] =  false;
            self.dietPlanArray.removeObject(at: self.myIndexPath.row);
            self.dietPlanArray.insert(cellDict, at: self.myIndexPath.row);
            
        } else {
            
            cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
            let cellDict = self.dietPlanArray[self.myIndexPath.row] as! NSMutableDictionary;
            cellDict["selected"] =  true;
            self.dietPlanArray.removeObject(at: self.myIndexPath.row);
            self.dietPlanArray.insert(cellDict, at: self.myIndexPath.row);
            
        }
        print(self.dietPlanArray);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func calenderBarBtn(_ sender: Any) {
        formatter.dateFormat = "dd-MM-yyyy";
        let result = formatter.string(from: Date());
        self.dateLabel.text = result;
        self.currentDate = result;
        dayFormatter.dateFormat = "EEEE";
        let currentDayString: String = dayFormatter.string(from: Date());
        self.dayLabel.text = currentDayString;
        self.checkNutritionistPublishedDietPlan();
    }
    
    @objc func nextDate(dateStr: String) {
        counter += 1
        if self.dictCount == counter {
            self.nextButton.isHidden = true
        } else {
        self.prevButton.isHidden = false
        }
        let myDate = formatter.date(from: dateStr)!;
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate);
        self.currentDate = formatter.string(from: tomorrow!);
        self.dateLabel.text = self.currentDate;
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat  = "EEEE";
        let dayInWeek = dateFormatter.string(from: tomorrow!);
        self.dayLabel.text = dayInWeek;
        self.getDietPlanPerDay(date: self.currentDate)
        print("your next Date is \(self.currentDate)");

    }
    
    @objc func prevDate(dateStr: String) {
        counter -= 1
        if self.counter == 1 {
            self.prevButton.isHidden = true
        }else {
            self.nextButton.isHidden = false
        }

        let myDate = formatter.date(from: dateStr)!;
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: myDate);
        self.currentDate = formatter.string(from: tomorrow!);
        self.dateLabel.text = self.currentDate;
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat  = "EEEE";
        let dayInWeek = dateFormatter.string(from: tomorrow!);
        self.dayLabel.text = dayInWeek;
        self.getDietPlanPerDay(date: self.currentDate)
        print("your next Date is \(self.currentDate)");
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
         nextDate(dateStr: self.currentDate)
        } else {
        convertNextDate(dateString: self.currentDate);
        }
    }
    
    @IBAction func prevButtonTapped(_ sender: Any) {
        if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
            prevDate(dateStr: self.currentDate)

        } else {
        convertPreviousDate(dateString: self.currentDate);
        }
    }
    
    @objc func convertNextDate(dateString : String) {
        
        let myDate = formatter.date(from: dateString)!;
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate);
        self.currentDate = formatter.string(from: tomorrow!);
        self.dateLabel.text = self.currentDate;
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat  = "EEEE";
        let dayInWeek = dateFormatter.string(from: tomorrow!);
        self.dayLabel.text = dayInWeek;
        self.getDietPlanPerDay(day: dayInWeek, date: tomorrow!);
        print("your next Date is \(self.currentDate)");
    }
    
    @objc func convertPreviousDate(dateString : String) {
        
        let myDate = formatter.date(from: dateString)!
        let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: myDate)
        self.currentDate = formatter.string(from: previousDay!)
        self.dateLabel.text = self.currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: previousDay!)//
        self.dayLabel.text = dayInWeek
        self.getDietPlanPerDay(day: dayInWeek, date: previousDay!)
        print("your previous Date is \(self.currentDate)")
    }
    
    @objc func checkNutritionistPublishedDietPlan() {
        if let currentUserID = Auth.auth().currentUser?.uid {
  
            print( Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan")); Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if snapshot.childrenCount > 0 {
                    self.dateView.isHidden = false
                    self.saveButton.isHidden = false
                    self.tableView.isHidden = false
                    self.dismissView.isHidden = true
                    let dispatch_group = DispatchGroup();
                    dispatch_group.enter();
                    
                    for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let dietPlanObj = dietPlan.value;
                        if dietPlanObj is NSDictionary {
                            if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {

                           // print(dietPlanObj)
                                let dietPlanDict = dietPlanObj as! Dictionary<String, AnyObject>
                                print(dietPlanDict)
                                self.dictCount = dietPlanDict.count

                                self.firstKey = Array(dietPlanDict.keys.sorted()).first!
                            print(self.firstKey)// or .first
                            }

                        } else if dietPlanObj is Bool {
                            if dietPlan.key == "isPublished" {
                                if dietPlanObj as! Bool == true {
                                    
                                    if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
                                        self.formatter.dateFormat = "yyyy-MM-dd";

                                        self.currentDate = self.firstKey
                                        self.dateLabel.text = self.firstKey;
                                        self.getDietPlanPerDay(date: self.currentDate)
                                        if self.dictCount > 1 {
                                            self.nextButton.isHidden = false
                                            //self.prevButton.isHidden = false
                                        }
                                    } else if self.snapShot == "-KyotHu4rPoL3YOsVxUu" {
                                        let dateFormatter1 = DateFormatter();
                                        dateFormatter1.dateFormat  = "EEEE";//"EE" to get short style
                                        let dayInWeek = dateFormatter1.string(from: Date());
                                        self.dayLabel.text = dayInWeek;
                                       self.getDietPlanPerDay(day: dayInWeek, date: Date());
                                    }
                                    
                                } else {
                                    
                                    self.dateView.isHidden = true
                                    self.saveButton.isHidden = true
                                    self.tableView.isHidden = true
                                    self.dismissView.isHidden = false
                                    self.dietPopupView.isHidden = false

//                                    let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                                        print("Handle Ok logic here");
//                                        self.navigationController?.popViewController(animated: true);
//                                    }))
//                                    self.present(refreshAlert, animated: true, completion: nil);
                                    self.saveButton.isHidden = true;
                                }
                            } else if dietPlan.key == "isAccepted" {
                                if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
                                    self.saveButton.isHidden = true
                                } else {
                                if dietPlanObj as! Bool == true {
                                    self.saveButton.setTitle("SAVE", for: .normal);
                                    self.tableView.reloadData();
                                } else {
                                    self.saveButton.setTitle("APPROVE", for: .normal);
                                    self.tableView.reloadData();
                                }
                                }
                            }
                        }
                      
                    }
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData();
                        
                    }
                } else {
                    self.dateView.isHidden = true
                    self.saveButton.isHidden = true
                    self.tableView.isHidden = true
                    self.dismissView.isHidden = false
                    self.dietPopupView.isHidden = false

//                    let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                        print("Handle Ok logic here");
//                        self.navigationController?.popViewController(animated: true);
//                    }))
//                    self.present(refreshAlert, animated: true, completion: nil);
                }
            })
        }
    }
    
    @objc func getDietPlanPerDay(date: String) {
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan").child("dietDays").child(date).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                self.dietPlanArray = NSMutableArray()
                
                if snapshot.childrenCount > 0 {
                    self.dateView.isHidden = false
                    self.saveButton.isHidden = false
                    self.tableView.isHidden = false
                    self.dismissView.isHidden = true
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    
                    for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let dietPlanObj = dietPlan.value as! NSDictionary
                        
                        self.dietPlanArray.add(dietPlanObj)
                        
                    }
                    dispatch_group.leave()
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData()
                        
                    }
                } else {
        
                    self.dateView.isHidden = true
                    self.saveButton.isHidden = true
                    self.tableView.isHidden = true
                    self.dismissView.isHidden = false
                    self.dietPopupView.isHidden = false

//                    let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                        print("Handle Ok logic here");
//                        self.navigationController?.popViewController(animated: true);
//                    }))
//                    self.present(refreshAlert, animated: true, completion: nil);
                }
            })
        } else {
            self.dietPlanArray = NSMutableArray()
            self.tableView.reloadData()
            
        }
    }
    
    @objc func getDietPlanPerDay(day : String, date: Date) {
        if let currentUserID = Auth.auth().currentUser?.uid {
        Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan").child("weekDays").child(day).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            self.dietPlanArray = NSMutableArray()

            if snapshot.childrenCount > 0 {
                self.dateView.isHidden = false
                self.saveButton.isHidden = false
                self.tableView.isHidden = false
                self.dismissView.isHidden = true
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let dietPlanObj = dietPlan.value as! NSDictionary
                    
                    self.dietPlanArray.add(dietPlanObj)
                    
                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                   self.tableView.reloadData()
                    
                }
            } else {
        
                self.dateView.isHidden = true
                self.saveButton.isHidden = true
                self.tableView.isHidden = true
                self.dismissView.isHidden = false
                self.dietPopupView.isHidden = false

//                let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                    print("Handle Ok logic here");
//                    self.navigationController?.popViewController(animated: true);
//                }))
//                self.present(refreshAlert, animated: true, completion: nil);
            }
        })
        } else {
            self.dietPlanArray = NSMutableArray()
            self.tableView.reloadData()

        }
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if self.saveButton.currentTitle == "APPROVE" {
            if let currentUserID = Auth.auth().currentUser?.uid {
 Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan").updateChildValues(["isAccepted": true], withCompletionBlock: { (error, _) in
                if error == nil {
                    self.tableView.reloadData();
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Diet Plan have been approved by you!");
                    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIRST_MESSAGE"), object: nil)
                    
                    //api
                    
                    
                } else {
                    
                }
            })
            }
        } else {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var name = ""
            if self.snapShot == "-TacvBsX4yDrtgbl6YOQ" {
                name = "dietDays"
            } else {
                name = "weekDays"
            }
 Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.snapShot).child("dietPlan").child(name).child(self.dayLabel.text!).setValue(self.dietPlanArray, withCompletionBlock: { (error, _) in
                if error == nil {
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Saved Successfully!");
                    
                } else {
                }
            })
        }
      }
   }
}
