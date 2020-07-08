//
//  TBL_Tweaks+CoreDataProperties.swift
//  Tweak and Eat
//
//  Created by admin on 24/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation
import CoreData


extension TBL_Tweaks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TBL_Tweaks> {
        return NSFetchRequest<TBL_Tweaks>(entityName: "TBL_Tweaks");
    }

    @NSManaged public var tweakAudioMessage: String?
    @NSManaged public var tweakDateCreated: String?
    @NSManaged public var tweakDateUpdated: String?
    @NSManaged public var tweakId: Int64
    @NSManaged public var tweakLatitude: Double
    @NSManaged public var tweakLongitude: Double
    @NSManaged public var tweakModifiedImageURL: String?
    @NSManaged public var tweakOriginalImageURL: String?
    @NSManaged public var tweakRating: Float
    @NSManaged public var tweakStatus: Int64
    @NSManaged public var tweakSuggestedText: String?
    @NSManaged public var tweakUserComments: String?

}
