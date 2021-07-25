//
//  DataManager.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 28/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    @objc var managedObjectContext : NSManagedObjectContext! = nil;
    @objc var managedObjectModel : NSManagedObjectModel! = nil;
    @objc var persistentStoreCoordinator : NSPersistentStoreCoordinator! = nil;
    
    @objc let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    
    @objc class var sharedInstance: DataManager {
        struct Static {
            static let instance = DataManager()
        }
        
        let applicationDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        Static.instance.managedObjectModel = applicationDelegate.managedObjectModel;
        Static.instance.managedObjectContext = applicationDelegate.managedObjectContext;
        Static.instance.persistentStoreCoordinator = applicationDelegate.persistentStoreCoordinator;
        
        return Static.instance;
    }
    
    @objc func saveChanges() {
        do {
            try self.managedObjectContext.save();
        } catch let error {
            print("Could not save the data \(error)");
        }
    }
    
    //TBL Tweaks
    
    
    @objc func saveTweak(tweak : NSDictionary) {
        
        var tweakObject : TBL_Tweaks? = self.fetchTWEAKWithId(value: tweak.value(forKey: TBL_TweakConstants.TWEAK_ID) as! NSNumber);
        
        if(tweakObject == nil) {
            tweakObject = NSEntityDescription.insertNewObject(forEntityName: "TBL_Tweaks", into: self.managedObjectContext) as? TBL_Tweaks;
        }
                
        tweakObject!.tweakId = Int64(tweak.value(forKey: TBL_TweakConstants.TWEAK_ID) as! NSInteger);
        tweakObject!.tweakOriginalImageURL = tweak.value(forKey: TBL_TweakConstants.TWEAK_IMAGE_URL) as? String;
        tweakObject!.tweakModifiedImageURL = tweak.value(forKey: TBL_TweakConstants.TWEAK_MODIFIED_IMAGE_URL) as? String;
        tweakObject!.tweakSuggestedText = tweak.value(forKey: TBL_TweakConstants.TWEAK_TEXT) as? String;
        tweakObject!.tweakStatus = Int64(tweak.value(forKey: TBL_TweakConstants.TWEAK_STATUS) as! NSInteger);
        if tweak.value(forKey: TBL_TweakConstants.TWEAK_LATITUDE) is NSNull {
            tweakObject!.tweakLatitude = 0.0;
        } else {
            tweakObject!.tweakLatitude = tweak.value(forKey: TBL_TweakConstants.TWEAK_LATITUDE) as! Double;
        }
        if tweak.value(forKey: TBL_TweakConstants.TWEAK_LONGITUDE) is NSNull {
            tweakObject!.tweakLongitude = 0.0;
        } else {
            tweakObject!.tweakLongitude = tweak.value(forKey: TBL_TweakConstants.TWEAK_LONGITUDE) as! Double;
        }
        if tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) is NSNumber {
            tweakObject!.tweakRating = tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) as! Float;

        } else if tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) is String {
        if (tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) as! String).contains(",") {
            let tweakString = tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) as! String;

            tweakObject!.tweakRating = Float(tweakString.replacingOccurrences(of: ",", with: "."))!


        } else {
            let tweakString = tweak.value(forKey: TBL_TweakConstants.TWEAK_RATING) as! String;
            tweakObject!.tweakRating = Float(tweakString)!
            }
        }
        tweakObject!.tweakAudioMessage = tweak.value(forKey: TBL_TweakConstants.TWEAK_AUDIO_MSG) as? String;
        tweakObject!.tweakDateCreated = tweak.value(forKey: TBL_TweakConstants.TWEAK_CORRECT_DATE) as? String;
        tweakObject!.tweakDateUpdated = tweak.value(forKey: TBL_TweakConstants.TWEAK_UPDATED_DATE) as? String;
         if tweak.value(forKey: TBL_TweakConstants.TWEAK_USER_COMMENTS) is NSNull {
            tweakObject!.tweakUserComments = ""
         } else {
        tweakObject!.tweakUserComments = tweak.value(forKey: TBL_TweakConstants.TWEAK_USER_COMMENTS) as? String;
        }
        tweakObject!.mealType = tweak.value(forKey: TBL_TweakConstants.MEAL_TYPE) as! Int16
        tweakObject!.carbs = tweak.value(forKey: TBL_TweakConstants.CARBS) as! Int16
        tweakObject!.calories = tweak.value(forKey: TBL_TweakConstants.CALORIES) as! Int16
        tweakObject!.fats = tweak.value(forKey: TBL_TweakConstants.FATS) as! Int16
        tweakObject!.protein = tweak.value(forKey: TBL_TweakConstants.PROTEIN) as! Int16
        self.saveChanges()
    }
    
    @objc func fetchTWEAKWithId(value : NSNumber) -> TBL_Tweaks? {
        let fetchRequest : NSFetchRequest<TBL_Tweaks> = TBL_Tweaks.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "tweakId == %@",value);
        
        var results :[TBL_Tweaks]? = nil;
        do {
            results = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            
        }
        if(results?.count == 0) {
            return nil;
        } else {
            return results![0]
        }
    }
    
    @objc func fetchTweaks() -> [TBL_Tweaks]? {
        let fetchRequest : NSFetchRequest<TBL_Tweaks> = TBL_Tweaks.fetchRequest();
        let sortDecriptor = NSSortDescriptor(key: "tweakId", ascending: false);
        fetchRequest.sortDescriptors = [sortDecriptor];
        //tweakId
        var results :[TBL_Tweaks]? = nil;
        do {
            results = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            
        }
        if(results?.count == 0) {
            return nil;
        } else {
            return results!;
        }
    }
    
    // TBL Reminders
    
    @objc func saveReminders(reminder : [String : AnyObject]) {
        var reminderObject : TBL_Reminders? = self.fetchReminderWithId(id: (reminder[TBL_ReminderConstants.REMINDER_ID]! as! NSNumber).int64Value);
        
        if(reminderObject == nil) {
            reminderObject = NSEntityDescription.insertNewObject(forEntityName: "TBL_Reminders", into: self.managedObjectContext) as? TBL_Reminders;
        }
        
        reminderObject!.rmdrId = (reminder[TBL_ReminderConstants.REMINDER_ID]! as! NSNumber).int64Value;
        reminderObject!.rmdrType = (reminder[TBL_ReminderConstants.REMINDER_TYPE]! as! NSNumber).int64Value;
        reminderObject!.rmdrName = reminder[TBL_ReminderConstants.REMINDER_NAME]! as? String;
        reminderObject!.rmdrTime = reminder[TBL_ReminderConstants.REMINDER_TIME]! as? String;
        reminderObject!.rmdrStatus = reminder[TBL_ReminderConstants.REMINDER_STATUS]! as? String;
        
        self.saveChanges();
    }
    
    @objc func fetchReminderWithId(id : Int64) -> TBL_Reminders? {
        let fetchRequest : NSFetchRequest<TBL_Reminders> = TBL_Reminders.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "rmdrId == %d",id);
        
        var results :[TBL_Reminders]? = nil;
        do {
            results = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            
        }
        
        if(results?.count == 0) {
            return nil;
        } else {
            return results![0];
        }
    }
    
    @objc func fetchReminderWithType(type : String) -> [TBL_Reminders]? {
        let fetchRequest : NSFetchRequest<TBL_Reminders> = TBL_Reminders.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "rmdrType == %@",type);
        
        var results :[TBL_Reminders]? = nil;
        do {
            results = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            
        }
        if(results == nil) {
            return nil;
        } else {
            return results!;
        }
    }
    
    @objc func changeStatusOfReminderID(id : Int64) {
        let reminder : TBL_Reminders = self.fetchReminderWithId(id: id)!;
        let timeString = reminder.rmdrTime!;
        let timeArray = timeString.components(separatedBy: ":");
        if(reminder.rmdrStatus ==  TBL_ReminderConstants.REMINDER_STATUS_ENABLED) {
            reminder.rmdrStatus = TBL_ReminderConstants.REMINDER_STATUS_DISABLED;
            appDelegate.cancelNotificationForSpecificTime(hour: timeArray[0], min: timeArray[1]);
        
        } else {
            var rmdrBody = "";
            
            if reminder.rmdrName! == "Breakfast Tweak Reminder"{
                rmdrBody = " Good Morning! We’re ready to Tweak your Breakfast (7:30AM to 10AM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
            } else if reminder.rmdrName! == "Lunch Tweak Reminder"{
                rmdrBody = " Good Afternoon! We’re ready to Tweak your Lunch (12:30PM to 3PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
            } else if reminder.rmdrName! == "Dinner Tweak Reminder"{
                rmdrBody = " Good Evening! We’re ready to Tweak your Dinner (7:30PM to 10PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                
            }

            reminder.rmdrStatus = TBL_ReminderConstants.REMINDER_STATUS_ENABLED;
            appDelegate.scheduleNotification(hour: timeArray[0], min: timeArray[1], title: reminder.rmdrName!, body: rmdrBody);
        }
        
        self.saveChanges();
    }
    
    @objc func makeReminderStatusON(id : Int64) {
        let reminderObj : TBL_Reminders = self.fetchReminderWithId(id: id)!
        reminderObj.rmdrStatus = TBL_ReminderConstants.REMINDER_STATUS_ENABLED;
        
        self.saveChanges();
        
    }
    
    @objc func changeTimeOfReminderID(reminder : TBL_Reminders, time : String) {
        let reminder : TBL_Reminders? = self.fetchReminderWithId(id: reminder.rmdrId)!;
        if(reminder != nil) {
            reminder?.rmdrTime = time;
        }
        
        self.saveChanges();
    }
        
    // TBL Contacts
    
    @objc func saveInvitedFriends(friends : [String : AnyObject]) {
      var invitedFriendsObj : TBL_Contacts? = self.fetchContactsWithId(id: (friends[TBL_ContactConstants.CONTACT_NUMBER]! as! NSNumber).int64Value);
        
        if(invitedFriendsObj == nil) {
            invitedFriendsObj = NSEntityDescription.insertNewObject(forEntityName: "TBL_Contacts", into: DatabaseController.managedObjectContext) as? TBL_Contacts;
        }
        
        invitedFriendsObj?.contact_name = friends[TBL_ContactConstants.CONTACT_NAME]! as? String ;
        invitedFriendsObj?.contact_number = friends[TBL_ContactConstants.CONTACT_NUMBER]! as? String ;
        invitedFriendsObj?.contact_profilePic = friends[TBL_ContactConstants.CONTACT_PROFILE_PIC]! as? NSData ;
        invitedFriendsObj?.contact_selectedDate = friends[TBL_ContactConstants.CONTACT_SELECTED_DATE]! as? NSDate ;
        
        self.saveChanges();
        
    }
    
    @objc func fetchContactsWithId(id : Int64) -> TBL_Contacts? {
        let fetchRequest : NSFetchRequest<TBL_Contacts> = TBL_Contacts.fetchRequest();
        fetchRequest.predicate = NSPredicate(format : "contact_number == %d", id);
        
        var results : [TBL_Contacts]? = nil;
        do {
            results = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            
        }
        
        if (results?.count == 0) {
            return nil;
        } else {
            return results![0];
        }
    }
    
}
