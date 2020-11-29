//
//  MainPageScrollableTableViewController.swift
//  GestureRecognizers
//
//  Created by apple on 19/12/19.
//  Copyright © 2019 Uday Surya. All rights reserved.
//

import UIKit
import Firebase


class MainPageScrollableTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var recipesArray = NSArray()
    var tweaksArray = NSMutableArray()
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView1: UICollectionView!
    let sectionHeaderTitleArray = ["Our recipes for the week","Latest greatest from the Tweak Wall"]
    var tweakFeedsArray = [TweakWall]()
    var pullControl = UIRefreshControl()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func goToTweakWall(postedOn: Int) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myWall : MyWallViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as! MyWallViewController;
        myWall.postedOn = postedOn
        
        self.navigationController?.pushViewController(myWall, animated: true);
    }
    
    func goToRecipeWall(title: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let recipeWall : TweakRecipeViewController = storyBoard.instantiateViewController(withIdentifier: "TweakRecipeViewController") as! TweakRecipeViewController;
        recipeWall.recTitle = title
        
        self.navigationController?.pushViewController(recipeWall, animated: true);
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView2 {
        if self.tweakFeedsArray.count > 0 {
            let cellDict = self.tweakFeedsArray[indexPath.row]
            self.goToTweakWall(postedOn: cellDict.postedOn)
        }
        } else  if collectionView == self.collectionView1 {
             if self.recipesArray.count > 0 {
                let cellDict = self.recipesArray[indexPath.row] as! [String: AnyObject]
                self.goToRecipeWall(title: (cellDict["recp_id"] as AnyObject as? String)!)
            }
        }
      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
    }
   override func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:28)) //set these values as necessary
    returnedView.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        let label = UILabel(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:28))
        label.text = "  " + self.sectionHeaderTitleArray[section]
    label.textColor =  UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0);
    label.font = UIFont(name:"QUESTRIAL-REGULAR", size: 16.0)
    let imgView = UIImageView(frame: CGRect(x: tableView.frame.size.width - 18, y: 4, width: 14, height: 20))
    imgView.image = UIImage.init(named: "arrow")
        returnedView.addSubview(label)
    returnedView.addSubview(imgView)
        
        return returnedView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageScrollCollectionViewCell
        if collectionView == self.collectionView2 {
            if self.tweakFeedsArray.count > 0 {
        let cellDict = self.tweakFeedsArray[indexPath.row]
                DispatchQueue.main.async {
                    cell.itemLabel1.text = "\(cellDict.awesomeCount)" + " " + "awesome"
                    let comment = (cellDict.commentsCount > 0) ? "comments" : "comment";
                    cell.itemLabel2.text = "\(cellDict.commentsCount)" + " " + comment + " "
                    let imageUrl = cellDict.imageUrl as AnyObject as? String
                    cell.foodImageView.sd_setImage(with: URL(string: imageUrl!))
                }
       
            }
        }
        if collectionView == collectionView1 {
            if self.recipesArray.count > 0 {
            let cellDict = self.recipesArray[indexPath.row] as! [String: AnyObject]
                 DispatchQueue.main.async {
                    cell.itemLabel1.text = "carbs: " + "\(cellDict["recp_carbs"] as AnyObject as! String)"
                    cell.itemLabel2.text = "calories: " + "\(cellDict["recp_cals"] as AnyObject as! String)" + " "
            let imageUrl = cellDict["recp_img"] as AnyObject as! String
            cell.foodImageView.sd_setImage(with: URL(string: imageUrl))
            cell.titleLbl.text =  cellDict["recp_title"] as AnyObject as? String
                }
                
            }
        }
        return cell
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
                self.collectionView2.reloadItems(at: [indexPosition])
               
            }
            
        }
        
        
        //Process new coordinates
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
    
        return [AnyObject]() as AnyObject
    }
    
    @objc func getRecipes() {
   
       
        if UserDefaults.standard.value(forKey: "userSession") != nil {
            APIWrapper.sharedInstance.postRequestWithHeadersForIndiaAiDPContent(TweakAndEatURLConstants.HOMERECIPES, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                let responseDict = response as! [String:AnyObject];
                if responseDict["callStatus"] as! String == "GOOD" {
                    self.recipesArray = responseDict["data"] as AnyObject as! NSArray
                    print(self.recipesArray)
                    self.collectionView1.delegate = self
                    self.collectionView1.dataSource = self
                    self.collectionView1.reloadData()
                }
                
            }, failure: { error in
                print("Error in reminders");
            })
        }
    }
    
    @objc func getRecipesAndTweakWall() {
        self.getRecipes()
        if UserDefaults.standard.value(forKey: "userSession") != nil {
            Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "postedOn").queryLimited(toLast: 5).observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    self.tweakFeedsArray = [TweakWall]()
                    let dispatch_group = DispatchGroup();
                    dispatch_group.enter();
                    
                    for tweakFeeds in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let feedObj = tweakFeeds.value as? [String : AnyObject];
                        
                        let tweakFeedsObj = self.gettweaks(tweakSnap: tweakFeeds.key, tweakObj: feedObj)
                        self.tweakFeedsArray.append(tweakFeedsObj)
                    }
                    dispatch_group.leave();
                    
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        self.tweakFeedsArray = self.tweakFeedsArray.sorted(by: { $0.snapShot > $1.snapShot })
                        self.collectionView2.delegate = self
                        self.collectionView2.dataSource = self
                        self.collectionView2.reloadData()
                       
                        
                    }
                }
            })
        }
    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 1 {
//            return 50
//
//        }
//        return 0
//    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // example code
        if decelerate {
            if(scrollView.contentOffset.y < 0) {
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
            } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: false)
            }

        }
}
//    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        if(scrollView.contentOffset.y < 0) {
//           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
//            print("reached end")
//
//        }
//        print("reached end")
//
//    }
    
  
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
//            //you reached end of the table
//            print("reached end")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
//            return
//        } else if (scrollView.contentOffset.y <= 0){
//            //reach top
//            print("reached top")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: false)
//            return
//        }
//    }
    @objc func refresh(_ sender: Any) {
        //  your code to reload tableView
        print("refreshing...")
        self.pullControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addBorder(toSide: .Top, withColor: UIColor.darkGray.cgColor, andThickness: 1)

        self.tableView.backgroundColor = .clear
        //self.pullControl.tintColor = .clear
        pullControl.attributedTitle = NSAttributedString(string: "Pull down to Collapse..")
       // pullControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        self.pullControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(pullControl)

        NotificationCenter.default.addObserver(self, selector: #selector(MainPageScrollableTableViewController.getRecipesAndTweakWall), name: NSNotification.Name(rawValue: "GET_RECIPES_AND_TWEAKS"), object: nil)
        self.getRecipesAndTweakWall();
    }
}
