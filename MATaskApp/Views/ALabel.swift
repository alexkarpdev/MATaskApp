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
            //self.animate(y: animY)
        }
    }
    
    var allowTransform = true
    var safedTransform: CGAffineTransform!
    
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
    
    var isSelected: Bool = false
    
    //private var endAnimators = [UIViewPropertyAnimator]()
    
    func configureState() {
        alpha = tag > 2 ? 1 : 0
        print("configureState tag: \(tag) alpha: \(alpha)")
    }
    
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
        appearAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: { [unowned self] in
            self.alpha = self.tag > 2 ? 0 : 1
        })
        appearAnimator.addCompletion { (position) in
            self.alpha = self.tag > 2 ? 1 : 0
        }
        appearAnimator.scrubsLinearly = false
        appearAnimator.startAnimation()
        appearAnimator.pauseAnimation()
    }
    
    func animate(y: CGFloat) {
        print("animated tag: \(tag)")
        if y.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            updateALebel(state: .moved)
            allowTransform = true
        }else{
            allowTransform = false
        }
        
        if y.isIn(includingTop: botMoveY, excludingBot: disappearY) { //disappear -> 100
            if tag > 2 {
                //updateALebel(state: .hidden)
                //appearAnimator.fractionComplete = y.getPercentage(fromY: botMoveY, toY: disappearY)
                alpha = 1-y.getPercentage(fromY: botMoveY, toY: disappearY)
                print("animate disappear yp: \(y.getPercentage(fromY: botMoveY, toY: disappearY))")
                print("per: \(y.getPercentage(fromY: botMoveY, toY: disappearY)) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 0 //y.getPercentage(fromY: botMoveY, toY: disappearY)
                print("per: \(y.getPercentage(fromY: botMoveY, toY: disappearY)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y.isIn(includingTop: disappearY, excludingBot: appearY){ //appear -> 0
            if tag > 2 {
                //updateALebel(state: .shown)
                //appearAnimator.fractionComplete = y.getPercentage(fromY: disappearY, toY: appearY)
                alpha = 0//1 - y.getPercentage(fromY: disappearY, toY: appearY)
                print("animate appear yp: \(y.getPercentage(fromY: disappearY, toY: appearY))")
                print("per: \(y.getPercentage(fromY: disappearY, toY: appearY)) alpha: \(alpha) tag: \(tag)")
            }else{
                
                alpha = y.getPercentage(fromY: disappearY, toY: appearY)
                print("per: \(y.getPercentage(fromY: disappearY, toY: appearY)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y < botMoveY && tag > 2 {
            alpha = 1
        }

        if y < botMoveY && tag < 3 {
            alpha = 0
        }

        if y > appearY && tag > 2 {
            alpha = 0
        }

        if y > appearY && tag < 3 {
            alpha = 1
        }
        
        if tag < 3 {
            if y.isIn(includingTop: topSelectY, excludingBot: botSelectY) {
                updateALebel(state: .selected)
            }else{
                updateALebel(state: .shown)
            }
        }
    }
    
    func endAnimate() {
        print("end animated tag: \(tag)")
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
                //self.appearAnimator.stopAnimation(true)
                //self.appearAnimator.finishAnimation(at: .end)
                //self.configureAnimators()
            })
        }
    }
    
    func updateALebel(state: ALabelState) {
        
        print("updated tag: \(tag)")
        
        guard aLabelState != state else {return}
        
        textColor = tag == 12 ? ALabelState.selected.textColor : state.textColor
        switch state {
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
        
        aLabelState = state
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func restoreTransform() {
        transform = safedTransform
    }
    
    func configure() {
        safedTransform = transform
        turnY = frame.origin.y
        print("tY: \(turnY)  tag: \(tag)")
        configureState()
        configureY() //1!
        //configureAnimators() //2
    }
    
}
