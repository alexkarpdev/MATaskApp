//
//  AnimationController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 05.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

enum AnimationState {
    case moving
    case goback
}

protocol Animatable {
    func animate(y: CGFloat, state: AnimationState)
}

class AnimationController: NSObject {
    
    var cellImageView: UIImageView? {
        didSet {
            cellImageView?.addGestureRecognizer(panGestureRecognizer)
        }
    }
    var cellPanelView: UIView?
    
    var lockScroll: ((Bool)->())!
    var isAnimating = false
    
    var conteinerView: UIView!
    var movedImageView: UIImageView?
    var aView: AView?
    var aLabels: [ALabel]?
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    
    var startPoint = CGPoint()
    
    init(collectionView: MoviesCollectionView, aLabels: [ALabel],  lockScroll: @escaping (Bool)->()) {
        super.init()
        self.aLabels = aLabels
        conteinerView = collectionView.superview!
        startPoint = CGPoint(x: collectionView.leftSectionInset, y: collectionView.frame.origin.y)
        self.lockScroll = lockScroll
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
    }

    
    func animationBegin(isBegin: Bool) {
        if isBegin {
            movedImageView = cellImageView!.clone(superView: conteinerView, startPoint: startPoint)
            movedImageView!.addGestureRecognizer(panGestureRecognizer)
            //aView = cellPanelView as! AView
        }else{
            movedImageView?.removeFromSuperview()
            movedImageView = nil
            cellImageView!.addGestureRecognizer(panGestureRecognizer)
            //aView!.removeFromSuperview()
        }
        cellImageView!.isHidden = isBegin
        cellPanelView!.isHidden = isBegin
        lockScroll(isBegin)
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    
    
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        switch recognizer.state {
        case .began:
            animationBegin(isBegin: true)
        case .changed:
            self.movedImageView!.transform = CGAffineTransform(translationX: 0, y: recognizer.translation(in: self.movedImageView!).y)
        case .ended, .cancelled:
            let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
                self.movedImageView!.frame.origin = self.startPoint
            }
            backAnimator.addCompletion(){ position in
                self.animationBegin(isBegin: false)
            }
            backAnimator.isUserInteractionEnabled = false
            backAnimator.startAnimation()
        default:
            ()
        }
    }
    
    
}





extension AnimationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


















