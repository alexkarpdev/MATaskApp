//
//  AnimatableLabel.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableLabel: UILabel, Animatable {
    var isMenuLabel: Bool {
        get {
            return tag < 3
        }
    }
    
    func animate(y: CGFloat, controlPoints: ControlPoints) {
        print("animated tag: \(tag)")
        if y.isIn(includingTop: controlPoints.topMoveY, excludingBot: controlPoints.botMoveY) {
            // moving down
        }else{
            // stop moving
        }
        
        if y.isIn(includingTop: controlPoints.botMoveY, excludingBot: controlPoints.disappearY) {
            let p = y.getPercentage(fromY: controlPoints.botMoveY, toY: controlPoints.disappearY)
            if isMenuLabel {
                alpha = 0
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 1 - p
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y.isIn(includingTop: controlPoints.disappearY, excludingBot: controlPoints.appearY) {
            let p = y.getPercentage(fromY: controlPoints.disappearY, toY: controlPoints.appearY)
            if isMenuLabel {
                alpha = p
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 0
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y < controlPoints.botMoveY {
            if isMenuLabel {
                alpha = 0
            }else{
                alpha = 1
            }
        }
        
        if y > controlPoints.appearY {
            if isMenuLabel {
                alpha = 1
            }else{
                alpha = 0
            }
        }
        
        if isMenuLabel { // compute it in AnimationController
            if y.isIn(includingTop: controlPoints.topSelectY(forLabelAt: tag), excludingBot: controlPoints.botSelectY(forLabelAt: tag)) {
                //updateALebel(state: .selected) // perform closure
            }else{
                //updateALebel(state: .deselected) // perform closure
            }
        }
    }
    
    func endAnimate(touchState: UIGestureRecognizerState, initState: [String : Any]) {
        ()
    }
    
    func currentState() -> [String : Any] {
        let state: [String: Any] = ["frame.origin.y": frame.origin.y,
                                    "alpha": alpha,
                                    "textColor": textColor]
        return state
    }
}
