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
    static let AD_URL = "http://45.114.141.5:3047/api"
    static let STATIC_TEXT : String  = BASE_URL + "/api/master/statictextbylang/";
    static let AGE_GROUPS : String   = BASE_URL + "/api/master/agegroups";
    static let BODY_SHAPES : String  = BASE_URL + "/api/master/bodyshapes";
    static let ALLERGIES : String = BASE_URL + "/api/master/allergies"
    static let CONDITIONS : String = BASE_URL + "/api/master/conditions2"
    static let REMINDERS : String    = BASE_URL + "/api/master/reminders/%@";
    static let USER_LOGIN : String   = BASE_URL + "/api/user/login";
    static let USER_REGISTRATION : String     = BASE_URL + "/api/user/register";
    static let USER_REGISTRATION_CODE : String  = BASE_URL + "/api/user/registrationcode2";
    static let ALLCOUNTRYISDS : String  = BASE_URL + "/api/master/getallcountryisds";
    static let ALLOTHERCOUNTRYISDS : String  = BASE_URL + "/api/master/getallcountryisdsothers";
    
    static let GETPACKAGEDETAILSBYID : String  = BASE_URL + "/api/master/getpackagedetailsbyid/"


    static let GETCOUNTRYISD : String  = BASE_URL + "/api/master/getcountryisd/";
    static let INSTATOKEN : String = BASE_URL + "/api/payments/instatoken"
    static let PACKAGEREGISTRATION : String = BASE_URL  + "/api/payments/packageregistration"
    static let USERPREMIUMPACKS : String = BASE_URL  + "/api/payments/userpremiumpacks"
    static let FIREBASE_TOPIC_NAME : String = BASE_URL  + "/api/user/firebase/gettopics"
    static let STATIC_TEXT_IDEAL_PLATE : String = BASE_URL + "/api/user/statictextbycode/IDEAL_PLATE_TEXT"

    static let RANDOM_TITBIT_MESSAGE : String = BASE_URL + "/api/master/titbit";
    static let TIMELINES : String    = BASE_URL + "/api/user/timeline";
    static let UPDATE_TWEAK_RATING : String    = BASE_URL + "/api/user/updatetweakrating";
    //foodhabits
    static let FOOD_HABITS : String = BASE_URL + "/api/master/foodhabitsbycountry/";
    static let USER_HOMEPAGE : String = BASE_URL + "/api/user/homeimage";
    static let CHECKTWEAKABLE : String = BASE_URL + "/api/user/tweakable";
    static let TWEAKSTREAK : String = BASE_URL + "/api/user/tweakstreak";
    static let PROFILEFACTS : String = BASE_URL + "/api/user/profilefacts";
    static let UPDATEPROFILE : String = BASE_URL + "/api/user/updateprofile";
    static let HOMEINFO : String = BASE_URL + "/api/user/homeinfo2";
    static let DAILYTIPS : String  = BASE_URL + "/api/user/didyouknow";
    static let REMOVE_EXISTING_FRIEND : String   = BASE_URL + "/api/user/removeexistingfriend";
    static let INVITE_NEW_FRIENDS : String   = BASE_URL + "/api/user/invitenewfriends";
    static let INVITED_EXISTING_FRIEND : String  = BASE_URL + "/api/user/invitedfriends";
    static let GROUP_NAME : String =  BASE_URL + "/api/user/fulfillment/pushnotification";
    static let AiDP_CONTENT : String = BASE_URL + "/api/payments/aidpcontent";
    
    static let USA_AiDP_CONTENT : String = BASE_URL + "/api/payments/aidpcontentusa";
    static let MYS_AiDP_CONTENT : String = BASE_URL + "/api/payments/aidpcontentmys";
    static let IND_AiDP_CONTENT : String = BASE_URL + "/api/payments/myaidpcontentind";
    static let ALL_AiBP_CONTENT : String = BASE_URL + "/api/payments/myaibpcontentallcountries"
    
    //api/master/mealtypestweakable
    static let MEAL_TYPES : String = BASE_URL + "/api/master/mealtypestweakable";

    //api/payments/aidpcontentusa
    
    static let UPDATE_FITNESS_DATA : String =  BASE_URL + "/api/user/fitness/enternewdata";
    static let GET_FITNESS_DATA : String =  BASE_URL + "/api/user/fitness/getuserdata";
    
    static let IMAGE_TO_TWEAK : String = BASE_URL + "/api/user/imagetotweak";
    static let NEW_IMAGE_TO_TWEAK : String  = BASE_URL + "/api/user/imagetotweaktest";
    static let BUZZ_FRIENDS : String  = BASE_URL + "/api/user/buzzsos";
    static let SEND_GCM : String    = BASE_URL + "/api/user/gcmid";
    static let SEND_FBTOKEN : String    = BASE_URL + "/api/user/fbtoken";
    static let WALL_PUSH_NOTIFICATIONS : String    = BASE_URL + "/api/user/wall/pushawesomecomment2";
    static let ENDPOINT_NUTRITION_FBUID = BASE_URL + "/api/user/chat/nutritionistinfo"
    static let ENDPOINT_SERVE_AD = AD_URL + "/servead";
    static let ENDPOINT_CLICK_AD = AD_URL + "/clickad?";
    
    //GetPremiumPackages
    
    static let GET_PREMIUM_PACKAGES : String = BASE_URL + "/api/user/getpremiumpackages";
    
    //Chat PushNotification
    
    static let CHAT_PUSH_NOTIFICATION : String = BASE_URL + "/api/user/chat/pushnotification"
    static let CHAT_MESSAGE_TO_NUTRTIONIST : String = BASE_URL + "/api/pushnotification/tonutritionist"
    //FitBit
    
    static let FITBIT_DEVICE = "https://api.fitbit.com/1/user/-/devices.json"
    static let PURCHASE_LABELS : String = BASE_URL + "/api/payments/labelspurchase"
    static let LABEL_DETAILS : String = BASE_URL + "/api/user/labeldetails"
    static let LABEL_TRANSACTIONS : String = BASE_URL + "/api/user/labeltransactions"
    static let GET_HOME_PROMO : String = BASE_URL + "/api/user/gethomepromo"
    static let HOME_PROMO_CLICK : String = BASE_URL + "/api/user/gethomepromoclick"
    static let LABEL_PERC = BASE_URL + "/api/user/labelsrecentten"
    static let GET_DIFFERENCES_BY_CODE_USA = BASE_URL + "/api/master/diffsbycode/%@"
    static let GOALS_BY_LANG = BASE_URL + "/api/master/goalsbylang/EN"
    static let STRIPE_PAYMENT_FOR_USA = BASE_URL + "/api/payments/mytaeusa"
    static let STRIPE_PAYMENT_FOR_MYS = BASE_URL + "/api/payments/mytaemys"
    static let SEND_NOTIFY_TO_NUTRITIONIST = BASE_URL + "/api/user/sentnotitonutritionist"
    static let UNSUBSCRIBE_USA = BASE_URL + "/api/payments/mytaeunsubusa"
    static let UNSUBSCRIBE_MYS = BASE_URL + "/api/payments/mytaeunsubmys"
    static let UNSUBSCRIBE_IND = BASE_URL + "/api/payments/mytaeunsubind"

    
    static let RAZORPAY_START_SUB_IND = BASE_URL + "/api/payments/rpaystartsubind"
    
    static let GET_PREMIUM_PACKAGES2 = BASE_URL + "/api/user/getpremiumpackages2"
    
    static let MY_TANDE_SUB = BASE_URL + "/api/payments/packagemytaeregistration"
    //api/user/mytaepkgdetailsind
    
    static let MY_TANDE_PKG_DETAILS = BASE_URL + "/api/user/mytaepkgdetailsind"

    static let IAP_INDIA_SUBSCRIBE = BASE_URL + "/api/payments/mytaeindaplpaysubscribe"
    static let SGN_AiDP_CONTENT = BASE_URL + "/api/payments/myaidpcontentsgn"
    static let IDN_AiDP_CONTENT = BASE_URL + "/api/payments/myaidpcontentidn"
    static let AIBP_REGISTRATION = BASE_URL + "/api/payments/indsubregistration"
    static let HOMERECIPES = BASE_URL + "/api/user/homerecipes"
    static let GET_PREMIUM_PACKAGES_BY_COUNTRY = BASE_URL + "/api/user/getpremiumpackagesbycountry4"
    static  let GET_TWEAK_LABELS = BASE_URL + "/api/user/tweaklabels"
    static let GET_ALL_TIMESLOTS = BASE_URL + "/api/callschedules/getalltimeslots"
    static let CHECK_USER_SCHEDULE = BASE_URL + "/api/callschedules/checkuserschedule"
    static let SCHEDULE_USER_CALL = BASE_URL + "/api/callschedules/scheduleusercall"
    static let CHECK_APP_VERSION = BASE_URL + "/api/master/appversion"
    static let CALL_SCHEDULE_LANGUAGES = BASE_URL + "/api/master/callschlangs"
    static let CLUB_HOME1 = BASE_URL + "/api/content/clubhome1"
    static let CLUB_HOME2 = BASE_URL + "/api/content/clubhome2"
    static let CLUB_HOME3 = BASE_URL + "/api/content/clubhome3"
    static let CLUB_SUB1 = BASE_URL + "/api/content/clubsub1"
    static let CLUB_SUB2 = BASE_URL + "/api/content/clubsub2"
    static let CLUB_SUB3 = BASE_URL + "/api/content/clubsub3"
    static let CLUB_SUB4 = BASE_URL + "/api/content/clubsub4"
    static let CLUB_LANDING = BASE_URL + "/api/content/clublanding"
    static let CHECK_CLUB_MEMBER_SCHEDULE = BASE_URL + "/api/callschedules/checkclubmemberschedule"
    static let SCHEDULE_CLUB_MEMBER_CALL = BASE_URL + "/api/callschedules/scheduleclubmembercall"
    static let SAVE_FEEDBACK = BASE_URL + "/api/user/savefeedback"
    static let INTRO_SLIDE1 = BASE_URL + "/api/content/introslide1"
    static let INTRO_SLIDE2 = BASE_URL + "/api/content/introslide2"
    
    
    
}

