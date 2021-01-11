//
//  NotificationService.swift
//  BubblegumNotificationsSwift
//
//  Created by Martin Berger on 8/29/16.
//  Copyright © 2016 Martin Berger. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Realm
import RealmSwift

@available(iOS 10.0, *)
class NotificationService: NSObject {
    @objc var popUpView : PopUpNotificationView! = nil;

    @objc var dateFormat : TweakReminderViewController! = nil;
    @objc var authorized: Bool = false;
    @objc let requestId = "Request ID";
    @objc let categoryId = "Category ID";
    @objc var selectedDate : String!;
    @objc var window: UIWindow?;
    @objc let nav1 = UINavigationController();
    @objc var reminder : TweakReminderViewController! = nil;
   
    @available(iOS 10.0, *)
    lazy private var category: UNNotificationCategory? = {
        let action = UNNotificationAction.init(identifier: "Action ID", title: "Action", options: [.foreground]);
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground);
        let category = UNNotificationCategory.init(identifier: self.categoryId, actions: [action], intentIdentifiers: [], options: []);
        UNUserNotificationCenter.current().setNotificationCategories([category]);
        return category;
    }()
    
    @objc func setupAtAppStart() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self;
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().setNotificationCategories([self.category!]);
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func requestAuthorization(callback: ((Bool) -> Void)?) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current();
            center.requestAuthorization(options: [.alert, .badge, .sound]) { [unowned self] (granted, error) in
                self.authorized = granted;
                if error != nil {
                    print(error?.localizedDescription as String!);
                }
             NotificationCenter.default.post(name: .notificationServiceAuthorized, object: nil);
                
                if callback != nil {
                    callback!(granted);
                }
            }

        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func scheduleNotification(hour : String, min : String, title:String, body: String) {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("birds018.wav"));
            let date = Date();
            let formatter = DateFormatter();
            formatter.dateFormat = "dd/MM/yyyy";
            let todayDate = formatter.string(from: date);
            var dateInfo = DateComponents();
            dateInfo.hour = Int(hour);
            dateInfo.minute = Int(min);
            let time = hour + ":" + min
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true);
            let request = UNNotificationRequest.init(identifier: self.requestId + "+" + time, content: content, trigger: trigger);
            
            schedule(request: request);

        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc @available(iOS 10.0, *)
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
                print(error?.localizedDescription as String!);
            }
        }
    }
    
    @objc internal func check() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
            self.authorized = (settings.authorizationStatus == .authorized);
        }
    }
}

@available(iOS 10.0, *)
extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        completionHandler([.alert,.badge, .sound]);
       
    }
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
        completionHandler();
