//
//  HealthHelper.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 07/03/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import HealthKit
class HealthHelper: NSObject {
    @objc class var sharedInstance: HealthHelper {
        struct Singleton {
            static let instance = HealthHelper()
        }
        return Singleton.instance
    }
    
    //let healthStore = HKHealthStore()
    @objc let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
}
