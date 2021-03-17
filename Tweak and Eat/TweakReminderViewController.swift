//
//  TweakReminderViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import UserNotifications

@available(iOS 10.0, *)
class TweakReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @objc var player : AVAudioPlayer?;
    @IBOutlet var tweaksTableView: UITableView!;
    @objc var tweakReminders : [TBL_Reminders]?;
    @objc var overlayView : UIView!;
    @objc var array : String!;
    var myInt1 : Int!;
    var myInt2 : Int!;
    @objc var date : NotificationService! = nil;
    @objc let requestId = "Request ID";
    @objc let categoryId = "Category ID";
    @objc var selectedIndexPath : IndexPath!;
    @objc var selectedTime : String!;
    @objc var didSelectedTime : String!;
    @objc var datePicker : UIDatePicker!;
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var countryCode = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        self.title = bundle.localizedString(forKey: "tweak_reminders", value: nil, table: nil)
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)]);
        
     //   self.title = "Tweak Reminders"
        setupNotifications();
        Notifications.authorize();
        tweakReminders = DataManager.sharedInstance.fetchReminderWithType(type: TBL_ReminderConstants.REMINDER_TYPE_TWEAK);
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TweakAndEatRemindeCell = (Bundle.main.loadNibNamed("TweakAndEatRemindeCell", owner: self, options: nil)! as [Any])[0] as! TweakAndEatRemindeCell;
        if ((tweakReminders?.count)! > 0) {
            let reminderName = tweakReminders?[indexPath.row].rmdrName;
            
            if reminderName == "Breakfast Tweak Reminder"{
                cell.reminderTitle.text = bundle.localizedString(forKey: "breakfast_reminder_text", value: nil, table: nil)

            } else if reminderName == "Lunch Tweak Reminder"{
                cell.reminderTitle.text = bundle.localizedString(forKey: "lunch_reminder_text", value: nil, table: nil)
            } else if reminderName == "Dinner Tweak Reminder"{
                cell.reminderTitle.text = bundle.localizedString(forKey: "dinner_reminder_text", value: nil, table: nil)
            }

        
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "HH:mm";
            let date = dateFormatter.date(from: tweakReminders![indexPath.row].rmdrTime!);
            dateFormatter.dateFormat = "hh:mm a";
        
            cell.reminderTime.text =  dateFormatter.string(from: date!);
            cell.enableSwitch.addTarget(self, action: #selector(enableOrDisableReminder(sender:)), for: UIControl.Event.valueChanged);
            if(tweakReminders?[indexPath.row].rmdrStatus == TBL_ReminderConstants.REMINDER_STATUS_ENABLED) {
                cell.enableSwitch.isOn = true;
            } else {
                cell.enableSwitch.isOn = false;
            }
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        
        return cell;
    }
    
    @objc func enableOrDisableReminder(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tweaksTableView);
        let indexPath = self.tweaksTableView.indexPathForRow(at: buttonPosition);
            
        DataManager.sharedInstance.changeStatusOfReminderID(id: tweakReminders![(indexPath?.row)!].rmdrId);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((tweakReminders?.count)! > 0) {
            self.selectedIndexPath = indexPath;
            self.selectedTime = self.tweakReminders![indexPath.row].rmdrTime!;
            self.didSelectedTime = self.tweakReminders![indexPath.row].rmdrTime!;
        
            let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate;
            overlayView = UIView(frame: CGRect.init(0, 0, appDelegate.window!.bounds.size.width,appDelegate.window!.bounds.size.height));
            overlayView.backgroundColor = .white
            if #available(iOS 13.4, *) {
                datePicker = UIDatePicker(frame: CGRect.init(0, appDelegate.window!.bounds.size.height-160-40, appDelegate.window!.bounds.size.width,160));
               datePicker.preferredDatePickerStyle = .wheels
               datePicker.backgroundColor = UIColor.white
            }

            
            datePicker.datePickerMode = .time;
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged);
            datePicker.backgroundColor = UIColor.white;
        
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "HH:mm";
            datePicker.date = dateFormatter.date(from: self.tweakReminders![indexPath.row].rmdrTime!)!;
            let pickerToolbar : UIToolbar = UIToolbar(frame: CGRect.init(0, appDelegate.window!.bounds.size.height-160-30-50, appDelegate.window!.bounds.size.width,40));
            
            let spacing = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil);
            spacing.width = 15;
            let doneBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction));
            doneBarbutton.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
            let flexiItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil);
            let cancelBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAction));
            cancelBarbutton.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
           pickerToolbar.setItems([spacing,doneBarbutton,flexiItem,cancelBarbutton,spacing], animated: true);
            overlayView.addSubview(pickerToolbar);
            overlayView.addSubview(datePicker);
            appDelegate.window!.addSubview(overlayView);
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
    
    @objc func doneAction() {
        
        let timeString = self.didSelectedTime;
        let timeArray =  timeString?.components(separatedBy: ":");
        let hour = timeArray?[0];
        let min = timeArray?[1];
        self.cancelNotificationForSpecificTime(hour: hour!, min: min!);

        let reminderObj : TBL_Reminders = self.tweakReminders![self.selectedIndexPath.row];
        
        self.tweakReminders?[self.selectedIndexPath.row].rmdrTime = self.selectedTime;
        self.tweakReminders?[self.selectedIndexPath.row].rmdrStatus = TBL_ReminderConstants.REMINDER_STATUS_ENABLED;
        
        DataManager.sharedInstance.changeTimeOfReminderID(reminder: reminderObj, time: self.selectedTime);
        DataManager.sharedInstance.makeReminderStatusON(id: reminderObj.rmdrId);
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "HH:mm";
        let d = dateFormatter.string(from: datePicker.date);
        var array =  d.components(separatedBy: ":");
        let hh = array[0];
        let mm = array[1];
      
        let rmdrTitle = "Tweak & Eat Reminder";
        var rmdrBody = "";
        
        if reminderObj.rmdrName == "Breakfast Tweak Reminder"{
            rmdrBody = "Good Morning! We’re ready to Tweak your Breakfast (7:30AM to 10AM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
        } else if reminderObj.rmdrName == "Lunch Tweak Reminder"{
            rmdrBody = "Good Afternoon! We’re ready to Tweak your Lunch (12:30PM to 3PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
        } else if reminderObj.rmdrName == "Dinner Tweak Reminder"{
            rmdrBody = "Good Evening! We’re ready to Tweak your Dinner (7:30PM to 10PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";

        }
        Notifications.schedule(hour: hh, min: mm, title: rmdrTitle, body: rmdrBody);
        self.tweaksTableView.reloadRows(at: [self.selectedIndexPath], with: UITableView.RowAnimation.fade);
        overlayView.removeFromSuperview();
    }
    
    @objc func cancelAction() {
        overlayView.removeFromSuperview();
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "HH:mm";
        self.selectedTime = dateFormatter.string(from: sender.date);
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TweakReminderViewController.onNotificationServiceAuthorized), name: .notificationServiceAuthorized, object: nil);
    }
    
    @objc fileprivate func onNotificationServiceAuthorized() {
        let doneBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
