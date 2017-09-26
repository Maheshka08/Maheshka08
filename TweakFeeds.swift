//
//  TweakFeeds.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/25/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation

class TweakFeedsModel {
    var awesomeCount : String?
    var awesomeMemNickName : String?
    var awesomeMemPostedOn : String?
    var awesomeMemCommentText : String?
    var commentNickName : String?
    var commentPostedOn : String?
    var feedContent : String?
    var imageUrl : String?
    var postedOn : String?
    var tweakOwner : String?
    
    init(awesomeCount: String?,awesomeMemNickName: String?,awesomeMemPostedOn: String?,awesomeMemCommentText: String?,commentNickName: String?,commentPostedOn: String?,feedContent: String?,imageUrl: String?,postedOn: String?,tweakOwner: String?) {
        
        self.awesomeCount = awesomeCount
        self.awesomeMemNickName = awesomeMemNickName
        self.awesomeMemPostedOn = awesomeMemPostedOn
        self.awesomeMemCommentText = awesomeMemCommentText
        self.commentNickName = commentNickName
        self.commentPostedOn = commentPostedOn
        self.feedContent = feedContent
        self.imageUrl = imageUrl
        self.postedOn = postedOn
        self.tweakOwner = tweakOwner
    }
}
