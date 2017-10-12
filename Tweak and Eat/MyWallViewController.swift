//
//  MyWallViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import AVFoundation

class MyWallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate, GADInterstitialDelegate, ButtonCellDelegate {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait);
        adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
        adBannerView.delegate = self;
        adBannerView.rootViewController = self;
        
        return adBannerView;
    }()
    var player: AVAudioPlayer?
    var myProfileInfo : Results<MyProfileInfo>?
    var tweakFeedsInfo : Results<TweakFeedsInfo>?
    let realm :Realm = try! Realm()
    var myIndex : Int = 0
    var refreshPage: Int = 10
    var myIndexPath : IndexPath = []
    var tweakFeedsRef : DatabaseReference!
    var tweakFeedsArray = [TweakFeedsModel]()
    var tweakFeedsDictionary : [String:AnyObject] = [:]
    var nicKName : String = ""
    var sex : String = ""
    var userMsisdn : String = ""
    var isLiked : Bool?
    var Number : String = ""
    var loadingData = false
    var initialLoad = true
    @IBOutlet var tweakWallTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweakFeedsRef = Database.database().reference().child("TweakFeeds")
        self.tweakFeedsInfo = self.realm.objects(TweakFeedsInfo.self)

        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name
            sex = myProfObj.gender
            Number = myProfObj.msisdn
            
        }
        
        tweakFeedsRef.observe(.childChanged, with: { (snapshot) in
            let ID = snapshot.key
            let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
            self.tweakFeedsInfo = self.tweakFeedsInfo!.sorted(by: sortProperties)
            let index = self.realm.objects(TweakFeedsInfo.self).filter("snapShot = \(ID)")
//            let feedObj = snapshot.value as? [String : AnyObject]
//            
//            let tweakFeedObj = TweakFeedsInfo()
//            tweakFeedObj.feedContent = (feedObj?["feedContent"] as AnyObject) as! String
//            
//            tweakFeedObj.gender = (feedObj?["gender"] as AnyObject) as! String
//            tweakFeedObj.imageUrl = (feedObj?["imageUrl"] as AnyObject) as! String
//            tweakFeedObj.msisdn = (feedObj?["msisdn"] as AnyObject) as! String
//            let milisecond = feedObj?["postedOn"] as AnyObject as! NSNumber;
//            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
//            let dateFormatter = DateFormatter();
//            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
//            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
//            tweakFeedObj.postedOn = dateArrayElement as! String
//            tweakFeedObj.tweakOwner = (feedObj?["tweakOwner"] as AnyObject) as! String
//            
//            let awesomeCount = (feedObj?["awesomeCount"] as AnyObject) as! Int
//            tweakFeedObj.awesomeCount = awesomeCount
//            let awesomeMembers = feedObj?["awesomeMembers"]  as? [String : AnyObject]
//            
//            if awesomeCount != 0 && awesomeMembers != nil{
//                for members in awesomeMembers! {
//                    
//                    let awesomeMemObj = AwesomeMembers()
//                    let number = (members.value["msisdn"] as AnyObject) as! String
//                    if number == self.Number {
//                        awesomeMemObj.youLiked = "true"
//                    }else {
//                        awesomeMemObj.youLiked = "false"
//                    }
//                    awesomeMemObj.aweSomeNickName = (members.value["nickName"] as AnyObject) as! String
//                    let milisecond = members.value["postedOn"] as AnyObject;
//                    let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
//                    let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
//                    
//                    awesomeMemObj.aweSomePostedOn = dateArrayElement as! String
//                    awesomeMemObj.aweSomeMsisdn = (members.value["msisdn"] as AnyObject) as! String
//                    tweakFeedObj.awesomeMembers.append(awesomeMemObj)
//                }
//            }
//            let commentsCount = (feedObj?["commentsCount"] as AnyObject) as! Int
//            tweakFeedObj.commentsCount = commentsCount
//            let commentsMembers = feedObj?["comments"] as? [String : AnyObject]
//            if commentsCount != 0 && commentsMembers != nil{
//                for members in commentsMembers! {
//                    let commentsObj = CommentsMembers()
//                    
//                    commentsObj.commentsCommentText = (members.value["commentText"] as AnyObject) as! String
//                    commentsObj.commentsMsisdn = (members.value["msisdn"] as AnyObject) as! String
//                    commentsObj.commentsNickName = (members.value["nickName"] as AnyObject) as! String
//                    let milisecond = members.value["postedOn"] as AnyObject;
//                    let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
//                    let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
//                    commentsObj.commentsPostedOn = dateArrayElement as! String
//                    tweakFeedObj.comments.append(commentsObj)
//                }
//                
//            }
//            
//            tweakFeedObj.snapShot = snapshot.key
//            
//            saveToRealmOverwrite(objType: TweakFeedsInfo.self, objValues: tweakFeedObj)
//            let ind = self.tweakFeedsInfo?.index(of: <#T##TweakFeedsInfo#>)
//                let indexPath = IndexPath(item: <#T##Int#>, section: <#T##Int#>)
//                self.tableView.reloadRows(at: [indexPath], with: .none)
            
        })
        
        tweakFeedsRef.observe(.childAdded, with: { snapshot in
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for tweakFeeds in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let feedObj = tweakFeeds.value as? [String : AnyObject]
                    
                    let tweakFeedObj = TweakFeedsInfo()
                    tweakFeedObj.feedContent = (feedObj?["feedContent"] as AnyObject) as! String
                    
                    tweakFeedObj.gender = (feedObj?["gender"] as AnyObject) as! String
                    tweakFeedObj.imageUrl = (feedObj?["imageUrl"] as AnyObject) as! String
                    tweakFeedObj.msisdn = (feedObj?["msisdn"] as AnyObject) as! String
                    let milisecond = feedObj?["postedOn"] as AnyObject as! NSNumber;
                    let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                    let dateFormatter = DateFormatter();
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                    let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
                    tweakFeedObj.postedOn = dateArrayElement as! String
                    tweakFeedObj.tweakOwner = (feedObj?["tweakOwner"] as AnyObject) as! String
                    
                    let awesomeCount = (feedObj?["awesomeCount"] as AnyObject) as! Int
                    tweakFeedObj.awesomeCount = awesomeCount
                    let awesomeMembers = feedObj?["awesomeMembers"]  as? [String : AnyObject]
                    
                    if awesomeCount != 0 && awesomeMembers != nil{
                        for members in awesomeMembers! {
                            
                            let awesomeMemObj = AwesomeMembers()
                            let number = (members.value["msisdn"] as AnyObject) as! String
                            if number == self.Number {
                                awesomeMemObj.youLiked = "true"
                            }else {
                                awesomeMemObj.youLiked = "false"
                            }
                            awesomeMemObj.aweSomeNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
                            
                            awesomeMemObj.aweSomePostedOn = dateArrayElement as! String
                            awesomeMemObj.aweSomeMsisdn = (members.value["msisdn"] as AnyObject) as! String
                            tweakFeedObj.awesomeMembers.append(awesomeMemObj)
                        }
                    }
                    let commentsCount = (feedObj?["commentsCount"] as AnyObject) as! Int
                    tweakFeedObj.commentsCount = commentsCount
                    let commentsMembers = feedObj?["comments"] as? [String : AnyObject]
                    if commentsCount != 0 && commentsMembers != nil{
                        for members in commentsMembers! {
                            let commentsObj = CommentsMembers()
                            
                            commentsObj.commentsCommentText = (members.value["commentText"] as AnyObject) as! String
                            commentsObj.commentsMsisdn = (members.value["msisdn"] as AnyObject) as! String
                            commentsObj.commentsNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
                            commentsObj.commentsPostedOn = dateArrayElement as! String
                            tweakFeedObj.comments.append(commentsObj)
                        }
                        
                    }
                    
                    tweakFeedObj.snapShot = tweakFeeds.key
                    
                    saveToRealmOverwrite(objType: TweakFeedsInfo.self, objValues: tweakFeedObj)
                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    
                    let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
                    self.tweakFeedsInfo = self.tweakFeedsInfo!.sorted(by: sortProperties)
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    self.tweakWallTableView.reloadData()
                }
                
            }
            //upon first load, don't reload the tableView until all children are loaded
            if ( self.initialLoad == false ) {
                self.tweakWallTableView.reloadData()
            }
        })
        //if self.tweakFeedsInfo?.count == 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true);

            self.getFireBaseData()
