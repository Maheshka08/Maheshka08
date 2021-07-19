//
//  TweakAndEatConstants.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 02/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation

struct TweakAndEatConstants {
    
    static let DATA : String = "Data"
    
    static let AGE_GROUP_NAME : String = "name"
    static let CALL_STATUS : String = "callStatus"
    
    static let STATIC_NAME : String = "static_name"
    static let STATIC_VALUE : String = "static_value"
    
    static let OTP_VALUE : String = "code"
    static let STORED_OTP_KEY : String = "OTP"
    
    static let BUILD_VALUE : String = "build_value"
    static let BUILD_KEY : String = "build_key"
    
    static let INTRO_TEXT : String = "INTRO_TEXT"
    static let DATA_TEXT : String =  "HOWTO_TEXT"
    static let TERMS_OF_USE : String =  "TERMS_OF_USE"
    static let PRIVACY : String =  "PRIVACY"
    static let GUIDE_LINES : String =  "GUIDE_LINES"
    static let TWEAK_STREAK : String =  "TWEAK_STREAK"
    static let TWEAK_TOTAL : String =  "TWEAK_TOTAL"
    
    
    static let TWEAK_STATUS_GOOD : String = "GOOD"
    
    static let BODYSHAPE_ID : String = "id"
    static let BODYSHAPE_NAME : String = "name"
    static let BODYSHAPE_GENDER : String = "gender"
    static let BODYSHAPE_IMAGE : String = "imgurl"
    
    static let GENDER_MALE : String = "M"
    static let GENDER_FEMALE : String = "F"
    
    static let WOMEN_IMAGE_TOP : String = "Woman Top"
    static let WOMEN_IMAGE_FULL : String = "Woman Full"
    static let WOMEN_IMAGE_BOTTOM : String = "Woman Bottom"
    
    static let MEN_IMAGE_TOP : String = "Man Top"
    static let MEN_IMAGE_FULL : String = "Man Full"
    static let MEN_IMAGE_BOTTOM : String = "Man Bottom"
    
    static let TWEAKS : String = "tweaks"
    static let VERSION : String = "version"
    static let LATEST_BUILD : String = "latest_build"
    static let TAE_APP_ID_FOR_ADS = "S7ZyF2gDMzeTawV9fctm8kpHxQrJBX3sEYq4UGWj6dNPRnKCuh"
    
}

struct Handle_Notifications_Constants {
    static let NOTIFY : String = "notify"
    static let WALL_NOTIFY: String = "wall_notify"
    static let CHAT_NOTIFY: String = "chat_notify"
    static let TWEAK_NOTIFY: String = "tweak_notify"
}

struct TBL_TweakConstants {
    static let TWEAK_ID : String = "tweak_id"
    
    static let TWEAK_IMAGE_URL : String = "tweak_image_url"
    static let TWEAK_MODIFIED_IMAGE_URL : String = "tweak_modified_image_url"
    static let TWEAK_TEXT : String = "tweak_suggested_text"
    static let TWEAK_STATUS : String = "tweak_status"
    static let TWEAK_RATING : String = "tweak_rating"
    static let TWEAK_LATITUDE : String = "tweak_latitude"
    static let TWEAK_LONGITUDE : String = "tweak_longitude"
    static let TWEAK_USER_COMMENTS: String = "tweak_usr_comments"
    static let TWEAK_AUDIO_MSG : String = "tweak_audio_message"
    static let MEAL_TYPE: String = "tweak_meal_type"
    static let TWEAK_CORRECT_DATE : String = "tweak_crt_dttm"
    static let TWEAK_UPDATED_DATE : String = "tweak_upd_dttm"
    static let CALORIES: String = "tweak_cl_calories"
    static let CARBS: String = "tweak_cl_carbs"
    static let FATS: String = "tweak_cl_fats"
    static let PROTEIN: String = "tweak_cl_protein"
}

struct TBL_ReminderConstants {
    static let REMINDER_TYPE_TWEAK : String = "1"
    static let REMINDER_TYPE_DAILYTIP : String = "2"
    
    static let REMINDER_ID : String = "rmdr_id"
    static let REMINDER_STATUS : String = "rmdr_status"
    static let REMINDER_SORT : String = "rmdr_sort"
    static let REMINDER_TYPE : String = "rmdr_type"
    static let REMINDER_NAME : String = "rmdr_name"
    static let REMINDER_TIME : String = "rmdr_time"
    
    static let REMINDER_STATUS_ENABLED : String = "Y"
    static let REMINDER_STATUS_DISABLED : String = "N"
}

struct TBL_DailyTipConstants {
    static let TIP_ID : String = "pkg_id"
    static let EVENT_ID : String = "pkg_evt_id"
    static let TIP_MESSAGE : String = "pkg_evt_message"
    
    static let TIP_STATUS : String = "tip_status"
    static let STATUS_SHOWN : Bool = true
    static let STATUS_NOTSHOWN : Bool = false
}

struct TBL_ContactConstants {
    static let CONTACT_NAME : String = "contact_name"
    static let CONTACT_NUMBER : String = "contact_number"
    static let CONTACT_PROFILE_PIC : String = "contact_profile_pic"
    static let CONTACT_SELECTED_DATE : String = "contact_selected_date"
}

struct TweakAndEatColorConstants {
    
    static let AppDefaultColor : UIColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0)
    
}

struct FitBitDetails {
    
   static let clientID = "22CMY8"
   static let clientSecret = "a170437952d51518880fb9ac32d8c823"
}


