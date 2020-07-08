//
//  TBL_Contacts+CoreDataProperties.swift
//  Tweak and Eat
//
//  Created by admin on 24/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation
import CoreData


extension TBL_Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TBL_Contacts> {
        return NSFetchRequest<TBL_Contacts>(entityName: "TBL_Contacts");
    }

    @NSManaged public var contact_number: String?
    @NSManaged public var contact_profilePic: NSData?
    @NSManaged public var contact_selectedDate: NSDate?
    @NSManaged public var contact_name: String?

}
