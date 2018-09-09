//
//  ControlPoints.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 08.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

struct ControlPoints {
    var startY: CGFloat = 0
    var topBorderY: CGFloat = 0
    var topMoveY: CGFloat = 5
    var botMoveY: CGFloat = 30
    var disappearY: CGFloat = 45
    var appearY: CGFloat = 60
    var botBorderY: CGFloat = 140
    
    func topSelectY(forLabelAt tag: Int) -> CGFloat {
        return appearY + 5 + 20 * CGFloat(tag)
    }
    
    func botSelectY(forLabelAt tag: Int) -> CGFloat {
        return topSelectY(forLabelAt: tag) + 15
    }
}
