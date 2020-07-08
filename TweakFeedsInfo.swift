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
    @objc dynamic var snapShot = ""
    @objc dynamic var feedContent =  ""
    @objc dynamic var gender =  ""
    @objc dynamic var imageUrl =  ""
    @objc dynamic var msisdn =  ""
    @objc dynamic var postedOn =  ""
    @objc dynamic var awesomeCount =  0
    @objc dynamic var commentsCount =  0
    @objc dynamic var tweakOwner =  ""
    @objc dynamic var timeIn = NSDate()
    let awesomeMembers = List<AwesomeMembers>()
    let comments = List<CommentsMembers>()
    
    override static func primaryKey() -> String? {
        return "postedOn";
    }
    
}

class AwesomeMembers: Object {
    @objc dynamic var aweSomeNickName = ""
    @objc dynamic var aweSomePostedOn = ""
    @objc dynamic var aweSomeMsisdn = ""
    @objc dynamic var youLiked = "false"
    @objc dynamic var awesomeSnapShot = ""
}

class CommentsMembers: Object {
    @objc dynamic var commentsNickName = ""
    @objc dynamic var commentsPostedOn = ""
    @objc dynamic var commentsMsisdn = ""
    @objc dynamic var commentsCommentText = ""
    @objc dynamic var commentsTimeIn = NSDate()

}
