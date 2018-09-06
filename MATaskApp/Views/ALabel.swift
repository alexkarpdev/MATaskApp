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
                                           ALabelState.hidden.rawValue: ["shown","shown", ""]]
    
    static func getTextFor( state: ALabelState, tag: Int) -> String {
        return text[state.rawValue]![tag]
    }
}

class ALabel: UILabel, Animatable {
    
    var heightConstraint = NSLayoutConstraint()
    
    var startY: CGFloat = 0
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
    
    func configureY() {
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
        
        disappearAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.alpha = 0
        })
        disappearAnimator.startAnimation()
        disappearAnimator.pauseAnimation()
        
        appearAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.alpha = 1
        })
        appearAnimator.startAnimation()
        appearAnimator.pauseAnimation()
        
        selectAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.textColor = self.aLabelState.textColor
        })
        selectAnimator.startAnimation()
        selectAnimator.pauseAnimation()
        
        deselectAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.textColor = self.aLabelState.textColor
        })
        deselectAnimator.startAnimation()
        deselectAnimator.pauseAnimation()
        
    }
    
    func animate(y: CGFloat) {
        
        if y.isIn(includingTop: topMoveY, excludingBot: botMoveY) {
            updateALebel(state: .moved)
            moveAnimator.fractionComplete = y.getPercentage(fromY: startY, toY: botMoveY)
        }
        
        if y.isIn(includingTop: botMoveY, excludingBot: disappearY) {
            updateALebel(state: .hidden)
            disappearAnimator.fractionComplete = y.getPercentage(fromY: botMoveY, toY: disappearY)
        }
        
        if y.isIn(includingTop: disappearY, excludingBot: appearY) {
            updateALebel(state: .shown)
            appearAnimator.fractionComplete = y.getPercentage(fromY: disappearY, toY: appearY)
        }
        
        if aLabelState == .shown || aLabelState == .selected{
            if y.isIn(includingTop: topSelectY, excludingBot: botSelectY) {
                updateALebel(state: .selected)
            }else{
                updateALebel(state: .shown)
            }
        }
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
        configure()()
    }
    
    
    func configure() {
        
    }
    

}
