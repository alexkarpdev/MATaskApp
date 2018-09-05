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
    var rnd: Int { // make self is random from 0 to self
        return Int(arc4random_uniform(UInt32(self)))
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
}
