//
//  AnimationController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 05.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

enum AnimationType {
    case moveOut
    case moveIn
    case goBack
}

protocol Animatable {
    func animate()
}



class AnimationController {
    
    var movedView: UIImageView! {
        didSet {
            movedView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    var cellView: UIImageView! {
        didSet {
            if movedView != nil { movedView.removeFromSuperview() }
            movedView = cellView.clone(superView: viewConteiner, startPoint: startPoint)
        }
    }
    
    var viewConteiner: UIView!
    var panGestureRecognizer = UIPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    
    var startPoint = CGPoint()
    
    init(collectionView: MoviesCollectionView) {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        viewConteiner = collectionView.superview!
        startPoint = CGPoint(x: collectionView.leftSectionInset, y: collectionView.frame.origin.y)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            //movedView = cellView.clone(superView: viewConteiner, startPoint: startPoint)
        
            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.movedView.transform = CGAffineTransform(translationX: self.startPoint.x, y: 275)
            })
            animator.startAnimation()
            animator.pauseAnimation()
        case .changed:
            animator.fractionComplete = recognizer.translation(in: movedView).y / 275
        case .ended:
            animator.stopAnimation(true)
        //continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
}
