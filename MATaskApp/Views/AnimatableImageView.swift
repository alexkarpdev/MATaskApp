//
//  AnimatableImageView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableImageView: UIImageView {
    
    private lazy var topBorderY: CGFloat = {
        return 0 //superview!.frame.origin.y // fatalError("instance of AnimatableImageView has no superview!")
    }()
    private lazy var botBorderY: CGFloat = { //
        return frame.height / 2 * 1 // 1.3 - koef for orientation
    }()
    
    private var initState: InitialStates!
}

extension AnimatableImageView: Animatable {
    func animate(tY: CGFloat) {
        print("imageView ty: \(tY)")
        guard tY.isIn(includingTop: topBorderY, excludingBot: botBorderY) else {return}
        frame.origin.y = tY
    }
    
    func endAnimate(touchState: UIGestureRecognizerState, complition: (()->())?) {
        let endAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6)
        endAnimator.addAnimations { [unowned self] in
            self.frame.origin.y = self.initState.y
        }
        endAnimator.addCompletion(){ position in
            complition!()
        }
        endAnimator.isUserInteractionEnabled = false
        endAnimator.startAnimation()
    }
    
    func saveState() {
        initState = InitialStates(y: frame.origin.y)
    }
}