//        var msg = "Dear Tweakers, We now have more than 2,20,000 tweakers! More the merrier! Here to healthy life!"
//                       var imgUrlString = "https://s3.ap-south-1.amazonaws.com/tweakandeatpush/push_img_20180906_01.png"
//                       var link = "-IndIWj1mSzQ1GDlBpUt"
//                       var type = 0
//                      if type == 0 || type == 1 {
//                          let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//                                 self.popUpView = (Bundle.main.loadNibNamed("PopUpNotificationView", owner: self, options: nil)! as NSArray).firstObject as? PopUpNotificationView;
//                                 self.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//                              self.popUpView.frame = CGRect(0, 0, (navController?.view.frame.size.width)!, (navController?.view.frame.size.height)!);
//                          self.popUpView.showUIForSmallPopUp(imgUrlString: imgUrlString, msg: msg, link: link, type: type)
//                                 UIApplication.shared.keyWindow?.addSubview(self.popUpView)
//      //                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//      //                                          let v = UIView();
//      //                                          v.frame = CGRect(0, 0, (navController?.view.frame.size.width)!, (navController?.view.frame.size.height)!);
//      //                                          v.backgroundColor = .blue
//      //                                         // navController?.view.window?.addSubview(v)
//      //                           UIApplication.shared.keyWindow?.addSubview(v)
//                      }
     //   print(response.notification.request.content.title)
        
       // UIApplication.shared.applicationIconBadgeNumber = 1
        print(response)
        if response.notification.request.content.title == "Announcements" {
          
            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            if let viewControllers = navController?.viewControllers {
                for viewController in viewControllers {
                    // some process
                    if viewController is TweakNotificationsViewController {
                        print("yes it is")
                        return
                    }
                }
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let destination = storyBoard.instantiateViewController(withIdentifier:
                "TweakNotificationsViewController") as! TweakNotificationsViewController;
            navController?.pushViewController(destination, animated: true)

           
        } else if response.notification.request.content.title == "Fulfillments" {
//            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//            if let viewControllers = navController?.viewControllers {
//                for viewController in viewControllers {
//                    // some process
//                    if (viewController is OrdersTableViewController || viewController is OrderDetailsViewController) {
//                        print("yes it is")
//                        return
//                    }
//                }
//            }
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//            let destination = storyBoard.instantiateViewController(withIdentifier:
//                "OrdersTableViewController") as! OrdersTableViewController;
//            navController?.pushViewController(destination, animated: true)
        } else {
          
            if (response.notification.request.content.title != "" && response.notification.request.content.title != "Announcements" && response.notification.request.content.title != "Fulfillments" &&  response.notification.request.content.title != "Tweak & Eat Reminder" && response.notification.request.content.title != "Tweak & Eat"
                && response.notification.request.content.title != "New Message" &&  response.notification.request.content.title != "First Tweaker Contest") {
                
                let userInfo = response.notification.request.content.userInfo
                print(userInfo)
                var msg = "Dear Tweakers, We now have more than 2,20,000 tweakers! More the merrier! Here to healthy life!"
                var imgUrlString = "https://s3.ap-south-1.amazonaws.com/tweakandeatpush/push_img_20180906_01.png"
                var link = ""
                var type = 0
                var tweakID: NSNumber = 0
                if userInfo.index(forKey: "aps") != nil {
                    let apsInfo = userInfo["aps"] as AnyObject as! [String: AnyObject]
                    if apsInfo.index(forKey: "msg") != nil {
                        let message = apsInfo["msg"] as! String
                        msg = message
                        
                    }
                    if apsInfo.index(forKey: "img") != nil {
                
                        imgUrlString = apsInfo["img"] as! String

                    }
                   if apsInfo.index(forKey: "tweakId") != nil {
    tweakID = apsInfo["tweakId"] as! NSNumber
                    }
                    
                    if apsInfo.index(forKey: "type") != nil {
                        type = apsInfo["type"] as AnyObject as! Int
                    }
                    if apsInfo.index(forKey: "link") != nil {

                        let links = apsInfo["link"] as AnyObject as! String

                            if (links == "-Qis3atRaproTlpr4zIs" || links == "-KyotHu4rPoL3YOsVxUu" || links == "-SquhLfL5nAsrhdq7GCY" || links == "-TacvBsX4yDrtgbl6YOQ" || links == "PP_LABELS" || links == "PP_PACKAGES" || links == "-IndIWj1mSzQ1GDlBpUt" || links == "-AiDPwdvop1HU7fj8vfL" || links == "-MalAXk7gLyR3BNMusfi" || links == "-MzqlVh6nXsZ2TCdAbOp" || links == "-IdnMyAiDPoP9DFGkbas" || links == "-SgnMyAiDPuD8WVCipga" || links == "-PtpIndu4fke3hfj8skf" || links == "-PtpUsa9aqws5fcb7mkG" || links == "-PtpSgn5Kavqo3cakpqh" || links == "-PtpMys1ogs7bwt3malu" || links == "-PtpIdno8kwg2npl5vna" || links == "-PtpPhy3mskop9Avqj5L" || links == "-IndAiBPtmMrS4VPnwmD" || links == "-IdnAiBPLKMO5ePamQle" || links == "-SgnAiBPJlXfM3KzDWR8" || links == "-MysAiBPyaX9TgFT1YOp" || links == "-MysRamadanwgtLoss99" || links == "-PhyAiBPcYLiSYlqhjbI" || links == "-UsaAiBPxnaopT55GJxl"  || links == "CALS_LEFT_FS_POPUP" || links == "HOW_IT_WORKS" || links == "CHECK_THIS_OUT" || links == "-IndWLIntusoe3uelxER" || links == "CLUB_SUBSCRIPTION" || links == "-ClubInd3gu7tfwko6Zx" || links == "-ClubIdn4hd8flchs9Vy" || links == "-ClubUSA4tg6cvdhizQn" || links == "-ClubSGNPbeleu8beyKn" || links == "-ClubMYSheke8ebdjoWs" || links == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" || link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" || link == "-NcInd5BosUcUeeQ9Q32" ) {
                            link = links
                        } else {
                            link = links
                            }

                    } else {
                        link = ""
                      
                    }
                }
                let data = ["msg": msg, "imgUrlString":imgUrlString, "link": link, "type": type] as [String: AnyObject]
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                if type == 0 || type == 1 {
                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                           self.popUpView = (Bundle.main.loadNibNamed("PopUpNotificationView", owner: self, options: nil)! as NSArray).firstObject as? PopUpNotificationView;
                           self.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                        self.popUpView.frame = CGRect(0, 0, (navController?.view.frame.size.width)!, (navController?.view.frame.size.height)!);
                    self.popUpView.showUIForSmallPopUp(imgUrlString: imgUrlString, msg: msg.html2String.replacingOccurrences(of: "\\", with: ""), link: link, type: type)
                           UIApplication.shared.keyWindow?.addSubview(self.popUpView)

                } else if type == 4 {
                    

                        UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
                    
                    
                } else if type == 5 {
                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                           self.popUpView = (Bundle.main.loadNibNamed("PopUpNotificationView", owner: self, options: nil)! as NSArray).firstObject as? PopUpNotificationView;
                           self.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                        self.popUpView.frame = CGRect(0, 0, (navController?.view.frame.size.width)!, (navController?.view.frame.size.height)!);
                    self.popUpView.showUIForSmallPopUp(imgUrlString: imgUrlString, msg: msg.html2String.replacingOccurrences(of: "\\", with: ""), link: link, type: type)
                           UIApplication.shared.keyWindow?.addSubview(self.popUpView)
                } else {
                if navController?.topViewController is MyWallViewController {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_TWEAKWALL_DETAIL"), object: data)
                } else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                           let myWall : MyWallViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as! MyWallViewController;
                          // myWall.postedOn = postedOn
                           myWall.feedId = link
                           myWall.type = type
                           navController?.pushViewController(myWall, animated: true);
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_POPUP"), object: data)
                }
                }

            }
        }
    }
}


