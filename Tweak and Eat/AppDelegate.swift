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
import OneSignal
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseMessaging
import FirebaseInstanceID
import FacebookLogin
import FacebookCore
import FacebookShare
import Branch
import RNCryptor
import FBSDKCoreKit
import FlyshotSDK
import CleverTapSDK
import AppTrackingTransparency
let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver, UNUserNotificationCenterDelegate, MessagingDelegate,CleverTapInAppNotificationDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("onConversionDataSuccess data:")
               for (key, value) in conversionInfo {
                   print(key, ":", value)
               }
               if let status = conversionInfo["af_status"] as? String {
                   if (status == "Non-organic") {
                       if let sourceID = conversionInfo["media_source"],
                           let campaign = conversionInfo["campaign"] {
                           print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                       }
                   } else {
                       print("This is an organic install.")
                   }
                   if let is_first_launch = conversionInfo["is_first_launch"] as? Bool,
                       is_first_launch {
                       print("First Launch")
                   } else {
                       print("Not First Launch")
                   }
               }
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
           //Handle Deep Link Data
           print("onAppOpenAttribution data:")
           for (key, value) in attributionData {
               print(key, ":",value)
           }
       }
       func onAppOpenAttributionFailure(_ error: Error) {
           print("\(error)")
       }
    
  
    
    @objc var notifView = UIView();
    var badgeCountData : Results<BadgeCount>?;
    @objc var badgeCount: Int = 0;
    @objc var tweakNotifyRef : DatabaseReference!;
    var announcements : Results<Announcements>?;
    //var realm :Realm! = nil
    @objc let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
    var window: UIWindow?;
   // var adBannerView = GADBannerView();
    @objc var networkReconnectionBlock : (() -> Void)? = nil;
    @objc let requestId = "Request ID";
    @objc let categoryId = "Category ID";
    //@objc var locManager = CLLocationManager();
    @objc var longitude = "0.0";
    @objc var latitude = "0.0";
    var inAppMessageDictionary = [AnyHashable : Any]()
    
    enum ShortcutIdentifier: String {
        case TweakNow
        case MyEDR
        case TweakWall
        case RecipeWall
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    
    func setRootView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! WelcomeViewController;
        let navigationController = UINavigationController(rootViewController: mainViewController);
        self.window?.rootViewController = navigationController;
    }
    
    func inAppNotificationButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
          print("In-App Button Tapped with custom extras:", customExtras ?? "");
        inAppMessageDictionary = customExtras
        if inAppMessageDictionary.index(forKey: "btn_click") != nil {
            //self.setRootView()
            HandleRedirections.sharedInstance.tappedOnPopUpDone(link: (inAppMessageDictionary["btn_click"] as! String).replacingOccurrences(of: "tweakandeat://", with: ""))
           
    }
      }
    
//    func inAppNotificationDismissed(withExtras extras: [AnyHashable : Any]!, andActionExtras actionExtras: [AnyHashable : Any]!) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//                             let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
//
//              // vc.fromHomePopups = true
//                             let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//                             navController?.pushViewController(vc, animated: true);
//
//    }
//    func inAppNotificationDismissed(withExtras extras: [AnyHashable : Any]!, andActionExtras actionExtras: [AnyHashable : Any]!) {
//        if inAppMessageDictionary.count == 0 {
//            inAppMessageDictionary = actionExtras
//            if inAppMessageDictionary.index(forKey: "wzrk_c2a") != nil {
////                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
////                                     let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
////
////                      // vc.fromHomePopups = true
////                                     let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
////                                     navController?.pushViewController(vc, animated: true);
////            }
//                HandleRedirections.sharedInstance.tappedOnPopUpDone(link: (inAppMessageDictionary["wzrk_c2a"] as! String).replacingOccurrences(of: "tweakandeat://", with: ""))
//               // inAppMessageDictionary = [AnyHashable: Any]()
//
//
//        }
//
//    }
//
//    }
    
