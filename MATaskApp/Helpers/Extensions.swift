//
//  Extensions.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Int

extension Int {
    var rnd: Int {
        guard self != 0 else {return self}
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) // make self random from 0 to excluding self
        }else{
            let sign = 2.rnd < 1 ? -1 : 1
            return Int(arc4random_uniform(UInt32(abs(self)))) * sign // make self random from excluding -self to excluding self
        }
        
    }
}

// MARK: - CGFloat

extension CGFloat {
    var rounded: Int {
        return Int(self.rounded())
    }
    var abs: CGFloat {
        return self < 0 ? -self : self
    }
    func isIn(includingTop top: CGFloat, excludingBot bot: CGFloat) -> Bool {
        return self >= top && self < bot ? true : false
    }
    func getPercentage(fromY: CGFloat, toY: CGFloat) -> CGFloat {
        let p = (self - fromY) / (toY - fromY)
        return  p > 0 ? (p < 1 ? p : 1) : 0
    }
}
