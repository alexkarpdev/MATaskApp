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
    
    var movedImageView: UIImageView! {
        didSet {
            movedImageView.addGestureRecognizer(panGestureRecognizer)
            topBorderY = 0
            botBorderY = 0 + movedImageView.frame.height
        }
    }
    var cellPanelView: UIView?
    
    var lockScroll: ((Bool)->())!
    var isAnimating = false
    
    var conteinerView: UIView!
    var aView: AView?
    var aLabels = [ALabel]()
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    
    //var startPoint = CGPoint()
    var topBorderY: CGFloat = 0
    var botBorderY: CGFloat = 0
    
    
    init(collectionView: MoviesCollectionView, aLabels: [ALabel],  lockScroll: @escaping (Bool)->()) {
        super.init()
        self.aLabels = aLabels
        conteinerView = collectionView.superview!
        //startPoint = CGPoint(x: collectionView.leftSectionInset, y: collectionView.frame.origin.y)
        self.lockScroll = lockScroll
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
    }
    
    
    func animationBegin(isBegin: Bool) {
        if isBegin {
            //startPoint = CGPoint()
            UISelectionFeedbackGenerator().selectionChanged()
            //movedImageView = cellImageView!.clone(superView: conteinerView, startPoint: startPoint)
            //movedImageView!.addGestureRecognizer(panGestureRecognizer)
            //cellPanelView?.layer.zPosition = movedImageView!.layer.zPosition + 1
        }else{
            aLabels.forEach{
                $0.animY = $0.animY + 0
                $0.transform = CGAffineTransform.identity
                $0.allowTransform = true
            }
            
            //movedImageView.transform = CGAffineTransform.
            //movedImageView?.removeFromSuperview()
            //movedImageView = nil
            //cellPanelView!.layer.zPosition = cellImageView!.layer.zPosition
        }
        //cellImageView!.isHidden = isBegin
        //cellPanelView!.isHidden = isBegin
        lockScroll(isBegin)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        switch recognizer.state {
        case .began:
            
            animationBegin(isBegin: true)
        case .changed:
            let recTranslationY = recognizer.translation(in: movedImageView).y
            let shouldMovedToY = recTranslationY + movedImageView.frame.origin.y
            
            guard shouldMovedToY == max(topBorderY, min(botBorderY, shouldMovedToY)) else {return}
            
            movedImageView.transform = CGAffineTransform(translationX: 0, y: recTranslationY)
            let y = self.movedImageView.frame.origin.y// - startPoint.y
            
            if y < 21 {
                cellPanelView!.transform = CGAffineTransform(translationX: 0, y: recTranslationY * 0.3)
                cellPanelView!.alpha = y.getPercentage(fromY: 20, toY: 0)
            }
            self.aLabels.forEach{
                $0.animY = y
                if $0.allowTransform {
                    $0.transform = CGAffineTransform(translationX: 0, y: recTranslationY)
                }
            }
        case .ended, .cancelled:
            
            //recognizer.setTranslation(CGPoint(), in: movedImageView.superview)
            print("end")
            if self.movedImageView.frame.origin.y.rounded() == 0 {
                animationBegin(isBegin: false)
                return
                
            }
            
            self.aLabels.forEach{
                $0.endAnimate()
            }
            let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5)
            backAnimator.addAnimations { [unowned self] in
                self.movedImageView.frame.origin.y = 0
            }
            let labelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.3)
            labelAnimator.addAnimations ({ [unowned self] in
                self.aLabels.forEach{
                    $0.frame.origin.y = $0.turnY
                }
                }, delayFactor: 0.2)
            backAnimator.addCompletion(){ [unowned self] position in
                self.animationBegin(isBegin: false)
            }
            
            let panelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.5)
            panelAnimator.addAnimations ({  [unowned self] in
                self.cellPanelView?.frame.origin.y = self.movedImageView.frame.height
                self.cellPanelView?.alpha = 1
                }, delayFactor: 0.2)
            
            backAnimator.isUserInteractionEnabled = false
            backAnimator.startAnimation()
            labelAnimator.startAnimation()
            panelAnimator.startAnimation()
            
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


















