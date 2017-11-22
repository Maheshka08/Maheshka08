//
//  TweakNotificationsViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/1/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import UserNotifications

class TweakNotificationsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, TweakNotifyTableViewCellDelegate, UNUserNotificationCenterDelegate{
    
    func cellTappedOnImage(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebViewController
        destinationVC.urlString = sender as! String

    }
    
    func cellTappedOnMessageLbl(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer) {
        print(sender)
        self.myIndexPath = cell.myIndexPath
        let cellDictionary = self.announcements?[self.myIndexPath.row]
        let message = cellDictionary!["announcement"] as AnyObject as? String
        if message?.extractURLs().count == 0 {
            return
        } else {
            self.performSegue(withIdentifier: "showWebView", sender: message?.extractURLs()[0].absoluteString)

        }

    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var badgeCountData : Results<BadgeCount>?
    var badgeCount: Int = 0
    var myIndex : Int = 0
    var myIndexPath : IndexPath = []
    var announcements : Results<Announcements>?
    let realm :Realm = try! Realm()
    var tweakNotifyRef : DatabaseReference!
    @IBOutlet weak var notificationTableView: UITableView!
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        try! realm.write {
            self.badgeCountData = self.realm.objects(BadgeCount.self)
            realm.delete(self.badgeCountData!)
            appDelegate.badgeCount = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BADGECOUNT"), object: 0)
        }
            self.announcements = self.realm.objects(Announcements.self)

        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
        self.announcements = self.announcements!.sorted(by: sortProperties)
        if self.announcements?.count == 0 {
            MBProgressHUD.hide(for: self.view, animated: true);
            let alertController = UIAlertController(title: "No announcements", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(TweakNotificationsViewController.reloadTable(notification:)), name: NSNotification.Name(rawValue: "RELOAD_TABLE"), object: nil);
    }
    func reloadTable(notification : NSNotification) {
        //MBProgressHUD.showAdded(to: self.view, animated: true);

        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
        self.announcements = self.announcements!.sorted(by: sortProperties)
        if self.announcements?.count == 0 {
        MBProgressHUD.hide(for: self.view, animated: true);
        let alertController = UIAlertController(title: "No announcements", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }

        MBProgressHUD.hide(for: self.view, animated: true);
        
        self.notificationTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
//        self.announcements = self.realm.objects(Announcements.self)
//        //if self.tweakFeedsInfo?.count == 0 {
//        MBProgressHUD.showAdded(to: self.view, animated: true);
//         tweakNotifyRef = Database.database().reference().child("TweakNotificationsIos")
//        tweakNotifyRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
//            let announcement = snapshot.value as? [String: AnyObject]
//            let announcementObj = Announcements()
//            announcementObj.postedOn = (announcement?["dateTime"] as AnyObject) as! String
//            let announceMentData = self.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
//            if announceMentData != nil {
//                deleteRealmObj(objToDelete: announceMentData!)
//            }
//
//
// })
//         tweakNotifyRef.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
//            if snapshot.childrenCount > 0 {
//                let dispatch_group = DispatchGroup()
//                dispatch_group.enter()
//
//                for announceMent in snapshot.children.allObjects as! [DataSnapshot] {
//
//                    let announcements = announceMent.value as? [String : AnyObject]
//
//                    let announcementObj = Announcements()
//                    announcementObj.postedOn = (announcements?["dateTime"] as AnyObject) as! String
//                    let keyExists = announcements?["img"] != nil
//                    if (keyExists) {
//                        announcementObj.imageUrl = (announcements?["img"] as AnyObject) as! String
//                    } else {
//                       announcementObj.imageUrl = ""
//                    }
//                    let message = (announcements?["message"] as AnyObject) as! String
//                    // cell.notificationMessageLbl.text = message?.html2String
//                    announcementObj.announcement = message
//                    let announceMentData = self.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
//                    if announceMentData == nil {
//                        //self.sendPushNotification()
//                        //self.badgeCountData = self.realm.objects(BadgeCount.self)
//                       // for badges in self.badgeCountData! {
//
//                            let badge = BadgeCount()
//                            badge.badgeCount = self.badgeCount + 1
//                            badge.id = self.incrementID()
//                            saveToRealmOverwrite(objType: BadgeCount.self, objValues: badge)
//                        let entities = self.realm.objects(BadgeCount.self)
//                        let id = entities.max(ofProperty: "id") as Int?
//                        let entity = id != nil ? entities.filter("id == %@", id!).first : nil
//                        if entity == nil {
//                            self.badgeCount = 0
//                        } else {
//                            self.badgeCount = (entity?.badgeCount)!
//                        }
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BADGECOUNT"), object: badge.badgeCount)
//                        //}
//
//
//
//                        let identifier = ProcessInfo.processInfo.globallyUniqueString
//                        let content = UNMutableNotificationContent()
//                        content.title = "Announcements"
//                        content.body = message.html2String
//                        content.sound = UNNotificationSound(named: "AirplaneDing.wav")
//                        if announcementObj.imageUrl != "" {
//                        if let attachment = UNNotificationAttachment.create(identifier: identifier, urlString: announcementObj.imageUrl, options: nil) {
//                            // where myImage is any UIImage that follows the
//                            content.attachments = [attachment]
//                        }
//                        }
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
//                        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
//                        UNUserNotificationCenter.current().add(request) { (error) in
//                            // handle error
//                        }
//                    }
//                    saveToRealmOverwrite(objType: Announcements.self, objValues: announcementObj)
//
//
//                }
//                dispatch_group.leave()
//                dispatch_group.notify(queue: DispatchQueue.main) {
//
//                    let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
//                    self.announcements = self.announcements!.sorted(by: sortProperties)
//                    MBProgressHUD.hide(for: self.view, animated: true);
//
//                    self.notificationTableView.reloadData()
//                }
//            } else {
//
//                MBProgressHUD.hide(for: self.view, animated: true);
//                let alertController = UIAlertController(title: "No announcements", message: "", preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//            // ...
//        })
//
//    }
//
//    func incrementID() -> Int {
//        let realm = try! Realm()
//        return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
//    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TweakNotifyTableViewCell
        if cell.cellDelegate == nil {
            cell.cellDelegate = self;
        }
        cell.cellIndexPath = indexPath.row
        cell.myIndexPath = indexPath
        
        let cellDictionary = self.announcements?[indexPath.row]
        cell.notificationDate.text = cellDictionary!["postedOn"] as AnyObject as? String
        let message = cellDictionary!["announcement"] as AnyObject as? String
       // cell.notificationMessageLbl.text = message?.html2String
        let string              = message?.html2String
        let range               = (string! as NSString).range(of: "Click here for more details")
        let attributedString    = NSMutableAttributedString(string: string!)
        
    
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSUnderlineColorAttributeName, value: UIColor.blue, range: range)
        
        
        cell.notificationMessageLbl.attributedText = attributedString
        let imageUrl = cellDictionary?["imageUrl"] as AnyObject as? String

        if imageUrl == "" {
            cell.imgViewHeightConstraint.constant = 0
        } else {
            cell.notificationImageView.sd_setImage(with: URL(string: imageUrl!))
            cell.imgViewHeightConstraint.constant = 198

        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