//    func shouldShowInAppNotification(withExtras extras: [AnyHashable : Any]!) -> Bool {
//        return true
//    }
    
   
    
    @objc var launchedShortcutItem: UIApplicationShortcutItem?
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
    
    
    // MARK: - SINClientDelegate
   
    
    @objc func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        switch (shortCutType) {
        case ShortcutIdentifier.TweakNow.type:
            // Handle shortcut 1 (static).
            handled = true;
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let mainViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! WelcomeViewController;
            self.window = UIWindow(frame: UIScreen.main.bounds);
            let navigationController = UINavigationController(rootViewController: mainViewController);
            mainViewController.tweakNowAlert = true;
            self.window?.rootViewController = navigationController;
            self.window?.makeKeyAndVisible();
            break
        case ShortcutIdentifier.MyEDR.type:
            // Handle shortcut 3 (static).
            handled = true;
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let mainViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! WelcomeViewController;
            self.window = UIWindow(frame: UIScreen.main.bounds);
            let navigationController = UINavigationController(rootViewController: mainViewController);
            mainViewController.myEdRAlert = true;
            self.window?.rootViewController = navigationController;
            self.window?.makeKeyAndVisible();
            break
        case ShortcutIdentifier.TweakWall.type:
            // Handle shortcut 4 (static).
            handled = true
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let mainViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! WelcomeViewController;
            self.window = UIWindow(frame: UIScreen.main.bounds);
            let navigationController = UINavigationController(rootViewController: mainViewController);
            mainViewController.myWallAlert = true
            self.window?.rootViewController = navigationController;
            self.window?.makeKeyAndVisible();
            
            break
            
        case ShortcutIdentifier.RecipeWall.type:
            // Handle shortcut 5 (static).
            
            handled = true
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let mainViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! WelcomeViewController;
            self.window = UIWindow(frame: UIScreen.main.bounds);
            let navigationController = UINavigationController(rootViewController: mainViewController);
            mainViewController.recipeWallAlert = true
            self.window?.rootViewController = navigationController;
            self.window?.makeKeyAndVisible();
            break
            
            
        default:
            break
        }
        
        return handled
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let showRegistration : Bool  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool {
            if !showRegistration {
                let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem);
                completionHandler(handledShortCutItem);
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
       // UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
    }
    
    @objc func isAppAlreadyLaunchedOnce()->Bool{
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
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
            let messageData = message.data(using: .utf8)!
            let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
            return cipherData.base64EncodedString()
        }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        CleverTap.autoIntegrate()
        //CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        CleverTap.sharedInstance()?.setInAppNotificationDelegate(self)

        Flyshot.shared.initialize(sdkToken: "fl_test_eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lclV1aWQiOiI4ZjE0Mzc3MC1mZTk4LTQ4ZWEtOGJmZS1lNjUzZDk5Mjc4N2EiLCJhcHBsaWNhdGlvblV1aWQiOiIyYzRlNjBlNC1iZmJlLTRlMmItYjYzYi1kMjhjY2U5YzIyY2YiLCJ1dWlkIjoiMDYwMTZmNzEtYzYwYS00MjNjLTgyZDktNjJhNTZiMzkzMjJiIn0.XdAbRo-qhjuRio6Lk0hGxcwY0-eAuZiP9SfdV0gk2lE", onSuccess: {
           // SDK is ready for use
        }, onFailure: { (error) in
           // Handle error
        })
         Branch.getInstance().enableLogging()
        //Branch.getInstance().validateSDKIntegration()
         // listener for Branch Deep Link data
         Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
              // do stuff with deep link data (nav to pagye, display content, etc)
             print(params as? [String: AnyObject] ?? {})
//            UserDefaults.standard.set(params, forKey: "PUSHWHENKILLED")
//            UserDefaults.standard.synchronize()
            if params!.index(forKey: "goToLandingPage") != nil {
                self.goToHomePage(links: params!["goToLandingPage"]! as! String)
            }
            
         }
        
        

AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        //        // 1 - Get AppsFlyer preferences from .plist file
        //              guard let propertiesPath = Bundle.main.path(forResource: "afdevkey_donotpush", ofType: "plist"),
        //                  let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String:String] else {
        //                      fatalError("Cannot find `afdevkey_donotpush`")
        //              }
        //              guard let appsFlyerDevKey = properties["appsFlyerDevKey"],
        //                         let appleAppID = properties["appleAppID"] else {
        //                  fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key")
        //              }
                      // 2 - Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID

        Settings.isAutoLogAppEventsEnabled = true
        Settings.isAdvertiserIDCollectionEnabled = true
        Settings.isAutoInitEnabled = true
        ApplicationDelegate.initializeSDK(nil)

//        AppsFlyerLib.shared().appsFlyerDevKey = "K2xRtd4P275hKHPwSofe9h"
//        AppsFlyerLib.shared().appleAppID = "1267286348"
//        AppsFlyerLib.shared().delegate = self
//        //  Set isDebug to true to see AppsFlyer debug logs
//        AppsFlyerLib.shared().isDebug = true
        // AppsFlyerLib.shared().logEvent("af_complete_registration", withValues: [AFEventCompleteRegistration: "YES"])
        
        // The following block is for applications wishing to collect IDFA.
        // for iOS 14 and above - The user will be prompted for permission to collect IDFA.
        //                        If permission granted, the IDFA will be collected by the SDK.
        // for iOS 13 and below - The IDFA will be collected by the SDK. The user will NOT be prompted for permission.
//        if #available(iOS 14, *) {
//            // Set a timeout for the SDK to wait for the IDFA collection before handling app launch
//            AppsFlyerLib.shared().waitForAdvertisingIdentifier(withTimeoutInterval: 60)
//                  // Show the user the Apple IDFA consent dialog (AppTrackingTransparency)
//                  // Can be called in any place
//                 // ATTrackingManager.requestTrackingAuthorization { (status) in
//                 // }
//              }
        //AppEvents.logEvent(.init("fb_mobile_purchase"))
        
//      ApplicationDelegate.shared.application(
//          application,
//          didFinishLaunchingWithOptions: launchOptions
//      )
       // UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")

        
        
//        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
//            // Do what you want to happen when a remote notification is tapped.
//            UserDefaults.standard.set(remoteNotification, forKey: "remoteNotification")
//
//            if remoteNotification.index(forKey: "aps") != nil {
//
//            let apsInfo = remoteNotification["aps" as String] as? [String:AnyObject]
//                if apsInfo!["alert"] is String {
//                    if remoteNotification.index(forKey: "custom") != nil {
//                        let customInfo = remoteNotification["custom" as String] as? [String:AnyObject]
//                        let customA = customInfo!["a" as String] as? [String:AnyObject]
//                        let tweakID = customA!["tweak_id"] as! NSNumber
//                        UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
//
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
//
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
//
////                        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController;
////                        if let viewControllers = navController?.viewControllers {
////                            for viewController in viewControllers {
////                                // some process
////                                if viewController is TimelinesViewController || viewController is TimelinesDetailsViewController {
////                                    print("yes it is")
////
////                                }
////                            }
////                        }
//
//                    }
//                } else {
//            if (apsInfo!["alert"] as! [String:AnyObject]).index(forKey: "title") != nil {
//            let alert = apsInfo!["alert"] as! [String:AnyObject]
//            if alert["title"] as AnyObject as! String == "Tweak & Eat Message" {
//                UserDefaults.standard.set(apsInfo, forKey: "APS")
//                UserDefaults.standard.synchronize()
//            }
//            }
//            }
//            }
////            let apsString =  String(describing: aps)
////            debugPrint("\n last incoming aps: \(apsString)")
//
//
//        }
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_POPUP"), object: nil)
    
        
      //  Fabric.with([Crashlytics.self])
       

          // Crashlytics.sharedInstance().crash()
        

       //
        
        //Accept push notification when app is not open
