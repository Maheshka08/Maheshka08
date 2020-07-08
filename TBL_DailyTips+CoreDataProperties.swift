//
//  TBL_DailyTips+CoreDataProperties.swift
//  Tweak and Eat
//
//  Created by admin on 24/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation
import CoreData


extension TBL_DailyTips {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TBL_DailyTips> {
        return NSFetchRequest<TBL_DailyTips>(entityName: "TBL_DailyTips");
    }

    @NSManaged public var eventId: Int64
    @NSManaged public var status: Bool
    @NSManaged public var tipId: Int64
    @NSManaged public var tipMessage: String?

}
