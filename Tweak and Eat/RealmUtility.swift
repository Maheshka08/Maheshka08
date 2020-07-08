//
//  RealmUtility.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/19/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

let realm :Realm = try! Realm()

// Save any object to realm db
func saveToRealm(objToSave: Any) {
    do {
        try realm.write { () -> Void in
            realm.add(objToSave as! Object);
        }
    } catch {
        print("Error in SaveToRealm");
    }
}

// Save any object to realm db
func saveToRealmOverwrite(objType: Any, objValues: Any) {
    do {
        try realm.write { () -> Void in
            realm.create(objType as! Object.Type, value: objValues, update: true);
        }
    } catch {
        print("Error in SaveToRealmOverwrite");
    }
}

// delete realm object

func deleteRealmObj(objToDelete: Any) {
    do {
        try realm.write { () -> Void in
            realm.delete(objToDelete as! Object)
        }
    } catch {
        print("Error in deleteToRealm");
    }
}