//        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil  {
//            let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
//                // This block gets called when the user reacts to a notification received
//                let payload: OSNotificationPayload? = result?.notification.payload;
//                
//                print("Message = \(payload!.body)");
//                print("badge number = \(payload?.badge)");
//                print("notification sound = \(payload?.sound)");
//                
//                
//                if let additionalData = result!.notification.payload!.additionalData {
//                    print("additionalData = \(additionalData)");
//                    let tweakID = additionalData["tweak_id"] as! NSNumber
//                    UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
//                    
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
//                    
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
//                    
//                    
////                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController;
////                    if let viewControllers = navController?.viewControllers {
////                        for viewController in viewControllers {
////                            // some process
////                            if viewController is TimelinesViewController || viewController is TimelinesDetailsViewController {
////                                print("yes it is")
////                                return
////                            }
////                        }
////                    }
////
////                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
////                    let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
////                    self.window?.rootViewController = UINavigationController(rootViewController:clickViewController!)
//                    
//                }
//            }
//
//        }
       // NSLog("Twilio Voice Version: %@", VoiceClient.sharedInstance().version())
        //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
       
        let configCheck = Realm.Configuration();
        do {
            let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(fileUrlIs)")
        } catch  {
            print(error)
        }
        
   
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
//        locManager.delegate = self;
//        locManager.requestAlwaysAuthorization();
//        locManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locManager.requestWhenInUseAuthorization();
//        locManager.startMonitoringSignificantLocationChanges();
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
//        {
//
//            latitude = "\(locManager.location?.coordinate.latitude ?? 0.0)";
//            UserDefaults.standard.set(latitude, forKey: "LATITUDE")
//            longitude = "\(locManager.location?.coordinate.longitude ?? 0.0)";
//            UserDefaults.standard.set(longitude, forKey: "LONGITUDE")
//
//        }     else {
//        }
        FirebaseApp.configure(options: options!)

        Messaging.messaging().delegate = self as MessagingDelegate
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        
        let config = Realm.Configuration(
            schemaVersion: 11,
            migrationBlock: { migration, oldSchemaVersion in
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                if (oldSchemaVersion < 5) {
                    // The renaming operation should be done outside of calls to `enumerateObjects(ofType: _:)`.
                    //migration.renameProperty(onType: TweakRecipesInfo.className(), from: "id", to: "crtOn")
                    migration.enumerateObjects(ofType: TweakRecipesInfo.className()) { oldObject, newObject in
                        let oldID = oldObject!["id"] as! Int
                        newObject!["crtOn"] = "\(oldID)"
                    }
                }
                if (oldSchemaVersion < 6) {

                }
                if (oldSchemaVersion < 7) {
                    migration.enumerateObjects(ofType: PremiumPackageDetails.className(), { (oldObject, newObject) in
                        if let newObject = newObject {
                            newObject["addedToCart"] = false
                        }
                    })
                   
               }
                if (oldSchemaVersion < 8) {

                }
                if (oldSchemaVersion < 9) {

                }
                if (oldSchemaVersion < 10) {
                    
                }
                if (oldSchemaVersion < 11) {
                    
                }
 
                
                
        })
        Realm.Configuration.defaultConfiguration = config;
        // FirebaseApp.configure()
        
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
        
       // UIApplication.shared.statusBarStyle = .lightContent;
      //  GADMobileAds.configure(withApplicationID: "ca-app-pub-6742453784279360~7172537695");
        
        self.registerForPushNotifications(application: application);
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false;
        UINavigationBar.appearance().shadowImage = UIImage();
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default);
        UINavigationBar.appearance().tintColor = UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0);
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)]);
        
        self.setStatusBarBackgroundColor(color: UIColor.black);
        UITabBar.appearance().tintColor = UIColor(red : 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
        
//        DispatchQueue.global(qos: .background).async {
//            Contacts.sharedContacts().getContactsAuthenticationForAddressBook();
//        }
       // Messaging.messaging().delegate = self as? MessagingDelegate
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .InstanceIDTokenRefresh,
                                               object: nil);
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self;
        } else {
            // Fallback on earlier versions
        }
        if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil));
        }
        
        Notifications.setupAtAppStart();
