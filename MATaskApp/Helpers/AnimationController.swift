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



class AnimationController: NSObject {
    
    var cellImageView: UIImageView? {
        willSet{
            cellImageView?.alpha = 1
        }
        didSet {
            movedImageView?.removeFromSuperview()
            cellImageView!.addGestureRecognizer(panGestureRecognizer)
            
        }
    }
    var lockScroll: ((Bool)->())!
    var isAnimating = false
    var movedImageView: UIImageView?
    
    var viewConteiner: UIView!
    var panGestureRecognizer = UIPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    
    var startPoint = CGPoint()
    
    func prepareImageView(){
        movedImageView = cellImageView!.clone(superView: viewConteiner, startPoint: startPoint)
        cellImageView!.alpha = 0
        movedImageView!.addGestureRecognizer(panGestureRecognizer)
        isAnimating = true
        lockScroll(true)
    }
    func turnStateBack(){
        movedImageView?.removeFromSuperview()
        movedImageView = nil
        cellImageView!.addGestureRecognizer(panGestureRecognizer)
        cellImageView!.alpha = 1
        isAnimating = false
        lockScroll(false)
    }
    
    
    init(collectionView: MoviesCollectionView, lockScroll: @escaping (Bool)->()) {
        super.init()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
        viewConteiner = collectionView.superview!
        startPoint = CGPoint(x: collectionView.leftSectionInset, y: collectionView.frame.origin.y)
        self.lockScroll = lockScroll
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        switch recognizer.state {
        case .began:
            prepareImageView()
        case .changed:
            self.movedImageView!.transform = CGAffineTransform(translationX: 0, y: recognizer.translation(in: self.movedImageView!).y)
        case .ended:
            let backAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.6) {
                self.movedImageView!.frame.origin = self.startPoint
            }
            backAnimator.addCompletion(){ position in
                self.turnStateBack()
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


















