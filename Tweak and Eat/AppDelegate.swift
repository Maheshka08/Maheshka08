//
//  AppDelegate.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/08/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation
import GoogleMobileAds
import OneSignal
import UserNotifications
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver, GADBannerViewDelegate, UNUserNotificationCenterDelegate {
    
    var badgeCountData : Results<BadgeCount>?
    var badgeCount: Int = 0
    var tweakNotifyRef : DatabaseReference!
    var announcements : Results<Announcements>?
let realm :Realm = try! Realm()
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    var window: UIWindow?;
    var adBannerView = GADBannerView();
    var networkReconnectionBlock : (() -> Void)? = nil;
    let requestId = "Request ID";
    let categoryId = "Category ID";
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
    }
   
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            print("App already launched")
            
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        Realm.Configuration.defaultConfiguration = config;
        FirebaseApp.configure()
        
        let isFirstTime = isAppAlreadyLaunchedOnce()
        if isFirstTime == false {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
                center.removeAllDeliveredNotifications() // To remove all delivered notifications
            }
        }
    
           UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            
            //print("Requests: \(notificationRequests)")
        }

        UIApplication.shared.statusBarStyle = .lightContent;
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6742453784279360~7172537695");
     
        self.registerForPushNotifications(application: application);
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
        UINavigationBar.appearance().isTranslucent = false;
        UINavigationBar.appearance().shadowImage = UIImage();
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default);
        UINavigationBar.appearance().tintColor = UIColor.white;
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white];
        
        self.setStatusBarBackgroundColor(color: UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0));
        UITabBar.appearance().tintColor = UIColor(red : 89/255, green: 0/255, blue: 120/255, alpha: 1.0);

        DispatchQueue.global(qos: .background).async {
            Contacts.sharedContacts().getContactsAuthenticationForAddressBook();
        }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self;
        } else {
            // Fallback on earlier versions
        }
        if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil));
        }
        
        Notifications.setupAtAppStart();
        let locationManager : CLLocationManager = CLLocationManager();
        locationManager.requestAlwaysAuthorization();
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)");
            print("launchURL = \(notification?.payload.launchURL)");
            print("content_available = \(notification?.payload.contentAvailable)");
            
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload;
            
            print("Message = \(payload!.body)");
            print("badge number = \(payload?.badge)");
            print("notification sound = \(payload?.sound)");
            
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)");
             let tweakID = additionalData["tweak_id"] as! NSNumber
                UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let clickViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController; navController?.pushViewController(clickViewController, animated: true);
                
            }
        }
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
                if accepted == true {
                    print("User accepted notifications: \(accepted)");
                } else {
                    print("User accepted notifications: \(accepted)");
                }
            })
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ];
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "1a72adbf-091c-4f74-94a9-9e36d5b91bf9", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings);
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver);
        
        OneSignal.add(self as OSSubscriptionObserver);
        
        return true;
    }
  
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!");
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.");
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)");
    }
    
   
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState();
        let pushToken = status.subscriptionStatus.pushToken;
        let userId = status.subscriptionStatus.userId;
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!");
        }
        print("SubscriptionStateChange: \n\(stateChanges)");
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    func scheduleNotification(hour : String, min : String, title:String, body: String) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: "birds018.wav");
            
            var dateInfo = DateComponents();
            
            dateInfo.hour = Int(hour);
            dateInfo.minute = Int(min);
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true);
            let request = UNNotificationRequest.init(identifier: self.requestId + "+"  + hour + ":" + min, content: content, trigger: trigger);
           
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
    func cancelNotificationForSpecificTime(hour : String, min : String) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = [];
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == self.requestId + "+"  + hour + ":" + min {
                        identifiers.append(notification.identifier);
                    }
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers);
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color;
    }
    
    func tweakImageFolderPath() -> String {
        var documentsPath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        documentsPath = documentsPath.appending("/TweakImages/");
        return documentsPath as String;
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil);
        application.registerUserNotificationSettings(settings);
        application.registerForRemoteNotifications();
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let state = application.applicationState;
        if state == .active {
             
            let alert = UIAlertView(title: "Reminder", message: notification.alertBody!, delegate: "", cancelButtonTitle: "OK");
            alert.show();
        }
        application.applicationIconBadgeNumber = 0;
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications();
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let characterSet :CharacterSet = CharacterSet(charactersIn: "<>");
        let deviceTokenString: String = (deviceToken.description)
            .trimmingCharacters(in: characterSet)
            .replacingOccurrences(of: " ", with: "");
        
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken");
        
        print(deviceTokenString);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error);
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("content" + "\(userInfo)");
        
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let showRegistration : Bool  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool {
            if !showRegistration {
                self.getAnnouncements()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
     func fetchRecord(time: String, date: String) -> Int {
        let realm = try! Realm()
        let scope = realm.objects(DailyTipsNotify.self).filter("selectedDate == %@ AND selectedTime == %@", date,time)
        return scope.count
    }
    func getAnnouncements() {
    self.announcements = self.realm.objects(Announcements.self)
    //if self.tweakFeedsInfo?.count == 0 {
    //MBProgressHUD.showAdded(to: self.view, animated: true);
    tweakNotifyRef = Database.database().reference().child("TweakNotificationsIos")
    tweakNotifyRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
    let announcement = snapshot.value as? [String: AnyObject]
    let announcementObj = Announcements()
    announcementObj.postedOn = (announcement?["dateTime"] as AnyObject) as! String
    let announceMentData = self.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
    if announceMentData != nil {
    deleteRealmObj(objToDelete: announceMentData!)
    }
    
    
    })
    tweakNotifyRef.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
    if snapshot.childrenCount > 0 {
    let dispatch_group = DispatchGroup()
    dispatch_group.enter()
    
    for announceMent in snapshot.children.allObjects as! [DataSnapshot] {
    
    let announcements = announceMent.value as? [String : AnyObject]
    
    let announcementObj = Announcements()
    announcementObj.postedOn = (announcements?["dateTime"] as AnyObject) as! String
    let keyExists = announcements?["img"] != nil
    if (keyExists) {
    announcementObj.imageUrl = (announcements?["img"] as AnyObject) as! String
    } else {
    announcementObj.imageUrl = ""
    }
    let message = (announcements?["message"] as AnyObject) as! String
    // cell.notificationMessageLbl.text = message?.html2String
    announcementObj.announcement = message
    let announceMentData = self.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
    if announceMentData == nil {
    //self.sendPushNotification()
    //self.badgeCountData = self.realm.objects(BadgeCount.self)
    // for badges in self.badgeCountData! {
    
    let badge = BadgeCount()
        let entities = self.realm.objects(BadgeCount.self)
        let id = entities.max(ofProperty: "id") as Int?
        let entity = id != nil ? entities.filter("id == %@", id!).first : nil
        if entity == nil {
            self.badgeCount = 0
        } else {
            self.badgeCount = (entity?.badgeCount)!
        }
    badge.badgeCount = self.badgeCount + 1
    badge.id = self.incrementID()
    saveToRealmOverwrite(objType: BadgeCount.self, objValues: badge)
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BADGECOUNT"), object: badge.badgeCount)
    //}
    
    
    
    let identifier = ProcessInfo.processInfo.globallyUniqueString
    let content = UNMutableNotificationContent()
    content.title = "Announcements"
    content.body = message.html2String
    content.sound = UNNotificationSound(named: "AirplaneDing.wav")
    if announcementObj.imageUrl != "" {
    if let attachment = UNNotificationAttachment.create(identifier: identifier, urlString: announcementObj.imageUrl, options: nil) {
    // where myImage is any UIImage that follows the
    content.attachments = [attachment]
    }
    }
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
    let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { (error) in
    // handle error
    }
    }
    saveToRealmOverwrite(objType: Announcements.self, objValues: announcementObj)
    
    
    }
    dispatch_group.leave()
    dispatch_group.notify(queue: DispatchQueue.main) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RELOAD_TABLE"), object: nil)
    
    }
    } else {
    
    
    }
    // ...
    })
    
}

func incrementID() -> Int {
    let realm = try! Realm()
    return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
}
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let showRegistration : Bool  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool {
            if !showRegistration {
                self.getAnnouncements()
            }
        }
       

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext();
        DatabaseController.saveContext();
    }

    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.test.Tweak_and_Eat" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        return urls[urls.count-1];
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Tweak_and_Eat", withExtension: "momd")!;
        return NSManagedObjectModel(contentsOf: modelURL)!;
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel);
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite");
        var failureReason = "There was an error creating or loading the application's saved data.";
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil);
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]();
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?;
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?;

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict);
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort();
        }
        
        return coordinator;
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator;
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType);
        managedObjectContext.persistentStoreCoordinator = coordinator;
        return managedObjectContext;
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save();
            } catch {
               
                managedObjectContext.rollback();
                
                let nserror = error as NSError;
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
                abort();
            }
        }
    }

}

