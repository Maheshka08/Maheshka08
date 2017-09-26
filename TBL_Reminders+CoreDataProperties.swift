//
//  TBL_Reminders+CoreDataProperties.swift
//  Tweak and Eat
//
//  Created by admin on 24/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation
import CoreData


extension TBL_Reminders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TBL_Reminders> {
        return NSFetchRequest<TBL_Reminders>(entityName: "TBL_Reminders");
    }

    @NSManaged public var rmdrId: Int64
    @NSManaged public var rmdrName: String?
    @NSManaged public var rmdrStatus: String?
    @NSManaged public var rmdrTime: String?
    @NSManaged public var rmdrType: Int64

}
