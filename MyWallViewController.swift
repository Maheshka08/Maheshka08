//
//  MyWallViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//  Reviewed

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import AVFoundation

class TweakWall {
    @objc var snapShot : String
    @objc var feedContent : String
    @objc var gender : String
    @objc var imageUrl : String
    @objc var msisdn : String
    @objc var postedOn : Int
    @objc var awesomeCount : Int
    @objc var commentsCount : Int
    @objc var tweakOwner : String
    @objc var timeIn : NSDate
    var awesomeMembers : [TweakWallAwesomeMembers]
    var comments : [TweakWallCommentsMembers]
    
    init(snapShot: String, feedContent: String, gender: String, imageUrl: String, msisdn: String, postedOn: Int, awesomeCount: Int, commentsCount: Int, tweakOwner: String, timeIn: NSDate, awesomeMembers: [TweakWallAwesomeMembers], comments: [TweakWallCommentsMembers]) {
        
        self.snapShot = snapShot
        self.feedContent = feedContent
        self.gender = gender
        self.imageUrl = imageUrl
        self.msisdn = msisdn
        self.postedOn = postedOn
        self.awesomeCount = awesomeCount
        self.commentsCount = commentsCount
        self.tweakOwner = tweakOwner
        self.timeIn = timeIn
        self.awesomeMembers = awesomeMembers
        self.comments = comments
        
    }
    
}

class TweakWallAwesomeMembers {
    @objc var aweSomeNickName : String
    @objc var aweSomePostedOn : String
    @objc var aweSomeMsisdn : String
    @objc var youLiked : String
    @objc var awesomeSnapShot : String
    
    init(aweSomeNickName : String, aweSomePostedOn : String, aweSomeMsisdn : String, youLiked : String, awesomeSnapShot : String) {
        self.aweSomeNickName = aweSomeNickName
        self.aweSomePostedOn = aweSomePostedOn
        self.aweSomeMsisdn = aweSomeMsisdn
        self.youLiked = youLiked
        self.awesomeSnapShot = awesomeSnapShot
    }
}

class TweakWallCommentsMembers {
    @objc var commentsNickName : String
    @objc var commentsPostedOn : String
    @objc var commentsMsisdn : String
    @objc var commentsCommentText : String
    @objc var commentsTimeIn : NSDate
    
    init(commentsNickName : String, commentsPostedOn : String, commentsMsisdn : String, commentsCommentText : String, commentsTimeIn : NSDate) {
        self.commentsNickName = commentsNickName
        self.commentsPostedOn = commentsPostedOn
        self.commentsMsisdn = commentsMsisdn
        self.commentsCommentText = commentsCommentText
        self.commentsTimeIn = commentsTimeIn
    }
    
}
class MyWallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ButtonCellDelegate {
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc let queue = DispatchQueue(label: "background")
    @objc var player: AVAudioPlayer?
    var myProfileInfo : Results<MyProfileInfo>?
    var tweakFeedsInfo : Results<TweakFeedsInfo>?
    let realm :Realm = try! Realm()
    @objc var myIndex : Int = 0
    @objc var refreshPage: Int = 10
    @objc var myIndexPath : IndexPath = []
    @objc var tweakFeedsRef : DatabaseReference!
    var tweakFeedsArray = [TweakWall]()
    @objc var tweakFeedsDictionary : [String:AnyObject] = [:]
    @objc var nicKName : String = ""
    @objc var sex : String = ""
    @objc var userMsisdn : String = ""
    var isLiked : Bool?
    @objc var Number : String = ""
    @objc var countryCode : String = ""
    @objc var loadingData = false
    @objc var newImageView = UIImageView()
    @objc var scrollV = UIScrollView()
    @objc var postedOn = 0
    var feedId = ""
    var type = 0
    var topBannersDict = [String: AnyObject]()
    var topBannerImageLink = ""
    var topBannerImage = ""
    var ptpPackage = ""
    @IBOutlet var tweakWallTableView: UITableView!
    