//        } else {
//            self.refreshPage = (self.tweakFeedsInfo?.count)!
//        }
//        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
//        self.tweakFeedsInfo = self.tweakFeedsInfo!.sorted(by: sortProperties)
        
        let userdefaults = UserDefaults.standard
        if userdefaults.string(forKey: "USERBLOCKED") != nil{
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "No tweakfeeds")
            MBProgressHUD.hide(for: self.view, animated: true);

            return
        }
            print("No value in Userdefault,Either you can save value here or perform other operation")
           // userdefaults.set("Here you can save value", forKey: "key")
        

       
        
    }
    
    func getFireBaseData() {
        
        
        tweakFeedsRef.observeSingleEvent(of: .value, with: { snapshot in
            print("inital data loaded so reload tableView!  /(snapshot.childrenCount)")
            self.tweakWallTableView.reloadData()
            self.initialLoad = false
            
            
            
        })
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if !loadingData && indexPath.row == self.refreshPage - 1 {
//            loadingData = true
//            MBProgressHUD.showAdded(to: self.view, animated: true);
//            self.refreshPage += 10
//            loadMoreData()
//        }
//    }
//    
//    func loadMoreData() {
//        DispatchQueue.global(qos: .background).async {
//            // this runs on the background queue
//            // here the query starts to add new 10 rows of data to arrays
//            self.getFireBaseData()
//            DispatchQueue.main.async {
//                MBProgressHUD.hide(for: self.view, animated: true);
//                self.loadingData = false
//                
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.tweakFeedsInfo!.count > 0 {
            MBProgressHUD.hide(for: self.view, animated: true);
        }
        return self.tweakFeedsInfo!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TweakMyWallTableViewCell;
        
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self;
        }
        cell.cellIndexPath = indexPath.row
        cell.myIndexPath = indexPath
        
        let cellDictionary = self.tweakFeedsInfo?[indexPath.row]
        let awesomeMem = cellDictionary?["awesomeMembers"]  as! List<AwesomeMembers>
        cell.awesomeBtn?.setImage(UIImage(named: "AwesomeIcon.png"), for: .normal)

        for mem in awesomeMem {
            
            if mem.youLiked  == "true" {
                cell.awesomeBtn?.setImage(UIImage(named: "AwesomeIconFilled.png"), for: .normal)
            }
        }


        if cellDictionary?["gender"] as AnyObject as? String == "F" {
            cell.profilePic.image = UIImage.init(named: "wall_female")
        } else {
            cell.profilePic.image = UIImage.init(named: "wall_male")
        }
        if (cellDictionary?["commentsCount"] as AnyObject as? Int == 0 && cellDictionary?["awesomeCount"] as AnyObject as? Int == 0) {
            cell.likesHeightConstraint.constant = 0
            cell.userCommentsHeightConstraint.constant = 0
            cell.imgViewHeightConstraint.constant += 30
            cell.likesBtn.isHidden = true
            cell.userCommentsBtn.isHidden = true
            
        } else {
            cell.likesBtn.isHidden = true
            cell.userCommentsBtn.isHidden = true
            cell.likesHeightConstraint.constant = 30
            cell.userCommentsHeightConstraint.constant = 30
            cell.imgViewHeightConstraint.constant -= 30
        }
        
        if cellDictionary?["awesomeCount"] as AnyObject as? Int != 0 {
            cell.likesBtn.isHidden = false
            
                cell.likesBtn.setTitle("\(cellDictionary?["awesomeCount"] as AnyObject as! Int) Awesome", for: .normal)
            
        }
        if cellDictionary?["awesomeCount"] as AnyObject as? Int == 0 {
           cell.awesomeBtn.setImage(UIImage(named: "AwesomeIcon")!, for: UIControlState.normal);
        }
        
        if cellDictionary?["commentsCount"] as AnyObject as? Int != 0 {
            cell.userCommentsBtn.isHidden = false
             cell.commentBtn.setImage(UIImage(named: "CommentsFilledIcon.png"), for: .normal)
            if cellDictionary?["commentsCount"] as AnyObject as? Int == 1 {
                cell.userCommentsBtn.setTitle("\(cellDictionary?["commentsCount"] as AnyObject as! Int) Comment", for: .normal)
               
            } else {
                cell.userCommentsBtn.setTitle("\(cellDictionary?["commentsCount"] as AnyObject as! Int) Comments", for: .normal)
               
            }
            
        }
        if cellDictionary?["commentsCount"] as AnyObject as? Int == 0 {
             cell.commentBtn.setImage(UIImage(named: "CheckBoxIcon.png"), for: .normal)
        }
        
        cell.tweakOwner.text = cellDictionary?["tweakOwner"] as AnyObject as? String
        cell.feedContent.text = cellDictionary?["feedContent"] as AnyObject as? String
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
        let dateElement = dateFormatter.date(from: (cellDictionary?["postedOn"] as AnyObject as? String)!)
        if dateElement == nil {
            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
            let dateElement1 = dateFormatter.date(from: (cellDictionary?["postedOn"] as AnyObject as? String)!)            
            cell.postedOn.text = dateFormatter.string(from: dateElement1!)
        } else {
            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
            
            cell.postedOn.text = dateFormatter.string(from: dateElement!)
        }
        
       
        
        let imageUrl = cellDictionary?["imageUrl"] as AnyObject as? String
        cell.imageUrl.sd_setImage(with: URL(string: imageUrl!));
        cell.admobView.isHidden = true;
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tempArray = NSMutableArray()
        if segue.identifier == "popOver" {
            if sender as! String == "comments"{
            let popOverVC = segue.destination as! AwesomeCountViewController
            let cellDict = self.tweakFeedsInfo?[self.myIndexPath.row]
            let comments = cellDict?["comments"] as! List<CommentsMembers>
            
            if cellDict?["commentsCount"] as! Int != 0 {
                var tempDict : [String:AnyObject] = [:]
                for members in comments {
                    tempDict["commentText"] = members.commentsCommentText as AnyObject
                    tempDict["nickName"] = members.commentsNickName as AnyObject
                    tempDict["postedOn"] = members.commentsPostedOn as AnyObject
                    tempDict["msisdn"] = members.commentsMsisdn as AnyObject
                    tempDict["commentsTime"] = members.commentsTimeIn as AnyObject
                    tempArray.add(tempDict)
                }
                popOverVC.tweakDictionary["comments"] = tempArray as AnyObject
                
                
            }
            popOverVC.checkVariable = "Comments"
            popOverVC.titleName = " Comments";
            popOverVC.feedContent = (cellDict?.feedContent)!
            popOverVC.gender = (cellDict?.gender)!
            popOverVC.imageUrl = (cellDict?.imageUrl)!
            popOverVC.msisdn = (cellDict?.msisdn)!
            popOverVC.awesomeCount = (cellDict?.awesomeCount)!
            popOverVC.commentsCount = (cellDict?.commentsCount)!
            popOverVC.tweakOwner = (cellDict?.tweakOwner)!
            popOverVC.childSnap = (cellDict?.snapShot)!
            popOverVC.nicKName = nicKName
            popOverVC.sex = sex
            } else {
                let popOverVC = segue.destination as! AwesomeCountViewController
                        popOverVC.titleName = " Awesome";
                        var tempDict : [String:AnyObject] = [:]
                        let cellDict = self.tweakFeedsInfo?[self.myIndexPath.row]
                        let awesomeMembers = cellDict?["awesomeMembers"] as! List<AwesomeMembers>
                        if cellDict?["awesomeCount"] as! Int != 0 {
                            for members in awesomeMembers {
                                tempDict["nickName"] = members.aweSomeNickName as AnyObject
                                tempDict["postedOn"] = members.aweSomePostedOn as AnyObject
                                tempDict["msisdn"] = members.aweSomeMsisdn as AnyObject
                                tempArray.add(tempDict)
            
                            }
                            popOverVC.tweakDictionary["awesomeMembers"] = tempArray as AnyObject
                        }
                        popOverVC.checkVariable = "Awesome"
            }
        }
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    func cellTappedOnImage(_ cell: TweakMyWallTableViewCell, sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = CGRect(x:0, y:0 - 64, width: self.view.frame.size.width, height: self.view.frame.size.height + 64)
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func cellTappedAwesome(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        
        
       

        cell.awesomeBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        cell.awesomeBtn.transform = .identity
                        cell.awesomeBtn.setImage(UIImage(named: "AwesomeIconFilled.png")!, for: UIControlState.normal);
            },
                       completion: nil)
        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
        let currentTime = Int64(currentTimeStamp)
        let cellDict = self.tweakFeedsInfo?[self.myIndexPath.row]
        let snap = cellDict?["snapShot"] as! String
        var aweSomeCount = cellDict?["awesomeCount"] as! Int
        let awesomeMem = cellDict?["awesomeMembers"]  as! List<AwesomeMembers>
        for mem in awesomeMem {
            if mem.youLiked == "true" {
                
            return
        }
    }
        
        cell.awesomeBtn.setImage(UIImage(named:"AwesomeIconFilled.png"), for: UIControlState.normal)
            aweSomeCount += 1
        
        
        DispatchQueue.global(qos: .background).async {
                       // Bounce back to the main thread to update the UI
            self.tweakFeedsRef.child(snap).child("awesomeMembers").childByAutoId().setValue([
                "msisdn" : self.userMsisdn as AnyObject,
                "postedOn" : currentTime as AnyObject,
                "nickName": self.nicKName as AnyObject
                ])
            self.tweakFeedsRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
            DispatchQueue.main.async {
            
            }
        }
            self.awesomePopUpSound()
        
        
    }
    
   
    func cellTappedLikes(_ cell: TweakMyWallTableViewCell) {
        
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "likes")
    }
    func cellTappedUserComments(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "comments")
    }
    func cellTappedComments(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "comments")
        
    }
    
    func cellTappedShare(_ cell: TweakMyWallTableViewCell){
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        
        let cellDictionary = self.tweakFeedsInfo?[self.myIndexPath.row]
        let msisdn = (cellDictionary?["msisdn"] as AnyObject as? String)! + ".jpeg"
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(msisdn)
        print(paths)
        let imageData = UIImageJPEGRepresentation(cell.imageUrl.image!, 0.7)
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(msisdn)
        if fileManager.fileExists(atPath: imagePAth){

            // set up activity view controller
            let imageToShare = [ imageData ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

        }else{
            print("No Image")
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            let imageToShare = [ imageData ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

        }
    }
    
    func awesomePopUpSound(){
        guard let url = Bundle.main.url(forResource: "AwesomePopUpSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 478.0 - 49.0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}

