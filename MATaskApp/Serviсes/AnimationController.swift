//
//  AnimationController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 05.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

protocol Animatable: class {
    func animate(tY: CGFloat)
    func endAnimate(touchState: UIGestureRecognizerState, complition: (()->())?)
    func saveState()
}

class AnimationController: NSObject {
    
    private var aViews: [Animatable]
    private var lockScroll: ((Bool)->())! // add complition block to end animation!!!
    private var isBeginAnimation = false
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    
    init(aViews: [Animatable],  lockScroll: @escaping (Bool)->()) {
        self.aViews = aViews
        self.lockScroll = lockScroll
        super.init()
        
        self.aViews.forEach {
            $0.saveState()
        }
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
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
    
    
    private func animationBegin(isBegin: Bool) {
        guard isBegin != isBeginAnimation else {return}
        print("animation begin: \(isBegin)")
        if isBegin {
            //UISelectionFeedbackGenerator().selectionChanged()
        }else{
            //deinit
        }
        lockScroll(isBegin) //never will invoked
        isBeginAnimation = isBegin
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard recognizer.numberOfTouches < 2 else { return }
        print("recognizer state: \(recognizer.state.rawValue)")
        print("recognizer velocity: \(recognizer.velocity(in: (aViews.first as! UIView)).y)")
        
        switch recognizer.state {
        //case .began:
            
        case .changed://, .began:
            animationBegin(isBegin: true)
            let tY = recognizer.translation(in: (aViews.first as! UIView)).y// - 10
            aViews.forEach{
                $0.animate(tY: tY)
            }
           //
        case .ended, .cancelled:
            print("end")
            aViews.forEach{
                $0 is AnimatableImageView ? $0.endAnimate(touchState: recognizer.state, complition: {[unowned self] in
                    self.animationBegin(isBegin: false)
                }) : $0.endAnimate(touchState: recognizer.state, complition: nil)
            }
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


















