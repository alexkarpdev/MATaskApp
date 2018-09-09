//
//  AnimationController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 05.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

enum StateProperties {
    static let y = "frame.origin.y"
    static let alpha = "alpha"
    static let textColor = "textColor"
}

enum AnimationState {
    case moving
    case goback
}

protocol Animatable: class {
    func animate(tY: CGFloat)
    func endAnimate(touchState: UIGestureRecognizerState)
    func saveState()
}

class AnimationController: NSObject {
    
    private var aViews: [Animatable]
    
    private var lockScroll: ((Bool)->())! // add complition block to end animation!!!
    private var isAnimating = false
    
    private var conteinerView: UIView!
    private var aLabels = [ALabel]()
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    
    var movedImageView: UIImageView! {
        didSet {
            movedImageView.addGestureRecognizer(panGestureRecognizer)
            topBorderY = 0
            botBorderY = 0 + movedImageView.frame.height * 1.3
        }
    }
    var cellPanelView: UIView?

    var topBorderY: CGFloat = 0
    var botBorderY: CGFloat = 0
    
    
    init(conteinerView: UIView, aViews: [Animatable],  lockScroll: @escaping (Bool)->()) {
        self.aViews = aViews
        self.conteinerView = conteinerView
        self.lockScroll = lockScroll
        super.init()
        
        self.aViews.forEach {
            $0.saveState()
        }
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
    }
    
    func addCellViews(cellViews: [Animatable]) {
        cellViews.forEach{
            $0.saveState()
            if let aImageView = ($0 as? AnimatableImageView){
                aImageView.addGestureRecognizer(panGestureRecognizer)}
        }
        aViews.count == 5 ? aViews.append(contentsOf: cellViews):
                            aViews.replaceSubrange(5...6, with: cellViews)
    }
    
    
    func animationBegin(isBegin: Bool) {
        print("animation begin: \(isBegin)")
        if isBegin {
            UISelectionFeedbackGenerator().selectionChanged()
            //initialisation for start animations
//            aViews.forEach{
//                $0.saveState()
//            }
        }else{
            //deinit
            aLabels.forEach{
                //$0.animY = $0.animY + 0
                $0.allowTransform = false
            }
        }
        lockScroll(isBegin) //never will invoked
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        print("recognizer state: \(recognizer.state.rawValue)")
        switch recognizer.state {
        case .began:
            animationBegin(isBegin: true)
        case .changed:
            
            //pass only y
            //
            
            aViews.forEach{
                $0.animate(tY: recognizer.translation(in: ($0 as! UIView)).y)
            }
            
            
//            let recTranslationY = recognizer.translation(in: movedImageView).y
//            let shouldMovedToY = recTranslationY + movedImageView.frame.origin.y
//
//            guard shouldMovedToY == max(topBorderY, min(botBorderY, shouldMovedToY)) else {return}
//            movedImageView.frame.origin.y = recTranslationY
//            let y = self.movedImageView.frame.origin.y
//
//            if y < 21 {  //need a own AClass
//                cellPanelView!.frame.origin.y = movedImageView.frame.height + recognizer.translation(in: conteinerView!).y * 0.2
//                cellPanelView!.alpha = y.getPercentage(fromY: 20, toY: 0)
//            }else if y > 20{
//                cellPanelView!.alpha = 0
//            }else{
//                cellPanelView!.alpha = 1
//            }
//            self.aLabels.forEach{
//                $0.animate(tY: y * 0.8)
//                if $0.allowTransform {
//                    $0.frame.origin.y = $0.turnY + recognizer.translation(in: conteinerView!).y * 0.4
//                }
//            }
        case .ended, .cancelled:
            
            print("end")
            animationBegin(isBegin: false)
            aViews.forEach{
                $0.endAnimate(touchState: recognizer.state)
            }
            
//            if self.movedImageView.frame.origin.y.rounded() == 0 {
//                animationBegin(isBegin: false)
//                return
//            }
//
//            for (i, v) in aLabels.enumerated() {
//                v.endAnimate(touchState: recognizer.state)
//            }
//
//            let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5)
//            backAnimator.addAnimations { [unowned self] in
//                self.movedImageView.frame.origin.y = 0
//            }
//            let labelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.5)
//            labelAnimator.addAnimations { [unowned self] in
//                self.aLabels.forEach{
//                    $0.alpha = $0.tag > 2 ? 1 : 0
//                }
//            }
//            labelAnimator.addAnimations ({ [unowned self] in
//                self.aLabels.forEach{
//                    $0.frame.origin.y = $0.turnY
//                }
//                }, delayFactor: 0.2)
//            backAnimator.addCompletion(){ [unowned self] position in
//                self.animationBegin(isBegin: false)
//            }
//
//            let panelAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.5)
//            panelAnimator.addAnimations ({ [unowned self] in
//                self.cellPanelView?.frame.origin.y = self.movedImageView.frame.height
//                self.cellPanelView?.alpha = 1
//                }, delayFactor: 0.2)
//
//            //backAnimator.isUserInteractionEnabled = false
//            backAnimator.startAnimation()
//            labelAnimator.startAnimation()
//            panelAnimator.startAnimation()
            
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


















