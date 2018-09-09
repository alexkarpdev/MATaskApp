//
//  InitialStates.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 09.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

struct InitialStates {
    var y: CGFloat
    var alpha: CGFloat
    var textColor: UIColor
    
    init(y: CGFloat = 0, alpha: CGFloat = 0, textColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) {
        self.y = y
        self.alpha = alpha
        self.textColor = textColor
    }
}
