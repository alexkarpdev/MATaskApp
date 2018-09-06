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
struct ALabelText {
    
    private static let text: [String: [String]] = [ALabelState.shown.rawValue: ["Want", "Watched", "Don't like this"],
                                                   ALabelState.hidden.rawValue: ["Movies","Next to watch", ""]]
    
    static func getTextFor( state: ALabelState, tag: Int) -> String {
        return text[state.rawValue]![tag]
    }
}

class ALabel: UILabel, Animatable {
    
    var heightConstraint = NSLayoutConstraint()
    
    var startY: CGFloat = 0
    
    var animY: CGFloat = 0{
        didSet {
            self.animate(y: animY)
        }
    }
    
    private var topBorderY: CGFloat = 0
    private var topMoveY: CGFloat = 5
    private var botMoveY: CGFloat = 20
    private var disappearY: CGFloat = 40
    private var appearY: CGFloat = 70
    private var topSelectY: CGFloat = 0
    private var botSelectY: CGFloat = 0
    private var botBorderY: CGFloat = 140
    
    private let startHeight: CGFloat = 25
    
    private var aLabelState: ALabelState = .hidden
    
    private var moveAnimator = UIViewPropertyAnimator()
    private var disappearAnimator = UIViewPropertyAnimator()
    private var appearAnimator = UIViewPropertyAnimator()
    private var selectAnimator = UIViewPropertyAnimator()
    private var deselectAnimator = UIViewPropertyAnimator()
    
    private var backAnimator = UIViewPropertyAnimator()
    
    var timer = Timer()
    
    func configureY() { //1!
        topBorderY += startY
        topMoveY += startY
        botMoveY += startY
        disappearY += startY
        appearY += startY
        
        topSelectY = appearY + 10 + 30 * CGFloat(tag)
        botSelectY = topSelectY + 20
        
        botBorderY += startY
    }
    
    func configureAnimators() {
        moveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.botMoveY - self.topMoveY)
        })
        moveAnimator.startAnimation()
        moveAnimator.pauseAnimation()
        
        //        disappearAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
        //            self.alpha = 0
        //        })
        //        //disappearAnimator.startAnimation()
        //        //disappearAnimator.pauseAnimation()
        //        self.alpha = 1
        appearAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.alpha = 0
        })
        appearAnimator.startAnimation()
        appearAnimator.pauseAnimation()
        
        selectAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.textColor = self.aLabelState.textColor
        })
        selectAnimator.startAnimation()
        selectAnimator.pauseAnimation()
        
        deselectAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.textColor = self.aLabelState.textColor
        })
        deselectAnimator.startAnimation()
        deselectAnimator.pauseAnimation()
        
        backAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.6) {
            self.transform = CGAffineTransform(translationX: 0, y:  self.topMoveY - self.botMoveY)
        }
    }
    
    func animate(y: CGFloat) {
        
        print("animate y: \(y)")
        print("alpha: \(alpha)")
        if y.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            updateALebel(state: .moved)
            moveAnimator.fractionComplete = y.getPercentage(fromY: topMoveY, toY: botMoveY)
            print("animate move y: \(y)")
        }
        
        if y.isIn(includingTop: botMoveY, excludingBot: disappearY) { //disappear -> 100
            updateALebel(state: .hidden)
            appearAnimator.fractionComplete = y.getPercentage(fromY: botMoveY, toY: disappearY)
            print("animate disappear y: \(y)")
        }
        
        if y.isIn(includingTop: disappearY, excludingBot: appearY) { //appear -> 0
            updateALebel(state: .shown)
            appearAnimator.fractionComplete = y.getPercentage(fromY: appearY, toY: disappearY)
            print("animate appear y: \(y)")
        }
        
        if aLabelState == .shown || aLabelState == .selected{
            if y.isIn(includingTop: topSelectY, excludingBot: botSelectY) {
                self.textColor = self.aLabelState.textColor
                updateALebel(state: .selected)
                selectAnimator.fractionComplete = y.getPercentage(fromY: topSelectY, toY: botSelectY)
                print("animate select y: \(y)")
            }else{
                self.textColor = self.aLabelState.textColor
                updateALebel(state: .shown)
                deselectAnimator.fractionComplete = y.getPercentage(fromY: topSelectY, toY: botSelectY)
                print("animate deselect y: \(y)")
            }
        }
    }
    
    func endAnimate() {
        
        
        
        let alphaChange = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.6, animations: { [unowned self] in
            self.animY = 178
        })
        
        // To run an animation
        alphaChange.startAnimation()
        
        
        
//        let backAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
//            self.animY = 178
//        }
//        backAnimator.startAnimation()
        y = self.animY
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target:self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    var y:CGFloat = 0
    
    @objc func updateProgress() {
        guard y >= botMoveY else {
            timer.invalidate()
            backAnimator.startAnimation()
            return
        }
        y -= 2
        animate(y: y)
    }
    
    
    func updateALebel(state: ALabelState) {
        guard aLabelState != state else {return}
        aLabelState = state
        switch aLabelState {
        case .moved:
            ()
        case .hidden:
            text = ALabelText.getTextFor(state: state, tag: tag)
        case .shown:
            text = ALabelText.getTextFor(state: state, tag: tag)
        case .selected:
            ()
        }
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configure() {
        alpha = 0.65
        configureY() //1!
        configureAnimators() //2
        text = ALabelText.getTextFor(state: .hidden, tag: tag)
    }
    
    
}
