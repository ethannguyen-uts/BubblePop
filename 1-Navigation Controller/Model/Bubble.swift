//
//  Bubble.swift
//  1-Navigation Controller
//
//  Created by Ethan Nguyen, idea from Mrs Huo
//

import UIKit
import AVFoundation

class Bubble: UIButton {
    let id = UUID().uuidString
    let bubbleSize = 55
    var xPosition = 0
    var yPosition = 0
    var color = UIColor.red
    var score = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.color = getColor()
        self.backgroundColor = self.color
        self.score = getScore(color: self.color)
        self.frame = CGRect(x: xPosition, y: yPosition, width: bubbleSize, height: bubbleSize)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set position in the play screen
    func setPosition(x: Int, y: Int) {
        self.xPosition = x;
        self.yPosition = y;
        self.frame = CGRect(x: x, y: y, width: bubbleSize, height: bubbleSize)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    func getColor() -> UIColor {
        let code = Int.random(in: 1...100)
        switch code {
        case 1...40:
            return UIColor.red
        case 41...70:
            return UIColor.systemPink
        case 71...85:
            return UIColor.green
        case 86...95:
            return UIColor.blue
        case 96...100:
            return UIColor.black
        default:
            return UIColor.red
        }
    }
    
    func getScore(color: UIColor) -> Int {
        switch color {
        case .red:
            return 1
        case .systemPink:
            return 2
        case .green:
            return 5
        case .blue:
            return 8
        case .black:
            return 10
        default:
            return 0
        }
    }
    //animate when bubble appears
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.5
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        layer.add(springAnimation, forKey: nil)
    }
    //animate when bubble dissapear
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
}
