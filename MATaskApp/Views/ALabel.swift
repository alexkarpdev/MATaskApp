//
//  ALabel.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 06.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

enum ALabelState: String {
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
    
    static let text: [String: [String]] = [ALabelState.shown.rawValue: ["Want", "Watched", "Don't like this"],
                                           ALabelState.hidden.rawValue: ["shown","shown", ""]]
    
    static func getTextFor( state: ALabelState, tag: Int) -> String {
        return text[state.rawValue]![tag]
    }
}

class ALabel: UILabel, Animatable {
    
    var maxY:CGFloat = 0
    var appearY:CGFloat = 0
    
    var selectedYMin: CGFloat {
        return 0 * CGFloat(tag)
    }
    var selectedYMax: CGFloat {
        return 0 * CGFloat(tag)
    }
    
    let startHeight: CGFloat = 0
    let startY: CGFloat = 0
    
    var aLabelState: ALabelState = .hidden
    
    
    func animate(y: CGFloat, state: AnimationState) {
        
        if y > appearY {
            updateALebel(state: .shown)
            if y > selectedYMin && y < selectedYMax {
                updateALebel(state: .selected)
            }else{
                updateALebel(state: .shown)
            }
        }else{
            updateALebel(state: .hidden)
        }
        
        
        
        layoutIfNeeded()
        switch state {
        case .moving:
            ()
        case .goback:
            ()
        }
    }
    
    func updateALebel(state: ALabelState) {
        guard aLabelState != state else {return}
        aLabelState = state
        if state == .selected {
            alpha = 0.65
        }else{
            alpha = 0.3
        text = ALabelText.getTextFor(state: state, tag: tag)
        }
        
        if tag == 0 && state == .hidden {
            alpha = 0.65
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    

}
