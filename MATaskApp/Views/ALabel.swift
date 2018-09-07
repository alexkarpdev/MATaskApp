//
//  ALabel.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 06.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

enum ALabelState: String {
    case moved = "moved"
    case shown = "shown"
    case hidden = "hidden"
    case selected = "selected"
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65) //65%
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3) //30%
        }
    }
}

class ALabel: UILabel, Animatable {
    
    var heightConstraint = NSLayoutConstraint()
    
    var startY: CGFloat = 0
    
    var turnY: CGFloat = 0
    
    var animY: CGFloat = 0{
        didSet {
            self.animate(y: animY)
        }
    }
    
    var allowTransform = true
    
    private var topBorderY: CGFloat = 0
    private var topMoveY: CGFloat = 5
    private var botMoveY: CGFloat = 30
    private var disappearY: CGFloat = 40
    private var appearY: CGFloat = 60
    private var topSelectY: CGFloat = 0
    private var botSelectY: CGFloat = 0
    private var botBorderY: CGFloat = 140
    
    private var dM: CGFloat = 0
    private var dD: CGFloat = 0
    private var dA: CGFloat = 0
    
    private let startHeight: CGFloat = 25
    
    private var aLabelState: ALabelState = .hidden
    
    var appearAnimator = UIViewPropertyAnimator()
    private var selectAnimator = UIViewPropertyAnimator()
    private var deselectAnimator = UIViewPropertyAnimator()
    
    //private var endAnimators = [UIViewPropertyAnimator]()
    
    func configureY() { //1!
        topBorderY += startY
        topMoveY += startY
        botMoveY += startY
        disappearY += startY
        appearY += startY
        
        topSelectY = appearY + 5 + 20 * CGFloat(tag > 2 ? 0 : tag)
        botSelectY = topSelectY + 15
        
        botBorderY += startY
        
        dM = botMoveY - topMoveY
        dD = disappearY - botMoveY
        dA = appearY - disappearY
    }
    
    func configureAnimators() {
        appearAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
            self.alpha = self.tag > 2 ? 0 : 1
        })
        appearAnimator.scrubsLinearly = false
        appearAnimator.startAnimation()
        appearAnimator.pauseAnimation()
    }
    
    func animate(y: CGFloat) {
        if y.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            updateALebel(state: .moved)
            allowTransform = true
        }else{
            allowTransform = false
        }
        
        if y.isIn(includingTop: botMoveY, excludingBot: disappearY) && tag > 2 { //disappear -> 100
            updateALebel(state: .hidden)
            appearAnimator.fractionComplete = y.getPercentage(fromY: botMoveY, toY: disappearY).rounded()
            print("animate disappear yp: \(y.getPercentage(fromY: botMoveY, toY: disappearY).rounded())")
        }
        
        if y.isIn(includingTop: disappearY, excludingBot: appearY) && tag < 3{ //appear -> 0
            updateALebel(state: .shown)
            appearAnimator.fractionComplete = y.getPercentage(fromY: disappearY, toY: appearY).rounded()
            print("animate appear yp: \(y.getPercentage(fromY: disappearY, toY: appearY).rounded())")
        }
        
        if aLabelState == .shown || aLabelState == .selected{
            if y.isIn(includingTop: topSelectY, excludingBot: botSelectY) {
                updateALebel(state: .selected)
                print("animate select y: \(y)")
            }else{
                updateALebel(state: .shown)
                print("animate deselect y: \(y)")
            }
        }
    }
    
    func endAnimate() {
        textColor = tag == 12 ? ALabelState.selected.textColor : ALabelState.shown.textColor
        switch aLabelState {
        case .selected:
            let generator = UINotificationFeedbackGenerator()
            switch tag {
            case 0:
                generator.notificationOccurred(.warning)
            case 1:
                generator.notificationOccurred(.success)
            case 2:
                generator.notificationOccurred(.error)
            default:
                print("wrong tag: \(tag)")
            }
            
            //updateALebel(state: .shown)
        default:
            ()
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            if self.tag <= 2 { self.alpha = 0 } //hide menu
        }) { (position) in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
                if self.tag > 2 { self.alpha = 1 } //show caption
            }, completion: { (position) in
                self.appearAnimator.stopAnimation(false)
                self.appearAnimator.finishAnimation(at: .current)
                self.configureAnimators()
            })
        }
    }
    
    func updateALebel(state: ALabelState) {
        guard aLabelState != state else {return}
        aLabelState = state
        textColor = tag == 12 ? ALabelState.selected.textColor : state.textColor
        switch aLabelState {
        case .moved:
            ()
        case .hidden:
            ()//appearAnimator.fractionComplete = 1//tag > 2 ? 0 : 1
        case .shown:
            ()//appearAnimator.fractionComplete = tag > 2 ? 1 : 0
        case .selected:
            ()//appearAnimator.fractionComplete = 1//tag > 2 ? 0 : 0
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        turnY = frame.origin.y
        print("tY: \(turnY)  tag: \(tag)")
        configureY() //1!
        configureAnimators() //2
    }
    
}
