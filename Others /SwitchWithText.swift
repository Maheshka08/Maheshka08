//
//  SwitchWithText.swift
//  Tweak and Eat
//
//  Created by Mehera on 29/06/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation
import CoreMotion


class SwitchWithText: UIButton {
var fromWhichVc = ""
    var status: Bool = false {
        didSet {
            self.update()
        }
    }
    var offImage = UIImage(named: "reports_btn")
    var onImage = UIImage(named: "reports_btn")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStatus(false)
        self.comingFromWelcomeVC(val: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        UIView.transition(with: self, duration: 0.01, options: .transitionCrossDissolve, animations: {
            self.status ? self.setImage(self.onImage, for: .normal) : self.setImage(self.offImage, for: .normal)
        }, completion: nil)
        
    }
    func toggle() {
        
        self.status ? self.setStatus(false) : self.setStatus(true)
        if UserDefaults.standard.value(forKey: "SWAP_SWITCH_VIEW") != nil {
            if UserDefaults.standard.value(forKey: "SWAP_SWITCH_VIEW") as! String == "WELCOME_VIEW" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SWAP_VIEW"), object: self.status);

            } else if UserDefaults.standard.value(forKey: "SWAP_SWITCH_VIEW") as! String == "MY_TAE" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SWAP_VIEW_IN_MYTAE"), object: self.status);

            }
        }
    }
    
    func setStatus(_ status: Bool) {
        self.status = status
    }
    
    func comingFromWelcomeVC(val: String) {
        self.fromWhichVc = val
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.sendHapticFeedback()
        self.toggle()
    }
    
    func sendHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
}
