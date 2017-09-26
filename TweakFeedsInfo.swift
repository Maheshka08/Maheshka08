//
//  TweakFeedsInfo.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 27/07/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TweakFeedsInfo: Object {
    dynamic var snapShot = ""
    dynamic var feedContent =  ""
    dynamic var gender =  ""
    dynamic var imageUrl =  ""
    dynamic var msisdn =  ""
    dynamic var postedOn =  ""
    dynamic var awesomeCount =  0
    dynamic var commentsCount =  0
    dynamic var tweakOwner =  ""
    dynamic var timeIn = NSDate()
    let awesomeMembers = List<AwesomeMembers>()
    let comments = List<CommentsMembers>()
    
    
    override static func primaryKey() -> String? {
        return "postedOn";
    }
    
}

class AwesomeMembers: Object {
    dynamic var aweSomeNickName = ""
    dynamic var aweSomePostedOn = ""
    dynamic var aweSomeMsisdn = ""
    dynamic var youLiked = "false"
}

class CommentsMembers: Object {
    dynamic var commentsNickName = ""
    dynamic var commentsPostedOn = ""
    dynamic var commentsMsisdn = ""
    dynamic var commentsCommentText = ""
    dynamic var commentsTimeIn = NSDate()

}
