//
//  AnimatableView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableView: UIView, Animatable {
    private let topBorderY: CGFloat = 0
    private let botBorderY: CGFloat = 25
    private let moveKoef: CGFloat = 0.2
    
    private var initState: [String: Any]!
    
    
    func animate(tY: CGFloat) {
        print("View ty: \(tY)")
        let currentY = frame.origin.y
        guard tY.isIn(includingTop: topBorderY, excludingBot: botBorderY) else {return}
        frame.origin.y = (initState[StateProperties.y] as! CGFloat) + tY
        
        alpha = 1 - tY.getPercentage(fromY: topBorderY, toY: botBorderY)
        if tY >= botBorderY{
            alpha = 0
        }else if tY <= topBorderY{
            alpha = 1
        }
        print("View alpha: \(alpha) p: \(tY.getPercentage(fromY: topBorderY, toY: botBorderY))")
    }
    
    func endAnimate(touchState: UIGestureRecognizerState) {
        let endAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.4)
        endAnimator.addAnimations ({ [unowned self] in
            self.setValue(self.initState[StateProperties.y], forKey: StateProperties.y)
            self.setValue(self.initState[StateProperties.alpha], forKey: StateProperties.alpha)
            }, delayFactor: 0.2)
        
        endAnimator.startAnimation()
    }
    
    func saveState() {
        initState = [StateProperties.y: frame.origin.y,
                     StateProperties.alpha: alpha]
    }
    
    func applyInitState() {
        
    }
}
