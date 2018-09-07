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
    var rnd: Int { // make self random from 0 to self
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
    func isIn(includingTop top: CGFloat, excludingBot bot: CGFloat) -> Bool {
        return self >= top && self < bot ? true : false
    }
    func getPercentage(fromY: CGFloat, toY: CGFloat) -> CGFloat {
        let p = (self - fromY) / (toY - fromY)
        return  p > 0 ? (p < 1 ? p : 1) : 0
    }
    
}

// MARK: - UIImageView

extension UIImageView{
    
    func clone(superView: UIView? = nil, startPoint: CGPoint = CGPoint()) -> UIImageView{
        
        //let locationOfCloneImageView = CGPoint(x: 0, y: 0)
        //x and y coordinates of where you want your image. (More specifically, the x and y coordinated of where you want the CENTER of your image to be)
        let cloneImageView = UIImageView(image: self.image)
        
        cloneImageView.frame = CGRect(x: startPoint.x, y: startPoint.y, width: self.frame.size.width, height: self.frame.size.height)
        //same size as old image view
        cloneImageView.alpha = self.alpha
        //same view opacity
        cloneImageView.layer.opacity = self.layer.opacity
        //same layer opacity
        cloneImageView.layer.cornerRadius = self.layer.cornerRadius
        cloneImageView.clipsToBounds = self.clipsToBounds
        //same clipping settings
        cloneImageView.backgroundColor = self.backgroundColor
        //same BG color
        if let aColor = self.tintColor {
            self.tintColor = aColor
        }
        //matches tint color.
        cloneImageView.contentMode = self.contentMode
        //matches up things like aspectFill and stuff.
        cloneImageView.isHighlighted = self.isHighlighted
        //matches whether it's highlighted or not
        cloneImageView.isOpaque = self.isOpaque
        //matches can-be-opaque BOOL
        cloneImageView.isUserInteractionEnabled = self.isUserInteractionEnabled
        //touches are detected or not
        cloneImageView.isMultipleTouchEnabled = self.isMultipleTouchEnabled
        //multi-touches are detected or not
        cloneImageView.autoresizesSubviews = self.autoresizesSubviews
        //matches whether or not subviews resize upon bounds change of image view.
        //cloneImageView.hidden = originalImageView.hidden;//commented out because you probably never need this one haha... But if the first one is hidden, so is this clone (if uncommented)
        cloneImageView.layer.zPosition = self.layer.zPosition + 1
        //places it above other views in the parent view and above the original image. You can also just use `insertSubview: aboveSubview:` in code below to achieve this.
        if let superView = superView {
            superView.addSubview(cloneImageView)
        } else {
            self.superview?.addSubview(cloneImageView)
        }
        //adds this image view to the same parent view that the other image view is in.
        //cloneImageView.center = locationOfCloneImageView
        //set at start of code.
        
        return cloneImageView
    }
    
    
}
