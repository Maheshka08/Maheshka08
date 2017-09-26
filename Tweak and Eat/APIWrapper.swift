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

class APIWrapper: AFHTTPSessionManager {
    
    class var sharedInstance: APIWrapper {
        struct Static {
            static let instance = APIWrapper()
        }
        return Static.instance
    }
    
    func getStaticText(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
       self.getRequest(TweakAndEatURLConstants.STATIC_TEXT, success: successBlock, failure: failureBlock)
    }
    
    func getAgeGroups(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.AGE_GROUPS, success: successBlock, failure: failureBlock)
        
    }
    
    func getFoodHabits(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.FOOD_HABITS, success: successBlock, failure: failureBlock)
        
    }

    func getAllergies(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.ALLERGIES, success: successBlock, failure: failureBlock)
        
    }
    
    func getRandomTitBitMessage(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.RANDOM_TITBIT_MESSAGE, success: successBlock, failure: failureBlock)
        
    }
    
    func getConditions(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.CONDITIONS, success: successBlock, failure: failureBlock)
        
    }
    func getBodyShapes(_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.BODY_SHAPES, success: successBlock, failure: failureBlock)
    }
    
    func getReminders(type : String,_ successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.getRequest(String(format: TweakAndEatURLConstants.REMINDERS,type), success: successBlock, failure: failureBlock)
    }
    
    func login(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_LOGIN, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }
    
    func getRegistrationCode(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_REGISTRATION_CODE, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }

    func registerNewUser(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.USER_REGISTRATION, parametersDic:  parameters, success: successBlock, failure: failureBlock)
    }
    
    func getTimelines(sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.TIMELINES, userSession: sessionString, success: successBlock, failure: failureBlock)
    }

    
    func updatedRatings(sessionString : String,_ parameters : NSDictionary, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(TweakAndEatURLConstants.UPDATE_TWEAK_RATING, userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    

    func sendGCM(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(TweakAndEatURLConstants.SEND_GCM, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }

  
    func getDailyTips(count : Int,_ parameters : NSDictionary, sessionString : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        self.postRequestWithHeaders(String(format: TweakAndEatURLConstants.DAILYTIPS,count), userSession: sessionString, success: successBlock, failure: failureBlock)
    }
    
    func postRemoveExistingFriends(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject)->(Void)), failureBlock : @escaping ((NSError)->(Void))) {
        self.postRequest(TweakAndEatURLConstants.REMOVE_EXISTING_FRIEND, parametersDic: parameters, success: successBlock as! ((AnyObject!) -> (Void)), failure: failureBlock as! ((NSError!) -> (Void)))
    }
    
    func invitedFriends(_ parameters : NSDictionary, successBlock : @escaping ((AnyObject)->(Void)), failureBlock : @escaping ((NSError)->(Void))) {
        self.getRequest(TweakAndEatURLConstants.INVITED_EXISTING_FRIEND, success: successBlock as! ((AnyObject!) -> (Void)), failure: failureBlock as! ((NSError!) -> (Void)))
    }
    func updateRatingForTweak(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.UPDATE_TWEAK_RATING, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    func tweakImage(_ parameters : NSDictionary,userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.IMAGE_TO_TWEAK, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
    
    }
    func buzzFriends(userSession : String, successBlock : @escaping ((AnyObject!)->(Void)), failureBlock : @escaping ((NSError!)->(Void))) {
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(TweakAndEatURLConstants.BUZZ_FRIENDS, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            successBlock(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failureBlock(error as NSError!)
        }
        
    }
    func imageToTweak(_ url: String, parameters : NSDictionary, userSession : String, successBlock : @escaping ((URLSessionDataTask?, Any?)->(Void)), failureBlock : @escaping ((URLSessionDataTask?,Error?)->(Void))) {
        self.post(url, parameters: parameters, success: successBlock, failure: failureBlock)
    }
    
    func getRequest(_ url : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        
        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    func getRequest(_ url : String,sessionString : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")

        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    func getRequestWithHeader(sessionString : String,_ url : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(sessionString, forHTTPHeaderField: "Authorization")

        
        self.get(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }

    func postRequest(_ url : String, parametersDic : NSDictionary, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        
        self.post(url, parameters: parametersDic, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    func postRequestWithHeaders(_ url : String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    func putRequestWithHeaders(_ url : String,userSession : String, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.put(url, parameters: nil, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
    
    func postRequestWithHeaderMethod(_ url : String, userSession : String, parameters : [String : AnyObject], success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((NSError!)->(Void))) {
        self.requestSerializer = AFJSONRequestSerializer()
        self.requestSerializer.setValue(userSession, forHTTPHeaderField: "Authorization")
        
        self.post(url, parameters: parameters, success: { (dataTask : URLSessionDataTask?, object : Any?) in
            success(object as AnyObject)
        }) { (dataTask : URLSessionDataTask?, error : Error?) in
            failure(error as NSError!)
        }
    }
   
    // for image upload to server
    func postRequestWithHeaderForPicUpdate(_ url : String, userSession : String, parameters : [String : AnyObject],imageData : Data, success : @escaping ((AnyObject!)->(Void)), failure : @escaping ((Error!)->(Void))) {
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



