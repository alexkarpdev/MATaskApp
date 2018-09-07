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
        self.lockScroll = lockScroll
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
    }
    
    
    func animationBegin(isBegin: Bool) {
        print("animation begin: \(isBegin)")
        if isBegin {
            
            //startPoint = CGPoint()
//            aLabels.forEach{
//                $0.safedTransform = $0.transform
//            }
            UISelectionFeedbackGenerator().selectionChanged()
            //movedImageView = cellImageView!.clone(superView: conteinerView, startPoint: startPoint)
            //movedImageView!.addGestureRecognizer(panGestureRecognizer)
            //cellPanelView?.layer.zPosition = movedImageView!.layer.zPosition + 1
        }else{
            //movedImageView.transform = CGAffineTransform.
            aLabels.forEach{
                $0.animY = $0.animY + 0
                //$0.restoreTransform() //transform = CGAffineTransformFromString(NSStringFromCGAffineTransform($0.transform))
                $0.allowTransform = false
            }
            
            
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
        print("recognizer state: \(recognizer.state)")
        switch recognizer.state {
        case .began:
            
            animationBegin(isBegin: true)
        case .changed:
            let recTranslationY = recognizer.translation(in: movedImageView).y
            let shouldMovedToY = recTranslationY + movedImageView.frame.origin.y
            
            guard shouldMovedToY == max(topBorderY, min(botBorderY, shouldMovedToY)) else {return}
            movedImageView.frame.origin.y = recTranslationY
            //movedImageView.transform = CGAffineTransform(translationX: 0, y: recTranslationY)
            let y = self.movedImageView.frame.origin.y// - startPoint.y
            
            if y < 21 {
                cellPanelView!.transform = CGAffineTransform(translationX: 0, y: recTranslationY * 0.3)
                cellPanelView!.alpha = y.getPercentage(fromY: 20, toY: 0)
            }else if y > 20{
                cellPanelView!.alpha = 0
            }else{
                cellPanelView!.alpha = 1
            }
            self.aLabels.forEach{
                $0.animate(y: y)
                if $0.allowTransform {
                    $0.frame.origin.y = $0.turnY + recognizer.translation(in: conteinerView!).y// recTranslationY + $0.frame.origin.y// = CGAffineTransform(translationX: 0, y: recTranslationY)
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
            labelAnimator.addAnimations { [unowned self] in
                self.aLabels.forEach{
                    $0.alpha = $0.tag > 2 ? 1 : 0
                }
            }
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


















