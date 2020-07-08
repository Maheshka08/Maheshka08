//
//  DB.swift
//  RealmSwift
//
//  Created by Riccardo Rizzo on 12/07/17.
//  Copyright © 2017 Riccardo Rizzo. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    var realm:Realm
    static let sharedInstance = DBManager()
    
    init() {
        
        realm = try! Realm()
        
    }
}
