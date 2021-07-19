//
//  Extensions.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/26/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import Foundation
import UserNotifications
import Alamofire

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

//extension String {
//    var encodeEmoji: String{
//        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
//            return encodeStr as String
//        }
//        return self
//    }
//}
//
//extension String {
//    var decodeEmoji: String{
//        let data = self.data(using: String.Encoding.utf8);
//        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
//        if let str = decodedStr{
//            return str as String
//        }
//        return self
//    }
//}

//extension String {
//    func getEventNames(countryISO: String, eventName: String) -> String {
//        return "evt_" + countryISO.lowercased() + "_" + "i_" + eventName
//    }
//    
//}

//enum BackendError: RawRepresentable, Error {
//    typealias RawValue = AFError
//    
//    case parsing(reason: String)
//}

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat, txt: String?) {
        let text = txt
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, txt?.count ?? 0))
            self.attributedText = attributeString
        }
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: startDay)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
            guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
           return gregorian.date(byAdding: .day, value: 7, to: startDay)
       }
}

extension String {
    
    func getOrdinalValue() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: Int(self) ?? 0)) ?? ""
    }
    
    func getFormattedStringWithYear() -> String {
        if self == "" {
            return ""
        }
        let strArr = self.components(separatedBy: "-")
        let dd = strArr.last?.deletingPrefix("0").getOrdinalValue() ?? "0"
        let mm = strArr[1].deletingPrefix("0")
        let yy = strArr[0]
        switch mm {
        case "1":
        return dd + " " + "Jan, " + yy
        case "2":
        return dd + " " + "Feb, " + yy
        case "3":
        return dd + " " + "Mar, " + yy
        case "4":
        return dd + " " + "Apr, " + yy
        case "5":
        return dd + " " + "May, " + yy
        case "6":
        return dd + " " + "Jun, " + yy
        case "7":
        return dd + " " + "Jul, " + yy
        case "8":
        return dd + " " + "Aug, " + yy
        case "9":
        return dd + " " + "Sep, " + yy
        case "10":
        return dd + " " + "Oct, " + yy
        case "11":
        return dd + " " + "Nov, " + yy
        case "12":
        return dd + " " + "Dec" + yy
        
        default:
        return ""
    }
        
        
    
}
    
    func getFormattedString() -> String {
        if self == "" {
            return ""
        }
        let strArr = self.components(separatedBy: "-")
        let dd = strArr.last?.deletingPrefix("0").getOrdinalValue() ?? "0"
        let mm = strArr[1].deletingPrefix("0")
        switch mm {
        case "1":
        return dd + " " + "Jan"
        case "2":
        return dd + " " + "Feb"
        case "3":
        return dd + " " + "Mar"
        case "4":
        return dd + " " + "Apr"
        case "5":
        return dd + " " + "May"
        case "6":
        return dd + " " + "Jun"
        case "7":
        return dd + " " + "Jul"
        case "8":
        return dd + " " + "Aug"
        case "9":
        return dd + " " + "Sep"
        case "10":
        return dd + " " + "Oct"
        case "11":
        return dd + " " + "Nov"
        case "12":
        return dd + " " + "Dec"
        
        default:
        return ""
    }
        
        
    
}
    
}

extension UIView {

    var snapshot: UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}



extension JSONDecoder {
  func decodeResponse<T: Decodable>(from response: AFDataResponse<Data>) ->T {
    guard response.error == nil else {
      print(response.error!)
        return response.error?.localizedDescription as! T
    }

    guard let responseData = response.data else {
      print("didn't get any data from API")
        return response.error?.localizedDescription as! T
    }

    do {
      let item = try decode(T.self, from: responseData)
      return item
    } catch {
      print("error trying to decode response")
      print(error)
        return response.error?.localizedDescription as! T
    }
  }
}

extension UIView {
func addBorders(color: UIColor = UIColor.red, margins: CGFloat = 0, borderLineSize: CGFloat = 1, attribute: NSLayoutConstraint.Attribute) {
    let border = UIView()
    border.backgroundColor = color
    border.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(border)
    border.addConstraint(NSLayoutConstraint(item: border,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .height,
                                            multiplier: 1, constant: borderLineSize))
    self.addConstraint(NSLayoutConstraint(item: border,
                                          attribute: attribute,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute: attribute,
                                          multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: border,
                                          attribute: .leading,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute: .leading,
                                          multiplier: 1, constant: margins))
    self.addConstraint(NSLayoutConstraint(item: border,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute: .trailing,
                                          multiplier: 1, constant: margins))
}

}


extension Date {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension String {
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "QUESTRIAL-REGULAR", size: 18)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
    
//    @discardableResult func changeTextColor(_ text: String, _ fullText: String) -> NSMutableAttributedString {
//        let range = (fullText as NSString).range(of: text)
//
//        let attribute = NSMutableAttributedString.init(string: fullText)
//        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
//        let changedText = NSMutableAttributedString(string:text, attributes: attribute)
//        append(changedText)
//        
//        return self
//    }
    
  
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}
extension UIView {
    
    @objc func addTopBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1, constant: 0))
    }
}

extension UIButton {

    func flash() {

        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 5

        layer.add(flash, forKey: nil)
    }
}
extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

extension CALayer {
    
    @objc func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
        
    }
    
}

extension UIImageView {
    
    @objc func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
}
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
    }
}

extension UILabel {
    
    @objc func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .transitionCrossDissolve, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    @objc func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
    
    static func getWantedDate(forLastNDays nDays: Int) -> String {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -nDays, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

extension UIDevice {
    
    @objc var modelName: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let identifier = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4":
            return "iPhone XS Max"
        case "iPhone11,6":
            return "iPhone XS Max China"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
        
    }
}

extension UITextField {
    @objc func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIImageView {
    @objc func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    @objc func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}



let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    @objc func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        // set initial image to nil so it doesn't use the image from a reused cell
        image = nil
        
        // check if the image is already in the cache
        if let imageToCache = imageCache.object(forKey: imgURL! as NSString) {
            self.image = imageToCache
            return
        }
        
        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                // create UIImage
                let imageToCache = UIImage(data: data!)
                // add image to cache
                imageCache.setObject(imageToCache!, forKey: imgURL! as NSString)
                self.image = imageToCache
            }
        }
        task.resume()
    }
}

extension String {
    var htmlAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html), convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.characterEncoding): String.Encoding.utf8.rawValue]), documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return htmlAttributedString?.string ?? ""
    }
}

extension UIImage {

    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}

extension String {
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}

extension UNNotificationAttachment {
    
    @objc static func create(identifier: String, urlString: String, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let url = URL(string:urlString)
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            guard let imageData = image!.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
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
