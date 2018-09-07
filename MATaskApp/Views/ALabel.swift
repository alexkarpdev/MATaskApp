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

class ALabel: UILabel {
    
    private var isMenuLabel: Bool {
        return tag < 3
    }
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
    
    private var startHeight: CGFloat = 25
    private var aLabelState: ALabelState = .hidden
    
    var startY: CGFloat = 0
    var turnY: CGFloat = 0
    var animY: CGFloat = 0
    var allowTransform = true
    var heightConstraint: NSLayoutConstraint! {
        didSet{
            startHeight = heightConstraint.constant
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        turnY = frame.origin.y
        print("tY: \(turnY)  tag: \(tag)")
        configureState()
        configureY() //1!
    }
    
    private func configureState() {
        alpha = isMenuLabel ? 0 : 1
        print("configureState tag: \(tag) alpha: \(alpha)")
    }
    
    private func configureY() { //1!
        topBorderY += startY
        topMoveY += startY
        botMoveY += startY
        disappearY += startY
        appearY += startY
        
        topSelectY = appearY + 5 + 20 * CGFloat(isMenuLabel ? tag : 0)
        botSelectY = topSelectY + 15
        
        botBorderY += startY
        
        dM = botMoveY - topMoveY
        dD = disappearY - botMoveY
        dA = appearY - disappearY
    }
    
    
    private func updateALebel(state: ALabelState) {
        print("updated tag: \(tag)")
        guard aLabelState != state else {return}
        
        textColor = tag == 12 ? ALabelState.selected.textColor : state.textColor //top caption label always is selected
        switch state {
        case .moved:
            ()
        case .hidden:
            ()
        case .shown:
            ()
        case .selected:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        aLabelState = state
    }
}

extension ALabel: Animatable {
    func animate(y: CGFloat) {
        print("animated tag: \(tag)")
        if y.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            updateALebel(state: .moved)
            allowTransform = true
        }else{
            allowTransform = false
        }
        
        if y.isIn(includingTop: botMoveY, excludingBot: disappearY) { //disappear -> 100
            let p = y.getPercentage(fromY: botMoveY, toY: disappearY)
            if isMenuLabel {
                alpha = 0
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 1 - p
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y.isIn(includingTop: disappearY, excludingBot: appearY){ //appear -> 0
            let p = y.getPercentage(fromY: disappearY, toY: appearY)
            if isMenuLabel {
                alpha = p
                print("per: \(p) alpha: \(alpha) tag: \(tag)")
            }else{
                alpha = 0
                print("animate appear yp: \(p)")
                print("per: \(p)) alpha: \(alpha) tag: \(tag)")
            }
        }
        
        if y < botMoveY {
            if isMenuLabel {
                alpha = 0
            }else{
                alpha = 1
            }
        }
        
        if y > appearY {
            if isMenuLabel {
                alpha = 1
            }else{
                alpha = 0
            }
        }
        
        if isMenuLabel {
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
            updateALebel(state: .shown)
        default:
            ()
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: { [unowned self] in
            if self.isMenuLabel { self.alpha = 0 } //hide menu
        }) { (position) in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: { [unowned self] in
                if !self.isMenuLabel { self.alpha = 1 } //show caption
                }, completion: { (position) in
                    //some complition operations
                    //[unowned self]
            })
        }
    }
}
