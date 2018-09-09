//
//  AnimatableImageView.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

class AnimatableImageView: UIView, Animatable {
    func animate(y: CGFloat, controlPoints: ControlPoints) {
        return
    }
    
    func endAnimate(touchState: UIGestureRecognizerState, initState: [String : Any]) {
        return
    }
    
    func currentState() -> [String : Any] {
        let state: [String: Any] = ["frame.origin.y": frame.origin.y]
        return state
    }
}
