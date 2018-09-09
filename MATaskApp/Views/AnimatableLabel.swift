//
//  AnimatableLabel.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

enum ALState: String {
    case selected = "selected"
    case deselcted = "deselected"
    
    var textColor: UIColor {
        return self == .selected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3) // 65% : 30%
    }
}

class AnimatableLabel: UILabel, Animatable {
    
    private var initState: [String: Any]!
    
    private var topBorderY: CGFloat = 0
    private var topMoveY: CGFloat = 5
    private var botMoveY: CGFloat = 30
    private var disappearY: CGFloat = 45
    private var appearY: CGFloat = 60
    private var botBorderY: CGFloat = 140
    
    private lazy var topSelectY: CGFloat = {
        return appearY + 5 + 20 * CGFloat(tag)
    }()
    
    private lazy var botSelectY: CGFloat = {
        return topSelectY + 15
    }()
    
    private lazy var isMenuLabel: Bool = {
        return tag < 3
    }()
    
    var aLState: ALState!
    
    func animate(tY: CGFloat) {
        print("label ty: \(tY) tag:  \(tag)")
        print("animated tag: \(tag)")
        let currentY = frame.origin.y
        if tY.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            frame.origin.y = (initState[StateProperties.y] as! CGFloat) + tY
        }else{
            // stop moving
        }
        
        if tY.isIn(includingTop: botMoveY, excludingBot: disappearY) {
            let p = tY.getPercentage(fromY: botMoveY, toY: disappearY)
            if isMenuLabel {
                alpha = 0
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 1 - p
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if tY.isIn(includingTop: disappearY, excludingBot: appearY) {
            let p = tY.getPercentage(fromY: disappearY, toY: appearY)
            if isMenuLabel {
                alpha = p
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 0
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if tY < botMoveY {
            if isMenuLabel {
                alpha = 0
            }else{
                alpha = 1
            }
        }
        
        if tY > appearY {
            if isMenuLabel {
                alpha = 1
            }else{
                alpha = 0
            }
        }
        
        if isMenuLabel {
            if tY.isIn(includingTop: topSelectY, excludingBot: botSelectY) {
                textColor = ALState.selected.textColor
                //updateALebel(state: .selected)
            }else{
                textColor = ALState.deselcted.textColor
                //updateALebel(state: .deselected)
            }
        }
    }
    
    func endAnimate(touchState: UIGestureRecognizerState) {
        
        setValue(initState[StateProperties.textColor], forKey: StateProperties.textColor)
        
        let labelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.5)
        labelAnimator.addAnimations { [unowned self] in
            self.setValue(self.initState[StateProperties.alpha], forKey: StateProperties.alpha)
        }
        labelAnimator.addAnimations ({ [unowned self] in
            self.setValue(self.initState[StateProperties.y], forKey: StateProperties.y)
            }, delayFactor: 0.2)
    }
    
    func saveState() {
        initState = [StateProperties.y: frame.origin.y,
                                    StateProperties.alpha: alpha,
                                    StateProperties.textColor: textColor]
    }
    
    
}
