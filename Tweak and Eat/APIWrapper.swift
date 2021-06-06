//
//  APIWrapper.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 02/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire

class APIWrapper: AFHTTPSessionManager {
    
    @objc class var sharedInstance: APIWrapper {
        struct Static {
            static let instance = APIWrapper()
        }
        return Static.instance
    }
    
    @objc func getStaticText(lang: String, _ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
       self.getRequest(TweakAndEatURLConstants.STATIC_TEXT + lang, success: successBlock, failure: failureBlock)
    }
    
    @objc func getAgeGroups(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.AGE_GROUPS, success: successBlock, failure: failureBlock)
        
    }
    //getTimeSlots
    @objc func getTimeSlots(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.GET_ALL_TIMESLOTS, success: successBlock, failure: failureBlock)
        
    }
    
    @objc func getJSON(url: String,_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
           self.getRequest(url, success: successBlock, failure: failureBlock)
           
       }
    @objc func getDifferencesForUSA(type: String, _ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(String(format: TweakAndEatURLConstants.GET_DIFFERENCES_BY_CODE_USA,type), success: successBlock, failure: failureBlock)
        
    }
    @objc func getFoodHabits(countryCode: String,_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.FOOD_HABITS + countryCode, success: successBlock, failure: failureBlock)
        
    }

    @objc func getAllergies(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.ALLERGIES, success: successBlock, failure: failureBlock)
        
    }
    
    @objc func getRandomTitBitMessage(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.RANDOM_TITBIT_MESSAGE, success: successBlock, failure: failureBlock)
        
    }
    
    @objc func getConditions(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.CONDITIONS, success: successBlock, failure: failureBlock)
        
    }
    @objc func getBodyShapes(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.BODY_SHAPES, success: successBlock, failure: failureBlock)
    }
    
    @objc func getReminders(type : String,_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(String(format: TweakAndEatURLConstants.REMINDERS,type), success: successBlock, failure: failureBlock)
        
    }
    
    @objc func getAllOtherCountryCodes(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))){
        self.getRequest(TweakAndEatURLConstants.ALLOTHERCOUNTRYISDS, success: successBlock, failure: failureBlock)
    }
    
    @objc func getAllCountryCodes(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))){
        self.getRequest(TweakAndEatURLConstants.ALLCOUNTRYISDS, success: successBlock, failure: failureBlock)
    }
    
    
    @objc func getMealTypes(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))){
        self.getRequest(TweakAndEatURLConstants.MEAL_TYPES, success: successBlock, failure: failureBlock)
    }
    
    @objc func getCountryCodes(country: String, _ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))){
        self.getRequest(TweakAndEatURLConstants.GETCOUNTRYISD + country, success: successBlock, failure: failureBlock)
    }
    
    
    @objc func getPackageDetails(packageId: String, _ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))){
        self.getRequest(TweakAndEatURLConstants.GETPACKAGEDETAILSBYID + packageId, success: successBlock, failure: failureBlock)
    }
    

    
    @objc func login(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_LOGIN, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }
    
    @objc func getRegistrationCode(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_REGISTRATION_CODE, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }

    @objc func registerNewUser(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_REGISTRATION, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }
    
    @objc func getTimelines(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.TIMELINES, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    @objc func getIdealPlateStaticText(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.STATIC_TEXT_IDEAL_PLATE, userSession: sessionString, success: successBlock, failure: failureBlock)
    }

    
    @objc func getPremiumPackages(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.GET_PREMIUM_PACKAGES, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
//    @objc func getTimeSlots(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
//        self.postRequestWithHeaders(TweakAndEatURLConstants.GET_ALL_TIMESLOTS, userSession: sessionString, success: successBlock, failure: failureBlock)
//    }

    
    @objc func getPremiumPackages2(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.GET_PREMIUM_PACKAGES_BY_COUNTRY, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    @objc func getPremiumPackages5(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.GET_PREMIUM_PACKAGES_BY_COUNTRY5, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    @objc func updateFitnessData(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    @objc func getFitnessData(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.GET_FITNESS_DATA, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    @objc func updatedRatings(sessionString : String,_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.UPDATE_TWEAK_RATING, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
   
    @objc func sendGCM(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(TweakAndEatURLConstants.SEND_GCM, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func sendFBToken(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(TweakAndEatURLConstants.SEND_FBTOKEN, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func homePromoClick(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.HOME_PROMO_CLICK, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func push_Wall_Notification(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.put(TweakAndEatURLConstants.WALL_PUSH_NOTIFICATIONS, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
    }

    @objc func getDailyTips(count : Int,_ parameters : NSDictionary, sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(String(format: TweakAndEatURLConstants.DAILYTIPS,count), userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    @objc func postRemoveExistingFriends(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject)->(Void)), failureBlock : @escaping ((NSError)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.REMOVE_EXISTING_FRIEND, parametersDic: parameters, success: successBlock as! ((AnyObject!) -> (Void)), failure: failureBlock as! ((NSError!) -> (Void)))
    }
    
    @objc func invitedFriends(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject)->(Void)), failureBlock : @escaping ((NSError)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.INVITED_EXISTING_FRIEND, success: successBlock as! ((AnyObject!) -> (Void)), failure: failureBlock as! ((NSError!) -> (Void)))
    }
    
    @objc func updateRatingForTweak(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.UPDATE_TWEAK_RATING, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    
    @objc func razorPayApi(_ parameters : [String: AnyObject],userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.RAZORPAY_START_SUB_IND, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }

    
    @objc func packageRegistration(sessionString : String,_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")

        self.post(TweakAndEatURLConstants.PACKAGEREGISTRATION, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func purchaseLabels(sessionString : String,_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.PURCHASE_LABELS, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func labelDetails(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.LABEL_DETAILS, parameters: nil,  success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func labelTransactions(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.LABEL_TRANSACTIONS, parameters: nil,  success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    @objc func labelPerc(userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.LABEL_PERC, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    @objc func getTweakLabels(userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.GET_TWEAK_LABELS, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    
    
    
    @objc func userPremiumPackages(sessionString : String,_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.USERPREMIUMPACKS, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }


    @objc func tweakImage(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.IMAGE_TO_TWEAK, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
    
    }
    
    @objc func buzzFriends(userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.BUZZ_FRIENDS, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }

    
    @objc func imageToTweak(_ url: String, parameters : NSDictionary, userSession : String, successBlock : @escaping ((URLSessionDataTask?, Any?)->(Void)), failureBlock : @escaping ((URLSessionDataTask?,Error?)->(Void))) {
        self.post(url, parameters: parameters, success: successBlock, failure: failureBlock)
    }
    
    @objc func getRequest(_ url : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        
        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    @objc func getGoals(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.GOALS_BY_LANG, success: successBlock, failure: failureBlock)
        
    }
    
    @objc func getRequest(_ url : String,sessionString : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")

        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    @objc func getRequestWithHeader(sessionString : String,_ url : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")

        
        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }

    @objc func postRequest(_ url : String, parametersDic : NSDictionary, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        
        self.post(url, parameters: parametersDic, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    @objc func postReceiptData(_ url : String,userSession : String, params: [String: AnyObject], success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(url, parameters: params, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    @objc func postRequestWithHeaders(_ url : String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
       // if userSession != "" {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
       // }
        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    @objc func postRequestWithHeadersForUSAAiDPContent(_ url : String, status: String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        self.requestSerializer.setValue(status, forHTTPHeaderField: "status")

        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    @objc func postRequestWithHeadersForIndiaAiDPContent(_ url : String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    @objc func postFitBitRevokeRequest(_ url : String,base64 : String, parameters: NSDictionary, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        self.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    @objc func putRequestWithHeaders(_ url : String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    
    @objc func postTogetInstaToken(_ url : String, parameters : [String : AnyObject], success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
      
        self.post(url, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    func getMethodAlamofire<T: Codable>(url: String, parameters: [String : AnyObject]?, headers: HTTPHeaders?, _ completion: @escaping (Result<T, AFError>)->Void) {
        AF.request(URL(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                completion(response.result)
            }
    }
    
    @objc func postRequestWithHeaderMethod(_ url : String, userSession : String, parameters : [String : AnyObject], success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(url, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    @objc func postRequestWithHeaderMethodWithOutParameters(_ url : String, userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    @objc func putRequest(_ url : String, userSession : String, parameters : [String : AnyObject], success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(url, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
   
    // for image upload to server
    @objc func postRequestWithHeaderForPicUpdate(_ url : String, userSession : String, parameters : [String : AnyObject],imageData : Data, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((Error!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        self.post(url, parameters: parameters, constructingBodyWith: { formData in
            formData?.appendPart(withFileData: imageData, name: "UserSession", fileName: "TweakAndEat", mimeType: "image/png")
            
        }, success: { urlSessionData, response in
            print(response ?? [:])
            success(response as AnyObject!)
        }, failure: {urlSessionData, error in
            failure(error)
        })
    }
}

