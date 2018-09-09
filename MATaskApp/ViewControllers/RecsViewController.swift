//
//  RecsViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class RecsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var movieCollectionView: SlidedCollectionView!
    @IBOutlet var aLabels: [AnimatableLabel]!
    
    @IBOutlet weak var arButton: UIButton!
    
    private let moviesCount = 20
    private var isApearing = false
    
    var animationController: AnimationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !isApearing {
            appearingAnimation()
            animateArButton()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func configure() {
        let aViews: [Animatable] = aLabels
        animationController = AnimationController(aViews: aViews) { [unowned self] isLock in
            self.movieCollectionView.isScrollEnabled = !isLock
        }
        
        movieCollectionView.configure(movieItems: DBController.prepareData(for: moviesCount), animationController: animationController)
    }
    
    private func animateArButton() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 5
        flash.fromValue = 1
        flash.toValue = 0.2
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        let muvX = CAKeyframeAnimation()
        muvX.keyPath = "position.x"
        muvX.values = (0..<50).map{ _ in return (-4).rnd }
        muvX.keyTimes = (1...50).map{ i in return NSNumber(value: Float(i) / 5)}
        muvX.duration = 10
        muvX.autoreverses = true
        muvX.isAdditive = true
        
        let muvY = CAKeyframeAnimation()
        muvY.keyPath = "position.y"
        muvY.values = (0..<50).map{ _ in return (-4).rnd}
        muvY.keyTimes = (1...50).map{ i in return NSNumber(value: Float(i) / 5)}
        muvY.duration = 10
        muvY.autoreverses = true
        muvY.isAdditive = true
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [flash, muvX, muvY]
        animationGroup.repeatCount = Float.infinity
        //animationGroup.autoreverses = true
        animationGroup.duration = 20
        
        animationGroup.isRemovedOnCompletion = false
        
        arButton.layer.add(animationGroup, forKey: nil)
    }
    
    private func appearingAnimation() {
        isApearing = true
        UIViewPropertyAnimator(duration: 3, dampingRatio: 0.6) { [unowned self] in
            self.view.alpha = 1
        }.startAnimation()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

