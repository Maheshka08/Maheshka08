//
//  Contacts.swift
//  Tweak and Eat
//
//  Created by admin on 21/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData

private var contactsSingleTon : Contacts? = nil;
private let version : Float = (UIDevice.current.systemVersion as NSString).floatValue;
private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
//private let inviteFriends = mainStoryboard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController;

class Contacts: NSObject {
    
    @objc var contactsArray : [[String:AnyObject]] = [[String:AnyObject]]();
    
    @objc lazy var addressBook: ABAddressBook = {
        var error: Unmanaged<CFError>?;
        return ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue() as ABAddressBook;
    }()
    @objc class func sharedContacts() -> Contacts{
        if (contactsSingleTon == nil) {
            contactsSingleTon = Contacts();
        }
        return contactsSingleTon!;
    }
    
    @objc func getAllContactsBelowLatestVersioN() {
        
//        if (NSObject.version < 9.0) {
//            
//            
//        }else {
//            
//        }
    }
    
    @objc func getContactsAuthenticationForAddressBook() {
        
        switch ABAddressBookGetAuthorizationStatus(){
        case .authorized:
            print("Authorized");
            readFromAddressBook(addressBook: self.addressBook);
        case .denied:
            print("Denied");
        case .restricted:
            print("Restricted");
        case .notDetermined:
            print("Not determined");
    ABAddressBookRequestAccessWithCompletion(addressBook,{(granted, error) in
            if granted {
                let strongSelf = self;
                print("Access is granted");
                strongSelf.readFromAddressBook(addressBook: strongSelf.addressBook);
                        }
              else{
                print("Access is not granted");
                }
            })
            
        }
    }
    
    
    @objc func readFromAddressBook(addressBook: ABAddressBook){

        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray;
            if self.contactsArray.count > 0 {
                self.contactsArray.removeAll();
            }
            
            for i in 0..<allPeople.count{
                let person = allPeople[i] as ABRecord;
                var fName = "";
                var lName = "";
                var Idata : Data?;
                if let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty) {
                    fName = (firstName.takeRetainedValue() as? String) ?? "";
                }
                if let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty) {
                    lName = (lastName.takeRetainedValue() as? String) ?? "";
                }
                if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeRetainedValue() as Data! {
                    Idata = data;
                }else{
                    Idata = UIImage(named: "Contact")!.pngData();
                }
                
                var fullName = fName+" "+lName;
                fullName = fullName.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines);
                let phones : ABMultiValue = ABRecordCopyValue(person,kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValue;
                
                for index in 0 ..< ABMultiValueGetCount(phones){
                    let numberIndex : CFIndex = index as CFIndex;
                    let phoneUnmaganed = ABMultiValueCopyValueAtIndex(phones, numberIndex);
                    var phoneNumber : NSString = phoneUnmaganed!.takeUnretainedValue() as! NSString;
                    phoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: NSString.CompareOptions(rawValue: 8), range:NSMakeRange(0, phoneNumber.length)) as NSString;
                    let stringArray = phoneNumber.components(
                        separatedBy: NSCharacterSet.decimalDigits.inverted);
                    let newString = NSArray(array: stringArray).componentsJoined(by: "");
                    phoneNumber = newString as NSString;
                    if fullName == ""{
                        fullName = phoneNumber as String;
                    }
                    
                    // checking for validation for mobile number & database
                    if (phoneNumber as String).isPhoneNumber && !(phoneNumber as String).isContainInDB{
                        let contacts = ["lname": lName,"name" :fullName, "number":phoneNumber as String, "imageData":Idata ?? ""] as [String : Any];
                        
                        self.contactsArray.append((contacts as AnyObject) as! [String : AnyObject]);
                    // sort array in alphabetical order
                        self.contactsArray = self.contactsArray.sorted{ ($0["lname"] as? String)! < ($1["lname"] as? String)!;
                        }
                }
            }
        }
    }
    
    
    @objc class func getDataBase() -> Array<TBL_Contacts> {
        let fetchRequest = NSFetchRequest<TBL_Contacts>(entityName: "TBL_Contacts");
        let sortDescripter = NSSortDescriptor.init(key: "contact_selectedDate", ascending: false);
        fetchRequest.sortDescriptors = [sortDescripter];
        return try! context.fetch(fetchRequest);
    }
}

extension String{
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let PHONE_REGEX = "^([+][9][1]|[9][1]|[0]){0,1}([7-9]{1})([0-9]{9})$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX);
        let result =  phoneTest.evaluate(with: self);
        return result;
    }
    
    // retriving DB data
    var isContainInDB : Bool{
        var number = self;
        if number.characters.count == 13 {
            number = number.substring(with: 3..<13
            )
        }else if number.characters.count == 12 {
            number = number.substring(with: 2..<12);
        }else if number.characters.count == 11 {
            number = number.substring(with: 1..<11);
        }
        let resultPredicate2 = NSPredicate(format: "contact_number ENDSWITH %@ || contact_number BEGINSWITH %@", number, number);
        
        let fetchRequest = NSFetchRequest<TBL_Contacts>(entityName: "TBL_Contacts");
        fetchRequest.predicate = resultPredicate2;
        let results = try! context.fetch(fetchRequest);
        if results.count > 0 {
            return true;
        }
        return false;
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound);
        let endIndex = index(from: r.upperBound);
        return substring(with: startIndex..<endIndex);
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from);
    }
    
    func dateToStringFunction(currentDate : Date) -> String {
        let simpleDateFormat : DateFormatter = DateFormatter();
        simpleDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        simpleDateFormat.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!;
        
        let dateFormat = DateFormatter();
        dateFormat.dateFormat = "MMM dd,yyyy";
        
        let timeFormat = DateFormatter();
        timeFormat.dateFormat = "hh:mm a";
        
        return dateFormat.string(from: currentDate) + " at " + timeFormat.string(from: currentDate);
    }
}

