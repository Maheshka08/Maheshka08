//
//  AwesomeCountViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/14/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//  Reviewed

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift
import Realm


class AwesomeCountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var tweakFeedsRef : DatabaseReference!
    @objc var tweakFeed = TweakFeedsInfo()
    @objc var feedContent : String = ""
    @objc var gender : String = ""
    @objc var imageUrl : String = ""
    @objc var msisdn : String = ""
    @objc var tweakOwnerMsisdn = ""
    @objc var postedOn : String = ""
    @objc var tweakOwner : String = ""
    @objc var awesomeCount : Int = 0
    @objc var commentsCount : Int = 0
    @objc var nicKName : String = ""
    @objc var sex : String = ""
    @objc var userMsisdn : String = ""
    @objc var childSnap: String = ""
    @objc var recipeTitle: String = ""
    var awesomeMembers = [TweakWallAwesomeMembers]()
    var commentMembers = [TweakWallCommentsMembers]()
    @IBOutlet var placeHolderLabel: UILabel!
    
    @objc var titleName : String!
    @objc var tweaksFeedsArray = NSMutableArray()
    @objc var checkVariable : String = ""
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet var commentsView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var commentsTxtView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet var awesomeTableView: UITableView!
    @IBOutlet var awesomeView: UIView!
    
    @objc var tweakWall : TweakMyWallTableViewCell!
    @objc var tweakDictionary = Dictionary<String, Any>()
    let realm :Realm = try! Realm()
    @objc let backgroundImage = UIImage(named: "bckgrndImg.png")

 override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - getKayboardHeight
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        // do whatever you want with this keyboard height  self.view.frame.size.height - 216 - self.commentsView.frame.size.height
        self.commentsView.frame = CGRect(x:0, y: self.view.frame.size.height - keyboardHeight - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // keyboard is dismissed/hidden from the screen
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.commentsView.frame = CGRect(x:0, y:self.view.frame.size.height - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.commentsTxtView.layer.cornerRadius = 5
        self.commentsTxtView.layer.borderColor = UIColor.darkGray.cgColor
        self.commentsTxtView.layer.borderWidth = 2
        self.imgView.clipsToBounds = true
        self.imgView.contentMode = .scaleAspectFill
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
        let imageView = UIImageView(image: backgroundImage);
        self.awesomeTableView.backgroundView = imageView;
        self.imgView?.sd_setImage(with: URL(string: self.imageUrl));
        
        if self.recipeTitle == "" {
            self.titleView.isHidden = true;
        } else {
            self.titleView.isHidden = false;
            self.titleLbl.text = self.recipeTitle;
        }
        
        tweakFeedsRef = Database.database().reference();
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.commentsTxtView.delegate = self;
        self.commentsTxtView.layer.cornerRadius = 5.0;
        self.commentsTxtView.layer.borderColor = UIColor.darkGray.cgColor;
        self.commentsTxtView.layer.borderWidth = 1.0;
        self.postBtn.layer.cornerRadius = 5.0;
        self.postBtn.setTitle(self.bundle.localizedString(forKey: "post_btn", value: nil, table: nil), for: .normal)
        self.placeHolderLabel.text = self.bundle.localizedString(forKey: "write_comment", value: nil, table: nil)
        self.postBtn.isSelected = false;
        self.showAnimate();
        self.titleLabel.text = titleName;
        if (self.titleLabel.text == bundle.localizedString(forKey: "awesome", value: nil, table: nil)) {
            self.commentsView.isHidden = true;
            imageButton.setImage(UIImage(named: "awesome_icon_hover.png")!, for: UIControl.State.normal);
        }
        else {
            imageButton.setImage(UIImage(named: "comment_icon_hover.png")!, for: UIControl.State.normal);
        }
        if self.tweakDictionary.count > 0 {
            if self.checkVariable == bundle.localizedString(forKey: "awesome", value: nil, table: nil) {
                self.tweaksFeedsArray = self.tweakDictionary["awesomeMembers"]! as! NSMutableArray;
            } else {
                self.tweaksFeedsArray = self.tweakDictionary["comments"]! as! NSMutableArray;
            }
        }
        
        let descriptor = NSSortDescriptor(key: "postedOn", ascending: false);
        let tempArray: Array = self.tweaksFeedsArray.sortedArray(using: [descriptor]);
        self.tweaksFeedsArray = NSMutableArray(array: tempArray);
   
        self.tabBarController?.tabBar.isHidden = true;
        // Do any additional setup after loading the view.
    }
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.checkVariable == bundle.localizedString(forKey: "awesome", value: nil, table: nil) {
            return 85.0 - 10.0;
        }
        return UITableView.automaticDimension;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.isKind(of: UITextView.self) {
        resetCommentsView();
        }
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.view.endEditing(true);
        self.dismiss(animated: true, completion: {});
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweaksFeedsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AwesomeTableViewCell;
        if self.tweaksFeedsArray.count > 0 {
            let cellDict = self.tweaksFeedsArray[indexPath.row] as AnyObject;
            if self.checkVariable == bundle.localizedString(forKey: "awesome", value: nil, table: nil) {
                cell.awesomeName.text = cellDict["nickName"] as AnyObject as? String
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                let dateArrayElement = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!);
                if dateArrayElement == nil {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    let dateElement1 = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!);
                    cell.commentsLabel.text = dateFormatter.string(from: dateElement1!);
                } else {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    
                    cell.commentsLabel.text = dateFormatter.string(from: dateArrayElement!);
                }
            } else {
                print(cellDict);
                cell.commentsLabel.text = cellDict["commentText"] as AnyObject as? String;
                cell.awesomeName.text = cellDict["nickName"] as AnyObject as? String;
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                let dateArrayElement = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!);
                if dateArrayElement == nil {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    let dateElement1 = dateFormatter.date(from: (cellDict["postedOn"] as AnyObject as? String)!);
                    cell.awesomeTime.text = dateFormatter.string(from: dateElement1!);
                } else {
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                    
                    cell.awesomeTime.text = dateFormatter.string(from: dateArrayElement!);
                }
            }
        }
        return cell;
    }
    
    @objc func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current;
        let dayOfMonth = calendar.component(.day, from: date);
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        let currentDate = Date();
        if commentsTxtView.text == "" {
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "empty_comment", value: nil, table: nil));
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true);
        resetCommentsView();
        
        let dispatch_group = DispatchGroup()
        dispatch_group.enter()
        
        self.commentsCount += 1;
        var tempDict : [String:AnyObject] = [:];
        tempDict["commentText"] = self.commentsTxtView.text! as AnyObject;
        tempDict["nickName"] = self.nicKName as AnyObject;
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
        let dateArrayElement = dateFormatter.string(from: currentDate) as AnyObject;

        tempDict["postedOn"] = dateArrayElement as! String as AnyObject;
        tempDict["msisdn"] = self.userMsisdn as AnyObject;
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
        let currentTime = Int64(currentTimeStamp);
        //let commentMembers = self.tweakDictionary["comments"]! as! NSMutableArray;
        //let awesomeMembers = self.tweakDictionary["awesomeMembers"]! as! NSMutableArray
        var feedSet = [String: AnyObject]()
        feedSet["nickName"] = self.nicKName as AnyObject
        var msisdnSet = Set<String>()
        for mob in commentMembers {
           // let mobile = mob["msisdn"]
            let mobile: String = mob.commentsMsisdn
            msisdnSet.insert(mobile)
        }
        for awesome in self.awesomeMembers {
            let mobile: String = awesome.aweSomeMsisdn
            msisdnSet.insert(mobile)
        }
        if msisdnSet.contains(self.userMsisdn) {
        msisdnSet.remove(self.userMsisdn)
        }
        msisdnSet.insert(self.tweakOwnerMsisdn)
        if msisdnSet.count == 0 {
            msisdnSet.insert(self.tweakOwnerMsisdn)
            feedSet["msisdns"] = msisdnSet.joined(separator: ",") as AnyObject
        } else {
        feedSet["msisdns"] = msisdnSet.joined(separator: ",") as AnyObject
        }
        //feedSet["msisdns"] = msisdnSet.joined(separator: ",") as AnyObject
        feedSet["noteType"] = 4 as AnyObject
        feedSet["feedId"] = self.childSnap as AnyObject
        print(feedSet)
        DispatchQueue.global(qos: .background).async {
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.tweakFeedsRef.child("TweakFeeds").child(self.childSnap).child("comments").childByAutoId().setValue(["msisdn" : self.userMsisdn as AnyObject,"postedOn" : currentTime as AnyObject,"commentText": self.commentsTxtView.text! as AnyObject,"nickName": self.nicKName as AnyObject]);
            self.tweakFeedsRef.child("TweakFeeds").child(self.childSnap).updateChildValues(["commentsCount" : self.commentsCount as AnyObject]);
            
            DispatchQueue.main.async {
                self.tweaksFeedsArray.insert(tempDict, at: 0)
                self.awesomeTableView.reloadData();
                self.commentsTxtView.text = "";
                self.placeHolderLabel?.isHidden = false;
                let indexPath = IndexPath(row: self.tweaksFeedsArray.count-1, section: 0)
                self.awesomeTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }
        }
        
        dispatch_group.leave()
        dispatch_group.notify(queue: DispatchQueue.main) {
            if self.userMsisdn == self.msisdn {
                return
            }
            //let noteType : Int = 4
            APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.WALL_PUSH_NOTIFICATIONS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: feedSet, success: { response in
                
                print(response)
                    
            }, failure : { error in
                
                print("failure")
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))

            })
            
        }
    }

    @objc func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0;
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        });
    }
    
    @objc func removeAnimate()
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
//        self.commentsView.frame = CGRect(x:0, y: self.view.frame.size.height - 216 - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderLabel?.isHidden = false
//            if textView.contentSize.height >= 80 {
//              textView.isScrollEnabled = true
//            } else {
//              textView.isScrollEnabled = false
//            }
            
        }
        else {
            placeHolderLabel?.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func resetCommentsView(){
        view.endEditing(true)
        if self.commentsTxtView.text == "" {
            placeHolderLabel?.isHidden = false
        } else {
            placeHolderLabel?.isHidden = true
        }
        self.commentsView.frame = CGRect(x:0, y:self.view.frame.size.height - self.commentsView.frame.size.height, width: self.commentsView.frame.size.width, height: self.commentsView.frame.size.height)
    }
    //MARK: GET_TIME_STAMP
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
