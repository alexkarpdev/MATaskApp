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
    func animate(y: CGFloat)
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
    var aLabels = [ALabel]()
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    
    var startPoint = CGPoint()
    var timer = Timer()
    
    
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
            UISelectionFeedbackGenerator().selectionChanged()
            movedImageView = cellImageView!.clone(superView: conteinerView, startPoint: startPoint)
            movedImageView!.addGestureRecognizer(panGestureRecognizer)
            //aView = cellPanelView as! AView
        }else{
            aLabels.forEach{
                $0.animY = $0.animY + 0
                $0.transform = CGAffineTransform.identity
                $0.allowTransform = true
                $0.appearAnimator.isInterruptible = true
                $0.appearAnimator.startAnimation()
                $0.appearAnimator.pauseAnimation()
                
            }
            movedImageView?.removeFromSuperview()
            movedImageView = nil
            cellImageView!.addGestureRecognizer(panGestureRecognizer)
            //aView!.removeFromSuperview()
        }
        cellImageView!.isHidden = isBegin
        cellPanelView!.isHidden = isBegin
        lockScroll(isBegin)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        switch recognizer.state {
        case .began:
            animationBegin(isBegin: true)
        case .changed:
            let y = recognizer.location(in: conteinerView).y
            //guard max(178, min(360, recognizer.location(in: self.conteinerView!).y)) == recognizer.location(in: self.conteinerView!).y else {return}
            self.movedImageView!.transform = CGAffineTransform(translationX: 0, y: recognizer.translation(in: self.conteinerView!).y)
            
            self.aLabels.forEach{
                $0.animY = self.movedImageView!.frame.origin.y - startPoint.y//animate(y: self.movedImageView!.frame.origin.y)
                if $0.allowTransform {
                    $0.transform = CGAffineTransform(translationX: 0, y: recognizer.translation(in: self.conteinerView!).y)
                }
            }
        case .ended, .cancelled:
            
            print("end")
            
            //timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(turnBack), userInfo: nil, repeats: false)
            
            self.aLabels.forEach{
                $0.endAnimate()
            }
            let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5)
            backAnimator.addAnimations {
                self.movedImageView!.frame.origin = self.startPoint
            }
            let labelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.3)
            labelAnimator.addAnimations ({
                self.aLabels.forEach{
                    $0.frame.origin.y = $0.turnY
                }
            }, delayFactor: 0.1)
            
            labelAnimator.addCompletion(){ position in
                print(position)
                //self.aLabels.forEach{
                //}
            }
            backAnimator.addCompletion(){ position in
                self.animationBegin(isBegin: false)
            }
            backAnimator.isUserInteractionEnabled = false
            backAnimator.startAnimation()
            labelAnimator.startAnimation()

            
        default:
            ()
        }
    }
    
    @objc func turnBack(){
        self.aLabels.forEach{
            $0.animY = self.movedImageView!.frame.origin.y//animate(y: self.movedImageView!.frame.origin.y)
        }
    }
    
    
}

extension AnimationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


















