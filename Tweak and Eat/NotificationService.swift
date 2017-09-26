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
    
    var dateFormat : TweakReminderViewController! = nil;
    var authorized: Bool = false;
    let requestId = "Request ID";
    let categoryId = "Category ID";
    var selectedDate : String!;
    var window: UIWindow?;
    let nav1 = UINavigationController();
    var reminder : TweakReminderViewController! = nil;
   
    @available(iOS 10.0, *)
    lazy private var category: UNNotificationCategory? = {
        let action = UNNotificationAction.init(identifier: "Action ID", title: "Action", options: [.foreground]);
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground);
        let category = UNNotificationCategory.init(identifier: self.categoryId, actions: [action], intentIdentifiers: [], options: []);
        UNUserNotificationCenter.current().setNotificationCategories([category]);
        return category;
    }()
    
    func setupAtAppStart() {
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
    
    func requestAuthorization(callback: ((Bool) -> Void)?) {
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
    
    func scheduleNotification(hour : String, min : String, title:String, body: String) {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: "birds018.wav");
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
    
    @available(iOS 10.0, *)
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
                print(error?.localizedDescription as String!);
            }
        }
    }
    
    internal func check() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
            self.authorized = (settings.authorizationStatus == .authorized);
        }
    }
}

@available(iOS 10.0, *)
extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
      

        completionHandler([.alert,.badge, .sound]);
        saveDailyTip()
    }
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
        completionHandler();
    
    }
}

func fetchRecord(time: String, date: String) -> Int {
    let realm = try! Realm()
    let scope = realm.objects(DailyTipsNotify.self).filter("selectedDate == %@ AND selectedTime == %@", date,time)
    return scope.count
}

func saveDailyTip(){
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
        let notification = notificationRequests as [AnyObject]
        for notify in notification {
            if notify.content.title == "Daily Tips" {
                
                let identifierString = String(notify.identifier)
                let identifierArray = identifierString?.components(separatedBy: "+")
                //let todaysDate = identifierArray?[2]
                let time = identifierArray?[1]
                let date = Date();
                let formatter = DateFormatter();
                formatter.dateFormat = "dd/MM/yyyy";
                let todaysDate = formatter.string(from: date);
                let dailyTipInfo = fetchRecord(time: time!, date: todaysDate)
                if dailyTipInfo == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTips"), object: nil)
                    return
                }
                
                let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
                APIWrapper.sharedInstance.getRequest(TweakAndEatURLConstants.DAILYTIPS, sessionString: userSession, success:
                    { (responseDic : AnyObject!) -> (Void) in
                        
                        if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                            let response : [String:AnyObject] = responseDic as! [String:AnyObject];
                            let reminders : [String:AnyObject]? = response["tweaks"]  as? [String:AnyObject];
                            print(reminders!);
                            
                            let tipid = DailyTipsNotify();
                            tipid.pkg_evt_id = String(reminders?["pkg_evt_id"] as! Int);
                            tipid.selectedDate = todaysDate
                            tipid.selectedTime = time!
                            tipid.tipNotificationMessage = reminders?["pkg_evt_message"] as! String;
                            do {
                                try uiRealm.write { () -> Void in
                                    uiRealm.create(DailyTipsNotify.self, value: tipid, update: true)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTips"), object: nil)
                                }
                            } catch {
                                print("Error");
                            }
                            
                        }
                }) { (error : NSError!) -> (Void) in
                    print("Error in reminders");
                }
            }
        }
        print(notification)
    }

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

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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
