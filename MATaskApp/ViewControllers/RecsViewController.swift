//
//  RecsViewController.swift
//  MATaskApp
//
//  Created by Natalia Sonina on 04.09.2018.
//  Copyright © 2018 Alexey Karpov. All rights reserved.
//

import UIKit

class RecsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var movieCollectionView: MoviesCollectionView!
    @IBOutlet weak var wantLabel: ALabel!
    @IBOutlet weak var watchLable: ALabel!
    @IBOutlet weak var likeLabel: ALabel!
    @IBOutlet weak var aLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moviesLabel: ALabel!
    @IBOutlet weak var nextLabel: ALabel!
    @IBOutlet weak var arButton: UIButton!
    
    private let moviesCount = 20
    private var isApearing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateArButton()
        if !isApearing {appearingAnimation()}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func configure() {
        watchLable.heightConstraint = aLabelHeightConstraint
        let aLabels: [ALabel] = [wantLabel, watchLable, likeLabel, moviesLabel, nextLabel]
        movieCollectionView.configure(movieItems: DBController.prepareData(for: moviesCount), aLabels: aLabels)
    }
    
    func animateArButton() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 2
        flash.fromValue = 1
        flash.toValue = 0.2
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        flash.autoreverses = true
        flash.repeatCount = Float.infinity
        
        arButton.layer.add(flash, forKey: nil)
    }
    
    func appearingAnimation() {
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

