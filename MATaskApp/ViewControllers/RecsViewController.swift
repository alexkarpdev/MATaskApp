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
    
    let moviesCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateArButton()
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

