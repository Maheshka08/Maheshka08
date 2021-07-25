
import UIKit
import Photos
import Firebase
import RealmSwift
import Realm

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()

    //MARK: Properties
    var dateFormatter = DateFormatter();
    var hideBottomMessageBox = false
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @objc var fromPackages = false
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var myProfileInfo : Results<MyProfileInfo>?
    var chatInfo : Results<NutritionChat>?
    let realm :Realm = try! Realm()
    var items = [Message]()
    @objc let imagePicker = UIImagePickerController()
    @objc let barHeight: CGFloat = 50
    @objc var currentUser: User?
    @objc var canSendLocation = true
    @objc var nutritionistFBID = ""
    @objc var tweakID = ""
    @objc var chatID = ""
    @objc var imageUrl = ""
    @objc var donotChat = false
    
    //MARK: Methods
    @objc func customization() {
        
        self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.navigationItem.setHidesBackButton(true, animated: false)
       
    }

    //Downloads messages
    @objc func fetchData() {
        Message.downloadAllMessages(forUserID: nutritionistFBID, tweakID: self.tweakID, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)

                }
            }
        })
    }
    
    @objc func fetchMessages() {
        Message.downloadAllMessages2(forUserID: nutritionistFBID, chatID: self.chatID, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
    }
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func composeMessage(type: MessageType, isFirstMessage: Bool, content1: [String: Any], content2: [String: Any], timeStamp: Any, toID: String, tweakID: String)  {
        var message = Message(type: .text, content: "", owner: .sender, timestamp: Int(timeStamp as! Int64), isRead: false)
        if isFirstMessage == false {
             message = Message.init(type: type, content: content1, owner: .sender, timestamp: Int(timeStamp as! Int64), isRead: false)
        } else {
        message = Message.init(type: type, content: content2, owner: .sender, timestamp: Int(timeStamp as! Int64), isRead: false)
        }
        Message.send(message: message, toID: nutritionistFBID, isFirstMessage: isFirstMessage, tweakID: tweakID, completion: {(_) in
        })
        
    }
    
    func compose(type: MessageType, isFirstMessage: Bool, content: [String: Any], timeStamp: Any, toID: String, chatID: String)  {
         var message = Message(type: .text, content: content, owner: .sender, timestamp: Int(timeStamp as! Int64), isRead: false)
        Message.sendMessage(message: message, toID: nutritionistFBID, isFirstMessage: isFirstMessage, chatID: chatID, completion: {(_) in
        })
    }
    
    @IBAction func popBack(_ sender: Any) {
      self.navigationController!.popViewController(animated: true);
        
    }
   
    @objc func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func selectGallery(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .authorized || status == .notDetermined) {
            self.imagePicker.sourceType = .savedPhotosAlbum;
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectCamera(_ sender: Any) {

    }
    
    @IBAction func selectLocation(_ sender: Any) {
    
        self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func showOptions(_ sender: Any) {
        self.animateExtraButtons(toHide: false)
    }
    
    @objc func getDefaultProfileDetails()-> [String : Any] {
        let currentDate = Date()
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate)
        let currentTime = Int64(currentTimeStamp)
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        if let currentUserID = Auth.auth().currentUser?.uid {
            let profileDetails = ["age": self.myProfileInfo?.first?.age as Any, "allergies":self.myProfileInfo?.first?.allergies as Any,"bodyType": Int((self.myProfileInfo?.first?.bodyShape)!)!, "conditions":self.myProfileInfo?.first?.conditions as Any, "foodType": self.myProfileInfo?.first?.foodHabits as Any, "height":self.myProfileInfo?.first?.height as Any, "nickName": self.myProfileInfo?.first?.name as Any, "weight":self.myProfileInfo?.first?.weight as Any, "uid":currentUserID as Any, "lastUpdatedOn": currentTime as Any, "isUnread": true as Any] as [String : Any]
            return profileDetails

        }
        return [String: Any]()
    }
    
    @objc func disableChat() {
        if self.fromPackages == false {
        if let chatDetails = self.realm.object(ofType: NutritionChat.self, forPrimaryKey: self.tweakID) {
            try! self.realm.write {
            chatDetails.isLastMessage = true
            self.realm.add(chatDetails, update: true);
            }
        }
        } else  {
            if let chatDetails = self.realm.object(ofType: UserPackagesNutritionChat.self, forPrimaryKey: self.chatID) {
                try! self.realm.write {
                    chatDetails.isLastMessage = true
                    self.realm.add(chatDetails, update: true);
                }
            }
        }
        self.inputTextField.text = self.bundle.localizedString(forKey: "chatclose", value: nil, table: nil);

        self.inputBar.isUserInteractionEnabled = false
    }
    
    @objc func checkFirstMessage() {
        if self.fromPackages == false {

        if let chatDetails = self.realm.object(ofType: NutritionChat.self, forPrimaryKey: self.tweakID) {
            if chatDetails.isFirstMessage == false {
            try! self.realm.write {

            chatDetails.isFirstMessage = true
            self.realm.add(chatDetails, update: true);
            }
        }
      }
        } else {
            if let chatDetails = self.realm.object(ofType: UserPackagesNutritionChat.self, forPrimaryKey: self.chatID) {
                if chatDetails.isFirstMessage == false {
                    try! self.realm.write {
                        
                        chatDetails.isFirstMessage = true
                        self.realm.add(chatDetails, update: true);
                    }
                }
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.inputTextField.resignFirstResponder()
                NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.disableChat), name: NSNotification.Name(rawValue: "CHAT_ENDED"), object: nil)
                 NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.checkFirstMessage), name: NSNotification.Name(rawValue: "FIRST_MESSAGE"), object: nil)
                let currentDate = Date()
                let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate)
                let currentTime = Int64(currentTimeStamp)
                if self.fromPackages == false {
                var content1 = [String:Any]()
                var content2 = ["firstMessage": true as Any, "from": 0, "message": self.inputTextField.text! as Any, "postedOn": currentTime!, "tweakImage": self.imageUrl as Any] as [String: Any]
                content1["profileDetails"] = self.getDefaultProfileDetails()
                content1["tweaks"] = content2
                content2.removeValue(forKey: "firstMessage")
                content2.removeValue(forKey: "tweakImage")
                var firstMessage = false
                if let chatDetails = self.realm.object(ofType: NutritionChat.self, forPrimaryKey: self.tweakID) {
                    if chatDetails.isFirstMessage == true {
                        firstMessage = true
                    } else {
                        firstMessage = false
                    }
                }
                self.composeMessage(type: .text, isFirstMessage: firstMessage, content1: content1, content2: content2, timeStamp: currentTime!, toID: nutritionistFBID, tweakID: tweakID + "_id")
                self.inputTextField.text = ""
                } else {
                    var content2 = ["firstMessage": true as Any, "from": 0, "message": self.inputTextField.text! as Any, "postedOn": currentTime!] as [String: Any]
                  
                    var firstMessage = false
                    if let chatDetails = self.realm.object(ofType: UserPackagesNutritionChat.self, forPrimaryKey: self.chatID) {
                        if chatDetails.isFirstMessage == true {
                            firstMessage = true
                        } else {
                            firstMessage = false
                        }
                    }
                    self.compose(type: .text, isFirstMessage: firstMessage, content: content2, timeStamp: currentTime!, toID: nutritionistFBID, chatID: self.chatID)
                    self.inputTextField.text = ""
                }
            }
        }
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
           
            if self.items.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.fromPackages == false {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 330))
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 250))
            imgView.sd_setImage(with: URL(string: self.imageUrl));
            imgView.contentMode = .scaleAspectFill
            
            let titleLbl = UILabel(frame: CGRect(x: 10 , y: imgView.frame.maxY, width: tableView.frame.size.width - 20, height: 128))
            
            titleLbl.numberOfLines = 0
            //ask_question_desctiption
            titleLbl.text =  self.bundle.localizedString(forKey: "ask_question_desctiption", value: nil, table: nil);

            titleLbl.font = UIFont(name: "System", size: 17.0)
            titleLbl.textColor = UIColor.darkText
            titleLbl.backgroundColor = UIColor.white
            view.backgroundColor = UIColor.white
            view.addSubview(imgView)
            view.addSubview(titleLbl)
            return view
        }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.fromPackages == false {

        if section == 0 {
            return 380
        }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.backgroundColor = UIColor.clear
            cell.clearCellData()
//            cell.messageBackground.image = UIImage(named: "bubble_a.9")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .stretch).withRenderingMode(.alwaysTemplate);          cell.messageBackground.backgroundColor = .clear
//            cell.messageBackground.contentMode = .scaleAspectFit
//
            switch self.items[indexPath.row].type {
            case .text:
                let milisecond = Int64(self.items[indexPath.row].timestamp)
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)

                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                cell.timeStampLbl.text = dateFormatter.string(from: dateVar)
                
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.backgroundColor = UIColor.clear
            cell.clearCellData()
//            cell.messageBackground.image = UIImage(named: "bubble_b.9")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .stretch).withRenderingMode(.alwaysTemplate);
//            cell.messageBackground.backgroundColor = .clear
//            cell.messageBackground.contentMode = .scaleAspectFit
            switch self.items[indexPath.row].type {
            case .text:
                let milisecond = Int64(self.items[indexPath.row].timestamp)
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                
                dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm a";
                cell.timeStampLbl.text = dateFormatter.string(from: dateVar)
                
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextField.resignFirstResponder()
        switch self.items[indexPath.row].type {
        case .photo:
            if let photo = self.items[indexPath.row].image {
                let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
                self.inputAccessoryView?.isHidden = true
            }
        case .location:
            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
            let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
            self.inputAccessoryView?.isHidden = true
        default: break
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    }
   
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func getNutritionistFBID() {
//        DispatchQueue.main.async {
//                    self.sendButton.isHidden = true
//        }
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.ENDPOINT_NUTRITION_FBUID, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: ["tweakId":self.tweakID as AnyObject] , success: { response in
            print(response)

            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD"  {
//                DispatchQueue.main.async {
//
//                self.sendButton.isHidden = false
//                }
                self.nutritionistFBID = responseDic["nutFbUid"] as AnyObject as! String
                let nutritionChat = NutritionChat()
                nutritionChat.nutritionistFBID = self.nutritionistFBID
                nutritionChat.tweakID = self.tweakID
                saveToRealmOverwrite(objType: NutritionChat.self, objValues: nutritionChat)

                self.customization()
                self.fetchData()

            }
        }, failure : { error in
            print("failure")
//             DispatchQueue.main.async {
//                               self.sendButton.isHidden = true
//                   }
             TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
            
        })
    }
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.hideBottomMessageBox == true {
            self.inputBar.isHidden = true
        }
        self.addBackButton()
        
        
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }
        
        self.title = self.bundle.localizedString(forKey: "nutriton_chat", value: nil, table: nil);
        
        let tempImageView = UIImageView(image: UIImage(named: "chat_bg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
        
        
        self.inputTextField.placeholder = self.bundle.localizedString(forKey: "ask_question", value: nil, table: nil);
        //self.inputTextField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
        self.inputTextField.textColor = UIColor.black
        self.inputTextField.autocorrectionType = .yes
        if self.donotChat == true {
            self.inputTextField.placeholder = self.bundle.localizedString(forKey: "chatclose", value: nil, table: nil);
            
            self.inputBar.isUserInteractionEnabled = false
        }
        if self.fromPackages == false {
        if let chatDetails = self.realm.object(ofType: NutritionChat.self, forPrimaryKey: self.tweakID) {
            nutritionistFBID = (chatDetails.nutritionistFBID)
            if chatDetails.isLastMessage == true {
                self.inputTextField.text = self.bundle.localizedString(forKey: "chatclose", value: nil, table: nil);

                self.inputBar.isUserInteractionEnabled = false
            }
            self.customization()
            self.fetchData()

        } else {
            self.getNutritionistFBID()
        }
        } else {
            if let chatDetails = self.realm.object(ofType: UserPackagesNutritionChat.self, forPrimaryKey: self.chatID) {
                nutritionistFBID = (chatDetails.nutritionistFBID)
                if chatDetails.isLastMessage == true {
                    self.inputTextField.text = self.bundle.localizedString(forKey: "chatclose", value: nil, table: nil);

                    self.inputBar.isUserInteractionEnabled = false
                }
                self.customization()
                self.fetchMessages()
                
            } else {
                if let nutFBID = UserDefaults.standard.value(forKey: "NutritionistFirebaseId") {
                    self.nutritionistFBID = nutFBID as! String
                }
                let nutritionChat = UserPackagesNutritionChat()
                nutritionChat.nutritionistFBID = self.nutritionistFBID
                nutritionChat.chatID = self.chatID
                saveToRealmOverwrite(objType: UserPackagesNutritionChat.self, objValues: nutritionChat)
                self.customization()
                self.fetchMessages()

                
            }
        }
        //self.inputTextField.becomeFirstResponder()
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
