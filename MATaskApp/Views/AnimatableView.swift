//
//  AnimatableView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableView: UIView {
    private let topBorderY: CGFloat = 0
    private let botBorderY: CGFloat = 25
    private let moveKoef: CGFloat = 0.4
    
    private var initState: InitialStates!
}

extension AnimatableView: Animatable {
    func animate(tY: CGFloat) {
        let tkY = tY * moveKoef
        if tkY.isIn(includingTop: topBorderY, excludingBot: botBorderY){
            frame.origin.y = initState.y + tkY
            alpha = 1 - tY.getPercentage(fromY: topBorderY, toY: botBorderY)
        }
        if tkY >= botBorderY{
            alpha = 0
        }else if tkY <= topBorderY{
            alpha = 1
        }
    }
    
    func endAnimate(touchState: UIGestureRecognizerState, complition: (()->())?) {
        let endAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.6)
        endAnimator.addAnimations ({ [unowned self] in
            self.frame.origin.y = self.initState.y
            self.alpha = self.initState.alpha
            }, delayFactor: 0.2)
        
        endAnimator.startAnimation()
    }
    
    func saveState() {
        initState = InitialStates(y: frame.origin.y, alpha: alpha)
    }
}
