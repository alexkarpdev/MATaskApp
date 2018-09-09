//
//  AnimatableImageView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableImageView: UIImageView, Animatable {
    
    private lazy var topBorderY: CGFloat = {
        return 0 //superview!.frame.origin.y // fatalError("instance of AnimatableImageView has no superview!")
    }()
    private lazy var botBorderY: CGFloat = { //
        return frame.height * 1.3 // 1.3 - koef for orientation
    }()
    
    private var initState: [String: Any]!
    
    func animate(tY: CGFloat) {
        print("imageView ty: \(tY)")
        let currentY = frame.origin.y
        guard tY.isIn(includingTop: topBorderY, excludingBot: botBorderY) else {return}
        frame.origin.y = tY
    }
    
    func endAnimate(touchState: UIGestureRecognizerState) {
        let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5)
        backAnimator.addAnimations { [unowned self] in
            self.setValue(self.initState[StateProperties.y], forKey: StateProperties.y)
        }
        backAnimator.addCompletion(){ [unowned self] position in
            //self.animationBegin(isBegin: false)
        }
        backAnimator.startAnimation()
    }
    
    func saveState() {
        initState = [StateProperties.y: frame.origin.y]
    }
}