    @objc func goToDesiredPage(_ notification: NSNotification) {
        let obj = notification.object as! [String: AnyObject]
        let link = obj["link"] as! String
        let type = obj["type"] as! Int
        let tempTweakArray = self.tweakFeedsArray.filter{$0.snapShot == link}
                         if tempTweakArray.count > 0 {
                             if let indexPathRow = self.tweakFeedsArray.index(where: {$0.snapShot == link}) {
                                 // self.cellTapped = false
                               
                                 let indexPath = NSIndexPath(row: indexPathRow, section: 0)
                                // self.tweakWallTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                                 self.myIndexPath = indexPath as IndexPath
                                 if type == 3 {
                                 self.performSegue(withIdentifier: "popOver", sender: "likes")
                                 } else if type == 4 {
                                 self.performSegue(withIdentifier: "popOver", sender: "comments")
                                 }
                             }
       
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MyWallViewController.goToDesiredPage(_:)), name: NSNotification.Name(rawValue: "SHOW_TWEAKWALL_DETAIL"), object: nil);
        self.tweakFeedsArray = [TweakWall]()
        self.addBackButton()
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
        
        self.title = bundle.localizedString(forKey: "tweak_wall", value: nil, table: nil)
        tweakFeedsRef = Database.database().reference().child("TweakFeeds")
        self.tweakFeedsRef.observe(.childChanged, with: { (snapshot) in
            self.foundSnapshot(snapshot)
        })
        self.tweakFeedsRef.observe(.childAdded, with: { (snapshot) in
            if self.tweakFeedsArray.count > 0 {
                self.addNewTweak(snapshot)
            }
        })
        
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name
            sex = myProfObj.gender
            Number = myProfObj.msisdn
            
        }
        // self.tweakFeedsInfo = self.realm.objects(TweakFeedsInfo.self)
        MBProgressHUD.showAdded(to: self.view, animated: true);
        // check whether user is blocked or not
        let userdefaults = UserDefaults.standard
        if userdefaults.string(forKey: "USERBLOCKED") != nil{
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "No tweakfeeds")
            MBProgressHUD.hide(for: self.view, animated: true);
            
            return
        }
        self.getTopBanners()
        
    }
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popToRootViewController(animated: true)        //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        //            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        //        self.navigationController?.pushViewController(clickViewController!, animated: true);
        
        
    }
    
    func gettweaks(tweakSnap: String, tweakObj: [String : AnyObject]?) -> TweakWall {
        let tweakWallObj = TweakWall(snapShot: tweakSnap, feedContent: self.getTweakVal(tweakObj: tweakObj!, val: "feedContent", type: String.self) as! String, gender: self.getTweakVal(tweakObj: tweakObj!, val: "gender", type: String.self) as! String, imageUrl: self.getTweakVal(tweakObj: tweakObj!, val: "imageUrl", type: String.self) as! String, msisdn: self.getTweakVal(tweakObj: tweakObj!, val: "msisdn", type: String.self) as! String, postedOn: self.getTweakVal(tweakObj: tweakObj!, val: "postedOn", type: Int.self) as! Int, awesomeCount: self.getTweakVal(tweakObj: tweakObj!, val: "awesomeCount", type: Int.self) as! Int, commentsCount: self.getTweakVal(tweakObj: tweakObj!, val: "commentsCount", type: Int.self) as! Int, tweakOwner: self.getTweakVal(tweakObj: tweakObj!, val: "tweakOwner", type: String.self) as! String, timeIn: NSDate() , awesomeMembers: self.getArrayValues(tweakObj: tweakObj!, val: "awesomeMembers", returningClass: TweakWallAwesomeMembers.self) as! [TweakWallAwesomeMembers], comments: self.getArrayValues(tweakObj: tweakObj!, val: "comments", returningClass: TweakWallCommentsMembers.self) as! [TweakWallCommentsMembers])
        
        return tweakWallObj
    }
    
    func getTweakVal<T>(tweakObj: [String: AnyObject], val: String, type: T.Type) -> AnyObject {
        if (tweakObj.index(forKey: val) != nil) {
            if !(tweakObj[val] as AnyObject is NSNull) {
                return tweakObj[val] as AnyObject
            }
        }
        if type == Bool.self {
            return false as AnyObject
        } else if type == String.self {
            return "" as AnyObject
        } else if type == Int.self {
            return 0 as AnyObject
        } else if type == NSNumber.self {
            return 0 as AnyObject
        }
        return AnyObject.self as AnyObject
    }
    
    func getArrayValues<T>(tweakObj: [String: AnyObject], val: String, returningClass: T.Type) -> AnyObject {
        //  print(returningClass)
        if (tweakObj.index(forKey: val) != nil) {
            if !(tweakObj[val] as AnyObject is NSNull) {
                if returningClass == TweakWallAwesomeMembers.self {
                    let awesomeMembers = tweakObj[val]  as? [String : AnyObject];
                    let awesomeCount = self.getTweakVal(tweakObj: tweakObj, val: "awesomeCount", type: Int.self) as! Int
                    var awesomeLikedMembers = [TweakWallAwesomeMembers]()
                    
                    if awesomeCount != 0 && awesomeMembers != nil {
                        for members in awesomeMembers! {
                            let awesomeMemObj = TweakWallAwesomeMembers(aweSomeNickName: "", aweSomePostedOn: "", aweSomeMsisdn: "", youLiked: "", awesomeSnapShot: "")
                            let number = (members.value["msisdn"] as AnyObject) as! String;
                            if number == UserDefaults.standard.value(forKey: "msisdn") as! String {
                                awesomeMemObj.youLiked = "true"
                            }else {
                                awesomeMemObj.youLiked = "false"
                            }
                            awesomeMemObj.awesomeSnapShot = members.key
                            awesomeMemObj.aweSomeNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateFormatter = DateFormatter();
                            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject;
                            
                            awesomeMemObj.aweSomePostedOn = dateArrayElement as! String;
                            awesomeMemObj.aweSomeMsisdn = (members.value["msisdn"] as AnyObject) as! String;
                            awesomeLikedMembers.append(awesomeMemObj);
                        }
                    }
                    return awesomeLikedMembers as AnyObject
                } else if returningClass == TweakWallCommentsMembers.self {
                    let commentsCount = (tweakObj["commentsCount"] as AnyObject) as! Int
                    let commentsMembers = tweakObj[val] as? [String : AnyObject]
                    var commentMembers = [TweakWallCommentsMembers]()
                    
                    if commentsCount != 0 && commentsMembers != nil {
                        for members in commentsMembers! {
                            let commentsObj = TweakWallCommentsMembers(commentsNickName: "", commentsPostedOn: "", commentsMsisdn: "", commentsCommentText: "", commentsTimeIn: NSDate())
                            
                            commentsObj.commentsCommentText = (members.value["commentText"] as AnyObject) as! String
                            commentsObj.commentsMsisdn = (members.value["msisdn"] as AnyObject) as! String
                            commentsObj.commentsNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateFormatter = DateFormatter();
                            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
                            commentsObj.commentsPostedOn = dateArrayElement as! String
                            commentMembers.append(commentsObj)
                        }
                        
                    }
                    return commentMembers as AnyObject
                }
            }
        }
        //        else {
        //        return canBuyDiyArray as AnyObject
        //        }
        return [AnyObject]() as AnyObject
    }
    
    func addNewTweak(_ snapshot: DataSnapshot) {
        let dispatch_group = DispatchGroup()
        dispatch_group.enter()
        
        
        let feedObj = snapshot.value as? [String : AnyObject];
        
        let tweakFeedsObj = self.gettweaks(tweakSnap: snapshot.key, tweakObj: feedObj)
        self.tweakFeedsArray.append(tweakFeedsObj)
        
        dispatch_group.leave()
        dispatch_group.notify(queue: DispatchQueue.main) {
            MBProgressHUD.hide(for: self.view, animated: true);
            
            self.tweakFeedsArray = self.tweakFeedsArray.sorted(by: { $0.snapShot > $1.snapShot })
            self.tweakWallTableView.reloadData()
            
        }
        
    }
    
    func foundSnapshot(_ snapshot: DataSnapshot) {
        let idChanged = snapshot.key
        var rowVal = 0
        if snapshot.childrenCount > 0 {
            
            let dispatch_group = DispatchGroup();
            dispatch_group.enter();
            let feedObj = snapshot.value as? [String : AnyObject];
            
            let tweakFeedsObj = self.gettweaks(tweakSnap: snapshot.key, tweakObj: feedObj)
            if let indexPathRow = self.tweakFeedsArray.index(where: {$0.snapShot == idChanged}) {
                self.tweakFeedsArray[indexPathRow] = tweakFeedsObj
                rowVal = indexPathRow
            }
            
            dispatch_group.leave()
            dispatch_group.notify(queue: DispatchQueue.main) {
                let indexPosition = IndexPath(row: rowVal, section: 0)
                UIView.setAnimationsEnabled(false)
                // self.tweakWallTableView.beginUpdates()
                self.tweakWallTableView.reloadRows(at: [indexPosition], with: .none)
                //self.tweakWallTableView.endUpdates()
                //                UIView.performWithoutAnimation {
                //                    self.tweakWallTableView.reloadRows(at: [indexPosition], with: .none)
                //                }
            }
            
        }
        
        
        //Process new coordinates
    }
    
    @objc func getFireBaseData() {
        self.tweakFeedsRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                //   print(snapshot.childrenCount)
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for tweakFeeds in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let feedObj = tweakFeeds.value as? [String : AnyObject];
                    
                    let tweakFeedsObj = self.gettweaks(tweakSnap: tweakFeeds.key, tweakObj: feedObj)
                    self.tweakFeedsArray.append(tweakFeedsObj)
                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    self.tweakFeedsArray = self.tweakFeedsArray.sorted(by: { $0.snapShot > $1.snapShot })
                    self.tweakWallTableView.reloadData()
                    let tempTweakArray = self.tweakFeedsArray.filter{$0.snapShot == self.feedId}
                    if tempTweakArray.count > 0 {
                        if let indexPathRow = self.tweakFeedsArray.index(where: {$0.snapShot == self.feedId}) {
                            // self.cellTapped = false
                          
                            let indexPath = NSIndexPath(row: indexPathRow, section: 0)
                           // self.tweakWallTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                            self.myIndexPath = indexPath as IndexPath
                            if self.type == 3 {
                            self.performSegue(withIdentifier: "popOver", sender: "likes")
                            } else if self.type == 4 {
                            self.performSegue(withIdentifier: "popOver", sender: "comments")
                            }
                        }

                        
                    }
                    if self.postedOn == 0 {
                        return
                    }
                    if let indexPathRow = self.tweakFeedsArray.index(where: {$0.postedOn == self.postedOn}) {
                        // self.cellTapped = false
                        if indexPathRow == 0 {
                            return
                        }
                        let indexPath = NSIndexPath(row: indexPathRow, section: 0)
                        self.tweakWallTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                    }
                }
            }
        })
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.newImageView
    }
    
    
    //        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //            if !loadingData && indexPath.row == self.refreshPage - 1 {
    //                loadingData = true
    //                MBProgressHUD.showAdded(to: self.view, animated: true);
    //                self.refreshPage += 10
    //                loadMoreData()
    //            }
    //        }
    
    @objc func loadMoreData() {
        DispatchQueue.global(qos: .background).async {
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
           // self.getFireBaseData()
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.loadingData = false
                
            }
        }
    }
    
    @objc func bannerClicked() {
        
        self.goToDesiredVC(promoAppLink: self.topBannerImageLink)
    }
    func goToHomePage() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
           let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.navigationController?.pushViewController(clickViewController!, animated: true)
          
       }
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
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
    func goToDesiredVC(promoAppLink: String) {//IndWLIntusoe3uelxER
        if promoAppLink == "HOME" || promoAppLink == "" {
            self.goToHomePage()
            
        } else if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {
            
            
            if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                
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
        }    }
          
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if self.topBannersDict.count > 0 {
           let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))

           let buttonImage = UIButton(type: .custom)
           buttonImage.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80)
           //        button2.backgroundColor = .blue
          // buttonImage.setImage(UIImage.init(named: "ad-banner-1"), for: .normal)
               //  let imageUrl = self.topBannersDict["img"] as! String
               let url = URL(string: self.topBannerImage)
                      DispatchQueue.global(qos: .background).async {
                          // Call your background task
                          let data = try? Data(contentsOf: url!)
                          // UI Updates here for task complete.
                       //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");

                          if let imageData = data {
                              let image = UIImage(data: imageData)
                              DispatchQueue.main.async {
                                  
                               buttonImage.setBackgroundImage(image, for: .normal)
                                  
                              }
                       }
               }
           buttonImage.addTarget(self, action:#selector(self.bannerClicked), for: .touchUpInside)
           headerView.backgroundColor = UIColor.groupTableViewBackground
           headerView.addSubview(buttonImage)

           return headerView
           }
           return UIView()
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           if self.topBannersDict.count > 0 {
              return 80
           }
        return 0
       }
       
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  if self.tweakFeedsArray != nil {
        if self.tweakFeedsArray.count > 0 {
            MBProgressHUD.hide(for: self.view, animated: true);
            
            return self.tweakFeedsArray.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TweakMyWallTableViewCell;
        if self.tweakFeedsArray.count != 0 {
            
            if cell.buttonDelegate == nil {
                cell.buttonDelegate = self;
            }
            cell.cellIndexPath = indexPath.row
            cell.myIndexPath = indexPath
            
            let cellDictionary = self.tweakFeedsArray[indexPath.row]
            let awesomeMem = cellDictionary.awesomeMembers
            cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon.png"), for: .normal)
            
            for mem in awesomeMem {
                
                if mem.youLiked  == "true" {
                    cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon_hover.png"), for: .normal)
                }
            }
            
            if cellDictionary.gender as AnyObject as? String == "F" {
                cell.profilePic.image = UIImage.init(named: "wall_female")
            } else {
                cell.profilePic.image = UIImage.init(named: "wall_male")
            }
            if (cellDictionary.commentsCount as AnyObject as? Int == 0 && cellDictionary.awesomeCount as AnyObject as? Int == 0) {
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
            
            if cellDictionary.awesomeCount as AnyObject as? Int != 0 {
                cell.likesBtn.isHidden = false
                
                cell.likesBtn.setTitle("\(cellDictionary.awesomeCount as AnyObject as! Int) " + bundle.localizedString(forKey: "awesome", value: nil, table: nil), for: .normal)
                
            }
            if cellDictionary.awesomeCount as AnyObject as? Int == 0 {
                cell.awesomeBtn.setImage(UIImage(named: "awesome_icon")!, for: UIControl.State.normal);
            }
            
            if cellDictionary.commentsCount as AnyObject as? Int != 0 {
                cell.userCommentsBtn.isHidden = false
                cell.commentBtn.setImage(UIImage(named: "comment_icon_hover.png"), for: .normal)
                if cellDictionary.commentsCount as AnyObject as? Int == 1 {
                    cell.userCommentsBtn.setTitle("\(cellDictionary.commentsCount as AnyObject as! Int) " + bundle.localizedString(forKey: "comment", value: nil, table: nil), for: .normal)
                    
                } else {
                    cell.userCommentsBtn.setTitle("\(cellDictionary.commentsCount as AnyObject as! Int) " +  bundle.localizedString(forKey: "comments", value: nil, table: nil), for: .normal)
                    
                }
                
            }
            if cellDictionary.commentsCount as AnyObject as? Int == 0 {
                cell.commentBtn.setImage(UIImage(named: "comment_icon.png"), for: .normal)
            }
            
            cell.awesomeButtonTitle.setTitle(bundle.localizedString(forKey: "awesome", value: nil, table: nil), for: .normal)
            cell.commentsButtonTitle.setTitle(bundle.localizedString(forKey: "comments", value: nil, table: nil), for: .normal)
            
            cell.tweakOwner.text = cellDictionary.tweakOwner as AnyObject as? String
            cell.feedContent.text = cellDictionary.feedContent as AnyObject as? String
            let milisecond = cellDictionary.postedOn as AnyObject;
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "d MMM yyyy h:mm a";
            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
            cell.postedOn.text = dateFormatter.string(from: dateVar) as AnyObject as? String;
            //        let dateFormatter = DateFormatter();
            //        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
            //        let dateElement = dateFormatter.date(from: (cellDictionary.postedOn as AnyObject as? String)!)
            //        if dateElement == nil {
            //            dateFormatter.dateFormat = "d MMM yyyy h:mm a";
            //            let dateElement1 = dateFormatter.date(from: (cellDictionary.postedOn as AnyObject as? String)!)
            //            if dateElement1 == nil {
            //                            cell.postedOn.text = ""
            //            } else {
            //            cell.postedOn.text = dateFormatter.string(from: dateElement1!)
            //            }
            //        } else {
            //            dateFormatter.dateFormat = "d MMM yyyy h:mm a";
            //
            //            cell.postedOn.text = dateFormatter.string(from: dateElement!)
            //        }
            
            let imageUrl = cellDictionary.imageUrl as AnyObject as? String
            cell.imageUrl.sd_setImage(with: URL(string: imageUrl!))
            cell.admobView.isHidden = true;
        }
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tempArray = NSMutableArray()
        if segue.identifier == "popOver" {
            if sender as! String == "comments"{
                let popOverVC = segue.destination as! AwesomeCountViewController
                let cellDict = self.tweakFeedsArray[self.myIndexPath.row]
                let comments = cellDict.comments
                
                if cellDict.commentsCount != 0 {
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
                popOverVC.imageUrl = (cellDict.imageUrl)
                popOverVC.checkVariable = self.bundle.localizedString(forKey: "comments", value: nil, table: nil)
                
                popOverVC.titleName =  self.bundle.localizedString(forKey: "comments", value: nil, table: nil);
                popOverVC.feedContent = (cellDict.feedContent)
                popOverVC.gender = (cellDict.gender)
                popOverVC.imageUrl = (cellDict.imageUrl)
                popOverVC.msisdn = (cellDict.msisdn)
                popOverVC.awesomeCount = (cellDict.awesomeCount)
                popOverVC.commentsCount = (cellDict.commentsCount)
                popOverVC.tweakOwner = (cellDict.tweakOwner)
                popOverVC.childSnap = (cellDict.snapShot)
                popOverVC.nicKName = nicKName
                popOverVC.sex = sex
            } else {
                let popOverVC = segue.destination as! AwesomeCountViewController
                popOverVC.titleName = self.bundle.localizedString(forKey: "awesome", value: nil, table: nil)
                var tempDict : [String:AnyObject] = [:]
                let cellDict = self.tweakFeedsArray[self.myIndexPath.row]
                let awesomeMembers = cellDict.awesomeMembers
                
                if cellDict.awesomeCount != 0 {
                    for members in awesomeMembers {
                        tempDict["nickName"] = members.aweSomeNickName as AnyObject
                        tempDict["postedOn"] = members.aweSomePostedOn as AnyObject
                        tempDict["msisdn"] = members.aweSomeMsisdn as AnyObject
                        tempArray.add(tempDict)
                        
                    }
                    popOverVC.imageUrl = (cellDict.imageUrl)

                    popOverVC.tweakDictionary["awesomeMembers"] = tempArray as AnyObject
                }
                popOverVC.checkVariable = self.bundle.localizedString(forKey: "awesome", value: nil, table: nil)
            }
        } else if segue.identifier == "nutritionLabels" {
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
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    @objc func cellTappedOnImage(_ cell: TweakMyWallTableViewCell, sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let dismissBtn = UIButton(frame: CGRect(5, 64, 36, 36))
        dismissBtn.setImage(UIImage.init(named: "icons8-delete"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(self.dismissImageView), for: .touchUpInside)
        scrollV = UIScrollView(frame: CGRect(x: 0, y: 0 - 64, width: self.view.frame.size.width, height: self.view.frame.size.height + 64))
        scrollV.minimumZoomScale = 1.0
        scrollV.maximumZoomScale = 3.5
        scrollV.delegate = self
        scrollV.backgroundColor = UIColor.black
        self.view.addSubview(scrollV)
        newImageView = UIImageView(image: imageView.image)
        newImageView.frame = CGRect(x:0, y:0 , width: self.view.frame.size.width, height: self.view.frame.size.height)
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        scrollV.addSubview(newImageView)
        scrollV.addSubview(dismissBtn)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        newImageView.isUserInteractionEnabled = true
        
        
    }
    
    //    func pinch(sender:UIPinchGestureRecognizer) {
    //        if sender.state == .began || sender.state == .changed {
    //            let currentScale = newImageView.frame.size.width/newImageView.bounds.size.width
    //            let newScale = currentScale*sender.scale
    //            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
    //            newImageView.transform = transform
    //            sender.scale = 1
    //        } else if sender.state == .ended {
    //            newImageView.transform = CGAffineTransform.identity
    //        }
    //    }
    @objc func dismissImageView() {
        scrollV.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getTodayWeekDay()-> String{
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "EEEE"
             let weekDay = dateFormatter.string(from: Date())
             return weekDay
       }
    
    func getTopBanners() {
       // MBProgressHUD.hide(for: self.view, animated: true);
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
     if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
            self.getFireBaseData()
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
                   Database.database().reference().child("GlobalVariables").child("Pages").child("TopBanners").child("TweakWall").child(self.countryCode).child("\(weekNumber)").observe(DataEventType.value, with: { (snapshot) in
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
                           // MBProgressHUD.hide(for: self.view, animated: true);
                            
                            self.getFireBaseData()
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            
                            self.getFireBaseData()
                        }
            }
                   
                    
                   
                    
                })
        }
    }
    
    @objc func likesAndNoLikes(_ cell: TweakMyWallTableViewCell) {
        //        DispatchQueue.main.async {
        //            MBProgressHUD.showAdded(to: self.view, animated: true)
        //        }
        
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        if let btnImage = cell.awesomeBtn.image(for: .normal),
            let img = UIImage(named: "awesome_icon"), btnImage.pngData() == img.pngData()
        {
            
            
            
            //   DispatchQueue.main.async {
            
            
            //    }
            //            let dispatch_group = DispatchGroup()
            //            dispatch_group.enter()
            self.awesomePopUpSound()
            
            cell.awesomeBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 4.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            cell.awesomeBtn.transform = .identity
                            cell.awesomeBtn.setImage(UIImage(named: "awesome_icon_hover.png")!, for: UIControl.State.normal);
                },
                           completion: nil)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async() {
                
                
                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
                let currentTime = Int64(currentTimeStamp)
                let cellDict = self.tweakFeedsArray[self.myIndexPath.row]
                let snap = cellDict.snapShot
                var aweSomeCount = cellDict.awesomeCount
                let awesomeMem = cellDict.awesomeMembers
                for mem in awesomeMem {
                    if mem.youLiked == "true" {
                        
                        return
                    }
                }
                
                //cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover.png"), for: UIControl.State.normal)
                aweSomeCount += 1
                
                //DispatchQueue.global(qos: .background).async {
                // Bounce back to the main thread to update the UI
                self.tweakFeedsRef.child(snap).child("awesomeMembers").childByAutoId().setValue([
                    "msisdn" : self.userMsisdn as AnyObject,
                    "postedOn" : currentTime as AnyObject,
                    "nickName": self.nicKName as AnyObject
                    ])
                self.tweakFeedsRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
                
                //  }
                //             DispatchQueue.main.async {
                //            }
                if cellDict.msisdn == self.userMsisdn {
                    DispatchQueue.main.async {
                                       [weak self] in
                                       // Return data and update on the main thread, all UI calls should be on the main thread
                                       // Create strong reference to the weakSelf inside the block so that it´s not released while the block is running
                                       guard let strongSelf = self else {return}
                                       MBProgressHUD.hide(for: strongSelf.view, animated: true)
                                       
                                   }
                    return
                }
                let noteType : Int = 3
                APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.WALL_PUSH_NOTIFICATIONS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: [
                    "msisdn": cellDict.msisdn as AnyObject,
                    "noteType": noteType as AnyObject ,
                    "feedId": snap as AnyObject
                    ], success: { response in
                        DispatchQueue.main.async {
                            
                        }
                }, failure : { error in
                    
                    print("failure")
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        //   TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                    }
                    
                })
                
                DispatchQueue.main.async {
                    [weak self] in
                    // Return data and update on the main thread, all UI calls should be on the main thread
                    // Create strong reference to the weakSelf inside the block so that it´s not released while the block is running
                    guard let strongSelf = self else {return}
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    
                }
            }
            //            dispatch_group.leave()
            
        } else {
            
            //  self.myIndexPath = cell.myIndexPath
            self.awesomePopUpSound()
            
            cell.awesomeBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 4.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            cell.awesomeBtn.transform = .identity
                            cell.awesomeBtn.setImage(UIImage(named: "awesome_icon")!, for: UIControl.State.normal);
                },
                           completion: nil)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            DispatchQueue.global().async() {
                
                
                let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
                let currentTime = Int64(currentTimeStamp)
                let cellDict = self.tweakFeedsArray[self.myIndexPath.row]
                let snap = cellDict.snapShot
                var aweSomeCount = cellDict.awesomeCount
                let awesomeMem = cellDict.awesomeMembers
                
                //        if (awesomeMem.contains(where: {$0.aweSomeMsisdn == self.userMsisdn})) {
                //
                //        }
                for mem in awesomeMem {
                    if mem.aweSomeMsisdn == self.userMsisdn {
                        let awesomeSnap = mem.awesomeSnapShot
                        //cell.awesomeBtn.setImage(UIImage(named:"awesome_icon_hover"), for: UIControl.State.normal)
                        aweSomeCount -= 1
                        if aweSomeCount < 0 {
                            aweSomeCount = 0
                        }
                        
                        // Bounce back to the main thread to update the UI
                        
                        self.tweakFeedsRef.child(snap).child("awesomeMembers").child(awesomeSnap).removeValue()
                        
                        self.tweakFeedsRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    [weak self] in
                    // Return data and update on the main thread, all UI calls should be on the main thread
                    // Create strong reference to the weakSelf inside the block so that it´s not released while the block is running
                    guard let strongSelf = self else {return}
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    cell.awesomeBtn?.setImage(UIImage(named: "awesome_icon"), for: .normal)
                    
                }
            }
        }
    }
    
    @objc func cellTappedAwesome(_ cell: TweakMyWallTableViewCell) {
        likesAndNoLikes(cell)
    }
    
    @objc func cellTappedLikes(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "likes")
    }
    
    @objc func cellTappedUserComments(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "comments")
    }
    
    @objc func cellTappedComments(_ cell: TweakMyWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.performSegue(withIdentifier: "popOver", sender: "comments")
        
    }
    
    @objc func cellTappedShare(_ cell: TweakMyWallTableViewCell){
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        
        let cellDictionary = self.tweakFeedsArray[self.myIndexPath.row]
        let msisdn = (cellDictionary.msisdn as AnyObject as? String)! + ".jpeg"
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(msisdn)
        //print(paths)
        let imageData = cell.imageUrl.image!.jpegData(compressionQuality: 0.7)
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
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func awesomePopUpSound(){
        guard let url = Bundle.main.url(forResource: "AwesomePopUpSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 478.0 - 49.0;
    }
    
    @objc func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
