//
//  ALabel.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 06.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

enum LabelState {
    case shown
    case hidden
    case selected
}

class ALabel: UILabel, Animatable {
    
    var maxY:CGFloat = 0
    var appearY:CGFloat = 0
    
    var labelState: LabelState!
    
    func animate(y: CGFloat, state: AnimationState) {
        switch state {
        case .moving:
            ()
        case .goback:
            ()
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
