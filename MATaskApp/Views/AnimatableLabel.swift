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
    case deselected = "deselected"
    
    var textColor: UIColor {
        return self == .selected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3) // 65% : 30%
    }
}

class AnimatableLabel: UILabel {
    
    private var initState: InitialStates!
    
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
    
    private var aLState: ALState = .deselected
    
    private func updateALabelState(state: ALState) {
        guard state != aLState else {return}
        aLState = state
        textColor = aLState.textColor
        aLState == .selected ? UIImpactFeedbackGenerator(style: .medium).impactOccurred() : ()
    }
    
}

extension AnimatableLabel: Animatable {
    func animate(tY: CGFloat) {
        if tY.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            frame.origin.y = initState.y + tY - topMoveY
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
                updateALabelState(state: .selected)
            }else{
                updateALabelState(state: .deselected)
            }
        }
    }
    
    func endAnimate(touchState: UIGestureRecognizerState, complition: (()->())?) {
        
        switch aLState {
        case .selected where touchState == .ended:
            let generator = UINotificationFeedbackGenerator()
            switch tag {
            case 0: //
                generator.notificationOccurred(.warning)
            //accept selection
            case 1:
                generator.notificationOccurred(.success)
            //accept selection
            case 2:
                generator.notificationOccurred(.error)
            //accept selection
            default:
                print("wrong tag: \(tag)")
            }
        default:
            ()
        }
        aLState = .deselected
        textColor = initState.textColor
        
        let endAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6)
        endAnimator.addAnimations { [unowned self] in
            self.alpha = self.initState.alpha
        }
        endAnimator.addAnimations ({ [unowned self] in
            self.frame.origin.y = self.initState.y
            }, delayFactor: 0.2)
        
        endAnimator.startAnimation()
    }
    
    func saveState() {
        initState = InitialStates(y: frame.origin.y, alpha: alpha, textColor: textColor)
    }
}
