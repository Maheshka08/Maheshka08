
import Foundation
import UIKit
import Firebase

class Message {
    
    //MARK: Properties
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    private var toID: String?
    private var fromID: String?
    
    //MARK: Methods
    class func downloadAllMessages(forUserID: String, tweakID: String, completion: @escaping (Message) -> Swift.Void) {
        let tweak_id = tweakID + "_id"
        if let currentUserID = Auth.auth().currentUser?.uid {
        let path = Database.database().reference().child("TweakChats").child(forUserID).child("userChats").child(currentUserID).child("tweaks").child(tweak_id);
        print(path)
        Database.database().reference().child("TweakChats").child(forUserID).child("userChats").child(currentUserID).child("tweaks").child(tweak_id).observe(.childAdded, with: { (snapshot) in
            
            if snapshot.exists() {
                    let receivedMessage = snapshot.value as! [String: Any]
                
                    let type = MessageType.text
                
                if let tweaks: [String:Any] = receivedMessage["tweaks"] as? [String : Any] {
                    let content = tweaks["message"] as! String
                    let fromID = tweaks["from"] as! Int
                    let timestamp = tweaks["postedOn"] as! Int
                    if fromID == 0 {
                        let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true)
                        completion(message)
                    } else {
                        let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                        completion(message)
                    }
                    
                    if tweaks["chatEnded"] is NSNull {
                        
                    } else {
                        if let chatEnded: Bool = tweaks["chatEnded"] as? Bool {
                            if chatEnded == true {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHAT_ENDED"), object: nil)
                            }
                        }
                    }
                } else {
                    let content = receivedMessage["message"] as! String
                    let fromID = receivedMessage["from"] as! Int
                    let timestamp = receivedMessage["postedOn"] as! Int
                    if fromID == 0 {
                        let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true)
                        completion(message)
                    } else {
                        let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                        completion(message)
                    }
                    
                    if receivedMessage["chatEnded"] is NSNull {
                        
                    } else {
                        if let chatEnded: Bool = receivedMessage["chatEnded"] as? Bool {
                            if chatEnded == true {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHAT_ENDED"), object: nil)
                            }
                        }
                        
                    }
                }
                
            }
        })
    }
}
    
    class func downloadAllMessages2(forUserID: String, chatID: String, completion: @escaping (Message) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
          
            Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(chatID).child("chats").observe(.childAdded, with: { (snapshot) in
                
                if snapshot.exists() {
                    let receivedMessage = snapshot.value as! [String: Any]
                    
                    let type = MessageType.text
                    let content = receivedMessage["message"] as! String
                        let fromID = receivedMessage["from"] as! Int
                        let timestamp = receivedMessage["postedOn"] as! Int
                        if fromID == 0 {
                            let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true)
                            completion(message)
                        } else {
                            let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                            completion(message)
                        }
                        
                        if receivedMessage["chatEnded"] is NSNull {
                            
                        } else {
                            if let chatEnded: Bool = receivedMessage["chatEnded"] as? Bool {
                                if chatEnded == true {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHAT_ENDED"), object: nil)
                                }
                            }
                            
                        }
                    
                    
                }
            })
        }
    }
    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.type == .photo {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }
    
    class func markMessagesRead(forUserID: String)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
                        if snap.exists() {
                            for item in snap.children {
                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
                                let fromID = receivedMessage["fromID"] as! String
                                if fromID != currentUserID {
                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    
    func downloadLastMessage(forLocation: String, completion: @escaping () -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        let receivedMessage = (snap as! DataSnapshot).value as! [String: Any]
                        self.content = receivedMessage["content"]!
                        self.timestamp = receivedMessage["timestamp"] as! Int
                        let messageType = receivedMessage["type"] as! String
                        let fromID = receivedMessage["fromID"] as! String
                        self.isRead = receivedMessage["isRead"] as! Bool
                        var type = MessageType.text
                        switch messageType {
                        case "text":
                            type = .text
                        case "photo":
                            type = .photo
                        case "location":
                            type = .location
                        default: break
                        }
                        self.type = type
                        if currentUserID == fromID {
                            self.owner = .receiver
                        } else {
                            self.owner = .sender
                        }
                        completion()
                    }
                }
            })
        }
    }
    
    class func send(message: Message, toID: String, isFirstMessage: Bool, tweakID: String, completion: @escaping (Bool) -> Swift.Void)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            switch message.type {
            case .location:
                print("")

            case .text:

                Message.uploadMessage(withValues: message.content as!  [String : Any], toID: toID, tweakID: tweakID, completion: { (status) in
                    completion(status)
                })
            case .photo:
                print(UUID().uuidString)
            }
        }
    }
    
    class func sendMessage(message: Message, toID: String, isFirstMessage: Bool, chatID: String, completion: @escaping (Bool) -> Swift.Void)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            switch message.type {
            case .location:
                print("")
                
            case .text:
                
                Message.upload(withValues: message.content as!  [String : Any], toID: toID, chatID: chatID, completion: { (status) in
                    completion(status)
                })
            case .photo:
                print(UUID().uuidString)
            }
        }
    }
    
    class func upload( withValues:  [String: Any], toID: String, chatID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
 Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(chatID).child("chats").childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
            if error == nil {
                completion(true)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIRST_MESSAGE"), object: nil)
                
                //api
                APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.CHAT_MESSAGE_TO_NUTRTIONIST, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["msg_type" : "CHAT_MESSAGE_TO_NUTRTIONIST", "nut_fb_id": toID] as [String: AnyObject], success: { response in
                    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                    let responseResult = responseDic["CallStatus"] as! String
                    if  responseResult == "GOOD" {
                        
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                    }
                }, failure: { error in
                    
                    //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline");
                    
                })
                
                
                
            } else {
                completion(false)
            }
        })
            
        }
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    class func uploadMessage( withValues:  [String: Any], toID: String, tweakID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            print(Database.database().reference().child("TweakChats").child(toID).child("userChats").child(currentUserID).child("tweaks").child(tweakID).childByAutoId());
            if withValues["profileDetails"] != nil  {
                
                Database.database().reference().child("TweakChats").child(toID).child("userChats").child(currentUserID).setValue(withValues["profileDetails"], withCompletionBlock: { (error, _) in
                if error == nil {
                    completion(true)
                    Database.database().reference().child("TweakChats").child(toID).child("userChats").child(currentUserID).child("tweaks").child(tweakID).childByAutoId().setValue(withValues["tweaks"], withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIRST_MESSAGE"), object: nil)
                            
                            //api
                            APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.CHAT_PUSH_NOTIFICATION, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["tweakId" : tweakID] as [String: AnyObject], success: { response in
                                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                                let responseResult = responseDic["callStatus"] as! String
                                if  responseResult == "GOOD" {
                                    
                                   
                                    DispatchQueue.main.async {
                                   
                                    }
                                    
                                }
                            }, failure: { error in
                                
                                //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline");
                                
                            })
                            
                            
                        } else {
                            completion(false)
                        }
                    })

                } else {
                    completion(false)
                }
            })
            } else {
                Database.database().reference().child("TweakChats").child(toID).child("userChats").child(currentUserID).child("tweaks").child(tweakID).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                        let currentDate = Date()
                        let milliseconds: Int64 = Int64(currentDate.timeIntervalSince1970 * 1000)
                        let strTimeStamp: String = "\(milliseconds)"
                        let currentTime = Int64(strTimeStamp); Database.database().reference().child("TweakChats").child(toID).child("userChats").child(currentUserID).updateChildValues(["lastUpdatedOn": currentTime as Any, "isUnread": true as Any], withCompletionBlock: { (error, _) in
                            if error == nil {
                                completion(true)
                                //api
                                APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.CHAT_PUSH_NOTIFICATION, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["tweakId" : tweakID] as [String: AnyObject], success: { response in
                                    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                                    let responseResult = responseDic["callStatus"] as! String
                                    if  responseResult == "GOOD" {
                                      
                                        DispatchQueue.main.async {
                              
                                        }
                                        
                                    }
                                }, failure: { error in
                                    
                                    //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline");
                                    
                                })
                            } else {
                                completion(false)
                            }
                        })
                    } else {
                        completion(false)
                    }
                })
            }
        }
    }
    
    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
