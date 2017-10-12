//
//  AwesomeCountViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/14/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AwesomeCountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var tweakFeedsRef : DatabaseReference!
    var feedContent : String = ""
    var gender : String = ""
    var imageUrl : String = ""
    var msisdn : String = ""
    var postedOn : String = ""
    var tweakOwner : String = ""
    var awesomeCount : Int = 0
    var commentsCount : Int = 0
    var nicKName : String = ""
    var sex : String = ""
    var userMsisdn : String = ""
    var childSnap: String = ""
    @IBOutlet var placeHolderLabel: UILabel!
    var titleName : String!
    var tweaksFeedsArray = NSMutableArray()
    var checkVariable : String = ""
    @IBOutlet var commentsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var commentsTxtView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet var awesomeTableView: UITableView!
    @IBOutlet var awesomeView: UIView!
    var tweakWall : TweakMyWallTableViewCell!
    var tweakDictionary = Dictionary<String, Any>()

    
    override func viewDidLoad() {
        super.viewDidLoad();
        tweakFeedsRef = Database.database().reference()
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.commentsTxtView.delegate = self
        self.commentsTxtView.layer.cornerRadius = 5.0
        self.commentsTxtView.layer.borderColor = UIColor.darkGray.cgColor
        self.commentsTxtView.layer.borderWidth = 1.0
        self.postBtn.layer.cornerRadius = 5.0
        self.postBtn.isSelected = false
        self.showAnimate();
        self.titleLabel.text = titleName;
        if (self.titleLabel.text == " Awesome") {
            self.commentsView.isHidden = true
            imageButton.setImage(UIImage(named: "AwesomeIconFilled.png")!, for: UIControlState.normal);
        }
        else {
            imageButton.setImage(UIImage(named: "CommentsFilledIcon.png")!, for: UIControlState.normal);
        }
        if self.tweakDictionary.count > 0 {
            if self.checkVariable == "Awesome" {
                self.tweaksFeedsArray = self.tweakDictionary["awesomeMembers"]! as! NSMutableArray
            } else {
                self.tweaksFeedsArray = self.tweakDictionary["comments"]! as! NSMutableArray
            }
            
        }
        
        let descriptor = NSSortDescriptor(key: "postedOn", ascending: true)
        let tempArray: Array = self.tweaksFeedsArray.sortedArray(using: [descriptor])
        self.tweaksFeedsArray = NSMutableArray(array: tempArray)
   
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.checkVariable == "Awesome" {
            return 85.0 - 21.0
        }
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resetCommentsView()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: {})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweaksFeedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AwesomeTableViewCell;
        if self.tweaksFeedsArray.count > 0 {
            let cellDict = self.tweaksFeedsArray[indexPath.row] as AnyObject
            if self.checkVariable == "Awesome" {
                cell.awesomeName.text = cellDict["nickName"] as? String;
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                let dateArrayElement = dateFormatter.date(from: (cellDict["postedOn"] as? String)!)
                if dateArrayElement == nil {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    let dateElement1 = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!)
                    cell.commentsLabel.text = dateFormatter.string(from: dateElement1!)
                } else {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    
                    cell.commentsLabel.text = dateFormatter.string(from: dateArrayElement!)
                }
            } else {
                print(cellDict)
                cell.commentsLabel.text = cellDict["commentText"] as? String;
                cell.awesomeName.text = cellDict["nickName"] as? String;
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                let dateArrayElement = dateFormatter.date(from: (cellDict["postedOn"] as? String)!)
                if dateArrayElement == nil {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    let dateElement1 = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!)
                    cell.awesomeTime.text = dateFormatter.string(from: dateElement1!)
                } else {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    
                    cell.awesomeTime.text = dateFormatter.string(from: dateArrayElement!)
                }

                           }
         
//            if (self.checkVariable == "Awesomes") {
//                cell.commentsHeightConstraint.constant = 0;
//            } else {
//                cell.commentsHeightConstraint.constant = 21;
//            }
            
        }
        return cell;
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        let currentDate = Date()
        if commentsTxtView.text == "" {
            return
        }
        resetCommentsView()
        
        self.commentsCount += 1
        var tempDict : [String:AnyObject] = [:]
        tempDict["commentText"] = self.commentsTxtView.text! as AnyObject
        tempDict["nickName"] = self.nicKName as AnyObject
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
        let dateArrayElement = dateFormatter.string(from: currentDate) as AnyObject
//        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
//        let dateArrayElement1 = dateFormatter.string(from: currentDate ) as AnyObject

        
        tempDict["postedOn"] = dateArrayElement as! String as AnyObject
        tempDict["msisdn"] = self.userMsisdn as AnyObject
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate)
        let currentTime = Int64(currentTimeStamp)
        
        DispatchQueue.global(qos: .background).async {
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.tweakFeedsRef.child("TweakFeeds").child(self.childSnap).child("comments").childByAutoId().setValue(["msisdn" : self.userMsisdn as AnyObject,"postedOn" : currentTime as AnyObject,"commentText": self.commentsTxtView.text! as AnyObject,"nickName": self.nicKName as AnyObject])
            self.tweakFeedsRef.child("TweakFeeds").child(self.childSnap).updateChildValues(["commentsCount" : self.commentsCount as AnyObject])
            
            DispatchQueue.main.async {
                self.tweaksFeedsArray.add(tempDict)
                self.awesomeTableView.reloadData()
                self.commentsTxtView.text = ""
                self.placeHolderLabel?.isHidden = false
                
            }
        }
        
        
        
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.checkVariable == "Awesomes" {
//            return 85.0 - 21.0
//        }
//        return 85.0
//    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview();
            }
        });
    }
    
    //txtview delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.commentsView.frame = CGRect(x:0, y: self.view.frame.size.height - 216 - 50 - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderLabel?.isHidden = false
            
        }
        else {
            placeHolderLabel?.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if self.commentsTxtView.text == "" {
            placeHolderLabel?.isHidden = false
        } else {
          placeHolderLabel?.isHidden = true
        }
        self.commentsView.frame = CGRect(x:0, y:self.view.frame.size.height + 50 - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
        
        super.touchesBegan(touches, with: event)
    }
    
    func resetCommentsView(){
        view.endEditing(true)
        if self.commentsTxtView.text == "" {
            placeHolderLabel?.isHidden = false
        } else {
            placeHolderLabel?.isHidden = true
        }
        self.commentsView.frame = CGRect(x:0, y:self.view.frame.size.height - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)

    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
