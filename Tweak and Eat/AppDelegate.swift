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

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver, GADBannerViewDelegate, UNUserNotificationCenterDelegate {
    
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    var window: UIWindow?;
    var adBannerView = GADBannerView();
    var networkReconnectionBlock : ((Void) -> Void)? = nil;
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
                let tabBar: UITabBarController = self.window?.rootViewController as! TabBarController;
                tabBar.selectedIndex = 3;
                
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
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }
    
     func fetchRecord(time: String, date: String) -> Int {
        let realm = try! Realm()
        let scope = realm.objects(DailyTipsNotify.self).filter("selectedDate == %@ AND selectedTime == %@", date,time)
        return scope.count
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let isFirstTime = isAppAlreadyLaunchedOnce()
        if isFirstTime == false {
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
                    let dailyTipInfo = self.fetchRecord(time: time!, date: todaysDate)
                    if dailyTipInfo == 1 {
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