func fetchRecord(time: String, date: String) -> Int {
    let realm = try! Realm()
    let scope = realm.objects(DailyTipsNotify.self).filter("selectedDate == %@ AND selectedTime == %@", date,time)
    return scope.count
}

class Notifications {
    @available(iOS 10.0, *)
    static let service = NotificationService();
    static func setupAtAppStart() {
        if #available(iOS 10.0, *) {
            self.service.setupAtAppStart();
        } else {
            // Fallback on earlier versions
        }
    }
    static func schedule(hour : String, min : String, title:String, body: String) {
        if #available(iOS 10.0, *) {
            self.service.scheduleNotification(hour: hour ,min: min, title:title, body: body);
        } else {
            // Fallback on earlier versions
        }
    }
    static func authorize() {
        if #available(iOS 10.0, *) {
            self.service.requestAuthorization(callback: nil);
        } else {
            // Fallback on earlier versions
        }
    }
}

extension Notification.Name {
    static let notificationServiceAuthorized = Notification.Name("Authorized");
}

func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
    
    var rootVC = rootViewController
    if rootVC == nil {
        rootVC = UIApplication.shared.keyWindow?.rootViewController
    }
    
    if rootVC?.presentedViewController == nil {
        return rootVC
    }
    
    if let presented = rootVC?.presentedViewController {
        if presented.isKind(of: UINavigationController.self) {
            let navigationController = presented as! UINavigationController
            return navigationController.viewControllers.last!
        }
        
        if presented.isKind(of: UITabBarController.self) {
            let tabBarController = presented as! UITabBarController
            return tabBarController.selectedViewController!
        }
        
        return getVisibleViewController(presented)
    }
    return nil
}

extension UIApplication {
    @objc class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