//        var notification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
//        UserDefaults.standard.set(launchOptions, forKey: "NOTIFICATIONWHENAPPKILLED")
//
//        if notification != nil {
//            if let notification = notification {
//                print("app recieved notification from remote\(notification)")
//                UserDefaults.standard.set(launchOptions, forKey: "NOTIFICATIONWHENAPPKILLED")
//            }
//            if let notification = notification {
//                //  application(application: application, didReceiveRemoteNotification: notification, fetchCompletionHandler: nil)
//                // application(application, didReceiveRemoteNotification: notification)
//            }
//        } else {
//            print("app did not recieve notification")
//        }
//        let locationManager : CLLocationManager = CLLocationManager();
//        locationManager.requestAlwaysAuthorization();
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
           // UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            print("Received Notification: \(notification!.payload.notificationID)");
            print("launchURL = \(notification?.payload.launchURL)");
            print("content_available = \(notification?.payload.contentAvailable)");
            
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
           // UIApplication.shared.applicationIconBadgeNumber = 1
            // This block gets called when the user reacts to a notification received
          //  UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
           
//            let payload: OSNotificationPayload? = result?.notification.payload;
//            
//            print("Message = \(payload!.body)");
//            print("badge number = \(payload?.badge)");
//            print("notification sound = \(payload?.sound)");
//            

            if let additionalData = result!.notification.payload!.additionalData {
                
                print("additionalData = \(additionalData)");
                if additionalData.index(forKey: "tweak_complete") != nil {
                let tweak_complete = additionalData["tweak_complete"] as! Bool
                    if tweak_complete == true {
                if additionalData.index(forKey: "tweak_id") != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_TRENDS"), object: nil);
                    let tweakID = additionalData["tweak_id"] as! NSNumber
                    UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
                    
                    
                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController;
                    if let viewControllers = navController?.viewControllers {
                        for viewController in viewControllers {
                            // some process
                            if viewController is TimelinesDetailsViewController {
                                print("yes it is")
                              //  UserDefaults.standard.removeObject(forKey: "TWEAK_ID");
                                return
                            }
                        }
                    }
                    self.goToHomePage()
                }
                    }
//                    else {
//                     // goto chat
//                        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController;
//                        if let viewControllers = navController?.viewControllers {
//                            for viewController in viewControllers {
//                                // some process
//                                if viewController is ChatVC  {
//                                    print("yes it is")
//                                    return
//                                }
//                            }
//                        }
//                        self.goToHomePage()
//                    }
            }
        
                if additionalData.index(forKey: "tweak_chat") != nil {
                let chat_notify = additionalData["tweak_chat"] as! Bool
                if chat_notify == true {
                    if additionalData.index(forKey: "tweak_id") != nil {
                        let tweakID = Int(additionalData["tweak_id"] as! String)!
                    
                    UserDefaults.standard.setValue(tweakID, forKey: "CHAT_NOTIFICATION");
                        UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");

                    
                   
                   
                    
                    
                    let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController;
                    if let viewControllers = navController?.viewControllers {
                        for viewController in viewControllers {
                            // some process
                            if viewController is ChatVC {
                                UserDefaults.standard.removeObject(forKey: "CHAT_NOTIFICATION");
                                 UserDefaults.standard.removeObject(forKey: "TWEAK_ID");
                                print("yes it is")
                                return
                            }
                        }
                    }
                   // self.goToHomePage()
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
                    }
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHAT_NOTIFICATION"), object: nil)
                }
                }
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
                
               
            
               
                
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
        //self.sendRefreshedFBToken()
        Messaging.messaging().shouldEstablishDirectChannel = true
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error ?? "Sin error" as! Error)")
            } else {
                print("Connected to FCM.")
            }
        }
        if launchOptions != nil{
            let userInfoDict = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
            if userInfoDict != nil {
                //     Perform action here
                UserDefaults.standard.set(userInfoDict, forKey: "PUSHWHENKILLED")
                UserDefaults.standard.synchronize()
          //      if userInfoDict is [String: AnyObject] {

              //  }
                
            }
        }
        
        return true;
    }
    func goToMyTweakAndEat() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as? MyTweakAndEatVCViewController;
        self.window?.rootViewController = UINavigationController(rootViewController:clickViewController!)
    }

    
    func goToHomePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.window?.rootViewController = UINavigationController(rootViewController:clickViewController!)
    }
    func goToTAEClub() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
        self.window?.rootViewController = UINavigationController(rootViewController:vc)

    }
   
    
    func goToHomePage(links: String) {
        UserDefaults.standard.setValue(links, forKey: "FROM_DEEP_LINKS")
        UserDefaults.standard.synchronize()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.window?.rootViewController = UINavigationController(rootViewController:clickViewController!)
    }
    
    // Print out the location to the console
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print(location.coordinate)
//            longitude = "\(location.coordinate.longitude)"
//            latitude = "\(location.coordinate.latitude)"
//            UserDefaults.standard.set(latitude, forKey: "LATITUDE")
//            UserDefaults.standard.set(longitude, forKey: "LONGITUDE")
//
//        }
//    }
    
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
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        self.sendRefreshedFBToken()
        if UserDefaults.standard.value(forKey: "SUBSCRIBE_TOPIC") != nil {
            let topicsArray = UserDefaults.standard.value(forKey: "SUBSCRIBE_TOPIC") as! NSArray
            if Messaging.messaging().fcmToken != nil {
                for topic in topicsArray {
                    Messaging.messaging().subscribe(toTopic: topic as! String)
                }
            }
        }
    }
    
    @objc func sendRefreshedFBToken() {
        if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
            if let refreshedToken = InstanceID.instanceID().token() {
                APIWrapper.sharedInstance.sendFBToken(["fbToken" : refreshedToken as Any], userSession: (UserDefaults.standard.value(forKey: "userSession") as? String)!, successBlock: {(responseDic : AnyObject!) -> (Void) in
                    UserDefaults.standard.set(true, forKey: "FBTOKEN")
                    
                }, failureBlock: { (error : NSError!) -> (Void) in
                    //error
                    print("error");
                    
                })
            }
        }
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
    

    
    @objc func scheduleNotification(hour : String, min : String, title:String, body: String) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("birds018.wav"));
            
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
   
    @objc @available(iOS 10.0, *)
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
                print(error?.localizedDescription as String!);
            }
        }
    }
    @objc func cancelNotificationForSpecificTime(hour : String, min : String) {
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

    
    @objc func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
//            let app = UIApplication.shared
//            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
//            
//            let statusbarView = UIView()
//            statusbarView.backgroundColor = UIColor.white
//            UIApplication.shared.keyWindow?.addSubview(statusbarView)
//          
//            statusbarView.translatesAutoresizingMaskIntoConstraints = false
//            statusbarView.heightAnchor
//                .constraint(equalToConstant: statusBarHeight).isActive = true
//            statusbarView.widthAnchor
//                .constraint(equalTo: UIApplication.shared.keyWindow?.widthAnchor, multiplier: 1.0).isActive = true
//            statusbarView.topAnchor
//                .constraint(equalTo: UIApplication.shared.keyWindow?.topAnchor).isActive = true
//            statusbarView.centerXAnchor
//                .constraint(equalTo: UIApplication.shared.keyWindow?.centerXAnchor).isActive = true
//          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
       
    }
    
    @objc func tweakImageFolderPath() -> String {
        var documentsPath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        documentsPath = documentsPath.appending("/TweakImages/");
        return documentsPath as String;
    }
    
    @objc func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    //UIApplication.shared.applicationIconBadgeNumber = 1
                    DispatchQueue.main.async(execute: {

                UIApplication.shared.registerForRemoteNotifications()
                })
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            DispatchQueue.main.async(execute: {

            UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let state = application.applicationState;
        if state == .active {
            
            let alert = UIAlertView(title: "Reminder", message: notification.alertBody!, delegate: "", cancelButtonTitle: "OK");
            alert.show();
        }
        //application.applicationIconBadgeNumber = 0;
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types.isEmpty {
            application.registerForRemoteNotifications();
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenStr = deviceToken.map { String(format: "%02x", $0) }.joined()
//        let characterSet :CharacterSet = CharacterSet(charactersIn: "<>");
//        let deviceTokenString: String = (deviceToken.description)
//            .trimmingCharacters(in: characterSet)
//            .replacingOccurrences(of: " ", with: "");
        let tokenParts = deviceToken.map { data -> String in
               return String(format: "%02.2hhx", data)
           }
               
           let token = tokenParts.joined()
        
        UserDefaults.standard.set(token, forKey: "deviceToken");
        Messaging.messaging().apnsToken = deviceToken
        CleverTap.sharedInstance()?.setPushToken(deviceToken)

       // AppsFlyerLib.shared().handlePushNotification(userInfo)

        print(token);
       // push?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error);
    }
    
    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //print("content" + "\(userInfo)");
        //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
        //push?.application(application, didReceiveRemoteNotification: userInfo)
        Branch.getInstance().handlePushNotification(userInfo)

     //   UIApplication.shared.applicationIconBadgeNumber = 1
        fetchCompletionHandler(UIBackgroundFetchResult.newData);
        let state = UIApplication.shared.applicationState
        switch state {

           case .inactive:
               print("Inactive")
           // application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1

           case .background:
               print("Background")
               // update badge count here
              // application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1

           case .active:
               print("Active")
          //  application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
//        if application.applicationState == .inactive {
//            self.goToHomePage()
//        }
    }
    
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
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_TRENDS"), object: nil);
    }
    
    @objc func fetchRecord(time: String, date: String) -> Int {
        let realm = try! Realm()
        let scope = realm.objects(DailyTipsNotify.self).filter("selectedDate == %@ AND selectedTime == %@", date,time)
        return scope.count
    }
    @objc func getAnnouncements() {
        let db = DBManager()
        self.announcements = db.realm.objects(Announcements.self)
        
        tweakNotifyRef = Database.database().reference().child("TweakNotifications")
        tweakNotifyRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
            let announcement = snapshot.value as? [String: AnyObject]
            let announcementObj = Announcements()
            announcementObj.postedOn = (announcement?["dateTime"] as AnyObject) as! String
            let announceMentData = db.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
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
                    announcementObj.announcement = message
                    let announceMentData = db.realm.object(ofType: Announcements.self, forPrimaryKey: announcementObj.postedOn);
                    if announceMentData == nil {
                        
                        
                        let badge = BadgeCount()
                        let entities = db.realm.objects(BadgeCount.self)
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
                        if UserDefaults.standard.value(forKey: "RECIPES_ALREADY_SEEN") != nil {
                        let identifier = ProcessInfo.processInfo.globallyUniqueString
                        let content = UNMutableNotificationContent()
                        content.title = "Announcements"
                        content.body = message.html2String
                        content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("AirplaneDing.wav"))
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
    
    @objc func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    // Open Univerasal Links
       // For Swift version < 4.2 replace function signature with the commented out code
       // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      // handler for Universal Links
        return Branch.getInstance().continue(userActivity)
    }
//       // Open Deeplinks
//       // Open URI-scheme for iOS 8 and below
//       func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//           AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
//           return true
//       }
       // Open URI-scheme for iOS 9 and above
//    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//           AppsFlyerLib.shared().handleOpen(url, options: options)
//           return true
//       }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if Branch.getInstance().application(app, open: url, options: options) {
//            return true
//
//        }
//        return ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//        
//    }
       // Report Push Notification attribution data for re-engagements
    func applicationDidBecomeActive(_ application: UIApplication) {
     //   AppsFlyerLib.shared().start()
        //AppEventsLogger.activate(application)
        AppEvents.activateApp()

       UIApplication.shared.applicationIconBadgeNumber = 0
        if let showRegistration : Bool  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool {
            if !showRegistration {
                self.getAnnouncements()
            }
            if let fbTokenISNotSent: Bool = UserDefaults.standard.value(forKey: "FBTOKEN") as? Bool {
                if !fbTokenISNotSent {
                    
                    self.sendRefreshedFBToken()
                }
            } else {
                
            }
        }
        
    }

    //  Swift
    //  AppDelegate.swift
    //  Replace the code in AppDelegate.swift with the following code.
    //
    //  Copyright © 2020 Facebook. All rights reserved.
    //

   

              
//        func application(
//            _ app: UIApplication,
//            open url: URL,
//            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//        ) -> Bool {
//            if let scheme = url.scheme,
//                   scheme.localizedCaseInsensitiveCompare("tweakandeat") == .orderedSame,
//                   let view = url.host {
//
//                   var parameters: [String: String] = [:]
//                   URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
//                       parameters[$0.name] = $0.value
//                   }
//                   //redirect(to: view, with: parameters)
//
//                self.goToHomePage(links: url.host!)
//
//
//               }
//               return true
//            ApplicationDelegate.shared.application(
//                app,
//                open: url,
//                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//            )
//
//        }


        
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//
//        UIApplication.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//
//    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext();
        DatabaseController.saveContext();
    }
    
    // MARK: - Core Data stack
    @objc lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.test.Tweak_and_Eat" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        return urls[urls.count-1];
    }()
    
    @objc lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Tweak_and_Eat", withExtension: "momd")!;
        return NSManagedObjectModel(contentsOf: modelURL)!;
    }()
    
    @objc lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel);
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite");
        var failureReason = "There was an error creating or loading the application's saved data.";
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])

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
    
    @objc lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator;
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType);
        managedObjectContext.persistentStoreCoordinator = coordinator;
        return managedObjectContext;
    }()
    
    // MARK: - Core Data Saving support
    
    @objc func saveContext () {
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
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Refresh Token")
        if UserDefaults.standard.value(forKey: "SUBSCRIBE_TOPIC") != nil {
            let topicsArray = UserDefaults.standard.value(forKey: "SUBSCRIBE_TOPIC") as! NSArray
        if Messaging.messaging().fcmToken != nil {
            for topic in topicsArray {
                Messaging.messaging().subscribe(toTopic: topic as! String)
            }
        }
        }
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        
//        // Print message ID.
////        if let messageID = userInfo[gcmMessageIDKey] {
////            print("Message ID: \(messageID)")
////        }
//        
//        // Print full message.
//        print(userInfo)
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        let remoteMessages = remoteMessage.appData
        
        
        let identifier = ProcessInfo.processInfo.globallyUniqueString
        let content = UNMutableNotificationContent()
        content.title = "Fulfillments"
        if remoteMessages.index(forKey: "title") != nil {
            content.title = remoteMessage.appData["title"] as! String
            
        }

        
        if remoteMessages.index(forKey: "body") != nil {
            content.body = remoteMessage.appData["body"] as! String

        } else if remoteMessages.index(forKey: "msg") != nil {
            content.body = remoteMessage.appData["msg"] as! String
            
        } else {
            content.body = ""

        }
        if remoteMessages.index(forKey: "fb_notify") != nil {
            content.categoryIdentifier = "fbNotify"
            if remoteMessages.index(forKey: "msg") != nil {
                let msg = remoteMessages["msg"] as! String
                content.body = msg.html2String
            }
            if remoteMessages.index(forKey: "img") != nil {
                let imgUrlString = remoteMessages["img"] as! String
                if let attachment = UNNotificationAttachment.create(identifier: identifier, urlString: imgUrlString, options: nil) {
                    // where myImage is any UIImage that follows the
                    content.attachments = [attachment]
                    
                }
            }
        }
        let navController =  window?.rootViewController as? UINavigationController
        if let viewControllers = navController?.viewControllers {
            for viewController in viewControllers {
                // some process
                if (viewController is ChatVC) || viewController is DietPlanViewController {
                    print("yes it is")
                    return
                }
            }
        }
        content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("AirplaneDing.wav"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            // handle error
        }
      
    }
    
    @objc func dismissNotifFromScreen() {
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {() -> Void in
            self.notifView.frame = CGRect(x: 0, y: -70, width: (self.window?.frame.size.width)!, height: 60)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
//
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let notification = Notification(
            name: Notification.Name(rawValue: NotificationConstants.launchNotification),
            object:nil,
            userInfo:[UIApplication.LaunchOptionsKey.url:url])
        NotificationCenter.default.post(notification)
        return true
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
