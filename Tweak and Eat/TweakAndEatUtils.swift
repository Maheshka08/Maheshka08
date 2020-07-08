//
//  TweakAndEatUtils.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 03/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation

class TweakAndEatUtils {
    
    static let window : UIWindow = (UIApplication.shared.delegate as! AppDelegate).window!
    
 

    
    
    class func showMBProgressHUD() {
        MBProgressHUD.showAdded(to: self.window, animated: true)
    }
    
    class func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.window, animated: true)
    }
    
    class func getWidthForString(_ text:String, font:UIFont, height:CGFloat) -> CGFloat
    {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.width + (5 * label.frame.width/100)
    }
    
    
    
    class AlertView: NSObject {
        
        @objc class func showAlert(view: UIViewController , message: String) {
            var title = "OK"
            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                if language == "BA" {
                  title = "BAIK"
                } else if language == "EN" {
                   title = "OK"
                }
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func getEventNames(countryISO: String, eventName: String) -> String {
        
        return "evt_" + countryISO.lowercased() + "_" + "i_" + eventName
    }
    
    class func getHeightForString(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height + (5 * label.frame.height/100)
    }
    
    class func isValidResponse(_ data: [String:AnyObject]?) -> Bool {
        if(data == nil) {
            return false
        } else if(data!.count <= 0) {
            return false
        } else if(data![TweakAndEatConstants.CALL_STATUS] == nil) {
            return false
        } else if(data![TweakAndEatConstants.CALL_STATUS] as! String != TweakAndEatConstants.TWEAK_STATUS_GOOD) {
            return false
        }
        
        return true
    }
    
    class func isArrayContainElements(_ data: [AnyObject]?) -> Bool {
        if(data == nil) {
            return false
        } else if(data!.count <= 0) {
            return false
        }
        
        return true
    }
    
    class func isValueExistInDefaults(key: String) -> Any? {
        let existingObject : Any? = UserDefaults.standard.value(forKey: key)
        
        if(existingObject == nil) {
            return existingObject;
        } else {
            return nil;
        }
    }
    
    class func localTimeFromTZ(dateString : String) -> String {
        let simpleDateFormat : DateFormatter = DateFormatter()
        simpleDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        simpleDateFormat.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
        
        let resultDate : Date = simpleDateFormat.date(from: dateString)!
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "d MMM yyyy"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "hh:mm a"
        
        return dateFormat.string(from: resultDate) + " " + timeFormat.string(from: resultDate)
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}

extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

extension String {
    var html2AttributedString:NSAttributedString {
        
        do {
            return try NSAttributedString(data: data(using: String.Encoding.utf8)!, options:convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]), documentAttributes: nil)
        } catch {
        }
        return NSAttributedString(string: "")
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}
