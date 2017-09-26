//
//  TweakAndEatURLConstants.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 02/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation

struct TweakAndEatURLConstants {

    static let BASE_URL : String  = "https://www.tweakandeat.com:5009";
    static let STATIC_TEXT : String  = BASE_URL + "/api/master/statictext";
    static let AGE_GROUPS : String   = BASE_URL + "/api/master/agegroups";
    static let BODY_SHAPES : String  = BASE_URL + "/api/master/bodyshapes";
    static let ALLERGIES : String = BASE_URL + "/api/master/allergies"
    static let CONDITIONS : String = BASE_URL + "/api/master/conditions"
    static let REMINDERS : String    = BASE_URL + "/api/master/reminders/%@";
    static let USER_LOGIN : String   = BASE_URL + "/api/user/login";
    static let USER_REGISTRATION : String     = BASE_URL + "/api/user/register";
    static let USER_REGISTRATION_CODE : String  = BASE_URL + "/api/user/registrationcode";
    static let RANDOM_TITBIT_MESSAGE : String = BASE_URL + "/api/master/titbit";
    static let TIMELINES : String    = BASE_URL + "/api/user/timeline";
    static let UPDATE_TWEAK_RATING : String    = BASE_URL + "/api/user/updatetweakrating";
    //foodhabits
    static let FOOD_HABITS : String = BASE_URL + "/api/master/foodhabits";
    static let USER_HOMEPAGE : String = BASE_URL + "/api/user/homeimage";
    static let CHECKTWEAKABLE : String = BASE_URL + "/api/user/tweakable";
    static let TWEAKSTREAK : String = BASE_URL + "/api/user/tweakstreak";
    static let PROFILEFACTS : String = BASE_URL + "/api/user/profilefacts";
    static let UPDATEPROFILE : String = BASE_URL + "/api/user/updateprofile";
    static let HOMEINFO : String = BASE_URL + "/api/user/homeinfo";
    static let DAILYTIPS : String  = BASE_URL + "/api/user/didyouknow";
    static let REMOVE_EXISTING_FRIEND : String   = BASE_URL + "/api/user/removeexistingfriend";
    static let INVITE_NEW_FRIENDS : String   = BASE_URL + "/api/user/invitenewfriends";
    static let INVITED_EXISTING_FRIEND : String  = BASE_URL + "/api/user/invitedfriends";

    static let IMAGE_TO_TWEAK : String = BASE_URL + "/api/user/imagetotweak";
    static let NEW_IMAGE_TO_TWEAK : String  = BASE_URL + "/api/user/imagetotweaktest";
    static let BUZZ_FRIENDS : String  = BASE_URL + "/api/user/buzzsos";
    static let SEND_GCM : String    = BASE_URL + "/api/user/gcmid";
}

