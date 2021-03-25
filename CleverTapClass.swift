//
//  CleverTapClass.swift
//  Tweak and Eat
//
//  Created by Mehera on 15/03/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import Foundation
import CleverTapSDK
import Realm
import RealmSwift
import FirebaseInstanceID

class CleverTapClass {
    var myProfile : Results<MyProfileInfo>?
    var countryCode = ""
    func updateCleverTapWithProp(isUpdateProfile: Bool) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        self.myProfile = uiRealm.objects(MyProfileInfo.self);
        var name = ""
        var email = ""
        var mobileNumber = ""
        var ccCode = ""
        var age = ""
        var gender = ""
        var weight = ""
        var goals = ""
        var conditions = ""
        var allergies = ""
        var foodHabits = ""
        var height = ""
        
        
        // get profile details from database
        
        for prof in self.myProfile! {
            name = prof.name
            email = prof.email
            mobileNumber = prof.msisdn
            ccCode = self.countryCode
            age = prof.age
            gender = prof.gender
            weight = prof.weight
            goals = prof.goals
            conditions = prof.conditions
            allergies = prof.allergies
            foodHabits = prof.foodHabits
            height = prof.height
            
            
        }
        var totalCM: Int = 0
        if self.countryCode == "1" {
            let heightInFeets = height
            let feetArray = heightInFeets.components(separatedBy: "'")
            let feet = "\(feetArray[0])";
            let inches = "\(feetArray[1])";
            
            totalCM = Int((Float(Double(feet)! * 30.48) + Float(Double(inches)! * 2.54)));
            
        }
        
        // create a profile dictionary to store all the properties.
        
        let profile: Dictionary<String, AnyObject> = [
            //Update pre-defined profile properties
            "Name": name as AnyObject,
            "Identity": "+" + mobileNumber as AnyObject,
            "Email": email as AnyObject,
            //Update custom profile properties
            "Phone": "+" + mobileNumber as AnyObject,
            "Country Code": Int(ccCode)!  as AnyObject,
            "Age in years": Int(age)!  as AnyObject,
            "Age": Int(age)!  as AnyObject,
            "Gender": gender == "M" ? "Male" as AnyObject : "Female" as AnyObject,
            "Weight": (self.countryCode == "1") ? Int(weight)! as AnyObject : Int(weight)! * Int(2.2) as AnyObject,
            "Height": (self.countryCode == "1") ? totalCM as AnyObject : height as AnyObject,
            "Firebase Token": InstanceID.instanceID().token() as AnyObject,
            "BMI": (self.countryCode == "1") ? Int(Double(self.calculateBMI(massInKilograms: Double(Int(weight)! / Int(2.2)), heightInCentimeters: Double(totalCM)))) as AnyObject : Int(Double(self.calculateBMI(massInKilograms: Double(Int(weight)!), heightInCentimeters: Double(height)!))) as AnyObject,
            "Allergies": allergies.components(separatedBy: ",") as AnyObject,
            "Conditions": conditions.components(separatedBy: ",") as AnyObject,
            "Goals": goals.components(separatedBy: ",") as AnyObject,
            "Food Habits": foodHabits.components(separatedBy: ",") as AnyObject,
            "MSG-email": true as AnyObject,           // Disable email notifications
            "MSG-push": true as AnyObject,             // Enable push notifications
            "MSG-sms": false as AnyObject,             // Disable SMS notifications
            "MSG-whatsapp": false as AnyObject
            
        ]
        
        // record events with properties.
        
        if isUpdateProfile == true {
            CleverTap.sharedInstance()?.profilePush(profile)
            CleverTap.sharedInstance()?.recordEvent("user_profile_updated", withProps: profile)
        } else {
            CleverTap.sharedInstance()?.onUserLogin(profile)
            CleverTap.sharedInstance()?.recordEvent("Signup_completed",withProps: profile)
        }
    }
    
    // calculate BMI based on weight in kilograms and height in centimeters
    
    func calculateBMI(massInKilograms mass: Double, heightInCentimeters height: Double) -> Double {
        return mass / ((height * height) / 10000)
    }
}
