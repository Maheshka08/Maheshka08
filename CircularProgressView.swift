//
//  CircularProgressView.swift
//  Tweak and Eat
//
//  Created by Mehera on 26/06/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation
import UIKit
class CircularProgressView: UIView {
// First create two layer properties
 var circleLayer = CAShapeLayer()
 var progressLayer = CAShapeLayer()
   var progressClr = UIColor.white {
        didSet {
           circleLayer.strokeColor = progressClr.cgColor
        }
     }
     var trackClr = UIColor.white {
        didSet {
           progressLayer.strokeColor = trackClr.cgColor
        }
     }
override init(frame: CGRect) {
super.init(frame: frame)
createCircularPath()
}
required init?(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)
createCircularPath()
}
func createCircularPath() {
    let centerPoint = CGPoint (x: bounds.width / 2, y: bounds.width / 2)
    let circleRadius : CGFloat = bounds.width / 2

    let circularPath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(0.5 * M_PI), endAngle: CGFloat(2.5 * M_PI), clockwise: true    )
//let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
circleLayer.path = circularPath.cgPath
circleLayer.fillColor = UIColor.clear.cgColor
circleLayer.lineCap = .round
circleLayer.lineWidth = 6.0
    circleLayer.strokeColor = progressClr.cgColor
progressLayer.path = circularPath.cgPath
progressLayer.fillColor = UIColor.clear.cgColor
progressLayer.lineCap = .round
progressLayer.lineWidth = 6.0
progressLayer.strokeEnd = 0
    progressLayer.strokeColor = trackClr.cgColor
layer.addSublayer(circleLayer)
layer.addSublayer(progressLayer)
}
    func progressAnimation(duration: TimeInterval, val: Double) {
let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
circularProgressAnimation.duration = duration
circularProgressAnimation.toValue = val
circularProgressAnimation.fillMode = .forwards
circularProgressAnimation.isRemovedOnCompletion = false
progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
}
}
