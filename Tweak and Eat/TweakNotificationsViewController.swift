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
    
    @objc let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var badgeCountData : Results<BadgeCount>?;
    @objc var badgeCount: Int = 0;
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    var announcements : Results<Announcements>?;
    let realm :Realm = try! Realm();
    @objc var tweakNotifyRef : DatabaseReference!;
    @IBOutlet weak var notificationTableView: UITableView!;
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    
    
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.title = bundle.localizedString(forKey: "chekthis", value: nil, table: nil)
        
        UserDefaults.standard.setValue("YES", forKey: "RECIPES_ALREADY_SEEN")

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        UNUserNotificationCenter.current().removeAllDeliveredNotifications();
        try! realm.write {
            self.badgeCountData = self.realm.objects(BadgeCount.self);
            realm.delete(self.badgeCountData!);
            appDelegate.badgeCount = 0;
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BADGECOUNT"), object: 0);
        }
        self.announcements = self.realm.objects(Announcements.self);
        
        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)];
        self.announcements = self.announcements!.sorted(by: sortProperties);
        if self.announcements?.count == 0 {
            MBProgressHUD.hide(for: self.view, animated: true);
            let alertController = UIAlertController(title: bundle.localizedString(forKey: "no_announcements", value: nil, table: nil), message: "", preferredStyle: .alert);
            
            let defaultAction = UIAlertAction(title: bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil);
            
            alertController.addAction(defaultAction);
            self.present(alertController, animated: true, completion: nil);
        }
        NotificationCenter.default.addObserver(self, selector: #selector(TweakNotificationsViewController.reloadTable(notification:)), name: NSNotification.Name(rawValue: "RELOAD_TABLE"), object: nil);
    }
    
    @objc func reloadTable(notification : NSNotification) {
        
        let sortProperties = [SortDescriptor(keyPath: "timeIn", ascending: false)]
        self.announcements = self.announcements!.sorted(by: sortProperties);
        if self.announcements?.count == 0 {
            MBProgressHUD.hide(for: self.view, animated: true);
            let alertController = UIAlertController(title: bundle.localizedString(forKey: "no_announcements", value: nil, table: nil), message: "", preferredStyle: .alert);
            let defaultAction = UIAlertAction(title: bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil);
            alertController.addAction(defaultAction);
            self.present(alertController, animated: true, completion: nil);
        }
        
        MBProgressHUD.hide(for: self.view, animated: true);
        self.notificationTableView.reloadData();
    }
    
    @objc func cellTappedOnImage(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView;
        let newImageView = UIImageView(image: imageView.image);
        newImageView.frame = CGRect(x:0, y:0 - 64, width: self.view.frame.size.width, height: self.view.frame.size.height + 64);
        newImageView.backgroundColor = .black;
        newImageView.contentMode = .scaleAspectFit;
        newImageView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage));
        newImageView.addGestureRecognizer(tap);
        self.view.addSubview(newImageView);
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview();
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebViewController;
        destinationVC.urlString = sender as! String;
    }
    
    @objc func cellTappedOnMessageLbl(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer) {
        print(sender);
        self.myIndexPath = cell.myIndexPath;
        let cellDictionary = self.announcements?[self.myIndexPath.row];
        let message = cellDictionary!["announcement"] as AnyObject as? String;
        if message?.extractURLs().count == 0 {
            return
        } else {
            self.performSegue(withIdentifier: "showWebView", sender: message?.extractURLs()[0].absoluteString);
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TweakNotifyTableViewCell
        if cell.cellDelegate == nil {
            cell.cellDelegate = self;
        }
        cell.cellIndexPath = indexPath.row;
        cell.myIndexPath = indexPath;
        
        cell.notificationImageView.contentMode = .scaleToFill
        
        let cellDictionary = self.announcements?[indexPath.row];
        cell.notificationDate.text = cellDictionary!["postedOn"] as AnyObject as? String;
        let message = cellDictionary!["announcement"] as AnyObject as? String;
       
        let string              = message?.html2String;
        let range               = (string! as NSString).range(of: "Click here for more details");
        let attributedString    = NSMutableAttributedString(string: string!);
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range);
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.blue, range: range);
        
        cell.notificationMessageLbl.attributedText = attributedString;
        let imageUrl = cellDictionary?["imageUrl"] as AnyObject as? String;

        if imageUrl == "" {
            cell.imgViewHeightConstraint.constant = 0;
        } else {
            cell.notificationImageView.sd_setImage(with: URL(string: imageUrl!));
            cell.imgViewHeightConstraint.constant = 198;
            cell.notificationImageView.contentMode = .scaleAspectFill

        }
        cell.notificationImageView.layer.borderWidth = 2.0
        cell.notificationImageView.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
