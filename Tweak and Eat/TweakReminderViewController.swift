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

    var player : AVAudioPlayer?;
    @IBOutlet var tweaksTableView: UITableView!;
    var tweakReminders : [TBL_Reminders]?;
    var overlayView : UIView!;
    var array : String!;
    var myInt1 : Int!;
    var myInt2 : Int!;
    var date : NotificationService! = nil;
    let requestId = "Request ID";
    let categoryId = "Category ID";
    var selectedIndexPath : IndexPath!;
    var selectedTime : String!;
    var didSelectedTime : String!;
    var datePicker : UIDatePicker!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            cell.reminderTitle.text = tweakReminders?[indexPath.row].rmdrName;
        
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "HH:mm";
            let date = dateFormatter.date(from: tweakReminders![indexPath.row].rmdrTime!);
            dateFormatter.dateFormat = "hh:mm a";
        
            cell.reminderTime.text =  dateFormatter.string(from: date!);
            cell.enableSwitch.addTarget(self, action: #selector(enableOrDisableReminder(sender:)), for: UIControlEvents.valueChanged);
            if(tweakReminders?[indexPath.row].rmdrStatus == TBL_ReminderConstants.REMINDER_STATUS_ENABLED) {
                cell.enableSwitch.isOn = true;
            } else {
                cell.enableSwitch.isOn = false;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell;
    }
    
    func enableOrDisableReminder(sender: AnyObject) {
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
            overlayView = UIView(frame: CGRect.init(0, 0, appDelegate.window!.frame.size.width,appDelegate.window!.frame.size.height));
        
            datePicker = UIDatePicker(frame: CGRect.init(0, appDelegate.window!.frame.size.height-160-40, appDelegate.window!.frame.size.width,160));
            datePicker.datePickerMode = UIDatePickerMode.time;
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged);
            datePicker.backgroundColor = UIColor.white;
        
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "HH:mm";
            datePicker.date = dateFormatter.date(from: self.tweakReminders![indexPath.row].rmdrTime!)!;
          
            
            let pickerToolbar : UIToolbar = UIToolbar(frame: CGRect.init(0, appDelegate.window!.frame.size.height-160-30-40, appDelegate.window!.frame.size.width,30));
            
            let spacing = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil);
            spacing.width = 15;
            let doneBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneAction));
            doneBarbutton.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
            let flexiItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
            let cancelBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAction));
            cancelBarbutton.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
           pickerToolbar.setItems([spacing,doneBarbutton,flexiItem,cancelBarbutton,spacing], animated: true);
            overlayView.addSubview(pickerToolbar);
            overlayView.addSubview(datePicker);
            appDelegate.window!.addSubview(overlayView);
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
    
    func doneAction() {
        
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
        self.tweaksTableView.reloadRows(at: [self.selectedIndexPath], with: UITableViewRowAnimation.fade);
        overlayView.removeFromSuperview();
    }
    
    func cancelAction() {
        overlayView.removeFromSuperview();
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "HH:mm";
        self.selectedTime = dateFormatter.string(from: sender.date);
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TweakReminderViewController.onNotificationServiceAuthorized), name: .notificationServiceAuthorized, object: nil);
    }
    
    @objc fileprivate func onNotificationServiceAuthorized() {
        let doneBarbutton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneAction));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}
